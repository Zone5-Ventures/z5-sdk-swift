import Foundation

/// Altitude adjusted power
public struct UserWorkoutResultAlt: Searchable {

	public var averageWatts: Int?
	public var maximumWatts: Int?
	public var adjustedWatts: Int?
	public var tscore: Int?
	public var kj: Int?

	public init() {}

	// MARK: Codable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case averageWatts = "avgWatts"
		case maximumWatts = "maxWatts"
		case adjustedWatts = "adjWatts"
		case tscore
		case kj
	}

	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String? = nil) -> [String] {
		mapFieldsToSearchStrings(fields: fields, prefix: prefix)
	}
}
