//
//  URLRequestInterceptor.swift
//  Zone5
//
//  Created by Jean Hall on 17/11/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

internal class URLRequestInterceptor: URLProtocol {
	// shared session that all requests ultimately go out on. The one in httpClient funnels all requests to this interceptor which then get routed out this one
	static private let urlSession = URLSession(configuration: .default)
	// synchronize auto refresh so that only 1 request at a time can issue a refresh
	static private let refreshDispatchQueue = DispatchQueue(label: "URLRequestInterceptor.refreshDispatchQueue")
	static private let refreshDispatchSemaphore = DispatchSemaphore(value: 1) // allow 1 through at a time
	
	private let session: URLSession
	private var currentTask: URLSessionTask? = nil
	
	override init(request: URLRequest, cachedResponse: CachedURLResponse?, client: URLProtocolClient?) {
		session = URLRequestInterceptor.urlSession
		super.init(request: request, cachedResponse: cachedResponse, client: client)
	}
	
	/// intercept all requests, alter them and send them out the local shared session
	override class func canInit(with task: URLSessionTask) -> Bool {
		return true
	}
	
	/// intercept all requests, alter them and send them out the local shared session
	override class func canInit(with request: URLRequest) -> Bool {
		return true
	}
	
	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}

	override func startLoading() {
		// if we have a Cognito token with an expiry and this request requires auth token, check the expiry
		if let requiresAccessToken = request.getMeta(key: .requiresAccessToken) as? Bool, requiresAccessToken, let zone5 = request.getMeta(key: .zone5) as? Zone5, let token = zone5.accessToken as? OAuthToken, token.refreshToken != nil, let expiresAt = token.tokenExp, expiresAt < Date().addingTimeInterval(30.0).milliseconds.rawValue {
			// our token expires in less than 30 seconds. Do a refresh before sending the request
			// do these refresh requests synchronously so only one executes at a time and others wait for first refresh to complete - at which point duplicate refresh not necessary
			URLRequestInterceptor.refreshDispatchQueue.async {
				URLRequestInterceptor.refreshDispatchSemaphore.wait() // should let first 1 through
				// recheck TTL once inside mutex block, cos it might have been updated by another refresh while we were waiting for mutex
				if let token = zone5.accessToken as? OAuthToken, token.refreshToken != nil, let expiresAt = token.tokenExp, expiresAt < Date().addingTimeInterval(30.0).milliseconds.rawValue, let username = self.extractUsername(from: token.accessToken) {
					zone5.oAuth.refreshAccessToken(username: username) { result in
						// note that refresh does not require auth so it will not cyclicly enter this path
						URLRequestInterceptor.refreshDispatchSemaphore.signal()
						self.decorateAndSendRequest()
					}
				} else {
					// the refresh must've been performed while we were waiting for mutex. Signal and sendRequest immediately
					URLRequestInterceptor.refreshDispatchSemaphore.signal()
					self.decorateAndSendRequest()
				}
			}
			return
		} else {
			// token is not about to expire, has no refresh token, or we don't need auth. Send request immediately
			decorateAndSendRequest()
		}
	}
	
	override func stopLoading() {
		self.currentTask?.cancel()
	}
	
	private func onComplete(data: Data?, response: URLResponse?, error: Error?) {
		if let response = response {
			self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
		}
		
		if let data = data {
			self.client?.urlProtocol(self, didLoad: data)
		}
		 
		if let error = error {
			self.client?.urlProtocol(self, didFailWithError: error)
		}
		
		self.client?.urlProtocolDidFinishLoading(self)
	}
	
	/// call decorate(...) and then sendRequest(...)
	private func decorateAndSendRequest() {
		// decorate headers. This needs to be after the refresh code as the token may change
		let request = URLRequestInterceptor.decorate(request: self.request)
        print("Decorated for \(request.url?.absoluteString ?? ""): \(request.allHTTPHeaderFields ?? [:])")
		// send
		sendRequest(request)
	}
	
	/// decorate the request with headers, based on the given Zone5 configuraion
	/// - Parameters:
	///   - request: The request being decorated
	///	  - with: The Zone5 instance to decorate the request with
	class func decorate(request: URLRequest) -> URLRequest {
		let mutableRequest = (request as NSURLRequest).mutableCopy() as! NSMutableURLRequest
		let zone5 = request.getMeta(key: .zone5) as? Zone5
		
		// set user agent if configured
		if let agent = zone5?.userAgent, !agent.isEmpty {
			mutableRequest.setValue(agent, forHTTPHeaderField: "User-Agent")
		}
		
		// set legacy tp-nodecorate header
		mutableRequest.setValue("true", forHTTPHeaderField: "tp-nodecorate")
		
		// Sign the request with the access token if required
		if let requiresAccessToken = request.getMeta(key: .requiresAccessToken) as? Bool, requiresAccessToken, let zone5 = zone5, let token = zone5.accessToken {
			mutableRequest.setValue("Bearer \(token.rawValue)", forHTTPHeaderField: "Authorization")
		}
		
		return mutableRequest as URLRequest
	}
	
	/// We have finished with intercepting this request. Send the request for real with the real url session
	internal func sendRequest(_ request: URLRequest) {
		switch request.taskType {
		case .data:
			self.currentTask = session.dataTask(with: request, completionHandler: onComplete)
		case .upload:
			if let url = URLProtocol.property(forKey: "fileURL", in: request) as? URL {
				self.currentTask = session.uploadTask(with: request, fromFile: url, completionHandler: onComplete)
			} else {
				onComplete(data: nil, response: nil, error: Zone5.Error.invalidParameters)
			}
		case .download:
			self.currentTask = session.downloadTask(with: request) { url, response, error in
				self.onComplete(data: nil, response: response, error: error)
			}
		}
	
		currentTask?.resume()
	}
	
	/// Decode the Cognito token to get the username out of it. It is required (for some reason) for the cognito refresh
	internal func extractUsername(from jwt: String) -> String? {
		
		enum DecodeErrors: Error {
			case badToken
			case other
		}
		
		func base64Decode(_ base64: String) throws -> Data {
			let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
			guard let decoded = Data(base64Encoded: padded) else {
				throw DecodeErrors.badToken
			}
			return decoded
		}
		
		func decodeJWTPart(_ value: String) throws -> [String: Any] {
			let bodyData = try base64Decode(value)
			let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
			guard let payload = json as? [String: Any] else {
				throw DecodeErrors.other
			}
			return payload
		}
		
		let segments = jwt.components(separatedBy: ".")
		let part = segments.count > 1 ? (try? decodeJWTPart(segments[1])) ?? [:] : [:]
		return part["email"] as? String
	}
	
}

extension URLRequest {
	/// Creates a mutable copy of self, adds meta data to it, and returns the new URLRequest struct
	/// note URLRequest is a struct and is passed by value so the result of this must be assigned to the calling variable
	internal func setMeta(key: URLProtocolProperty, value: Any) -> URLRequest {
		let mutatingRequest = (self as NSURLRequest).mutableCopy() as! NSMutableURLRequest
		URLProtocol.setProperty(value, forKey: key.rawValue, in: mutatingRequest)
		return mutatingRequest as URLRequest
	}
	
	internal func getMeta(key: URLProtocolProperty) -> Any? {
		return URLProtocol.property(forKey: key.rawValue, in: self)
	}
	
	internal var taskType: URLSessionTaskType {
		return getMeta(key: .taskType) as? URLSessionTaskType ?? .data
	}
}
