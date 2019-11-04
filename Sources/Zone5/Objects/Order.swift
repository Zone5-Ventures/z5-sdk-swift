import Foundation

public struct Order: Codable {

	public var field: String

	public var direction: Direction

	public enum Direction: String, Codable {
		case ascending = "asc"
		case descending = "desc"
	}

	// MARK: Encodable

	enum CodingKeys: String, CodingKey {
		case field
		case direction = "order"
	}

}
