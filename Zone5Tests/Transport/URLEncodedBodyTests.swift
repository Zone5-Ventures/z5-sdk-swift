import XCTest
@testable import Zone5

final class URLEncodedBodyTests: XCTestCase {

	func testLiterals() throws {
		let tests: [URLEncodedBody] = [
			[ // Dictionary literal
				"booleanFalse": false,
				"booleanTrue": true,
				"empty": nil,
				"floatingPoint": 9876.54321,
				"integer": 1234567890,
				"string": "hello world",
			],
			[ // Array literal
				URLQueryItem(name: "booleanFalse", value: "false"),
				URLQueryItem(name: "booleanTrue", value: "true"),
				URLQueryItem(name: "empty", value: nil),
				URLQueryItem(name: "floatingPoint", value: "9876.54321"),
				URLQueryItem(name: "integer", value: "1234567890"),
				URLQueryItem(name: "string", value: "hello world"),
			],
		]

		let expectedString = "booleanFalse=false&booleanTrue=true&empty&floatingPoint=9876.54321&integer=1234567890&string=hello%20world"
		let expectedData = expectedString.data(using: .utf8)

		for test in tests {
			let string = test.description
			XCTAssertEqual(string, expectedString)

			let data = try test.encodedData()
			XCTAssertEqual(data, expectedData)
		}
	}
}
