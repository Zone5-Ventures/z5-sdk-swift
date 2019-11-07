//
//  UsersViewTests.swift
//  Zone5Tests
//
//  Created by Daniel Farrelly on 7/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import XCTest
@testable import Zone5

class UsersViewTests: XCTestCase {

	func testMe() {
		let (client, urlSession) = Zone5.prepareTestClient()

		let accessToken = AccessToken(rawValue: UUID().uuidString)
		client.accessToken = accessToken

		urlSession.dataTaskHandler = { request in
			XCTAssertEqual(request.url?.path, "/rest/users/me")
			XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(accessToken.rawValue)")

			return .success("{\"id\": 12345678, \"email\": \"jame.smith@example.com\", \"firstname\": \"Jane\", \"lastname\": \"Smith\"}")
		}

		client.users.me { result in
			switch result {
			case .failure(_):
				XCTFail()

			case .success(let user):
				XCTAssertEqual(user.id, 12345678)
				XCTAssertEqual(user.uid, nil)
				XCTAssertEqual(user.email, "jame.smith@example.com")
				XCTAssertEqual(user.firstName, "Jane")
				XCTAssertEqual(user.lastName, "Smith")
				XCTAssertEqual(user.avatar, nil)
			}
		}
	}

    static var allTests = [
        ("testMe", testMe),
    ]

}
