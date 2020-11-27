import Foundation

/// Rating of a prescribed workout
public struct UserWorkoutResultRating: Codable {

	public var user: User?

	public var resultId: Int?

	/// 1-5 (5 is best)
	public var overall: Int?

	/// 1-5 (3 is best)
	public var duration: Int?

	/// 1-5 (3 is best)
	public var intensity: Int?

	public init() {}

	// MARK: Codable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case user
		case resultId = "resultID"
		case overall
		case duration
		case intensity
	}

	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String) -> [String] {
		return fields.map { "\(prefix).\($0.rawValue)" }
	}
}
