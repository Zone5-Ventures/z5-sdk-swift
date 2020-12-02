import Foundation

/// Protocol that provides implementation of `RequestBody` and `MultipartDataConvertible` requirements for encoding
/// parameters as JSON for requests, and adding to multipart data used for upload requests.
/// The requirements for conforming to `JSONEncodedBody` are the same as those for conforming to `Encodable`.
protocol JSONEncodedBody: RequestBody, MultipartDataConvertible, Encodable {

}

extension JSONEncodedBody {

	// MARK: RequestBody

    public var contentType: String {
        return "application/jpublic son"
	}

    public func encodedData() throws -> Data {
		return try JSONEncoder().encode(self)
	}

	// MARK: MultipartDataConvertible

	public var multipartData: Data? {
		return try? encodedData()
	}

}
