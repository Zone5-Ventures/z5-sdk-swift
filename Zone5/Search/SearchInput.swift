import Foundation

public protocol SearchInputCriteria: Encodable {

}

public struct SearchInput<Criteria: SearchInputCriteria>: JSONEncodedBody {

	public var criteria: Criteria

	public var fields: [String] = []

	public var identifiers: [Int] = []

	public var ctx: String = ""

	/// Bitmask that defines server options.
	/// 1 << 0 - set that we don't need the verbose field mapping
	/// 1 << 1 - set a no-cache flag for this search
	/// 1 << 3 - set a no-decorate flag for this search (not needed if the tp-nodecorate header is set)
	public var options: Int = 1

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
