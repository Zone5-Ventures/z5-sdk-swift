//
//  SearchResultTests.swift
//  Zone5Tests
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import XCTest
@testable import Zone5

class SearchResultTests: XCTestCase {

	func testDecodeResultsAsEmptyArray() throws {
		let result = try decode(
			json: "{\"result\": [], \"cnt\": 10, \"offset\": 0}",
			as: SearchResult<UserWorkoutResult>.self
		)

		XCTAssertEqual(result.total, 10)
		XCTAssertEqual(result.offset, 0)

		XCTAssertEqual(result.count, 0)

		XCTAssert(result.result.fields.isEmpty)
		XCTAssert(result.result.keys.isEmpty)
	}

	func testDecodeResultsAsArray() throws {
		let result = try decode(
			json: "{\"result\": [{\"id\": 12345, \"activity\": \"workouts\"}, {\"id\": 67890, \"activity\": \"files\"}], \"cnt\": 10, \"offset\": 0}",
			as: SearchResult<UserWorkoutResult>.self
		)

		XCTAssertEqual(result.total, 10)
		XCTAssertEqual(result.offset, 0)

		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0].id, 12345)
		XCTAssertEqual(result[0].activity, .workout)
		XCTAssertEqual(result[1].id, 67890)
		XCTAssertEqual(result[1].activity, .file)

		XCTAssert(result.result.fields.isEmpty)
		XCTAssert(result.result.keys.isEmpty)
	}

	func testDecodeResultsAsEmptyMappedResult() throws {
		let result = try decode(
			json: "{\"result\": {\"results\": [], \"fields\": {}, \"keys\": []}, \"cnt\": 10, \"offset\": 0}",
			as: SearchResult<UserWorkoutResult>.self
		)

		XCTAssertEqual(result.total, 10)
		XCTAssertEqual(result.offset, 0)

		XCTAssertEqual(result.count, 0)

		XCTAssert(result.result.fields.isEmpty)
		XCTAssert(result.result.keys.isEmpty)
	}

	func testDecodeResultsAsMappedResult() throws {
		let result = try decode(
			json: "{\"result\": {\"results\": [{\"id\": 12345, \"activity\": \"workouts\"}], \"fields\": {}, \"keys\": []}, \"cnt\": 10, \"offset\": 0}",
			as: SearchResult<UserWorkoutResult>.self
		)

		XCTAssertEqual(result.total, 10)
		XCTAssertEqual(result.offset, 0)

		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result[0].id, 12345)
		XCTAssertEqual(result[0].activity, .workout)

		XCTAssert(result.result.fields.isEmpty)
		XCTAssert(result.result.keys.isEmpty)
	}

}
