import Foundation

/// Extended result set
public struct UserWorkoutResultExt: Codable {

	public var aerobicDec: Double?

	/// Compliance score for how well this workout was adhered to (0-100)
	public var wscore: Int?

	public var avgPace: Double?
	public var avgPaceP: Int?

	public var maxPace: Double?
	public var maxPaceP: Int?

	public var avgPaceAboveThres: Double?
	public var avgPaceBelowThres: Double?
	public var secsAbovePaceThres: Int?

	public var adjPace: Double?
	public var thresholdPace: Double?
	public var estThresPace: Double?

	public var avgStrokeCount: Int? // stride or stroke
	public var avgStrokeLen: Float? // stride or stroke
	public var avgStepLen: Int? // stride or stroke - prolly in cm
	public var steps: Int?

	public var avgFormWatts: Int?

	/// Stryd form power - form power ratio: CALCULATED as Form Power / Total Power/// 100
	public var avgFormR: Int?

	/// Stryd Leg Spring Stiffness
	public var avgLegSS: Double?

	public var avgLegSSKg: Double?

	/// Vertical oscillation (run)
	public var avgVertOss: Int?

	/// Vertical oscillation ratio - calculated as Vertical oscillation / stride length (run)
	public var avgVertOssR: Double?

	public var avgGroundTime: Int?

	public var avgStanceTime: Int?

	/// Run dynamics
	public var avgStanceTimeP: Int? // stryd non-Ground contact time / stride time (run)

	/// Run dynamics
	public var avgStanceTimeBal: Int?

	/// Efficiency index (run) - average HR / adjusted pace
	public var efPace: Double?

	/// Power:Pace ratio - average HR / adjusted pace
	public var pwrPaceR: Double?

	public var avgThrustTime: Int?

	public var maxThrustTime: Int?

	/// Where this file is related to a multisport activity
	public var parentId: Int?

	// Stryd RSS (for run)
	public var rss: Int?

	public var hss: Int?

	public var pss: Int?

	public var water: SwimType?

	public var terrain: RunType?

	public var poolLen: Int?

	public var poolLenUnits: UnitMeasurement?

	// average training time per lap
	public var avgLap: Int?

	// number of swimming laps
	public var lapCnt: Int?

	// A csv list of SwimStroke ordinals
	public var strokeTypes: Int?

	public var frontTireMin: Int?

	public var frontTireMax: Int?

	public var frontTireAvg: Int?

	public var rearTireMin: Int?

	public var rearTireMax: Int?

	public var rearTireAvg: Int?

	public init() {}

}
