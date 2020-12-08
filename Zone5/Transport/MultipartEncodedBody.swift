import Foundation

/// Structure used to encode multipart data for upload requests.
/// - Note: Parts are encoded in the order that they are appended.
struct MultipartEncodedBody: RequestBody {

	/// Character set that can be used to generate a random `boundary` string on a per-instance basis
	private static let boundaryCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

	/// Boundary string used as the basis for separating the parts within the encoded multipart data.
	var boundary: String

	init() {
		boundary = "Zone5Multipart-" + (0..<15).compactMap { _ in MultipartEncodedBody.boundaryCharacters.randomElement() }
	}

	/// Errors that can be generated while encoding a `MultipartEncodedBody`.
	enum Error: Swift.Error {

		/// The multipart's boundary string couldn't be encoded.
		case invalidBoundary

		/// The `Part`'s header couldn't be encoded.
		case invalidHeader

		/// The `Part`'s content couldn't be encoded.
		case invalidContent

	}

	// MARK: Parts

	private var parts: [Part] = []

	mutating func append(_ part: Part) {
		parts.append(part)
	}

	mutating func appendPart(name: String, content: MultipartDataConvertible) throws {
		let part = try Part(name: name, content: content)
		append(part)
	}

	mutating func appendPart(name: String, filename: String, content: MultipartDataConvertible) throws {
		let part = try Part(name: name, filename: filename, content: content)
		append(part)
	}

	mutating func appendPart(name: String, contentsOf fileURL: URL) throws {
		let content = try Data(contentsOf: fileURL)
		try appendPart(name: name, filename: fileURL.lastPathComponent, content: content)
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
            output.append(components: .divider, boundary, .newline, part.data, .newline)
            // a binary data section should end with a single newline which preceeds the final boundary
		}

		output.append(components: .divider, boundary, .divider)

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
public protocol MultipartDataConvertible {

	var multipartData: Data? { get }

}

extension Data: MultipartDataConvertible {

	public var multipartData: Data? {
		return self
	}

}

extension String: MultipartDataConvertible {

	public var multipartData: Data? {
		return data(using: .utf8)
	}

}

extension NSNumber: MultipartDataConvertible {

	public var multipartData: Data? {
		return stringValue.multipartData
	}

}
