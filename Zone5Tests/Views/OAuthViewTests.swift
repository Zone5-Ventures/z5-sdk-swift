import XCTest
@testable import Zone5

class OAuthViewTests: XCTestCase {

	func testAccessToken() {
		let tests: [(prepareConfiguration: (_ configuration: inout ConfigurationForTesting) -> Void, response: TestHTTPClientURLSession.Result<String>, expectedResult: Zone5.Result<OAuthToken>)] = [
			( // Should complete with .invalidConfiguration when client is not configured correctly.
				prepareConfiguration: { $0.accessToken = nil; $0.clientID = nil; $0.clientSecret = nil },
				response: .message("{\"message\":\"UT010031: Login failed\"}", statusCode: 500),
				expectedResult: .failure(.invalidConfiguration)
			),
			( // Should complete with .serverError(_:) if a message is transmitted.
				prepareConfiguration: { $0.accessToken = nil },
				response: .message("UT010031: Login failed", statusCode: 500),
				expectedResult: .failure(.serverError(Zone5.Error.ServerMessage(message: "UT010031: Login failed")))
			),
			( // Should complete with .serverError(_:) if a message is transmitted, even on success.
				prepareConfiguration: { $0.accessToken = nil },
				response: .success("{\"message\":\"UT010031: Login failed\"}"),
				expectedResult: .failure(.serverError(Zone5.Error.ServerMessage(message: "UT010031: Login failed")))
			),
			( // Should complete with .failedDecodingResponse(_:) when an unexpected JSON value is returned.
				prepareConfiguration: { $0.accessToken = nil },
				response: .success("Request should fail for invalid response content (such as something that isn't even JSON)."),
				expectedResult: .failure(.failedDecodingResponse(Zone5.Error.unknown))
			),
			( // Should succeed when a valid response is returned from the server.
				prepareConfiguration: { $0.accessToken = nil },
				response: .success("{\"access_token\":\"ACCESS_TOKEN_VALUE\",\"ignored_value\":\"that is dropped during decoding\"}"),
				expectedResult: .success(OAuthToken(rawValue: "ACCESS_TOKEN_VALUE"))
			),
			( // Should succeed even if a valid AccessToken exists.
				prepareConfiguration: { _ in },
				response: .success("{\"access_token\":\"ACCESS_TOKEN_VALUE\"}"),
				expectedResult: .success(OAuthToken(rawValue: "ACCESS_TOKEN_VALUE"))
			),
		]

		execute(with: tests) { client, _, urlSession, test in
			var configuration = ConfigurationForTesting()
			test.prepareConfiguration(&configuration)
			client.configure(with: configuration)

			urlSession.dataTaskHandler = { request in
				XCTAssertEqual(request.url?.path, "/rest/oauth/access_token")
				XCTAssertNil(request.allHTTPHeaderFields?["Authorization"])

				return test.response
			}

			client.oAuth.accessToken(username: "username", password: "password") { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					print(lhs, rhs)
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				case (.success(let lhs), .success(let rhs)):
					XCTAssertEqual(lhs.accessToken, rhs.accessToken)

				default:
					XCTFail("Unexpected result:\n\t- Got: \(result)\n\t- Expected: \(test.expectedResult)")
				}
			}
		}
	}
	
	func testAdhocToken() {
		var expected = OAuthToken(token: "test token", expiresIn: 123)
		expected.scope = "things"
		
		let tests = [expected]
		execute(with: tests) { client, _, urlSession, expected in
			
			urlSession.dataTaskHandler = { request in
				XCTAssertEqual(request.url?.path, "/rest/oauth/access_token")
				XCTAssertNil(request.allHTTPHeaderFields?["Authorization"])

				return .success("{\"access_token\": \"test token\", \"scope\": \"things\", \"expires_in\":123}")
			}

			client.oAuth.accessToken(username: "username", password: "password") { result in
				switch result {
				case .success(let token):
					XCTAssertEqual(token.accessToken, expected.accessToken)
					XCTAssertEqual(token.expiresIn, expected.expiresIn)
					XCTAssertEqual(token.scope, expected.scope)
					
				default:
					XCTFail()
				}
			}
		}
	}
}
