import Foundation

final class HTTPClient {

	weak var zone5: Zone5?

	var decoder = JSONDecoder()

	let urlSession: URLSession

	private let urlSessionDelegate: URLSessionDelegate

	init() {
		let configuration = URLSessionConfiguration.default
		urlSessionDelegate = URLSessionDelegate()
		urlSession = URLSession(configuration: configuration, delegate: urlSessionDelegate, delegateQueue: nil)

		urlSessionDelegate.httpClient = self
	}

	private class URLSessionDelegate: NSObject, Foundation.URLSessionDelegate {

		weak var httpClient: HTTPClient?

	}

	// MARK: Performing requests

	private func perform(_ request: Request, method: Request.Method, completion: @escaping (_ result: Result<Data, Zone5.Error>) -> Void) {
		do {
			guard let baseURL = zone5?.baseURL else {
				throw Zone5.Error.invalidConfiguration
			}

			let urlRequest = try request.urlRequest(for: baseURL, method: method)

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

	func post<T: Decodable>(_ request: Request, encoding: Request.Encoding = .json, expectedType: T.Type, completion: @escaping (_ result: Result<T, Zone5.Error>) -> Void) {
		perform(request, method: .post(encoding)) { [weak self] result in
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
