//
//  Zone5Tests.swift
//  Zone5Tests
//
//  Created by Daniel Farrelly on 6/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import XCTest
@testable import Zone5

class Zone5Tests: XCTestCase {
	var zone5: Zone5 {
		return Zone5(httpClient: HTTPClient(urlSession: TestHTTPClientURLSession()))
	}

	func testAccessTokenFromLogin() {
		XCTAssertNil(zone5.accessToken)
		let now = Date()
		let expiry = (now + 10).milliseconds.rawValue
		var loginResponse = LoginResponse()
		loginResponse.token = "abc"
		loginResponse.refresh = "zxc"
		loginResponse.tokenExp = expiry
		
		var oAuth = OAuthToken(loginResponse: loginResponse)
		XCTAssertEqual(expiry, oAuth.tokenExp)
		XCTAssertTrue(oAuth.expiresIn! >= Int(10.0 - (Date().timeIntervalSince1970 - now.timeIntervalSince1970)))
		XCTAssertTrue(oAuth.expiresIn! <= 10)
		XCTAssertEqual("abc", oAuth.accessToken)
		XCTAssertEqual("zxc" ,oAuth.refreshToken)
		
		XCTAssertNil(Zone5.shared.accessToken)
		Zone5.shared.accessToken = oAuth
		oAuth = Zone5.shared.accessToken as! OAuthToken
		XCTAssertEqual(expiry, oAuth.tokenExp)
		XCTAssertTrue(oAuth.expiresIn! >= Int(10.0 - (Date().timeIntervalSince1970 - now.timeIntervalSince1970)))
		XCTAssertTrue(oAuth.expiresIn! <= 10)
		XCTAssertEqual("abc", oAuth.accessToken)
		XCTAssertEqual("zxc" ,oAuth.refreshToken)
	}
	
	func testAccessToken() {
		XCTAssertNil(zone5.accessToken)
		let now = Date()
		
		let oAuth = OAuthToken(token: "abc", refresh: "zxc", expiresIn: 300)
		
		XCTAssertNotNil(oAuth.tokenExp)
		
		if let expiresAt = oAuth.tokenExp {
			XCTAssertTrue(expiresAt >= now.addingTimeInterval(300).milliseconds.rawValue)
			XCTAssertTrue(expiresAt <= Date().addingTimeInterval(300).milliseconds.rawValue)
		}
	}
	
	func testFieldName() {
		XCTAssertEqual(["headunit.manufacturer"], UserHeadunit.fields([.manufacturer], prefix: "headunit"))
		XCTAssertEqual(["turbo.numAssistChanges", "turbo.avgAssist"], UserWorkoutResultTurbo.fields([.assistChanges, .averageAssist], prefix: "turbo"))
		XCTAssertEqual(["turboExt.avgBattery1Temperature", "turboExt.avgGPSSpeed"], UserWorkoutResultTurboExt.fields([.averageBattery1Temperature, .averageGPSSpeed], prefix: "turboExt"))
	}
}
