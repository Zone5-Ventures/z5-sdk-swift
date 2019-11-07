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

		let tests: [(token: UUID?, json: String, expectedResult: Result<User, Zone5.Error>)] = [
			(
				token: nil,
				json: "{\"id\": 12345678, \"email\": \"jame.smith@example.com\", \"firstname\": \"Jane\", \"lastname\": \"Smith\"}",
				expectedResult: .failure(.requiresAccessToken)
			),
			(
				token: UUID(),
				json: "{\"id\": 12345678, \"email\": \"jame.smith@example.com\", \"firstname\": \"Jane\", \"lastname\": \"Smith\"}",
				expectedResult: .success {
					var user = User()
					user.id = 12345678
					user.email = "jame.smith@example.com"
					user.firstName = "Jane"
					user.lastName = "Smith"
					return user
				}
			),
		]

		for test in tests {
			if let token = test.token {
				client.accessToken = AccessToken(rawValue: token.uuidString)
			}

			urlSession.dataTaskHandler = { request in
				XCTAssertEqual(request.url?.path, "/rest/users/me")
				XCTAssertEqual(request.allHTTPHeaderFields?["Authorization"], "Bearer \(client.accessToken!.rawValue)")

				return .success(test.json)
			}

			client.users.me { result in
				switch (result, test.expectedResult) {
				case (.failure(let lhs), .failure(let rhs)):
					XCTAssertEqual((lhs as NSError).domain, (rhs as NSError).domain)
					XCTAssertEqual((lhs as NSError).code, (rhs as NSError).code)

				case (.success(let lhs), .success(let rhs)):
					XCTAssertEqual(lhs.id, rhs.id)
					XCTAssertEqual(lhs.uid, rhs.uid)
					XCTAssertEqual(lhs.email, rhs.email)
					XCTAssertEqual(lhs.firstName, rhs.firstName)
					XCTAssertEqual(lhs.lastName, rhs.lastName)
					XCTAssertEqual(lhs.avatar, rhs.avatar)

				default:
					XCTFail()
				}
			}

		}
	}

    static var allTests = [
        ("testMe", testMe),
    ]

}
