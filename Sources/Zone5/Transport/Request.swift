import Foundation

struct Request {

	var endpoint: HTTPEndpoint

	var body: RequestBody?

	init(endpoint: HTTPEndpoint, body: RequestBody? = nil) {
		self.endpoint = endpoint
		self.body = body
	}

	enum Method: String {
		case get = "GET"
		case post = "POST"
	}

	func urlRequest(for baseURL: URL, method: Method) throws -> URLRequest {
		let url = baseURL.appendingPathComponent(endpoint.uri)
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue

		switch method {
		case .get:
			if let body = body as? URLEncodedBody {
				guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
					print("Request URL could not be converted to URLComponents: \(url)")
					throw Zone5.Error.failedEncodingRequestBody
				}

				components.queryItems = body.queryItems
				request.url = components.url
			}
			else if let body = body {
				print("GET request for endpoint `\(endpoint)` has body content of type `\(type(of: body))`. Is this intended to be a POST request?")
				throw Zone5.Error.unexpectedRequestBody
			}

		case .post:
			guard let body = body else {
				print("POST request for endpoint `\(endpoint)` is missing the body content. Is this intended to be a GET request?")
				throw Zone5.Error.missingRequestBody
			}

			do {
				request.setValue(body.contentType, forHTTPHeaderField: "Content-Type")
				request.httpBody = try body.encodedData()
			}
			catch {
				print("An error was thrown while encoding the request body: \(error)")
				throw Zone5.Error.failedEncodingRequestBody
			}
		}

		return request
	}

}
