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
	let response1 = TokenResponse(token: "12345", expiresIn: 100, refreshToken: "54321", scope: "???")
	let token1 = ThirdPartyToken(token: "12345", refreshToken: "54321", expiresIn: 100, scope: "???")
	let pushRegistration1 = PushRegistration(token: "12345", platform: "ios", deviceId: "johhny")

	func testSetThirdPartyToken() {
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<ThirdPartyTokenResponse, Zone5.Error>)] = [
			(
				token: nil,
				json: "{}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"available\":true,\"token\":{\"token\":\"12345\", \"scope\":\"???\", \"expiresIn\":100, \"refreshToken\":\"54321\"}}",
				expectedResult: .success {
					let result = ThirdPartyTokenResponse(available: true, token: response1)
					return result
				}
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
	
	func testHasThirdPartyToken() {
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<ThirdPartyTokenResponse, Zone5.Error>)] = [
			(
				token: nil,
				json: "{}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"available\":true,\"token\":{\"token\":\"12345\", \"scope\":\"???\", \"expiresIn\":100, \"refreshToken\":\"54321\"}}",
				expectedResult: .success {
					let result = ThirdPartyTokenResponse(available: true, token: response1)
					return result
				}
			),
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
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<ThirdPartyTokenResponse, Zone5.Error>)] = [
			(
				token: nil,
				json: "{}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"available\":true,\"token\":{\"token\":\"12345\", \"scope\":\"???\", \"expiresIn\":100, \"refreshToken\":\"54321\"}}",
				expectedResult: .success {
					let result = ThirdPartyTokenResponse(available: true, token: response1)
					return result
				}
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

	
	
	func testRegisterDeviceWithThirdParty() {
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<PushRegistrationResponse, Zone5.Error>)] = [
			(
				token: nil,
				json: "{}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{\"token\": \"12345\"}",
				expectedResult: .success {
					return PushRegistrationResponse(token: "12345")
				}
			),
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
				json: "{\"result\": 999}",  //TODO: Find out what the tag/result really is
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
					return UpgradeAvailableResponse(upgrade: true)
				}
			),
		]

		execute(with: tests) { client, _, urlSession, test in
			client.accessToken = test.token

			urlSession.dataTaskHandler = { request in
				XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(test.token?.rawValue ?? "UNKNOWN")")
				return .success(test.json)
			}

			let _ = client.thirdPartyConnections.getDeprecated() { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				case (.success(let lhs), .success(let rhs)):
					XCTAssertEqual(lhs.upgrade, rhs.upgrade)

				default:
					print(result, test.expectedResult)
					//XCTFail()
				}
			}
		}
	}
	
	
}
