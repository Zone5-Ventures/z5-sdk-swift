import XCTest
@testable import Zone5

final class Request_Tests: XCTestCase {

	func testExample() {
		let url = URL(string: "https://localhost")!

		var request = Request(endpoint: "endpoint/uri")
		request.parameters["example"] = "example"

		do {
			let urlRequest = try request.urlRequest(for: url, method: .post(.json))

			XCTAssertNotNil(urlRequest.httpBody)

			let decoded = try JSONDecoder().decode([String: String].self, from: urlRequest.httpBody!)

			XCTAssertEqual(decoded["example"], request.parameters["example"])
		}
		catch {
			XCTFail()
		}
	}

    static var allTests = [
        ("testExample", testExample),
    ]
}
