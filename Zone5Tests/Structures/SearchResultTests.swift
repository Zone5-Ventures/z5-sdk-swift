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

	let decoder = JSONDecoder()

	func testDecodeResultsAsArray() throws {
		let json = "{\"result\": [{\"id\": 12345, \"activity\": \"workouts\"}, {\"id\": 67890, \"activity\": \"files\"}], \"cnt\": 10, \"offset\": 0}"

		let data = json.data(using: .utf8)!
		let result = try decoder.decode(SearchResult<Activity>.self, from: data)

		XCTAssertEqual(result.total, 10)
		XCTAssertEqual(result.offset, 0)

		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0].id, 12345)
		XCTAssertEqual(result[0].category, .workout)
		XCTAssertEqual(result[1].id, 67890)
		XCTAssertEqual(result[1].category, .file)

		XCTAssert(result.result.fields.isEmpty)
		XCTAssert(result.result.keys.isEmpty)
	}

	func testDecodeResultsAsMappedResult() throws {
		let json = "{\"result\": {\"results\": [{\"id\": 12345, \"activity\": \"workouts\"}, {\"id\": 67890, \"activity\": \"files\"}], \"fields\": {}, \"keys\": []}, \"cnt\": 10, \"offset\": 0}"

		let data = json.data(using: .utf8)!
		let result = try decoder.decode(SearchResult<Activity>.self, from: data)

		XCTAssertEqual(result.total, 10)
		XCTAssertEqual(result.offset, 0)

		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0].id, 12345)
		XCTAssertEqual(result[0].category, .workout)
		XCTAssertEqual(result[1].id, 67890)
		XCTAssertEqual(result[1].category, .file)

		XCTAssert(result.result.fields.isEmpty)
		XCTAssert(result.result.keys.isEmpty)
	}

}
