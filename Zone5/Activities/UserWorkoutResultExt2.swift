import Foundation

public struct UserWorkoutResultExt2: Searchable {

	/// Respiration - breaths/minute
	public var averageRespiration: Int?

	/// Respiration - breaths/minute
	public var maximumRespiration: Int?

	/// 0-20+ Garmin MTB dynamics - Flow (double) (0-1 - Smooth, 1-20 Moderate, 20+ rough
	public var averageFlow: Float?

	/// 0-20+ Garmin MTB dynamics - Flow (double) (0-1 - Smooth, 1-20 Moderate, 20+ rough
	public var maximumFlow: Float?

	/// 0-40+ Garmin MTB dynamics - Grit (sum this and /1000) - 0-20 (Easy), 20-40 (moderate), Hard 40+
	public var averageGrit: Int? //

	/// 0-40+ Garmin MTB dynamics - Grit (sum this and /1000) - 0-20 (Easy), 20-40 (moderate), Hard 40+
	public var maximumGrit: Int?

	/// kGrit - Sum of Garmin MTB dynamics Grit
	public var sumGrit: Int? // kGrit

	/// Calories consumed
	public var caloriesIn: Int?

	/// Calories deficient - calories in - calories out
	public var caloriesDifference: Int? // calories in - calories out

	/// Fluid loss (milliliter)
	public var fluidOut: Int?

	/// Fluid consumed (milliliter)
	public var fluidIn: Int?

	/// Fluid deficient - fluid in - fluid out (milliliter)
	public var fluidDifference: Int?

	public init() {}

	// MARK: Codable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case averageRespiration = "avgResp"
		case maximumRespiration = "maxResp"
		case averageFlow = "avgFlow"
		case maximumFlow = "maxFlow"
		case averageGrit = "avgGrit"
		case maximumGrit = "maxGrit"
		case sumGrit = "sumGrit"
		case caloriesIn = "caloriesIn"
		case caloriesDifference = "caloriesDiff"
		case fluidOut = "fluidOut"
		case fluidIn = "fluidIn"
		case fluidDifference = "fluidDiff"
	}

	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String? = nil) -> [String] {
		mapFieldsToSearchStrings(fields: fields, prefix: prefix)
	}
}
