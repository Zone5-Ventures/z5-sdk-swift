import Foundation

public class APIView {

	internal weak var zone5: Zone5?

	internal init(zone5: Zone5) {
		self.zone5 = zone5
	}

	typealias Completion<T: Decodable> = (_ result: Result<T, Zone5.Error>) -> Void

	/// Executes the given `block`, calling the `completionHandler` if an error is thrown.
	internal func perform<T>(with completionHandler: @escaping Completion<T>, _ block: (_ zone5: Zone5) throws -> PendingRequest?) -> PendingRequest? {
		do {
			guard let zone5 = zone5 else {
				throw Zone5.Error.unknown
			}

			return try block(zone5)
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

	internal func get<T>(_ endpoint: RequestEndpoint, parameters queryParams: URLEncodedBody?, expectedType: T.Type, with completionHandler: @escaping Completion<T>) -> PendingRequest? {
		let request = Request(endpoint: endpoint, method: .get, queryParams: queryParams)

		return perform(with: completionHandler) { zone5 in
			return zone5.httpClient.perform(request, expectedType: T.self, completion: completionHandler)
		}
	}

	internal func get<T>(_ endpoint: RequestEndpoint, parameters queryParams: URLEncodedBody? = nil, with completionHandler: @escaping Completion<T>) -> PendingRequest? {
		return get(endpoint, parameters: queryParams, expectedType: T.self, with: completionHandler)
	}

	/// post request may contain only a body *or* query params and a body
	internal func post<T>(_ endpoint: RequestEndpoint, parameters queryParams: URLEncodedBody? = nil, body: RequestBody?, expectedType: T.Type, with completionHandler: @escaping Completion<T>) -> PendingRequest? {
		let request = Request(endpoint: endpoint, method: .post, queryParams: queryParams, body: body)

		return perform(with: completionHandler) { zone5 in
			return zone5.httpClient.perform(request, expectedType: T.self, completion: completionHandler)
		}
	}

	internal func post<T>(_ endpoint: RequestEndpoint, parameters queryParams: URLEncodedBody? = nil, body: RequestBody?, with completionHandler: @escaping Completion<T>) -> PendingRequest? {
		return post(endpoint, parameters: queryParams, body: body, expectedType: T.self, with: completionHandler)
	}

	internal func delete<T>(_ endpoint: RequestEndpoint, parameters queryParams: URLEncodedBody? = nil, expectedType: T.Type, with completionHandler: @escaping Completion<T>) -> PendingRequest? {
		let request = Request(endpoint: endpoint, method: .delete, queryParams: queryParams)

		return perform(with: completionHandler) { zone5 in
			return zone5.httpClient.perform(request, expectedType: T.self, completion: completionHandler)
		}
	}

	internal func delete<T>(_ endpoint: RequestEndpoint, parameters queryParams: URLEncodedBody? = nil, with completionHandler: @escaping Completion<T>) -> PendingRequest? {
		return delete(endpoint, parameters: queryParams, expectedType: T.self, with: completionHandler)
	}

	internal func upload<T>(_ endpoint: RequestEndpoint, contentsOf fileURL: URL, body: RequestBody?, expectedType: T.Type, with completionHandler: @escaping Completion<T>) -> PendingRequest? {
		let request = Request(endpoint: endpoint, method: .post, body: body)

		return perform(with: completionHandler) { zone5 in
			return zone5.httpClient.upload(fileURL, with: request, expectedType: T.self, completion: completionHandler)
		}
	}

	internal func upload<T>(_ endpoint: RequestEndpoint, contentsOf fileURL: URL, body: RequestBody? = nil, with completionHandler: @escaping Completion<T>) -> PendingRequest? {
		return upload(endpoint, contentsOf: fileURL, body: body, expectedType: T.self, with: completionHandler)
	}

	internal func download(_ endpoint: RequestEndpoint, queryParams: URLEncodedBody? = nil, with completionHandler: @escaping Completion<URL>) -> PendingRequest? {
		let request = Request(endpoint: endpoint, method: .get, queryParams: queryParams)

		return perform(with: completionHandler) { zone5 in
			return zone5.httpClient.download(request, completion: completionHandler)
		}
	}

}
