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

	private class URLSessionDelegate: NSObject, Foundation.URLSessionDelegate {

		weak var httpClient: HTTPClient?

	}

	// MARK: Performing requests

	private func perform(_ request: Request, method: Request.Method, completion: @escaping (_ result: Result<Data, Zone5.Error>) -> Void) {
		do {
			guard let zone5 = zone5, let baseURL = zone5.baseURL else {
				throw Zone5.Error.invalidConfiguration
			}

			var urlRequest = try request.urlRequest(for: baseURL, method: method)

			if request.endpoint.requiresAccessToken {
				guard let accessToken = zone5.accessToken else {
					throw Zone5.Error.requiresAccessToken
				}

				accessToken.sign(request: &urlRequest)
			}

			let task = urlSession.dataTask(with: urlRequest) { data, response, error in
				if let error = error {
					completion(.failure(.transportFailure(error)))
				}
				else if let data = data {
					completion(.success(data))
				}
				else {
					completion(.failure(.unknown))
				}
			}

			task.resume()
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

	func post<T: Decodable>(_ request: Request, expectedType: T.Type, completion: @escaping (_ result: Result<T, Zone5.Error>) -> Void) {
		perform(request, method: .post) { [weak self] result in
			guard let self = self else {
				completion(.failure(.invalidConfiguration))

				return
			}

			switch result {
			case .failure(let error):
				completion(.failure(error))

			case .success(let data):
				do {
					let object = try self.decoder.decode(expectedType, from: data)

					completion(.success(object))
				}
				catch {
					let originalError = error

					do {
						let message = try self.decoder.decode(Zone5.Error.ServerMessage.self, from: data)

						if let data = try? request.body?.encodedData(), let string = String(data: data, encoding: .utf8) {
							print(string)
						}

						completion(.failure(.serverError(message)))
					}
					catch {
						print("Failed to decode server response: \(String(data: data, encoding: .utf8) ?? "unknown content")")
						completion(.failure(.failedDecodingResponse(originalError)))
					}
				}
			}
		}
	}

	func get<T: Decodable>(_ request: Request, expectedType: T.Type, completion: @escaping (_ result: Result<T, Zone5.Error>) -> Void) {
		perform(request, method: .get) { [weak self] result in
			guard let self = self else {
				completion(.failure(.invalidConfiguration))

				return
			}

			switch result {
			case .failure(let error):
				completion(.failure(error))

			case .success(let data):
				do {
					let object = try self.decoder.decode(expectedType, from: data)

					completion(.success(object))
				}
				catch {
					print(String(data: data, encoding: .utf8))

					completion(.failure(.failedDecodingResponse(error)))
				}
			}
		}
	}

}

internal protocol HTTPClientURLSession: class {

	func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

}

extension URLSession: HTTPClientURLSession { }
