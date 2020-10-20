import Foundation

struct Request {

	var endpoint: RequestEndpoint

	var method: Method

	var body: RequestBody?
	
	var queryParams: URLEncodedBody?

	init(endpoint: RequestEndpoint, method: Method, queryParams: URLEncodedBody? = nil, body: RequestBody? = nil) {
		self.endpoint = endpoint
		self.method = method
		self.queryParams = queryParams
		self.body = body
	}

	enum Method: String {
		case get = "GET"
		case head = "HEAD"
		case post = "POST"
		case put = "PUT"
		case delete = "DELETE"
		case connect = "CONNECT"
		case options = "OPTIONS"
		case trace = "TRACE"
		case patch = "PATCH"
	}

	func urlRequest(with baseURL: URL, accessToken: AccessToken?) throws -> URLRequest {
		let url = baseURL.appendingPathComponent(endpoint.uri)
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		request.setValue("true", forHTTPHeaderField: "tp-nodecorate")

		// Sign the request with the access token if we have one
		if endpoint.requiresAccessToken, let accessToken = accessToken {
			request.setValue("Bearer \(accessToken.rawValue)", forHTTPHeaderField: "Authorization")
		}
		else if endpoint.requiresAccessToken {
			throw Zone5.Error.requiresAccessToken
		}

		// if there are queryParams, set them in the request. This is valid on all types.
		if let queryParams = queryParams {
			guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
				print("Request URL could not be converted to URLComponents: \(url)")
				throw Zone5.Error.failedEncodingRequestBody
			}

			components.queryItems = queryParams.queryItems
			request.url = components.url
		}
		
		// process body of request
		switch method {
		case .get, .head:
			// no body allowed
			if let body = body {
				print("GET request for endpoint `\(endpoint)` has body content of type `\(type(of: body))`. Is this intended to be a POST request?")
				throw Zone5.Error.unexpectedRequestBody
			}

		case .post, .delete:
			// body is optional
			if let body = body {
				do {
					request.setValue(body.contentType, forHTTPHeaderField: "Content-Type")
					request.httpBody = try body.encodedData()
				}
				catch {
					print("An error was thrown while encoding the request body: \(error)")
					throw Zone5.Error.failedEncodingRequestBody
				}
			}

		default:
			throw Zone5.Error.unknown
		}
		
		return request
	}

	func urlRequest(toUpload fileURL: URL, with baseURL: URL, accessToken: AccessToken?) throws -> (URLRequest, Data) {
		var request = try urlRequest(with: baseURL, accessToken: accessToken)
		request.httpBody = nil

		do {
			var multipart = MultipartEncodedBody()
			try multipart.appendPart(name: "filename", content: fileURL.lastPathComponent)
			try multipart.appendPart(name: "attachment", contentsOf: fileURL)

			if let body = body as? JSONEncodedBody {
				try multipart.appendPart(name: "json", content: body)
			}
			else if body != nil {
				throw Zone5.Error.unexpectedRequestBody
			}

			request.setValue(multipart.contentType, forHTTPHeaderField: "Content-Type")

			return (request, try multipart.encodedData())
		}
		catch Zone5.Error.unexpectedRequestBody {
			throw Zone5.Error.unexpectedRequestBody
		}
		catch {
			throw Zone5.Error.failedEncodingRequestBody
		}
	}

}
