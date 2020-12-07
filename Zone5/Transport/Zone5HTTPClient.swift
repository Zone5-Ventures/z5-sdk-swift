import Foundation

final public class Zone5HTTPClient {

	/// The parent instance of the `Zone5` SDK.
	weak var zone5: Zone5?

	/// The `URLSession` used to perform requests.
	/// - Note: This is defined as a custom protocol to allow injection of a mock instance used in unit testing.
	private let urlSession: HTTPClientURLSession

	/// Object used for managing the various delegate calls made by our `urlSession`.
	private let urlSessionDelegate: URLSessionDelegate?

	/// Initializes a new instance of the `HTTPClient` that uses the URLRequestInterceptor to process requests
	public init() {
		let urlSessionDelegate = URLSessionDelegate()
		
		// create a URLSession which routes all requests into the interceptor
		let configuration: URLSessionConfiguration = .default
		configuration.protocolClasses = [ URLRequestInterceptor.self ]
		
		self.urlSession = URLSession(configuration: configuration, delegate: urlSessionDelegate, delegateQueue: nil)
		self.urlSessionDelegate = urlSessionDelegate

		urlSessionDelegate.httpClient = self
	}

	/// Initializes a new instance of the `HTTPClient` with the given URLSession
	/// This is used in unit tests to mock a URLSesson
	/// - Parameter urlSession: A custom `HTTPClientURLSession` instance to use for handling calls.
	/// - Note: For testing purposes _only_.
	init(urlSession: HTTPClientURLSession) {
		self.urlSession = urlSession
		self.urlSessionDelegate = nil
	}

	/// Delegate class used for managing the various calls made by our `urlSession`.
	final fileprivate class URLSessionDelegate: NSObject, Foundation.URLSessionDelegate {

		weak var httpClient: Zone5HTTPClient?

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
	private func execute<T: Decodable>(with completion: (_ result: Result<T, Zone5.Error>) -> Void, _ block: (_ zone5: Zone5, _ baseURL: URL) throws -> PendingRequest) -> PendingRequest? {
		do {
			guard let zone5 = zone5, zone5.isConfigured, let baseURL = zone5.baseURL else {
				throw Zone5.Error.invalidConfiguration
			}

			return try block(zone5, baseURL)
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
    public func perform<T: Decodable>(_ request: Request,
                                      additionalHeaders: [String: String]? = nil,
                                      keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                      expectedType: T.Type,
                                      completion: @escaping (_ result: Result<T, Zone5.Error>) -> Void) -> PendingRequest? {
		return execute(with: completion) { zone5, baseURL in
			var urlRequest = try request.urlRequest(with: baseURL, zone5: zone5, taskType: .data)
			let decoder = self.decoder
            decoder.keyDecodingStrategy = keyDecodingStrategy
            if let headers = additionalHeaders {
                for header in headers {
                    urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
                }
            }
			let task = urlSession.dataTask(with: urlRequest) { data, response, error in
				if let error = error {
					completion(.failure(.transportFailure(error)))
				}
				else if let data = data {
					completion(decoder.decode(data, response: response, from: request, as: expectedType))
				}
				else {
					completion(.failure(.unknown))
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
	///   - completion: Function called with the result of the download. If successful, the response data is returned,
	///   		decoded as the given `expectedType`, otherwise the error that was encountered.
	public func upload<T: Decodable>(_ fileURL: URL, with request: Request, expectedType: T.Type, completion: @escaping (_ result: Result<T, Zone5.Error>) -> Void) -> PendingRequest? {
		return execute(with: completion) { zone5, baseURL in
			var (urlRequest, multipartData) = try request.urlRequest(toUpload: fileURL, with: baseURL, zone5: zone5)
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
            decoder.keyDecodingStrategy = .useDefaultKeys
			let task = urlSession.uploadTask(with: urlRequest, fromFile: cacheURL) { data, response, error in
				defer { try? FileManager.default.removeItem(at: cacheURL) }

				if let error = error {
					completion(.failure(.transportFailure(error)))
				}
				else if let data = data {
					completion(decoder.decode(data, response: response, from: request, as: expectedType))
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
	public func download(_ request: Request, completion: @escaping (_ result: Result<URL, Zone5.Error>) -> Void) -> PendingRequest? {
		return execute(with: completion) { zone5, baseURL in
			let urlRequest = try request.urlRequest(with: baseURL, zone5: zone5, taskType: .download)

			let decoder = self.decoder
            decoder.keyDecodingStrategy = .useDefaultKeys
			let task = urlSession.downloadTask(with: urlRequest) { location, response, error in
				if let error = error {
					completion(.failure(.transportFailure(error)))
				}
				else if
					let contentDisposition = (response as? HTTPURLResponse)?.allHeaderFields["Content-Disposition"] as? String,
					contentDisposition.hasPrefix("attachment"),
					let location = location,
					let filename = response?.suggestedFilename {
					do {
						let cacheURL = Zone5HTTPClient.downloadsDirectory.appendingPathComponent(filename)
						try FileManager.default.copyItem(at: location, to: cacheURL)

						completion(.success(cacheURL))

						try? FileManager.default.removeItem(at: cacheURL)
					}
					catch {
						completion(.failure(.transportFailure(error)))
					}
				}
				else if let location = location, let data = try? Data(contentsOf: location) {
					completion(decoder.decode(data, response: response, from: request, as: URL.self))
				}
				else {
					completion(.failure(.unknown))
				}
			}

			task.resume()
			return PendingRequest(task)
		}
	}

}

public extension JSONDecoder {

	func decode<T: Decodable>(_ data: Data, response: URLResponse?, from request: Request, as expectedType: T.Type) -> Result<T, Zone5.Error> {
		#if DEBUG
		var debugMessage = ""
		defer {
			if let requestData = try? request.body?.encodedData(), let requestString = String(data: requestData, encoding: .utf8) {
                debugMessage += "\n\t- Request to \(response?.url?.absoluteString ?? "unknown"): \(requestString)"
			}
			if let responseString = String(data: data, encoding: .utf8) {
				debugMessage += "\n\t- Response: \(responseString)"
			}
			print(debugMessage)
		}
		#endif

		if let httpResponse = response as? HTTPURLResponse {
			guard (200..<400).contains(httpResponse.statusCode) else {
				#if DEBUG
                debugMessage = "Server responded with status code of \(httpResponse.statusCode) to \(request.endpoint.uri). (headers were \(request.headers ?? [:]))"
				#endif

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
					return .failure(.failedDecodingResponse(Zone5.Error.unknown))
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
						return .failure(.serverError(value))
					} else {
						throw error
					}
				}
			}
			
			#if DEBUG
            debugMessage = "Successfully decoded server response from \(response?.url?.absoluteString ?? "") as `\(expectedType)`."
			#endif

			return .success(decodedValue)
		}
		catch {
			let originalError = error

			#if DEBUG
			debugMessage = "Failed to decode server response as `\(expectedType)`.\n\t- Error: \(originalError)"
			#endif

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

	func downloadTask(with: URLRequest, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask

}

extension URLSession: HTTPClientURLSession { }
