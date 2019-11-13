import Foundation

public protocol SearchInputCriteria: Encodable {

	associatedtype Field: Codable

}

public struct SearchInput<Criteria: SearchInputCriteria>: JSONEncodedBody {

	public var criteria: Criteria

	public var fields: [Criteria.Field] = []

	public var identifiers: [Int] = []

	public var ctx: String = ""

	/// Bitmask that defines server options that is intended for internal use only.
	private let options: Int = 1

	/// Creates a new `SearchInput` with the given criteria.
	/// - Parameter criteria: The criteria to be used in performing the intended search.
	public init(criteria: Criteria) {
		self.criteria = criteria
	}

	// MARK: Encodable

	enum CodingKeys: String, CodingKey {
		case criteria
		case fields
		case identifiers = "ids"
		case ctx
		case options = "opts"
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(criteria, forKey: .criteria)
		try container.encode(ctx, forKey: .ctx)
		try container.encode(options, forKey: .options)

		if !fields.isEmpty {
			try container.encode(fields, forKey: .fields)
		}

		if !identifiers.isEmpty {
			try container.encode(identifiers, forKey: .identifiers)
		}
	}

}
