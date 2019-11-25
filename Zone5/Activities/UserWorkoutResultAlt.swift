import Foundation

/// Altitude adjusted power
public struct UserWorkoutResultAlt: Codable {

	public var averageWatts: Int?
	public var maximumWatts: Int?
	public var adjustedWatts: Int?
	public var tscore: Int?
	public var kj: Int?

	public init() {}

	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case averageWatts = "avgWatts"
		case maximumWatts = "maxWatts"
		case adjustedWatts = "adjWatts"
		case tscore
		case kj
	}

}
