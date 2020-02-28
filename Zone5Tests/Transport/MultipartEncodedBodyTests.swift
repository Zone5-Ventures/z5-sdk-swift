import XCTest
@testable import Zone5

final class MultipartEncodedBodyTests: XCTestCase {

	private let developmentAssets = Bundle.tests.urlsForDevelopmentAssets()!.filter { $0.pathExtension != "multipart" }

	private struct InvalidMultipartData: MultipartDataConvertible {

		let multipartData: Data? = nil

	}

	func testMultipartEncoding() throws {
		for assetURL in developmentAssets {
			var context = DataFileUploadContext()
			context.equipment = .gravel
			context.name = "Epic Ride"

			var multipart = MultipartEncodedBody()
			var expectations: [String: Expectation] = [:]

			try multipart.appendPart(name: "JSONEncodedBody", content: context)
			expectations["JSONEncodedBody"] = .object(context)

			try multipart.appendPart(name: "String", content: "Hello World")
			expectations["String"] = .object("Hello World")

			try multipart.appendPart(name: "Number", content: NSNumber(1234567890))
			expectations["Number"] = .object(NSNumber(1234567890))

			try multipart.appendPart(name: "File", contentsOf: assetURL)
			expectations["File"] = .file(assetURL)

			try multipart.appendPart(name: "EmptyString", content: "")
			expectations["EmptyString"] = .object("")

			try multipart.appendPart(name: "EmptyData", content: Data())
			expectations["EmptyData"] = .object(Data())

			/// It's a rare scenario that valid `MultipartDataConvertible` objects can't be appended to a multipart data
			/// structure, but just in case, let's verify that the scenario throws an error.
			XCTAssertThrowsError(try multipart.appendPart(name: "InvalidContent", content: InvalidMultipartData()))

			let data = try multipart.encodedData()
			MultipartEncodedBodyTests.validate(data, with: multipart.contentType, against: expectations)
		}
	}

	func testNoParts() throws {
		let multipart = MultipartEncodedBody()
		let data = try multipart.encodedData()
		MultipartEncodedBodyTests.validate(data, with: multipart.contentType, against: [:])
	}

	// MARK: Utilities

	enum Expectation {
		case object(MultipartDataConvertible)
		case file(URL)
	}

	/// Parses and validates that the given `data` conforms to multipart.
	/// - Note: This is somewhat complex, and relies on comparing the output of `MultipartDataConvertible.multipartData`
	/// against itself, so it has its own unit test below, which validates known good multipart data.
	static func validate(_ multipartData: Data, with contentType: String, against expectations: [String: Expectation]) {
		let (contentTypeMime, contentTypeParameters) = parse(contentType)
		XCTAssertEqual(contentTypeMime, "multipart/form-data")
		XCTAssertNotNil(contentTypeParameters["boundary"])

		guard let boundary = contentTypeParameters["boundary"],
			let boundaryData = "--\(boundary)".data(using: .utf8) else {
			return
		}

		var expectationsCovered: [String] = []

		enumerateParts(in: multipartData, separatedBy: boundaryData) { partData in
			var partDisposition: (mime: String, parameters: [String: String])?

			let headerIndex = enumerateHeaders(in: partData) { key, value in
				guard key.caseInsensitiveCompare("Content-Disposition") == .orderedSame else {
					return
				}

				partDisposition = parse(value)
			}

			guard let (partMime, partParameters) = partDisposition else {
				XCTFail("Content-Disposition is a required header for multipart segments")
				return
			}

			XCTAssertEqual(partMime, "form-data")

			let partContent = Data(partData[headerIndex..<partData.endIndex])

			guard let partName = partParameters["name"], let expectation = expectations[partName] else {
				XCTFail("Unexpected part name in the Content-Disposition header")
				return
			}

			let expectedContent: Data
			switch expectation {
			case .object(let object):
				guard let objectData = object.multipartData else {
					XCTFail("Couldn't convert expected object into data")
					return
				}

				expectedContent = objectData

			case .file(let fileURL):
				guard let fileData = try? Data(contentsOf: fileURL) else {
					XCTFail("Couldn't load data from expected file")
					return
				}

				expectedContent = fileData
			}

			XCTAssertEqual(partContent, expectedContent)
			expectationsCovered.append(partName)
		}

		let expectationsRemaining = Set(expectations.keys).subtracting(expectationsCovered)

		XCTAssert(expectationsRemaining.isEmpty, "Not all expectations were accounted for: \(expectationsRemaining)")
	}

	private static let newlineData = "\r\n".data(using: .utf8)!

	private static func enumerateParts(in data: Data, separatedBy separator: Data, using block: (_ part: Data) -> Void) {
		var partIndex = data.startIndex

		while var partRange = data.range(scanningUpTo: separator, startingFrom: &partIndex) {
			partRange = data.range(trimmingOccurrencesOf: newlineData, in: partRange)

			guard !partRange.isEmpty else {
				continue
			}

			block(Data(data[partRange]))
		}
	}

