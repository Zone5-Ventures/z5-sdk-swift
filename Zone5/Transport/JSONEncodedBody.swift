import Foundation

protocol JSONEncodedBody: RequestBody, MultipartDataConvertible, Encodable {

}

extension JSONEncodedBody {

	// MARK: RequestBody

	var contentType: String {
		return "application/json"
	}

	func encodedData() throws -> Data {
		return try JSONEncoder().encode(self)
	}

	// MARK: MultipartDataConvertible

	public var multipartData: Data? {
		return try? encodedData()
	}

}
