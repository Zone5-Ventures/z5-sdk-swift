import Foundation

final internal class HTTPClient {

	weak var zone5: Zone5?

	var decoder = JSONDecoder()

	private let urlSession: HTTPClientURLSession

	private let urlSessionDelegate: URLSessionDelegate?

	init() {
		let configuration = URLSessionConfiguration.default
		let urlSessionDelegate = URLSessionDelegate()
		let urlSession = URLSession(configuration: configuration, delegate: urlSessionDelegate, delegateQueue: nil)

		self.urlSession = urlSession
		self.urlSessionDelegate = urlSessionDelegate

		urlSessionDelegate.httpClient = self
	}

	/// - Parameter urlSession: A `HTTPClientURLSession` instance to use for handling calls.
	/// - Note: For testing purposes _only_.
	init(urlSession: HTTPClientURLSession) {
		self.urlSession = urlSession
		self.urlSessionDelegate = nil
	}

	fileprivate class URLSessionDelegate: NSObject, Foundation.URLSessionDelegate {

		weak var httpClient: HTTPClient?

	}

	// MARK: Cache directories

	private static let cachesDirectory: URL = {
		let sharedURL = try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		return sharedURL.appendingPathComponent("com.zone5ventures.Zone5SDK")
	}()

	private static let uploadsDirectory = cachesDirectory.appendingPathComponent("uploads").creatingIfNeeded()

	private static let downloadsDirectory = cachesDirectory.appendingPathComponent("downloads").creatingIfNeeded()

	// MARK: Performing requests

	private func execute<T: Decodable>(with completion: (_ result: Result<T, Zone5.Error>) -> Void, _ block: (_ zone5: Zone5, _ baseURL: URL) throws -> Void) {
		do {
			guard let zone5 = zone5, let baseURL = zone5.baseURL else {
				throw Zone5.Error.invalidConfiguration
			}

			try block(zone5, baseURL)
		}
		catch {
			if let error = error as? Zone5.Error {
				completion(.failure(error))
			}
			else {
				completion(.failure(.unknown))
			}
		}
	}

	func perform<T: Decodable>(_ request: Request, expectedType: T.Type, completion: @escaping (_ result: Result<T, Zone5.Error>) -> Void) {
		execute(with: completion) { zone5, baseURL in
			let urlRequest = try request.urlRequest(with: baseURL, accessToken: zone5.accessToken)

			let decoder = self.decoder
			let task = urlSession.dataTask(with: urlRequest) { data, response, error in
				if let error = error {
					completion(.failure(.transportFailure(error)))
				}
				else if let data = data {
					completion(decoder.decode(data, from: request, as: expectedType))
				}
				else {
					completion(.failure(.unknown))
				}
			}

			task.resume()
		}
	}

	func upload<T: Decodable>(_ fileURL: URL, with request: Request, expectedType: T.Type, completion: @escaping (_ result: Result<T, Zone5.Error>) -> Void) {
		execute(with: completion) { zone5, baseURL in
			let (urlRequest, multipartData) = try request.urlRequest(toUpload: fileURL, with: baseURL, accessToken: zone5.accessToken)
			let cacheURL = HTTPClient.uploadsDirectory.appendingPathComponent(fileURL.lastPathComponent).appendingPathExtension("multipart")

			do {
				try multipartData.write(to: cacheURL)
			}
			catch {
				throw Zone5.Error.failedEncodingRequestBody
			}

			let decoder = self.decoder
			let task = urlSession.uploadTask(with: urlRequest, fromFile: cacheURL) { [weak self] data, response, error in
				defer { try? FileManager.default.removeItem(at: fileURL) }

				if let error = error {
					completion(.failure(.transportFailure(error)))
				}
				else if let data = data {
					completion(decoder.decode(data, from: request, as: expectedType))
				}
				else {
					completion(.failure(.unknown))
				}
			}

			task.resume()
		}
	}

}

private extension URL {

	func creatingIfNeeded() -> URL {
		try! FileManager.default.createDirectory(at: self, withIntermediateDirectories: true, attributes: nil)

		return self
	}

}

private extension JSONDecoder {

	func decode<T: Decodable>(_ data: Data, from request: Request, as expectedType: T.Type) -> Result<T, Zone5.Error> {
		do {
			// Attempt to decode and return the `data` as the `expectedType` using our decoder
			let response = try decode(expectedType, from: data)

			return .success(response)
		}
		catch {
			let originalError = error

			do {
				// Decoding as `expectedType` failed, so lets try to decode as a `ServerMessage` instead, in the hopes
				// that the server responded with a legitimate error.
				let message = try decode(Zone5.Error.ServerMessage.self, from: data)

				return .failure(.serverError(message))
			}
			catch {
				#if DEBUG
				var debugMessage = "Failed to decode server response.\n\t- Error: \(originalError)"
				if let requestData = try? request.body?.encodedData(), let requestString = String(data: requestData, encoding: .utf8) {
					debugMessage += "\n\t- Request: \(requestString)"
				}
				if let responseString = String(data: data, encoding: .utf8) {
					debugMessage += "\n\t- Response: \(responseString)"
				}
				print(debugMessage)
				#endif

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

}

extension URLSession: HTTPClientURLSession { }
