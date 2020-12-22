//
//  ResponseDecodingTests.swift
//  Zone5Tests
//
//  Created by Jean Hall on 16/12/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import XCTest
@testable import Zone5

class ResponseDecodingTests: XCTestCase {

	func testString() throws {
		let str = "basic string"
		
		let data = str.data(using: .utf8)!
		let response = URLResponse(url: URL(string: "https://staging.todaysplan.com.au/rest/test")!, mimeType: "string", expectedContentLength: data.count, textEncodingName: nil)
		let request = Request(endpoint: EndpointsForTesting.default, method: .get)
		let decoder = JSONDecoder()
		let result = decoder.decode(data, response: response, from: request, as: String.self, debugLogging: true)
		try XCTAssertEqual(str, result.get())
	}
	
	func testStringEscaped() {
		let str = "basic string"
		let escaped = "\"\(str)\""
		
		let data = escaped.data(using: .utf8)!
		let response = URLResponse(url: URL(string: "https://staging.todaysplan.com.au/rest/test")!, mimeType: "string", expectedContentLength: data.count, textEncodingName: nil)
		let request = Request(endpoint: EndpointsForTesting.default, method: .get)
		let decoder = JSONDecoder()
		let result = decoder.decode(data, response: response, from: request, as: String.self, debugLogging: true)
		try XCTAssertEqual(str, result.get())
	}
	
	func testRegex() throws {
		let regex = #"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$"#
		let data = regex.data(using: .utf8)!
		let response = URLResponse(url: URL(string: "https://staging.todaysplan.com.au/rest/test")!, mimeType: "string", expectedContentLength: data.count, textEncodingName: nil)
		let request = Request(endpoint: EndpointsForTesting.default, method: .get)
		
		let decoder = JSONDecoder()
		
		let result = decoder.decode(data, response: response, from: request, as: String.self, debugLogging: true)
		
		try XCTAssertEqual(regex, result.get())
    }

}
