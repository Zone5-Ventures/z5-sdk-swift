import Foundation

/// Peak pace
public struct UserWorkoutResultPeakPace: Codable {

	public var peak3SecondPace: Int?
	public var peak4SecondPace: Int?
	public var peak5SecondPace: Int?
	public var peak10SecondPace: Int?
	public var peak12SecondPace: Int?
	public var peak20SecondPace: Int?
	public var peak30SecondPace: Int?
	public var peak1MinutePace: Int?
	public var peak2MinutePace: Int?
	public var peak3MinutePace: Int?
	public var peak4MinutePace: Int?
	public var peak5MinutePace: Int?
	public var peak6MinutePace: Int?
	public var peak10MinutePace: Int?
	public var peak15MinutePace: Int?
	public var peak20MinutePace: Int?
	public var peak30MinutePace: Int?
	public var peak40MinutePace: Int?
	public var peak60MinutePace: Int?
	public var peak120MinutePace: Int?
	public var peak180MinutePace: Int?

	public init() {}

	// MARK: Codable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case peak3SecondPace = "peak3secPace"
		case peak4SecondPace = "peak4secPace"
		case peak5SecondPace = "peak5secPace"
		case peak10SecondPace = "peak10secPace"
		case peak12SecondPace = "peak12secPace"
		case peak20SecondPace = "peak20secPace"
		case peak30SecondPace = "peak30secPace"
		case peak1MinutePace = "peak1minPace"
		case peak2MinutePace = "peak2minPace"
		case peak3MinutePace = "peak3minPace"
		case peak4MinutePace = "peak4minPace"
		case peak5MinutePace = "peak5minPace"
		case peak6MinutePace = "peak6minPace"
		case peak10MinutePace = "peak10minPace"
		case peak15MinutePace = "peak15minPace"
		case peak20MinutePace = "peak20minPace"
		case peak30MinutePace = "peak30minPace"
		case peak40MinutePace = "peak40minPace"
		case peak60MinutePace = "peak60minPace"
		case peak120MinutePace = "peak120minPace"
		case peak180MinutePace = "peak180minPace"
	}

	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String) -> [String] {
		return fields.map { "\(prefix).\($0.rawValue)" }
	}
}
