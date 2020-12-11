import Foundation

final public class Zone5HTTPClient {

	private static let downloadProgressNotification = Notification.Name("downloadProgressNotification")
	private static let downloadCompleteNotification = Notification.Name("downloadCompleteNotification")
	
	/// The parent instance of the `Zone5` SDK.
	weak var zone5: Zone5?

	/// The `URLSession` used to perform requests.
	/// - Note: This is defined as a custom protocol to allow injection of a mock instance used in unit testing.
	private let urlSession: HTTPClientURLSession

	/// Object used for managing the various delegate calls made by our `urlSession`.
	internal let urlSessionDelegate: Zone5DownloadDelegate = Zone5DownloadDelegate()
	
	/// Initializes a new instance of the `HTTPClient` that uses the URLRequestInterceptor to process requests
	public init() {
		
		// create a URLSession which routes all requests into the interceptor
		let configuration: URLSessionConfiguration = .default
		configuration.protocolClasses = [ URLRequestInterceptor.self ]
		
		self.urlSession = URLSession(configuration: configuration, delegate: urlSessionDelegate, delegateQueue: nil)
		
		urlSessionDelegate.httpClient = self
	}

	/// Initializes a new instance of the `HTTPClient` with the given URLSession
	/// This is used in unit tests to mock a URLSesson
	/// - Parameter urlSession: A custom `HTTPClientURLSession` instance to use for handling calls.
	/// - Note: For testing purposes _only_.
	init(urlSession: HTTPClientURLSession) {
		self.urlSession = urlSession
		urlSessionDelegate.httpClient = self
	}

	/// Delegate class used for managing the various calls made by our `urlSession`. Delegate is only used by downloads. Upload and Data tasks use completion handler which automatically disables delegates.
	/// Used by downloads to capture progress
	final internal class Zone5DownloadDelegate: NSObject, URLSessionDownloadDelegate {
		weak var httpClient: Zone5HTTPClient?
		
		func postCompleteNotification(response: URLResponse?, downloadTask: URLSessionDownloadTask, location: URL) {
			var userInfo: [String:Any] = ["location": location]
			if let response = response {
				userInfo["response"] = response
			}
			
			httpClient?.zone5?.notificationCenter.post(name: downloadCompleteNotification, object: downloadTask, userInfo: userInfo)
		}
		
		func postCompleteErrorNotification(response: URLResponse?, downloadTask: URLSessionDownloadTask, error: Swift.Error) {
			var userInfo: [String:Any] = ["error": error]
			if let response = response {
				userInfo["response"] = response
			}
			
			httpClient?.zone5?.notificationCenter.post(name: downloadCompleteNotification, object: downloadTask, userInfo: userInfo)
		}
		
		func postProgressNotification(downloadTask: URLSessionDownloadTask, bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
			httpClient?.zone5?.notificationCenter.post(name: Zone5HTTPClient.downloadProgressNotification, object: downloadTask, userInfo: [
				"bytesWritten": bytesWritten,
				"totalBytesWritten" : totalBytesWritten,
				"totalBytesExpectedToWrite" : totalBytesExpectedToWrite
			   ])
		}
		
		/// MARK: URLSessionDownloadDelegate
		
		// URLSessionDownloadDelegate: download complete. Call complete
		public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
			postCompleteNotification(response: downloadTask.response, downloadTask: downloadTask, location: location)
		}

		// URLSessionDownloadDelegate: download progress. Call progress
		public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
			postProgressNotification(downloadTask: downloadTask, bytesWritten: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
		}
		
