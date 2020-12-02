import XCTest
@testable import Zone5

final class Zone5HTTPClientUploadRequestTests: XCTestCase {

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

			let fileURL = developmentAssets.randomElement()
			XCTAssertNotNil(fileURL)

			urlSession.uploadTaskHandler = { urlRequest, uploadedURL in
				XCTFail("Request should never be performed when invalidly configured.")

				return .error(Zone5.Error.unknown)
			}

			_ = httpClient.upload(fileURL!, with: request, expectedType: User.self) { result in
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

			let fileURL = developmentAssets.randomElement()!

			urlSession.uploadTaskHandler = { urlRequest, uploadedURL in
				XCTFail("Request should never be performed when missing a required access token.")

				return .error(Zone5.Error.unknown)
			}

			_ = httpClient.upload(fileURL, with: request, expectedType: User.self) { result in
				if case .failure(let error) = result,
					case .requiresAccessToken = error {
						return // Success!
				}

				XCTFail("\(method.rawValue) request unexpectedly completed with \(result).")
			}
		}
	}

	func testUnexpectedRequestBody() {
		let parameters: [(method: Request.Method, body: RequestBody?)] = [
			(.get, SearchInputReport.forInstance(activityType: .workout, identifier: 12345)),
			(.post, ["string": "hello world", "integer": 1234567890] as URLEncodedBody),
		]

		execute(with: parameters) { zone5, httpClient, urlSession, parameters in
			let request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: parameters.method, body: parameters.body)

			let fileURL = developmentAssets.randomElement()!

			urlSession.uploadTaskHandler = { urlRequest, uploadedURL in
				XCTFail("Request should never be performed when encountering an unexpected request body.")

				return .error(Zone5.Error.unknown)
			}

			_ = httpClient.upload(fileURL, with: request, expectedType: User.self) { result in
				if case .failure(let error) = result,
					case .unexpectedRequestBody = error {
						return // Success!
				}

				XCTFail("Request unexpectedly completed with \(result).")
			}
		}
	}

	func testServerFailure() {
		let parameters: [(method: Request.Method, body: JSONEncodedBody?)] = [
			(.get, nil),
			(.post, SearchInputReport.forInstance(activityType: .workout, identifier: 12345)),
		]

		execute(with: parameters) { zone5, httpClient, urlSession, parameters in
			var request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: parameters.method)
			request.body = parameters.body

			let fileURL = developmentAssets.randomElement()!
			XCTAssertNotNil(fileURL)

			let serverMessage = Zone5.Error.ServerMessage(message: "A server error occurred.", statusCode: 500)

			urlSession.uploadTaskHandler = { urlRequest, uploadedURL in
				XCTAssertEqual(urlRequest.url?.path, request.endpoint.uri)
				XCTAssertEqual(urlRequest.httpMethod, parameters.method.rawValue)
				XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Authorization"], "Bearer \(zone5.accessToken!)")

				if let uploadedData = try? Data(contentsOf: uploadedURL), let contentType = urlRequest.allHTTPHeaderFields?["Content-Type"] {
					var expectations: [String: MultipartEncodedBodyTests.Expectation] = [
						"filename": .object(fileURL.lastPathComponent),
						"attachment": .file(fileURL),
					]

					if let body = parameters.body {
						expectations["json"] = .object(body)
					}

					MultipartEncodedBodyTests.validate(uploadedData, with: contentType, against: expectations)
				}
				else {
					XCTFail("Expected uploaded file to have data and a Content-Type to go with it.")
				}

				return .message(serverMessage.message, statusCode: 500)
			}

			_ = httpClient.upload(fileURL, with: request, expectedType: User.self) { result in
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
		let parameters: [(method: Request.Method, body: JSONEncodedBody?)] = [
			(.get, nil),
			(.post, SearchInputReport.forInstance(activityType: .workout, identifier: 12345)),
		]

		execute(with: parameters) { zone5, httpClient, urlSession, parameters in
			var request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: parameters.method)
			request.body = parameters.body

			let fileURL = developmentAssets.randomElement()!
			let transportError = Zone5.Error.unknown

			urlSession.uploadTaskHandler = { urlRequest, uploadedURL in
				XCTAssertEqual(urlRequest.url?.path, request.endpoint.uri)
				XCTAssertEqual(urlRequest.httpMethod, parameters.method.rawValue)
				XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Authorization"], "Bearer \(zone5.accessToken!)")

				if let uploadedData = try? Data(contentsOf: uploadedURL), let contentType = urlRequest.allHTTPHeaderFields?["Content-Type"] {
					var expectations: [String: MultipartEncodedBodyTests.Expectation] = [
						"filename": .object(fileURL.lastPathComponent),
						"attachment": .file(fileURL),
					]

					if let body = parameters.body {
						expectations["json"] = .object(body)
					}

					MultipartEncodedBodyTests.validate(uploadedData, with: contentType, against: expectations)
				}
				else {
					XCTFail("Expected uploaded file to have data and a Content-Type to go with it.")
				}

				return .error(transportError)
			}

			_ = httpClient.upload(fileURL, with: request, expectedType: User.self) { result in
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
		let parameters: [(method: Request.Method, body: JSONEncodedBody?)] = [
			(.get, nil),
			(.post, SearchInputReport.forInstance(activityType: .workout, identifier: 12345)),
		]

		execute(with: parameters) { zone5, httpClient, urlSession, parameters in
			var request = Request(endpoint: EndpointsForTesting.requiresAccessToken, method: parameters.method)
			request.body = parameters.body

			let fileURL = developmentAssets.randomElement()!

			urlSession.uploadTaskHandler = { urlRequest, uploadedURL in
				XCTAssertEqual(urlRequest.url?.path, request.endpoint.uri)
				XCTAssertEqual(urlRequest.httpMethod, request.method.rawValue)
				XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Authorization"], "Bearer \(zone5.accessToken!)")

				if let uploadedData = try? Data(contentsOf: uploadedURL), let contentType = urlRequest.allHTTPHeaderFields?["Content-Type"] {
					var expectations: [String: MultipartEncodedBodyTests.Expectation] = [
						"filename": .object(fileURL.lastPathComponent),
						"attachment": .file(fileURL),
					]

					if let body = parameters.body {
						expectations["json"] = .object(body)
					}

					MultipartEncodedBodyTests.validate(uploadedData, with: contentType, against: expectations)
				}
				else {
					XCTFail("Expected uploaded file to have data and a Content-Type to go with it.")
				}

				return .success("{\"id\": 12345678, \"email\": \"jame.smith@example.com\", \"firstname\": \"Jane\", \"lastname\": \"Smith\"}")
			}

			_ = httpClient.upload(fileURL, with: request, expectedType: User.self) { result in
				if case .success(let user) = result {
					XCTAssertEqual(user.id, 12345678)
					XCTAssertEqual(user.email, "jame.smith@example.com")
					XCTAssertEqual(user.firstName, "Jane")
					XCTAssertEqual(user.lastName, "Smith")
				}
				else {
					XCTFail("\(parameters.method.rawValue) request unexpectedly completed with \(result).")
				}
			}
		}
	}
}