	private static func enumerateHeaders(in data: Data, using block: (_ key: String, _ value: String) -> Void) -> Data.Index {
		var headerIndex = data.startIndex

		while true {
			let headerRange: Range<Data.Index>
			if let scannedRange = data.range(scanningUpTo: newlineData, startingFrom: &headerIndex) {
				headerRange = scannedRange
			}
			else {
				headerRange = headerIndex..<data.endIndex
				headerIndex = data.endIndex
			}

			if headerRange.isEmpty {
				break
			}

			let headerData = data[headerRange]

			guard let header = String(data: headerData, encoding: .utf8)?.split(separator: ":", maxSplits: 2) else {
				break
			}

			let headerKey = header[0].trimmingCharacters(in: .whitespaces)
			let headerValue = header[1].trimmingCharacters(in: .whitespaces)

			block(headerKey, headerValue)
		}

		return headerIndex
	}

	/// Parses a header value (i.e. `attachment; filename="filename.jpg"`) into its components.
	/// - Note: This is somewhat complex, so it has its own unit test below.
	static func parse(_ headerValue: String) -> (mime: String, parameters: [String: String]) {
		let scanner = Scanner(string: headerValue)
		scanner.charactersToBeSkipped = nil

		var mime = ""
		var parameters: [String: String] = [:]
		var currentKey = ""
		var scanningKey = true
		while true {
            let character: Character
            if #available(iOS 13.0, *) {
                character = scanner.scanCharacter() ?? ";"
            }
            else if scanner.scanLocation < scanner.string.count {
                let index = scanner.string.index(scanner.string.startIndex, offsetBy: scanner.scanLocation)
                character = scanner.string[index]
                scanner.scanLocation += 1
            }
            else {
                character = ";"
            }
            
			if character == ";" {
				// Finished the value, remove wrapping quotes (if found), and prepare for the next key
				if let segmentValue = parameters[currentKey] {
					parameters[currentKey] = segmentValue.replacingOccurrences(of: "^\"(.*)\"$", with: "$1", options: .regularExpression)
				}
				else if scanningKey, mime.isEmpty, parameters.isEmpty {
					mime = currentKey // Capture the mimeType (which is the first segment, and doesn't have a key-value structure)
				}

				currentKey = ""
				scanningKey = true

				if scanner.isAtEnd {
					break
				}

                if #available(iOS 13.0, *) {
                    _ = scanner.scanCharacters(from: .whitespaces)
                }
                else {
                    scanner.scanCharacters(from: CharacterSet(charactersIn: ";"), into: nil)
                    scanner.scanCharacters(from: .whitespaces, into: nil)
                }
			}
			else if character == "=" {
				// Finished scanning the key, switch to the value
				parameters[currentKey] = ""
				scanningKey = false
                
                if #available(iOS 13.0, *) {
                }
                else {
                    scanner.scanCharacters(from: CharacterSet(charactersIn: "="), into: nil)
                }
			}
			else if !scanningKey, var segmentValue = parameters[currentKey] {
				// Scan characters into the value
				segmentValue.append(character)
				parameters[currentKey] = segmentValue
			}
			else {
				// Scan characters into the key
				currentKey.append(character)
			}
		}

		return (mime, parameters)
	}

	// MARK: Utility tests

	func testValidateKnownGoodMultipartData() {
		for assetURL in developmentAssets {
			let multipartURL = assetURL.appendingPathExtension("multipart")

			guard let multipartData = try? Data(contentsOf: multipartURL) else {
				continue
			}

			var context = DataFileUploadContext()
			context.equipment = .gravel
			context.name = "Epic Ride"

			let expectations: [String: Expectation] = [
				"json": .object(context),
				"filename": .object(assetURL.lastPathComponent),
				"attachment": .file(assetURL),
			]

			let contentType = "multipart/form-data; boundary=Zone5MultipartY0NqCq7gshT1E36A"
			MultipartEncodedBodyTests.validate(multipartData, with: contentType, against: expectations)
		}
	}

	func testParseHeaderValue() {
		let tests: [(String, String, [String: String])] = [
			("application/json", "application/json", [:]),
			("multipart/form-data; boundary=boundary", "multipart/form-data", ["boundary": "boundary"]),
			("attachment", "attachment", [:]),
			("attachment; filename=\"filename.jpg\"", "attachment", ["filename": "filename.jpg"]),
			("form-data; name=\"field name\"; filename=\"filename.jpg\"", "form-data", ["name": "field name", "filename": "filename.jpg"]),
		]

		for (headerValue, expectedMime, expectedParameters) in tests {
			let (parsedMime, parsedParameters) = MultipartEncodedBodyTests.parse(headerValue)

			XCTAssertEqual(parsedMime, expectedMime)
			XCTAssertEqual(parsedParameters, expectedParameters)
		}
	}
}

private extension Data {

	func range(trimmingOccurrencesOf data: Self, in range: Range<Index>) -> Range<Index> {
		guard !range.isEmpty else {
			return range
		}

		var trimmedRange = range

		while let childRange = self.range(of: data, options: [.anchored], in: trimmedRange) {
			trimmedRange = childRange.endIndex..<trimmedRange.endIndex
		}

		while let childRange = self.range(of: data, options: [.anchored, .backwards], in: trimmedRange) {
			trimmedRange = trimmedRange.startIndex..<childRange.startIndex
		}

		return trimmedRange
	}

	func range(scanningUpTo data: Self, startingFrom startIndex: inout Self.Index) -> Range<Index>? {
		guard let range = firstRange(of: data, in: startIndex..<endIndex) else {
			return nil
		}

		defer { startIndex = range.endIndex }
		return startIndex..<range.startIndex
	}

}
