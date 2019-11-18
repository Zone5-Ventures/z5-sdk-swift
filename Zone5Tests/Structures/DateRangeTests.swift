//
//  DateRangeTests.swift
//  Zone5
//
//  Created by Daniel Farrelly on 18/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import XCTest
@testable import Zone5

class DateRangeTests: XCTestCase {

	let decoder = JSONDecoder()

	func testDecode() throws {
		let tests: [(json: String, expected: Result<DateRange, Swift.Error>)] = [
			(
				json: "{\"floorTs\":1566099275352,\"ceilTs\":1574044475352,\"tz\":\"Australia\\/Sydney\"}",
				expected: .success(DateRange(name: nil, floor: 1566099275.352, ceiling: 1574044475.352, timeZone: TimeZone(identifier: "Australia/Sydney")!))
			),
			(
				json: "{\"floorTs\":1566099275352,\"ceilTs\":1574044475352,\"tz\":\"INVALID_TIMEZONE_IDENTIFIER\"}",
				expected: .failure(DateRange.DecodingError.invalidTimeZoneIdentifier(identifier: "INVALID_TIMEZONE_IDENTIFIER"))
			),
			(
				json: "{\"name\":\"Test Range\",\"floorTs\":1566099275352,\"ceilTs\":1574044475352}",
				expected: .success(DateRange(name: "Test Range", floor: 1566099275.352, ceiling: 1574044475.352))
			),
		]

		for (json, expected) in tests {
			let data = json.data(using: .utf8)!
			let result: DateRange

			switch expected {
			case .success(let expectedRange):
				do {
					result = try decoder.decode(DateRange.self, from: data)

					XCTAssertEqual(result.name, expectedRange.name)
					XCTAssertEqual(result.floor, expectedRange.floor)
					XCTAssertEqual(result.ceiling, expectedRange.ceiling)
					XCTAssertEqual(result.timeZone.identifier, expectedRange.timeZone.identifier)
				}
				catch {
					XCTFail("Failed to decode JSON\n\t- Error: \(error)\n\t- Expected: \(expectedRange)")
				}

			case .failure(let expectedError):
				do {
					result = try decoder.decode(DateRange.self, from: data)

					XCTFail("Unexpected success in decoding JSON\n\t- Expected: \(expectedError)")
				}
				catch {
					XCTAssertEqual((error as NSError).domain, (expectedError as NSError).domain)
					XCTAssertEqual((error as NSError).code, (expectedError as NSError).code)

					if case DateRange.DecodingError.invalidTimeZoneIdentifier(let identifier) = error,
						case DateRange.DecodingError.invalidTimeZoneIdentifier(let expectedIdentifier) = expectedError {
						XCTAssertEqual(identifier, expectedIdentifier)
					}
				}
			}
		}
	}

}
