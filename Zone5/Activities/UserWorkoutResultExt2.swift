import Foundation

public struct UserWorkoutResultExt2: Codable {

	/// Respiration - breaths/minute
	public var avgResp: Int?

	/// Respiration - breaths/minute
	public var maxResp: Int?

	/// 0-20+ Garmin MTB dynamics - Flow (double) (0-1 - Smooth, 1-20 Moderate, 20+ rough
	public var avgFlow: Float?

	/// 0-20+ Garmin MTB dynamics - Flow (double) (0-1 - Smooth, 1-20 Moderate, 20+ rough
	public var maxFlow: Float?

	/// 0-40+ Garmin MTB dynamics - Grit (sum this and /1000) - 0-20 (Easy), 20-40 (moderate), Hard 40+
	public var avgGrit: Int? //

	/// 0-40+ Garmin MTB dynamics - Grit (sum this and /1000) - 0-20 (Easy), 20-40 (moderate), Hard 40+
	public var maxGrit: Int?

	/// kGrit - Sum of Garmin MTB dynamics Grit
	public var sumGrit: Int? // kGrit

	/// Calories consumed
	public var caloriesIn: Int?

	/// Calories deficient - calories in - calories out
	public var caloriesDiff: Int? // calories in - calories out

	/// Fluid loss (milliliter)
	public var fluidOut: Int?

	/// Fluid consumed (milliliter)
	public var fluidIn: Int?

	/// Fluid deficient - fluid in - fluid out (milliliter)
	public var fluidDiff: Int?

	public init() {}

}
