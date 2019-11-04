import Foundation

protocol RequestBody {

	var contentType: String { get }

	func encodedData() throws -> Data

}
