import XCTest
@testable import Zone5

final class Request_Tests: XCTestCase {

	enum Endpoints: String, HTTPEndpoint {
		case test = "endpoint/uri"
	}

	func testExample() {
		let url = URL(string: "https://localhost")!

		let body: URLEncodedBody = [
			"example": "example"
		]

		let request = Request(endpoint: Endpoints.test, body: body)

		do {
			let urlRequest = try request.urlRequest(for: url, method: .post)

			XCTAssertNotNil(urlRequest.httpBody)

//			let decoded = try JSONDecoder().decode(URLEncodedBody.self, from: urlRequest.httpBody!)
//
//			XCTAssertNotNil(decoded)
//			XCTAssertEqual(decoded, body)
		}
		catch {
			XCTFail()
		}
	}

    static var allTests = [
        ("testExample", testExample),
    ]
}
