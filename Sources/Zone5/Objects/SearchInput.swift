import Foundation

public struct SearchInputOptions: OptionSet, Encodable {

	public let rawValue: Int

	public init(rawValue: Int) {
		self.rawValue = rawValue
	}

	public static let disableFieldSchema = SearchInputOptions(rawValue: 1 << 0)
	public static let disableServerSideDecoration = SearchInputOptions(rawValue: 1 << 1)

}

public struct SearchInput<Criteria: Encodable>: JSONEncodedBody {

	public var criteria: Criteria

	public var fields: [String] = []

	public var identifiers: [Int] = []

	public var ctx: String = ""

	public var options: SearchInputOptions = .disableFieldSchema

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
