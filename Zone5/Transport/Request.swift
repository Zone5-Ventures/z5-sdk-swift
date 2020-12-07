import Foundation

public struct Request {

	public var endpoint: RequestEndpoint

	var method: Method

	var body: RequestBody?
    
    var headers: [String: String]?
	
	var queryParams: URLEncodedBody?

    public init(endpoint: RequestEndpoint, method: Method, headers: [String: String]? = nil, queryParams: URLEncodedBody? = nil, body: RequestBody? = nil) {
		self.endpoint = endpoint
		self.method = method
        self.headers = headers
		self.queryParams = queryParams
		self.body = body
	}

	public enum Method: String {
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

	func urlRequest(with baseURL: URL, zone5: Zone5, taskType: URLSessionTaskType) throws -> URLRequest {
        let url: URL
        if !endpoint.uri.contains("http") {
            url = baseURL.appendingPathComponent(endpoint.uri)
        } else {
            guard let unwrapped = URL(string: endpoint.uri) else { throw Zone5.Error.invalidParameters }
            url = unwrapped
        }
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue

		// mark if token auth is required for the request
		if endpoint.requiresAccessToken, zone5.accessToken != nil {
			request = request.setMeta(key: .requiresAccessToken, value: true)
		}
		else if endpoint.requiresAccessToken {
			throw Zone5.Error.requiresAccessToken
		}
		
		// pass reference to Zone5 instance and set task type (data|upload|download)
		request = request.setMeta(key: .zone5, value: zone5).setMeta(key: .taskType, value: taskType)
		
		// if there are queryParams, set them in the request. This is valid on all types.
		if let queryParams = queryParams {
			guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
				print("Request URL could not be converted to URLComponents: \(url)")
				throw Zone5.Error.failedEncodingRequestBody
			}

			components.queryItems = queryParams.queryItems
			request.url = components.url
		}
        
        // if there are headers, add it to the request
        if let addtlHeaders = headers {
            for addtl in addtlHeaders {
                request.addValue(addtl.value, forHTTPHeaderField: addtl.key)
            }
        }
        
		// process body of request
		switch method {
		case .get, .head:
			// no body allowed
			if let body = body {
				print("GET request for endpoint `\(endpoint)` has body content of type `\(type(of: body))`. Is this intended to be a POST request?")
				throw Zone5.Error.unexpectedRequestBody
			}

        default:
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
		}
		
		return request
	}

	func urlRequest(toUpload fileURL: URL, with baseURL: URL, zone5: Zone5) throws -> (URLRequest, Data) {
		var request = try urlRequest(with: baseURL, zone5: zone5, taskType: .upload)
		
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
