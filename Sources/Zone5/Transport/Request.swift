import Foundation

struct Request {

	var endpoint: String

	var parameters: [String: String]

	var accessToken: AccessToken?

	init(endpoint: String) {
		self.endpoint = endpoint
		self.parameters = [:]
	}

	init(endpoint: String, accessToken: AccessToken) {
		self.init(endpoint: endpoint)

		self.accessToken = accessToken
	}


	var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = []

		for (key, value) in parameters {
			items.append(URLQueryItem(name: key, value: value))
		}

		return items.sorted { $0.name < $1.name }
    }


	enum Method {
		case get
		case post(_ encoding: Encoding)
	}

	enum Encoding: String {
		case json = "application/json"
		case url = "application/x-www-form-urlencoded"
		case multipart = "multipart/form-data"
	}

	func urlRequest(for baseURL: URL, method: Method) throws -> URLRequest {
		var request = URLRequest(url: baseURL.appendingPathComponent(endpoint))

		switch method {
		case .get:
			request.httpMethod = "GET"

		case .post(let encoding):
			request.httpMethod = "POST"

			if !parameters.isEmpty {
				request.setValue(encoding.rawValue, forHTTPHeaderField: "Content-Type")

				if case .json = encoding, let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
					request.httpBody = body
				}
				else if case .url = encoding, let body = queryItems.urlEncodedString.data(using: .utf8) {
					request.httpBody = body
				}
				else if case .multipart = encoding {
					request.httpBody = nil
				}
				else {
					throw Zone5.Error.failedEncodingParameters
				}
			}
		}

		accessToken?.sign(request: &request)

		return request
	}

}

fileprivate extension URLQueryItem {

	var urlEncodedString: String {
		guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
			return description
		}

		if let encodedValue = value?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
			return String(format: "%@=%@", encodedName, encodedValue)
		}
		else {
			return String(format: "%@", encodedName)
		}
	}

}

fileprivate extension Array where Element == URLQueryItem {

	var urlEncodedString: String {
		return map { $0.urlEncodedString }.joined(separator: "&")
	}

}
