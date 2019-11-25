import Foundation

public struct UserWorkoutResultTurbo: Codable {

	public var productName: String? // ie file_id.product_name --> SPECIALIZED_WSBC601160149N

	public var averageMotorPower: Int?
	public var maximumMotorPower: Int?

	public var minimumMotorTemperature: Int?
	public var averageMotorTemperature: Int?
	public var maximumMotorTemperature: Int?

	public var minimumBattery1: Int?
	public var averageBattery1: Int?
	public var maximumBattery1: Int?

	public var minimumBattery2: Int?
	public var averageBattery2: Int?
	public var maximumBattery2: Int?

	public var minimumProfileScale: Int?
	public var averageProfileScale: Int?
	public var maximumProfileScale: Int?

	public var minimumCurrentScale: Int?
	public var averageCurrentScale: Int?
	public var maximumCurrentScale: Int?

	public var averageSupportFactor: Double?
	public var maximumSupportFactor: Double?

	public init() {}

	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case productName = "product"
		case averageMotorPower = "avgMotorPower"
		case maximumMotorPower = "maxMotorPower"
		case minimumMotorTemperature = "minMotorTemp"
		case averageMotorTemperature = "avgMotorTemp"
		case maximumMotorTemperature = "maxMotorTemp"
		case minimumBattery1 = "minBattery1"
		case averageBattery1 = "avgBattery1"
		case maximumBattery1 = "maxBattery1"
		case minimumBattery2 = "minBattery2"
		case averageBattery2 = "avgBattery2"
		case maximumBattery2 = "maxBattery2"
		case minimumProfileScale = "minProfileScale"
		case averageProfileScale = "avgProfileScale"
		case maximumProfileScale = "maxProfileScale"
		case minimumCurrentScale = "minCurrentScale"
		case averageCurrentScale = "avgCurrentScale"
		case maximumCurrentScale = "maxCurrentScale"
		case averageSupportFactor = "avgSupportFactor"
		case maximumSupportFactor = "maxSupportFactor"
	}

}
