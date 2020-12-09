//
//  ExternalView.swift
//  Zone5
//
//  Created by Jean Hall on 8/12/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

/// Collection of functions for invoking requests to external servers other than Zone5
/// The purpose for using the Zone5 library for sending requests to external servers is to utilise the
/// shared Cognito token and make use of the inbuilt token refresh functionality
public class ExternalView: APIView {
	
	/// Perform a request via the given method with the given endpoint.
	///
	/// Note that if you pass a body with a method that does not support a body you will get an unexpectedRequestBody exception
	@discardableResult
    public func requestDecode<T>(_ endpoint: RequestEndpoint, method: Zone5.Method, headers: [String: String]? = nil, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, parameters queryParams: URLEncodedBody? = nil, body: RequestBody? = nil, type: T.Type = T.self, completion completionHandler: @escaping Completion<T>) -> PendingRequest? {
		return perform(with: completionHandler) { zone5 in
			let request = Request(endpoint: endpoint, method: method, headers: headers, queryParams: queryParams, body: body)
			return zone5.httpClient.perform(request, keyDecodingStrategy: keyDecodingStrategy, expectedType: type, completion: completionHandler)
		}
		
	}
	
	/// Perform a request and instead of decoding the response pass back the raw Data and URLResponse
	@discardableResult
	public func request(_ endpoint: RequestEndpoint, method: Zone5.Method, headers: [String: String]? = nil, parameters queryParams: URLEncodedBody? = nil, body: RequestBody? = nil, completion completionHandler: @escaping (_ result: Result<(Data?, URLResponse), Zone5.Error>) -> Void) -> PendingRequest? {
		do {
			guard let zone5 = zone5 else {
				throw Zone5.Error.unknown
			}

			let request = Request(endpoint: endpoint, method: method, headers: headers, queryParams: queryParams, body: body)
			return zone5.httpClient.perform(request, completion: completionHandler)
		}
		catch {
			if let error = error as? Zone5.Error {
				completionHandler(.failure(error))
			}
			else {
				completionHandler(.failure(.unknown))
			}
			return nil
		}
	}

	/// Upload the given file via a POST request with the given endpoint.
	@discardableResult
	public func postUpload<T>(_ endpoint: RequestEndpoint, file fileURL: URL, headers: [String: String], keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, parameters queryParams: URLEncodedBody? = nil, body: RequestBody? = nil, completion completionHandler: @escaping Completion<T>) -> PendingRequest? {
		return upload(endpoint, method: .post, file: fileURL, headers: headers, keyDecodingStrategy: keyDecodingStrategy, parameters: queryParams, body: body, completion: completionHandler)
	}
	
	/// Upload the given file via a PUT request with the geiven endpoint.
	@discardableResult
	public func putUpload<T>(_ endpoint: RequestEndpoint, file fileURL: URL, headers: [String: String], keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, parameters queryParams: URLEncodedBody? = nil, body: RequestBody? = nil, completion completionHandler: @escaping Completion<T>) -> PendingRequest? {
		return upload(endpoint, method: .put, file: fileURL, headers: headers, keyDecodingStrategy: keyDecodingStrategy, parameters: queryParams, body: body, completion: completionHandler)
	}
	
	private func upload<T>(_ endpoint: RequestEndpoint, method: Zone5.Method, file fileURL: URL, headers: [String: String], keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, parameters queryParams: URLEncodedBody? = nil, body: RequestBody? = nil, completion completionHandler: @escaping Completion<T>) -> PendingRequest? {
		
		return perform(with: completionHandler) { zone5 in
			let request = Request(endpoint: endpoint, method: method, headers: headers, queryParams: queryParams, body: body)
			return zone5.httpClient.upload(fileURL, with: request, keyDecodingStrategy: keyDecodingStrategy, expectedType: T.self, completion: completionHandler)
		}
		
	}

	/// Download a file with the given endpoint. This is a get request so may contain query parameters but no body
	@discardableResult
	public func download(_ endpoint: RequestEndpoint, headers: [String: String], queryParams: URLEncodedBody? = nil, progressHandler: ( (_ progress: Progress) -> Void )? = nil, completionHandler: @escaping Completion<URL>) -> PendingRequest? {
		
		return perform(with: completionHandler) { zone5 in
			let request = Request(endpoint: endpoint, method: .get, headers: headers, queryParams: queryParams)
			return zone5.httpClient.download(request, progress: progressHandler, completion: completionHandler)
		}
		
	}
}
