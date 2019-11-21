import XCTest
@testable import Zone5

final class HTTPClientDownloadRequestTests: XCTestCase {

	private let developmentAssets = Bundle.tests.urlsForDevelopmentAssets()!.filter { $0.pathExtension != "multipart" }

	func testInvalidConfiguration() {
		var configuration = ConfigurationForTesting()
		configuration.baseURL = nil
		configuration.clientID = nil
		configuration.clientSecret = nil

		let methods: [Request.Method] = [
			.get,
			.post,
		]

		execute(with: methods, configuration: configuration) { zone5, httpClient, urlSession, method in
			let request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: method)

			urlSession.downloadTaskHandler = { urlRequest in
				XCTFail("Request should never be performed when invalidly configured.")

				return .error(Zone5.Error.unknown)
			}

			httpClient.download(request) { result in
				if case .failure(let error) = result,
					case .invalidConfiguration = error {
						return // Success!
				}

				XCTFail("\(method.rawValue) request unexpectedly completed with \(result).")
			}
		}
	}

	func testMissingAccessToken() {
		var configuration = ConfigurationForTesting()
		configuration.accessToken = nil

		let methods: [Request.Method] = [
			.get,
			.post,
		]

		execute(with: methods, configuration: configuration) { zone5, httpClient, urlSession, method in
			let request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: method)

			urlSession.downloadTaskHandler = { urlRequest in
				XCTFail("Request should never be performed when missing a required access token.")

				return .error(Zone5.Error.unknown)
			}

			httpClient.download(request) { result in
				if case .failure(let error) = result,
					case .requiresAccessToken = error {
						return // Success!
				}

				XCTFail("\(method.rawValue) request unexpectedly completed with \(result).")
			}
		}
	}

	func testUnexpectedRequestBody() {
		execute { zone5, httpClient, urlSession in
			var request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: .get)
			request.body = SearchInputReport.forInstance(activityType: .workout, identifier: 12345)

			urlSession.downloadTaskHandler = { urlRequest in
				XCTFail("Request should never be performed when encountering an unexpected request body.")

				return .error(Zone5.Error.unknown)
			}

			httpClient.download(request) { result in
				if case .failure(let error) = result,
					case .unexpectedRequestBody = error {
						return // Success!
				}

				XCTFail("Request unexpectedly completed with \(result).")
			}
		}
	}

	func testMissingRequestBody() {
		execute { zone5, httpClient, urlSession in
			let request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: .post)

			urlSession.downloadTaskHandler = { urlRequest in
				XCTFail("Request should never be performed when encountering an unexpected request body.")

				return .error(Zone5.Error.unknown)
			}

			httpClient.download(request) { result in
				if case .failure(let error) = result,
					case .missingRequestBody = error {
						return // Success!
				}

				XCTFail("Request unexpectedly completed with \(result).")
			}
		}
	}

	func testServerFailure() {
		let parameters: [(method: Request.Method, body: RequestBody?)] = [
			(.get, nil),
			(.post, SearchInputReport.forInstance(activityType: .workout, identifier: 12345)),
		]

		execute(with: parameters) { zone5, httpClient, urlSession, parameters in
			var request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: parameters.method)
			request.body = parameters.body

			let serverMessage = Zone5.Error.ServerMessage(message: "A server error occurred.")

			urlSession.downloadTaskHandler = { urlRequest in
				XCTAssertEqual(urlRequest.url?.path, request.endpoint.uri)
				XCTAssertEqual(urlRequest.httpMethod, parameters.method.rawValue)
				XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Authorization"], "Bearer \(zone5.accessToken!)")

				return .message(serverMessage.message, statusCode: 500)
			}

			httpClient.download(request) { result in
				if case .failure(let error) = result,
					case .serverError(let message) = error,
					message == serverMessage {
						return // Success!
				}

				XCTFail("\(parameters.method.rawValue) request unexpectedly completed with \(result).")
			}
		}
	}

	func testTransportFailure() {
		let parameters: [(method: Request.Method, body: RequestBody?)] = [
			(.get, nil),
			(.post, SearchInputReport.forInstance(activityType: .workout, identifier: 12345)),
		]

		execute(with: parameters) { zone5, httpClient, urlSession, parameters in
			var request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: parameters.method)
			request.body = parameters.body

			let transportError = Zone5.Error.unknown

			urlSession.downloadTaskHandler = { urlRequest in
				XCTAssertEqual(urlRequest.url?.path, request.endpoint.uri)
				XCTAssertEqual(urlRequest.httpMethod, parameters.method.rawValue)
				XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Authorization"], "Bearer \(zone5.accessToken!)")

				return .error(transportError)
			}

			httpClient.download(request) { result in
				if case .failure(let error) = result,
					case .transportFailure(let underlyingError) = error,
					(underlyingError as NSError).domain == (transportError as NSError).domain,
					(underlyingError as NSError).code == (transportError as NSError).code {
						return // Success!
				}

				XCTFail("\(parameters.method.rawValue) request unexpectedly completed with \(result).")
			}
		}
	}

	func testSuccessfulRequest() {
		let parameters: [(method: Request.Method, body: RequestBody?)] = [
			(.get, nil),
			(.get, ["string": "hello world", "integer": 1234567890] as URLEncodedBody),
			(.post, ["string": "hello world", "integer": 1234567890] as URLEncodedBody),
			(.post, SearchInputReport.forInstance(activityType: .workout, identifier: 12345)),
		]

		execute(with: parameters) { zone5, httpClient, urlSession, parameters in
			var request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: parameters.method)
			request.body = parameters.body

			let fileURL = developmentAssets.randomElement()!

			urlSession.downloadTaskHandler = { urlRequest in
				XCTAssertEqual(urlRequest.url?.path, request.endpoint.uri)
				XCTAssertEqual(urlRequest.httpMethod, request.method.rawValue)
				XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Authorization"], "Bearer \(zone5.accessToken!)")

				return .success(fileURL)
			}

			httpClient.download(request) { result in
				if case .success(let downloadedURL) = result {
					XCTAssert(FileManager.default.contentsEqual(atPath: downloadedURL.path, andPath: fileURL.path))
				}
				else {
					XCTFail("\(parameters.method.rawValue) request unexpectedly completed with \(result).")
				}
			}
		}
	}

	static var allTests = [
        ("testInvalidConfiguration", testInvalidConfiguration),
		("testMissingAccessToken", testMissingAccessToken),
		("testUnexpectedRequestBody", testUnexpectedRequestBody),
		("testMissingRequestBody", testMissingRequestBody),
		("testServerFailure", testServerFailure),
		("testTransportFailure", testTransportFailure),
		("testSuccessfulRequest", testSuccessfulRequest),
    ]

}
