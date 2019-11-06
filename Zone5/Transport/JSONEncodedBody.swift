import Foundation

protocol JSONEncodedBody: RequestBody, Encodable {

}

extension JSONEncodedBody {

	var contentType: String {
		return "application/json"
	}

	func encodedData() throws -> Data {
		return try JSONEncoder().encode(self)
	}

}
