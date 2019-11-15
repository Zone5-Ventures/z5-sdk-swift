import Foundation

public struct UserWorkoutResultTurbo: Codable {

	public var product: String? // ie file_id.product_name --> SPECIALIZED_WSBC601160149N

	public var avgMotorPower: Int?
	public var maxMotorPower: Int?

	public var minMotorTemp: Int?
	public var avgMotorTemp: Int?
	public var maxMotorTemp: Int?

	public var minBattery1: Int?
	public var avgBattery1: Int?
	public var maxBattery1: Int?

	public var minBattery2: Int?
	public var avgBattery2: Int?
	public var maxBattery2: Int?

	public var minProfileScale: Int?
	public var avgProfileScale: Int?
	public var maxProfileScale: Int?

	public var minCurrentScale: Int?
	public var avgCurrentScale: Int?
	public var maxCurrentScale: Int?

	public var avgSupportFactor: Double?
	public var maxSupportFactor: Double?

	public init() {}

}
