import XCTest
@testable import Zone5

final class MultipartTests: XCTestCase {

	func testExample() throws {
		guard let fileURL = Bundle.tests.url(forDevelopmentAsset: "2013-12-22-10-30-12", withExtension: "fit") else  {
			return XCTFail()
		}

		var context = DataFileUploadContext()
		context.equipment = .gravel
		context.name = "Epic Ride"
		//context.bikeID = "d584c5cb-e81f-4fbe-bc0d-667e9bcd2c4c" // TODO: Does bikeID exist? It's not defined in java.

		var multipart = MultipartEncodedBody()
		try multipart.appendPart(name: "json", content: context)
		try multipart.appendPart(name: "filename", content: fileURL.lastPathComponent)
		//try multipart.appendPart(name: "attachment", contentsOf: fileURL)

		test: do {
			let data = try multipart.encodedData()
			let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileURL.lastPathComponent)

			try data.write(to: outputURL)
			print(outputURL)

			let string = String(data: data, encoding: .utf8)!
			print(multipart.contentType)
			print(string)
		}
		catch {
			return XCTFail()
		}
	}

    static var allTests = [
        ("testExample", testExample),
    ]
}
