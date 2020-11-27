import Foundation

/// Peak leg spring stiffness
public struct UserWorkoutResultPeakLss: Codable {

	public var peak3SecondLSS: Float?
	public var peak4SecondLSS: Float?
	public var peak5SecondLSS: Float?
	public var peak10SecondLSS: Float?
	public var peak12SecondLSS: Float?
	public var peak20SecondLSS: Float?
	public var peak30SecondLSS: Float?
	public var peak1MinuteLSS: Float?
	public var peak2MinuteLSS: Float?
	public var peak3MinuteLSS: Float?
	public var peak4MinuteLSS: Float?
	public var peak5MinuteLSS: Float?
	public var peak6MinuteLSS: Float?
	public var peak10MinuteLSS: Float?
	public var peak15MinuteLSS: Float?
	public var peak20MinuteLSS: Float?
	public var peak30MinuteLSS: Float?
	public var peak40MinuteLSS: Float?
	public var peak60MinuteLSS: Float?
	public var peak120MinuteLSS: Float?
	public var peak180MinuteLSS: Float?

	public var peak3SecondLSSKg: Float?
	public var peak4SecondLSSKg: Float?
	public var peak5SecondLSSKg: Float?
	public var peak10SecondLSSKg: Float?
	public var peak12SecondLSSKg: Float?
	public var peak20SecondLSSKg: Float?
	public var peak30SecondLSSKg: Float?
	public var peak1MinuteLSSKg: Float?
	public var peak2MinuteLSSKg: Float?
	public var peak3MinuteLSSKg: Float?
	public var peak4MinuteLSSKg: Float?
	public var peak5MinuteLSSKg: Float?
	public var peak6MinuteLSSKg: Float?
	public var peak10MinuteLSSKg: Float?
	public var peak15MinuteLSSKg: Float?
	public var peak20MinuteLSSKg: Float?
	public var peak30MinuteLSSKg: Float?
	public var peak40MinuteLSSKg: Float?
	public var peak60MinuteLSSKg: Float?
	public var peak120MinuteLSSKg: Float?
	public var peak180MinuteLSSKg: Float?

	public init() {}

	// MARK: Codable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case peak3SecondLSS = "peak3secLss"
		case peak4SecondLSS = "peak4secLss"
		case peak5SecondLSS = "peak5secLss"
		case peak10SecondLSS = "peak10secLss"
		case peak12SecondLSS = "peak12secLss"
		case peak20SecondLSS = "peak20secLss"
		case peak30SecondLSS = "peak30secLss"
		case peak1MinuteLSS = "peak1minLss"
		case peak2MinuteLSS = "peak2minLss"
		case peak3MinuteLSS = "peak3minLss"
		case peak4MinuteLSS = "peak4minLss"
		case peak5MinuteLSS = "peak5minLss"
		case peak6MinuteLSS = "peak6minLss"
		case peak10MinuteLSS = "peak10minLss"
		case peak15MinuteLSS = "peak15minLss"
		case peak20MinuteLSS = "peak20minLss"
		case peak30MinuteLSS = "peak30minLss"
		case peak40MinuteLSS = "peak40minLss"
		case peak60MinuteLSS = "peak60minLss"
		case peak120MinuteLSS = "peak120minLss"
		case peak180MinuteLSS = "peak180minLss"

		case peak3SecondLSSKg = "peak3secLssKg"
		case peak4SecondLSSKg = "peak4secLssKg"
		case peak5SecondLSSKg = "peak5secLssKg"
		case peak10SecondLSSKg = "peak10secLssKg"
		case peak12SecondLSSKg = "peak12secLssKg"
		case peak20SecondLSSKg = "peak20secLssKg"
		case peak30SecondLSSKg = "peak30secLssKg"
		case peak1MinuteLSSKg = "peak1minLssKg"
		case peak2MinuteLSSKg = "peak2minLssKg"
		case peak3MinuteLSSKg = "peak3minLssKg"
		case peak4MinuteLSSKg = "peak4minLssKg"
		case peak5MinuteLSSKg = "peak5minLssKg"
		case peak6MinuteLSSKg = "peak6minLssKg"
		case peak10MinuteLSSKg = "peak10minLssKg"
		case peak15MinuteLSSKg = "peak15minLssKg"
		case peak20MinuteLSSKg = "peak20minLssKg"
		case peak30MinuteLSSKg = "peak30minLssKg"
		case peak40MinuteLSSKg = "peak40minLssKg"
		case peak60MinuteLSSKg = "peak60minLssKg"
		case peak120MinuteLSSKg = "peak120minLssKg"
		case peak180MinuteLSSKg = "peak180minLssKg"
	}

	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String) -> [String] {
		return fields.map { "\(prefix).\($0.rawValue)" }
	}
}