		// URLSessionTaskDelegate: on success we would've called from urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL).
		public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
			if let downloadTask = task as? URLSessionDownloadTask {
				if let error = error {
					postCompleteErrorNotification(response: downloadTask.response, downloadTask: downloadTask, error: error)
				} else {
					// if the file download was successful then urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
					// would've been called and the notification would've been posted and handled and the observer deregistered so this post will go unheard.
					// this is just a catch all to make sure there is no scenario that a completion handler is not called
					postCompleteErrorNotification(response: downloadTask.response, downloadTask: downloadTask, error: Zone5.Error.unknown)
				}
			}
		}
	}

	// MARK: Cache directories

	/// Cache directory used for storing uploads.
	private static let uploadsDirectory: URL = {
		let sharedURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		let uploadURL = sharedURL.appendingPathComponent("com.zone5ventures.Zone5SDK/uploads")
		try! FileManager.default.createDirectory(at: uploadURL, withIntermediateDirectories: true, attributes: nil)
		return uploadURL
	}()

	/// Cache directory used for storing downloads.
	private static let downloadsDirectory: URL = {
		let sharedURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		let downloadURL = sharedURL.appendingPathComponent("com.zone5ventures.Zone5SDK/downloads")
		try! FileManager.default.createDirectory(at: downloadURL, withIntermediateDirectories: true, attributes: nil)
		return downloadURL
	}()

	// MARK: Performing requests

	/// The decoder used to convert raw response data into a structure of the expected type.
	private let decoder = JSONDecoder()

	/// Validates the SDK configuration, and then calls the given `block` function, handling any thrown errors using the given `completion`.
	/// - Parameters:
	///   - completion: Function called with errors that are thrown in the `block`.
	///   - block: The function containing the work to perform. It receives a strong copy of the parent `Zone5` class, and the configured `baseURL`.
	private func execute<T>(with completion: (_ result: Result<T, Zone5.Error>) -> Void, _ block: (_ zone5: Zone5) throws -> PendingRequest) -> PendingRequest? {
		do {
			guard let zone5 = zone5, zone5.isConfigured else {
				throw Zone5.Error.invalidConfiguration
			}

			return try block(zone5)
		}
		catch {
			if let error = error as? Zone5.Error {
				completion(.failure(error))
			}
			else {
				completion(.failure(.unknown))
			}
			return nil
		}
	}

	/// Perform a data task using the given `request`, calling the completion with the result.
	/// - Parameters:
	///   - request: A request that defines the endpoint, method and body used.
	///   - expectedType: The expected, `Decodable` type that is used to decode the response data.
	///   - completion: Function called with the result of the download. If successful, the response data is returned,
	///   		decoded as the given `expectedType`, otherwise the error that was encountered.
    func perform<T: Decodable>(_ request: Request,
                                      keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                      expectedType: T.Type,
                                      completion: @escaping (_ result: Result<T, Zone5.Error>) -> Void) -> PendingRequest? {
		return execute(with: completion) { zone5 in
			let urlRequest = try request.urlRequest(zone5: zone5, taskType: .data)
			
			let decoder = self.decoder
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
			let task = urlSession.dataTask(with: urlRequest) { data, response, error in
				if let error = error {
					completion(.failure(.transportFailure(error)))
				}
				else if let data = data {
					completion(decoder.decode(data, response: response, from: request, as: expectedType, debugLogging: zone5.debugLogging))
				}
				else {
					completion(.failure(.unknown))
				}
			}
			
			task.resume()
			return PendingRequest(task)
		}
	}
    
    /// Perform a data task using the given `request`, calling the completion with the result.
    /// - Parameters:
    ///   - request: A request that defines the endpoint, method and body used.
    ///   - completion: Function called with the result of the download. If successful, the response data is returned,
    func perform(_ request: Request,
				completion: @escaping (_ result: Result<(Data?, URLResponse), Zone5.Error>) -> Void) -> PendingRequest? {
        return execute(with: completion) { zone5 in
            let urlRequest = try request.urlRequest(zone5: zone5, taskType: .data)
            
            let task = urlSession.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    completion(.failure(.transportFailure(error)))
                }
				else if let response = response {
					completion(.success((data, response)))
				}
                else {
					completion(.failure(.failedDecodingResponse(Zone5.Error.unknown)))
                }
            }
            task.resume()
            return PendingRequest(task)
        }
    }

	/// Perform an upload task using the given `fileURL` and `request`, calling the completion with the result.
	///
	/// This method prepares a `MultipartEncodedBody` containing the contents of the file to be uploaded, caches it to
	/// disk, and then uses that as the source for the subsequent upload task, attaching the `request`s body as a part
	/// of the multipart data. As such, the request body is therefore expected to conform to `JSONEncodedBody`, and
	/// will result in an error if another body type is provided.
	/// - Parameters:
	///   - fileURL: The URL for the file to be uploaded.
	///   - request: A request that defines the endpoint, method and body used.
	///   - expectedType: The expected, `Decodable` type that is used to decode the response data.
	///   - completion: Function called with the result of the upload. If successful, the response data is returned,
	///   		decoded as the given `expectedType`, otherwise the error that was encountered.
	func upload<T: Decodable>(_ fileURL: URL, with request: Request, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, expectedType: T.Type, completion: @escaping (_ result: Result<T, Zone5.Error>) -> Void) -> PendingRequest? {
		return execute(with: completion) { zone5 in
			var (urlRequest, multipartData) = try request.urlRequest(toUpload: fileURL, zone5: zone5)
			let cacheURL = Zone5HTTPClient.uploadsDirectory.appendingPathComponent(fileURL.lastPathComponent).appendingPathExtension("multipart")

			// save URL against the request (needed to create actual uploadTask in interceptor)
			urlRequest = urlRequest.setMeta(key: .fileURL, value: cacheURL)
			
			do {
				try multipartData.write(to: cacheURL)
			}
			catch {
				throw Zone5.Error.failedEncodingRequestBody
			}

			let decoder = self.decoder
            decoder.keyDecodingStrategy = keyDecodingStrategy
			
			let task = urlSession.uploadTask(with: urlRequest, fromFile: cacheURL) { data, response, error in
				defer { try? FileManager.default.removeItem(at: cacheURL) }

				if let error = error {
					completion(.failure(.transportFailure(error)))
				}
				else if let data = data {
					completion(decoder.decode(data, response: response, from: request, as: expectedType, debugLogging: zone5.debugLogging))
				}
				else {
					completion(.failure(.unknown))
				}
			}

			task.resume()
			return PendingRequest(task)
		}
	}

	/// Perform a download task using the given `request`, calling the completion with the result.
	/// - Parameters:
	///   - request: A request that defines the endpoint, method and body used.
	///   - completion: Function called with the result of the download. If successful, the location of the downloaded
	///			file on disk is returned, otherwise the error that was encountered.
	func download(_ request: Request, progress onProgress: ( (_ bytesWritten: Int64, _ totalBytesWritten: Int64, _ totalBytesExpectedToWrite: Int64) -> Void )? = nil, completion onCompletion: @escaping (_ result: Result<URL, Zone5.Error>) -> Void) -> PendingRequest? {
		return execute(with: onCompletion) { zone5 in
			let urlRequest = try request.urlRequest(zone5: zone5, taskType: .download)

			let decoder = self.decoder
			decoder.keyDecodingStrategy = .useDefaultKeys
			
			// create with no completion handler. This will force delegate to be used so that we can capture progress
			let task = urlSession.downloadTask(with: urlRequest)
			
			// observe the URLDownloadDelegate callbacks. Note that queue here is intentionally nil so that "the block runs synchronously on the posting thread", which is the serial URLSession delegate/callback thread
			let progressObserver: NSObjectProtocol = zone5.notificationCenter.addObserver(forName: Zone5HTTPClient.downloadProgressNotification, object: task, queue: nil) { notification in
				if let bytesWritten = notification.userInfo?["bytesWritten"] as? Int64,
				   let totalBytesWritten = notification.userInfo?["totalBytesWritten"] as? Int64,
				   let totalBytesExpectedToWrite = notification.userInfo?["totalBytesExpectedToWrite"] as? Int64 {
					onProgress?(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite)
				}
			}
			
			var completeObserver: NSObjectProtocol? = nil
			completeObserver = zone5.notificationCenter.addObserver(forName: Zone5HTTPClient.downloadCompleteNotification, object: task, queue: nil) { notification in
				// remove observers.
				zone5.notificationCenter.removeObserver(progressObserver, name: Zone5HTTPClient.downloadProgressNotification, object: task)
				if let completeObserver = completeObserver {
					zone5.notificationCenter.removeObserver(completeObserver, name: Zone5HTTPClient.downloadCompleteNotification, object: task)
				}
				
				if let error = notification.userInfo?["error"] as? Error {
					onCompletion(.failure(.transportFailure(error)))
				}
				else if let response = notification.userInfo?["response"] as? HTTPURLResponse,
						(200..<400).contains(response.statusCode),
						let location = notification.userInfo?["location"] as? URL,
						let filename = response.suggestedFilename {
					do {
						let cacheURL = Zone5HTTPClient.downloadsDirectory.appendingPathComponent(filename)
						try? FileManager.default.removeItem(at: cacheURL)
						
						try FileManager.default.copyItem(at: location, to: cacheURL)

						onCompletion(.success(cacheURL))

						try? FileManager.default.removeItem(at: cacheURL)
					}
					catch {
						onCompletion(.failure(.transportFailure(error)))
					}
				}
				else if let response = notification.userInfo?["response"] as? URLResponse, let location = notification.userInfo?["location"] as? URL, let data = try? Data(contentsOf: location) {
					onCompletion(decoder.decode(data, response: response, from: request, as: URL.self, debugLogging: zone5.debugLogging))
				}
				else {
					onCompletion(.failure(.unknown))
				}

			}
			
			task.resume()
			
			return PendingRequest(task)
		}
	}
}

