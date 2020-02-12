//
//  MillisecondsTests.swift
//  Zone5
//
//  Created by Daniel Farrelly on 22/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import XCTest
@testable import Zone5

class MillisecondsTests: XCTestCase {

	func testArithmetic() throws {
		let tests: [(arithmetic: () -> Milliseconds, expected: Milliseconds)] = [
			(
				arithmetic: { .zero + .zero + .zero },
				expected: 0
			),
			(
				arithmetic: { 1234 + 5678 },
				expected: 6912
			),
			(
				arithmetic: { 500 + 500 * 5 - 4000 / 5 },
				expected: 2200
			),
			(
				arithmetic: { (((500 + 500) * 5) - 4000) / 5  },
				expected: 200
			),
			(
				arithmetic: {
					var milliseconds = Milliseconds(rawValue: 12345)
					milliseconds += 67890
					milliseconds -= 67890
					milliseconds *= 10
					milliseconds /= 10
					return milliseconds
				},
				expected: 12345
			),
			(
				arithmetic: { min(0 as Milliseconds, 1000 as Milliseconds) },
				expected: 0
			),
			(
				arithmetic: { max(0 as Milliseconds, 1000 as Milliseconds) },
				expected: 1000
			),
		]

		for (arithmetic, expected) in tests {
			let computed = arithmetic()
			XCTAssertEqual(computed.magnitude, UInt(abs(expected.rawValue)))
			XCTAssertEqual(computed.rawValue, expected.rawValue)
			XCTAssertEqual(computed, expected)
			XCTAssertEqual(computed, Milliseconds(exactly: expected.rawValue))
		}
	}

	func testConversion() throws {
		let tests: [Date] = [
			Milliseconds.now.date,
			Date(),
			Date(timeIntervalSinceNow: 123456789),
			Date(timeIntervalSince1970: 123456789),
			Date(timeIntervalSinceReferenceDate: 123456789),
			Date(timeIntervalSinceNow: 123456789.987654321),
			Date(timeIntervalSince1970: 123456789.987654321),
			Date(timeIntervalSinceReferenceDate: 123456789.987654321),
		]

		for originalDate in tests {
			let timeInterval = round(originalDate.timeIntervalSince1970 * 1000) / 1000
			let roundedDate = Date(timeIntervalSince1970: timeInterval)
			let milliseconds = originalDate.milliseconds

			XCTAssertEqual(timeInterval, milliseconds.timeInterval)
			XCTAssertEqual(timeInterval.milliseconds, milliseconds)
			XCTAssertEqual(milliseconds.date, roundedDate)
			XCTAssertEqual(Date(converting: timeInterval), roundedDate)
			XCTAssertEqual(TimeInterval(converting: milliseconds.date), timeInterval)
			XCTAssertEqual(Milliseconds(timeInterval: timeInterval), milliseconds)
			XCTAssertEqual(Milliseconds(date: roundedDate), milliseconds)
			XCTAssertEqual(Milliseconds(date: originalDate), milliseconds)
		}
	}

	func testCodable() throws {
		let tests: [(json: String, expected: Milliseconds?)] = [
			("[0]", 0),
			("[123456789]", 123456789),
			("[123456789.987654321]", nil),
		]

		for (json, expected) in tests {
            do {
                let decoded = try decode(json: json, as: [Milliseconds].self)
                XCTAssertEqual(decoded.first, expected)
            } catch {
                print(error)
            }

			guard let milliseconds = expected else {
				continue
			}

            do {
                let encoded = try encode([milliseconds])
                XCTAssertEqual(encoded, json)
            } catch {
                print(error)
            }
		}
	}

}
