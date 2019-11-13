import Foundation

public class APIView {

	internal weak var zone5: Zone5?

	internal init(zone5: Zone5) {
		self.zone5 = zone5
	}

	typealias Completion<T: Decodable> = (_ result: Result<T, Zone5.Error>) -> Void

	/// Executes the given `block`, calling the `completionHandler` if an error is thrown.
	internal func perform<T>(with completionHandler: @escaping Completion<T>, _ block: (_ zone5: Zone5) throws -> Void) {
		do {
			guard let zone5 = zone5 else {
				throw Zone5.Error.unknown
			}

			try block(zone5)
		}
		catch {
			if let error = error as? Zone5.Error {
				completionHandler(.failure(error))
			}
			else {
				completionHandler(.failure(.unknown))
			}
		}
	}

	internal func get<T>(_ endpoint: RequestEndpoint, parameters: URLEncodedBody?, expectedType: T.Type, with completionHandler: @escaping Completion<T>) {
		let request = Request(endpoint: endpoint, method: .get, body: parameters)

		perform(with: completionHandler) { zone5 in
			zone5.httpClient.perform(request, expectedType: T.self, completion: completionHandler)
		}
	}

	internal func get<T>(_ endpoint: RequestEndpoint, parameters: URLEncodedBody? = nil, with completionHandler: @escaping Completion<T>) {
		get(endpoint, parameters: parameters, expectedType: T.self, with: completionHandler)
	}

	internal func post<T>(_ endpoint: RequestEndpoint, body: RequestBody, expectedType: T.Type, with completionHandler: @escaping Completion<T>) {
		let request = Request(endpoint: endpoint, method: .post, body: body)

		perform(with: completionHandler) { zone5 in
			zone5.httpClient.perform(request, expectedType: T.self, completion: completionHandler)
		}
	}

	internal func post<T>(_ endpoint: RequestEndpoint, body: RequestBody, with completionHandler: @escaping Completion<T>) {
		post(endpoint, body: body, expectedType: T.self, with: completionHandler)
	}

	internal func upload<T>(_ endpoint: RequestEndpoint, contentsOf fileURL: URL, body: RequestBody?, expectedType: T.Type, with completionHandler: @escaping Completion<T>) {
		let request = Request(endpoint: endpoint, method: .post, body: body)

		perform(with: completionHandler) { zone5 in
			zone5.httpClient.upload(fileURL, with: request, expectedType: T.self, completion: completionHandler)
		}
	}

	internal func upload<T>(_ endpoint: RequestEndpoint, contentsOf fileURL: URL, body: RequestBody? = nil, with completionHandler: @escaping Completion<T>) {
		upload(endpoint, contentsOf: fileURL, body: body, expectedType: T.self, with: completionHandler)
	}

	internal func download(_ endpoint: RequestEndpoint, parameters: URLEncodedBody? = nil, with completionHandler: @escaping Completion<URL>) {
		let request = Request(endpoint: endpoint, method: .get, body: parameters)

		perform(with: completionHandler) { zone5 in
			zone5.httpClient.download(request, completion: completionHandler)
		}
	}

}
