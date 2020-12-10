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
	
	var z5: Zone5!
	
	override func setUp() {
		z5 = createNewZone5()
	}
	
	func testAccessTokenFromLogin() {
		XCTAssertNil(z5.accessToken)
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
		
		XCTAssertNil(z5.accessToken)
		Zone5.shared.accessToken = oAuth
		oAuth = Zone5.shared.accessToken as! OAuthToken
		XCTAssertEqual(expiry, oAuth.tokenExp)
		XCTAssertTrue(oAuth.expiresIn! >= Int(10.0 - (Date().timeIntervalSince1970 - now.timeIntervalSince1970)))
		XCTAssertTrue(oAuth.expiresIn! <= 10)
		XCTAssertEqual("abc", oAuth.accessToken)
		XCTAssertEqual("zxc" ,oAuth.refreshToken)
	}
	
	func testAccessToken() {
		XCTAssertNil(z5.accessToken)
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
	
	func testAccessTokenUpdated() {
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(rawValue: "123"))
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenOnChanged() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(rawValue: "123"))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(token: "123", refresh: "zxc", tokenExp: 4))
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenOnChanged2() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(token: "123", refresh: "zxc", tokenExp: 4))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(token: "123", refresh: "zxc", tokenExp: 5))
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenOnChanged3() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(token: "123", refresh: "zxc", tokenExp: 4))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(token: "123", refresh: "zxc1", tokenExp: 4))
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenUpdatedOnNil() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(token: "123", refresh: "zxc", tokenExp: 4))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		z5.configure(for: URL(string: "http://test")!, accessToken: nil)
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenUpdatedOnNil2() {
		z5.configure(for: URL(string: "http://test")!, accessToken: nil)
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(token: "123", refresh: "zxc", tokenExp: 4))
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenNotUpdatedWhenSame() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(rawValue: "123"))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.isInverted = true
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(rawValue: "123"))
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func testAccessTokenNotUpdatedWhenSame2() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(token: "123", refresh: "zxc", tokenExp: 4))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.isInverted = true
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(token: "123", refresh: "zxc", tokenExp: 4))
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func testAccessTokenNotUpdatedWhenSameNil() {
		z5.configure(for: URL(string: "http://test")!, accessToken: nil)
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.isInverted = true
		
		z5.configure(for: URL(string: "http://test")!, accessToken: nil)
		waitForExpectations(timeout: 1, handler: nil)
	}
	
	func testAccessTokenOnChangedAlt() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(rawValue: "123"))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthTokenAlt(rawValue: "123"))
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenOnChangedAlt2() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthTokenAlt(rawValue: "123"))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthToken(rawValue: "123"))
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenOnChangedAlt3() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthTokenAlt(rawValue: "123"))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthTokenAlt(rawValue: "1234"))
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenOnChangedAlt4() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthTokenAlt(rawValue: "123"))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		var oauth = OAuthTokenAlt(rawValue: "123")
		oauth.tokenExp = 6
		z5.configure(for: URL(string: "http://test")!, accessToken: oauth)
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenOnChangedAlt5() {
		z5.configure(for: URL(string: "http://test")!, accessToken: nil)
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.assertForOverFulfill = true
		expectation.expectedFulfillmentCount = 1
		
		var oauth = OAuthTokenAlt(rawValue: "123")
		oauth.tokenExp = 6
		z5.configure(for: URL(string: "http://test")!, accessToken: oauth)
		waitForExpectations(timeout: 5, handler: nil)
	}
	
	func testAccessTokenNotChangedAlt() {
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthTokenAlt(rawValue: "123"))
		
		let expectation = self.expectation(forNotification: Zone5.authTokenChangedNotification, object: z5, handler: nil)
		expectation.isInverted = true
		
		z5.configure(for: URL(string: "http://test")!, accessToken: OAuthTokenAlt(rawValue: "123"))
		waitForExpectations(timeout: 1, handler: nil)
	}
}
