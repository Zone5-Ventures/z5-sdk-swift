import XCTest
@testable import Zone5

final class RequestEndpointTests: XCTestCase {

	func testRequiresAccessToken() {
		let tests: [(endpoint: EndpointsForTesting, expectedValue: Bool)] = [
			(.withReplaceableTokens, false),
			(.requiresAccessToken, true),
			(.default, false),
		]

		for test in tests {
			XCTAssertEqual(test.endpoint.requiresAccessToken, test.expectedValue)
		}
	}

	func testReplacingTokens() {
		let tests: [(endpoint: EndpointsForTesting, replacements: [String: CustomStringConvertible], expectedURI: String)] = [
			(.withReplaceableTokens, ["token": "value"], "/endpoint/with/value"),
			(.default, ["default": "altered"], "/endpoint/default"),
		]

		for test in tests {
			let detokenizedEndpoint = test.endpoint.replacingTokens(test.replacements)
			XCTAssertEqual(detokenizedEndpoint.uri, test.expectedURI)
		}
	}

    static var allTests = [
        ("testRequiresAccessToken", testRequiresAccessToken),
		("testReplacingTokens", testReplacingTokens),
    ]

}
