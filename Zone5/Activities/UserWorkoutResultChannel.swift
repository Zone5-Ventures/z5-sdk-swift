import Foundation

public struct UserWorkoutResultChannel: Codable {

	/// A nice field display name
	public var name: String?

	/// The mapped field type
	public var type: MappedFieldType?

	/// The native record number
	public var num: Int?
	
	/// aggregates
	public var min: Double?
	
	public var max: Double?
	
	public var avg: Double?

	public init() {}
	
	public enum CodingKeys: String, CodingKey, CaseIterable {
		case name
		case type
		case num
		case min
		case max
		case avg
	}

	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String) -> [String] {
		return fields.map { "\(prefix).\($0.rawValue)" }
	}
}
