//
//  Multipart.swift
//  Zone5
//
//  Created by Daniel Farrelly on 12/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

struct MultipartEncodedBody: RequestBody {

	var boundary = "Zone5MultipartY0NqCq7gshT1E36A"

	enum Error: Swift.Error {
		case invalidBoundary
		case invalidHeader
		case invalidContent
	}

	// MARK: Parts

	private var parts: [Part] = []

	mutating func append(_ part: Part) {
		parts.append(part)
	}

	mutating func appendPart(name: String, content: MultipartDataConvertible) throws {
		let part = try Part(name: name, content: content)
		parts.append(part)
	}

	mutating func appendPart(name: String, filename: String, content: MultipartDataConvertible) throws {
		let part = try Part(name: name, filename: filename, content: content)
		parts.append(part)
	}

	mutating func appendPart(name: String, contentsOf fileURL: URL) throws {
		let content = try Data(contentsOf: fileURL)
		let part = try Part(name: name, filename: fileURL.lastPathComponent, content: content)
		parts.append(part)
	}

	struct Part {

		let name: String

		let data: Data

		init(name: String, filename: String? = nil, content: MultipartDataConvertible) throws {
			var headerComponents: [String] = []
			headerComponents.append("Content-Disposition: form-data")
			headerComponents.append("name=\"\(name)\"")

			if let filename = filename {
				headerComponents.append("filename=\"\(filename)\"")
			}

			guard let header = headerComponents.joined(separator: "; ").multipartData else {
				throw Error.invalidHeader
			}

			guard let content = content.multipartData else {
				throw Error.invalidContent
			}

			self.name = name
			self.data = Data(components: header, .newline, .newline, content)
		}

	}

	// MARK: Request body

	var contentType: String {
		return "multipart/form-data; boundary=\(boundary)"
	}

	func encodedData() throws -> Data {
		var output = Data()

		guard let boundary = boundary.data(using: .utf8) else {
			throw Error.invalidBoundary
		}

		for part in parts {
			output.append(components: .divider, boundary, .newline, part.data, .newline, .newline)
		}

		output.append(components: .divider, boundary, .divider, .newline)

		return output
	}

}

// MARK: Data

/// Some extension on the `Data` structure to make life a little easier.
private extension Data {

	static let divider = Data([45, 45]) // "--"

	static let newline = Data([13, 10]) // "\r\n"

	init(components: [Data]) {
		self.init(components.flatMap { $0 })
	}

	init(components: Data...) {
		self.init(components: components)
	}

	mutating func append(components: Data...) {
		append(Data(components: components))
	}

}

// MARK: Multipart data convertible

/// Protocol to convert objects to data for inclusion in a multipart POST body.
protocol MultipartDataConvertible {

	var multipartData: Data? { get }

}

extension Data: MultipartDataConvertible {

	var multipartData: Data? {
		return self
	}

}

extension String: MultipartDataConvertible {

	var multipartData: Data? {
		return data(using: .utf8)
	}

}

extension NSNumber: MultipartDataConvertible {

	var multipartData: Data? {
		return stringValue.multipartData
	}

}
