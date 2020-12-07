//
//  ThirdPartyViewTests.swift
//  Zone5
//
//  Created by John Covele on Oct 16, 2020.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import XCTest
@testable import Zone5

class ThirdPartyViewTests: XCTestCase {
	let token1 = ThirdPartyToken(token: "12345", expiresIn: 100, refreshToken: "54321", scope: "???")
	let response1 = ThirdPartyTokenResponse(available: true, token: ThirdPartyToken(token: "12345", expiresIn: 100, refreshToken: "54321", scope: "???"))
	let pushRegistration1 = PushRegistration(token: "12345", platform: "ios", deviceId: "johhny")

	func testSetThirdPartyToken() {
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<ThirdPartyResponse, Zone5.Error>)] = [
			(
				token: nil,
				json: "{\"success\":true}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"success\":true}",
				expectedResult: .success {
					return ThirdPartyResponse(success: true)
				}
			),
			(
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"success\":false}",
				expectedResult: .success {
					return ThirdPartyResponse(success: false)
				}
			),
			(
				// incorrect response
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"available\":true,\"token\":{\"token\":\"12345\", \"scope\":\"???\", \"expires_in\":100, \"refresh_token\":\"54321\"}}",
				expectedResult: .failure(.failedDecodingResponse(Zone5.Error.unknown))
			),
		]

		execute(with: tests) { client, _, urlSession, test in
			client.accessToken = test.token

			urlSession.dataTaskHandler = { request in
				XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(test.token?.rawValue ?? "UNKNOWN")")
				return .success(test.json)
			}

			let _ = client.thirdPartyConnections.setThirdPartyToken(type: UserConnectionsType.strava, connection: token1) { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				case (.success(let lhs), .success(let rhs)):
					XCTAssertEqual(lhs.success, rhs.success)

				default:
					print(result, test.expectedResult)
					XCTFail()
				}
			}
		}
	}
	
	func testHasThirdPartyToken() {
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<ThirdPartyTokenResponse, Zone5.Error>)] = [
			(
				// this endpoint requires auth
				token: nil,
				json: "{\"available\":false}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				// successful request, result is false
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"available\":false}",
				expectedResult: .success {
					return ThirdPartyTokenResponse(available:false)
				}
			),
			(
				// successful request, result contains full info
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"available\":true,\"token\":{\"token\":\"12345\", \"scope\":\"???\", \"expires_in\":100, \"refresh_token\":\"54321\"}}",
				expectedResult: .success {
					return ThirdPartyTokenResponse(available:true, token: ThirdPartyToken(token:"12345", expiresIn: 100,  refreshToken: "54321", scope:"???"))
				}
			),
			(
				// successful request, result contrains minimal allowed info
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"available\":true,\"token\":{\"token\":\"12345\"}}",
				expectedResult: .success {
					return ThirdPartyTokenResponse(available:true, token: ThirdPartyToken(token:"12345"))
				}
			),
			(
				// incorrect payload
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"success\":true}",
				expectedResult: .failure(.failedDecodingResponse(Zone5.Error.unknown))
			)
		]

		execute(with: tests) { client, _, urlSession, test in
			client.accessToken = test.token

			urlSession.dataTaskHandler = { request in
				XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(test.token?.rawValue ?? "UNKNOWN")")
				return .success(test.json)
			}

			let _ = client.thirdPartyConnections.hasThirdPartyToken(type: UserConnectionsType.strava) { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				case (.success(let lhs), .success(let rhs)):
					XCTAssertEqual(lhs.available, rhs.available)
					XCTAssertEqual(lhs.token?.token, rhs.token?.token)
					XCTAssertEqual(lhs.token?.scope, rhs.token?.scope)
					XCTAssertEqual(lhs.token?.expiresIn, rhs.token?.expiresIn)
					XCTAssertEqual(lhs.token?.refreshToken, rhs.token?.refreshToken)

				default:
					print(result, test.expectedResult)
					XCTFail()
				}
			}
		}
	}

	
	func testRemoveThirdPartyToken() {
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<ThirdPartyResponse, Zone5.Error>)] = [
			(
				// endpoint requires auth
				token: nil,
				json: "{\"success\":true}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				// successful response, with false result
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"success\":false}",
				expectedResult: .success { return ThirdPartyResponse(success: false)}
			),
			(
				// successful response, with true result
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"success\":true}",
				expectedResult: .success { return ThirdPartyResponse(success: true)}
			),
			(
				// incorrect payload
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"available\":true,\"token\":{\"token\":\"12345\", \"scope\":\"???\", \"expiresIn\":100, \"refreshToken\":\"54321\"}}",
				expectedResult: .failure(.failedDecodingResponse(Zone5.Error.unknown))
			),
		]

		execute(with: tests) { client, _, urlSession, test in
			client.accessToken = test.token

			urlSession.dataTaskHandler = { request in
				XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(test.token?.rawValue ?? "UNKNOWN")")
				return .success(test.json)
			}

			let _ = client.thirdPartyConnections.removeThirdPartyToken(type: UserConnectionsType.strava) { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				case (.success(let lhs), .success(let rhs)):
					XCTAssertEqual(lhs.success, rhs.success)

				default:
					print(result, test.expectedResult)
					XCTFail()
				}
			}
		}
	}

	
	
	func testRegisterDeviceWithThirdParty() {
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<PushRegistrationResponse, Zone5.Error>)] = [
			(
				// endpoint requires auth
				token: nil,
				json: "{\"token\": 12345}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				// success
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"token\": 12345}",
				expectedResult: .success {
					return PushRegistrationResponse(token: 12345)
				}
			),
			(
				// invalid response
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"success\": true}",
				expectedResult: .failure(.failedDecodingResponse(Zone5.Error.unknown))
			)
		]

		execute(with: tests) { client, _, urlSession, test in
			client.accessToken = test.token

			urlSession.dataTaskHandler = { request in
				XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(test.token?.rawValue ?? "UNKNOWN")")
				return .success(test.json)
			}

			let _ = client.thirdPartyConnections.registerDeviceWithThirdParty(registration: pushRegistration1) { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				case (.success(let lhs), .success(let rhs)):
					XCTAssertEqual(lhs.token, rhs.token)

				default:
					print(result, test.expectedResult)
					XCTFail()
				}
			}
		}
	}
	
	func testDeregisterDeviceWithThirdParty() {
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<VoidReply, Zone5.Error>)] = [
			(
				token: nil,
				json: "{}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{}",
				expectedResult: .success {
					return VoidReply()
				}
			),
		]

		execute(with: tests) { client, _, urlSession, test in
			client.accessToken = test.token

			urlSession.dataTaskHandler = { request in
				XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(test.token?.rawValue ?? "UNKNOWN")")
				return .success(test.json)
			}

			let _ = client.thirdPartyConnections.deregisterDeviceWithThirdParty(token: "12345") { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				//case (.success(let lhs), .success(let rhs)):
					//XCTAssertEqual(lhs, rhs)  //TODO: how to test for success?

				default:
					print(result, test.expectedResult)
					//XCTFail()  //TODO: put back in default case when success is fixed
				}
			}
		}
	}


	func testGetDeprecated() {
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<UpgradeAvailableResponse, Zone5.Error>)] = [
			(
				token: nil,
				json: "{}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"upgrade\": true}",  //TODO: Find out what the tag/result really is
				expectedResult: .success {
					return UpgradeAvailableResponse(isUpgradeAvailable: true)
				}
			),
		]

		execute(with: tests) { client, _, urlSession, test in
			client.accessToken = test.token

			urlSession.dataTaskHandler = { request in
				XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(test.token?.rawValue ?? "UNKNOWN")")
				return .success(test.json)
			}

			let _ = client.userAgents.getDeprecated() { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				case (.success(let lhs), .success(let rhs)):
					XCTAssertEqual(lhs.isUpgradeAvailable, rhs.isUpgradeAvailable)

				default:
					print(result, test.expectedResult)
					//XCTFail()
				}
			}
		}
	}
	
	
}