extension JSONDecoder {

	func decode<T: Decodable>(_ data: Data, response: URLResponse?, from request: Request, as expectedType: T.Type, debugLogging: Bool = false) -> Result<T, Zone5.Error> {
		defer {
			if debugLogging {
				// don't unecessarily construct log lines unless debugLogging is explicitly set
				var debugMessage = ""
				if let requestData = try? request.body?.encodedData(), let requestString = String(data: requestData, encoding: .utf8) {
					debugMessage += "\n\t- Request to \(request.endpoint.uri): \(requestString)"
				}
				if let responseString = String(data: data, encoding: .utf8) {
					debugMessage += "\n\t- Response: \(responseString)"
				}
				z5DebugLog(debugMessage)
			}
		}

		if let httpResponse = response as? HTTPURLResponse {
			guard (200..<400).contains(httpResponse.statusCode) else {
                z5DebugLog("Server responded with status code of \(httpResponse.statusCode) to \(request.endpoint.uri). (headers were \(request.headers ?? [:]))")

				do {
					var decodedMessage = try decode(Zone5.Error.ServerMessage.self, from: data)
					decodedMessage.statusCode = httpResponse.statusCode

					return .failure(.serverError(decodedMessage))
				}
				catch {
					let serverError = Zone5.Error.ServerMessage(message: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode), statusCode: httpResponse.statusCode)
					return .failure(.serverError(serverError))
				}
			}
		}

