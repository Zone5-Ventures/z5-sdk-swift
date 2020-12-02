import Foundation

/// Protocol defining the requirements for parameters used for requests.
public protocol RequestBody {

	/// The string value for the requests "Content-Type" header, this is typically a MIME type that reflects the type of
	/// data returned by `encodingData()`, but may also contain other parameters.
	/// - SeeAlso: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type>
	var contentType: String { get }

	/// The actual content of the conforming structure, encoded as data.
	func encodedData() throws -> Data

}
