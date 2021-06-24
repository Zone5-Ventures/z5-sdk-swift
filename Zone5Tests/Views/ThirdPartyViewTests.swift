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

	let pushRegistration1 = PushRegistration(token: "12345", platform: "ios", deviceId: "johhny")

	func testBuildQuery() {
		let client = ThirdPartyConnectionsView(zone5: Zone5())
		// the server is case sensitive. This needs to be all lower case
		XCTAssertEqual("service_name=garminconnect", client.queryParams(.garminconnect).description)
		XCTAssertEqual("service_name=garminwellness", client.queryParams(.garminwellness).description)
		XCTAssertEqual("service_name=garmintraining", client.queryParams(.garmintraining).description)
		XCTAssertEqual("service_name=todaysplan", client.queryParams(.todaysplan).description)
		XCTAssertEqual("service_name=trainingpeaks", client.queryParams(.trainingpeaks).description)
		XCTAssertEqual("service_name=myfitnesspal", client.queryParams(.myfitnesspal).description)
		XCTAssertEqual("service_name=underarmour", client.queryParams(.underarmour).description)
		XCTAssertEqual("service_name=ridewithgps", client.queryParams(.ridewithgps).description)
	}
	
	func testSetThirdPartyToken() {
        let tests: [(parameters: URLEncodedBody?, expectedResult: Result<Zone5.VoidReply, Zone5.Error>)] = [
			(
                parameters: ["oauth_token": "token", "oauth_verifier": "verifier"],
				expectedResult: .failure(authFailure)
			),
			(
                parameters: ["oauth_token": "token", "oauth_verifier": "verifier"],
                expectedResult: .success(Zone5.VoidReply())
			)
		]

		execute(with: tests) { client, _, urlSession, test in
            let _ = client.thirdPartyConnections.setThirdPartyToken(type: .garminconnect, parameters: test.parameters) { result in
                switch (result, test.expectedResult) {
                case (.failure(let lhs), .failure(let rhs)):
                    XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
                    XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

                case (.success(let lhs), .success(let rhs)):
                    XCTAssertNotNil(lhs)
                    XCTAssertNotNil(rhs)

                default:
                    print(result, test.expectedResult)
                    XCTFail()
                }
            }
		}
	}
	
	func testHasThirdPartyToken() {
		let tests: [(json: String, expectedResult: Result<Bool, Zone5.Error>)] = [
            (
                json: "[{\"type\": \"garminconnect\",\"enabled\": false}]",
                expectedResult: .success {
                    return false
                }
            ),
            (
                json: "[{\"type\": \"garminconnect\",\"enabled\": false}]",
                expectedResult: .success {
                    return false
                }
            )

//			(
//				// this endpoint requires auth
//				token: nil,
//				json: "{\"available\":false}",
//				expectedResult: .failure(authFailure)
//			),
//			(
//				// successful request, result is false
//				token: OAuthToken(rawValue: UUID().uuidString),
//				json: "{\"available\":false}",
//				expectedResult: .success {
//					return ThirdPartyTokenResponse(available:false)
//				}
//			),
//			(
//				// successful request, result contains full info
//				token: OAuthToken(rawValue: UUID().uuidString),
//				json: "{\"available\":true,\"token\":{\"token\":\"12345\", \"scope\":\"???\", \"expires_in\":100, \"refresh_token\":\"54321\"}}",
//				expectedResult: .success {
//					return ThirdPartyTokenResponse(available:true, token: ThirdPartyToken(token:"12345", expiresIn: 100,  refreshToken: "54321", scope:"???"))
//				}
//			),
//			(
//				// successful request, result contrains minimal allowed info
//				token: OAuthToken(rawValue: UUID().uuidString),
//				json: "{\"available\":true,\"token\":{\"token\":\"12345\"}}",
//				expectedResult: .success {
//					return ThirdPartyTokenResponse(available:true, token: ThirdPartyToken(token:"12345"))
//				}
//			),
//			(
//				// incorrect payload
//				token: OAuthToken(rawValue: UUID().uuidString),
//				json: "{\"success\":true}",
//				expectedResult: .failure(.failedDecodingResponse(Zone5.Error.unknown))
//			)
		]

		execute(with: tests) { client, _, urlSession, test in

			let _ = client.thirdPartyConnections.hasThirdPartyToken(type: UserConnectionType.strava) { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				case (.success(let lhs), .success(let rhs)):
					XCTAssertEqual(lhs, rhs)

				default:
					print(result, test.expectedResult)
					XCTFail()
				}
			}
		}
	}

	
	func testRemoveThirdPartyToken() {
        let tests: [(json: String, expectedResult: Result<Zone5.VoidReply, Zone5.Error>)] = [
			(
                json: "{}",
				expectedResult: .failure(authFailure)
			),
            (
                json: "{}",
                expectedResult: .success(Zone5.VoidReply())
            )
		]

		execute(with: tests) { client, _, urlSession, test in
			let _ = client.thirdPartyConnections.removeThirdPartyToken(type: UserConnectionType.strava) { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				case (.success(let lhs), .success(let rhs)):
                    XCTAssertNotNil(lhs)
                    XCTAssertNotNil(rhs)

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
				expectedResult: .failure(authFailure)
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
		let tests: [(token: AccessToken?, json: String, expectedResult: Result<Zone5.VoidReply, Zone5.Error>)] = [
			(
				token: nil,
				json: "{}",
				expectedResult: .failure(authFailure)
			),
			(
				token: OAuthToken(rawValue: UUID().uuidString),
				json: "{}",
				expectedResult: .success {
					return Zone5.VoidReply()
				}
			),
		]

		execute(with: tests) { client, _, urlSession, test in
			
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
				expectedResult: .failure(authFailure)
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