		do {
			// Attempt to decode and return the `data` as the `expectedType` using our decoder
			if expectedType == Zone5.VoidReply.self {
				// special handling required for Void types. Enforce enpty data. Create NoReply object.
				if data.count > 0 {
					z5Log("Failed to decode server response as `\(expectedType)`. Error: Non Void response")
					return .failure(.failedDecodingResponse(Zone5.Error.failedDecodingResponse(Zone5.Error.unknown)))
				} else {
					return .success(Zone5.VoidReply() as! T)
				}
			}
			
			let decodedValue: T
			if #available(iOS 13.0, *) {
				// from iOS 13 fragments are correctly decoded
				//print(String(bytes: data, encoding: .utf8))
				decodedValue = try decode(expectedType, from: data)
			}
			else if expectedType == Bool.self || expectedType == String.self {
				// prior to iOS 13 top level fragments cannot be decoded with JSONDecoder.
				// If we know that we are a fragment, decode fragement
				let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
				decodedValue = jsonObject as! T
				
			} else {
				// prior to iOS 13 top level fragments cannot be decoded with JSONDecoder.
				// If we do not know that we are a fragement, attempt normal decode and fall back to fragment
				do {
					decodedValue = try decode(expectedType, from: data)
				}
				catch {
					let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.fragmentsAllowed])
					if let value = jsonObject as? T {
						decodedValue = value
					} else if let value = jsonObject as? Zone5.Error.ServerMessage {
						z5Log("Failed to decode server response as `\(expectedType)`. Error: \(error)")
						return .failure(.serverError(value))
					} else {
						throw error
					}
				}
			}
			
            z5DebugLog("Successfully decoded server response from \(response?.url?.absoluteString ?? "") as `\(expectedType)`.")

			return .success(decodedValue)
		}
		catch {
			let originalError = error

			z5Log("Failed to decode server response as `\(expectedType)`. Error: \(originalError)")

			do {
				// Decoding as `expectedType` failed, so lets try to decode as a `ServerMessage` instead, in the hopes
				// that the server responded with a legitimate error.
				let decodedMessage = try decode(Zone5.Error.ServerMessage.self, from: data)

				return .failure(.serverError(decodedMessage))
			}
			catch {
				// Decoding as a `ServerMessage` also failed, so we should pass on the original error.
				// Getting this far typically means there's a problem in the SDK.
				return .failure(.failedDecodingResponse(originalError))
			}
		}
	}


}

internal protocol HTTPClientURLSession: class {

	func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

	func uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask

	func downloadTask(with: URLRequest) -> URLSessionDownloadTask
}

extension URLSession: HTTPClientURLSession { }
