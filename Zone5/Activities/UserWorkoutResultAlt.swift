import Foundation

/// Altitude adjusted power
public struct UserWorkoutResultAlt: Codable {

	public var avgWatts: Int?
	public var maxWatts: Int?
	public var adjWatts: Int?
	public var tscore: Int?
	public var kj: Int?

	public init() {}

}
