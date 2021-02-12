import Foundation

/// Extended result set
public struct UserWorkoutResultExt: Searchable {

	public var aerobicDec: Double?

	/// Compliance score for how well this workout was adhered to (0-100)
	public var wscore: Int?

	public var averagePace: Double?
	public var averagePacePercentage: Int?

	public var maximumPace: Double?
	public var maximumPacePercentage: Int?

	public var averagePaceAboveThreshold: Double?
	public var averagePaceBelowThreshold: Double?
	public var secsAbovePaceThreshold: Int?

	public var adjustedPace: Double?
	public var thresholdPace: Double?
	public var estimatedThresholdPace: Double?

	public var averageStrokeCount: Int? // stride or stroke
	public var averageStrokeLength: Float? // stride or stroke
	public var averageStepLength: Int? // stride or stroke - prolly in cm
	public var steps: Int?

	public var averageFormWatts: Int?

	/// Stryd form power - form power ratio: CALCULATED as Form Power / Total Power/// 100
	public var averageFormRatio: Int?

	/// Stryd Leg Spring Stiffness
	public var averageLegSS: Double?

	public var averageLegSSKg: Double?

	/// Vertical oscillation (run)
	public var averageVerticalOscillation: Int?

	/// Vertical oscillation ratio - calculated as Vertical oscillation / stride length (run)
	public var averageVerticalOscillationRatio: Double?

	public var averageGroundTime: Int?

	public var averageStanceTime: Int?

	/// Run dynamics
	public var averageStanceTimePercentage: Int? // stryd non-Ground contact time / stride time (run)

	/// Run dynamics
	public var averageStanceTimeBalance: Int?

	/// Efficiency index (run) - average HR / adjusted pace
	public var efficiencyPace: Double?

	/// Power:Pace ratio - average HR / adjusted pace
	public var powerPaceRatio: Double?

	public var averageThrustTime: Int?

	public var maximumThrustTime: Int?

	/// Where this file is related to a multisport activity
	public var parentID: Int?

	// Stryd RSS (for run)
	public var rss: Int?

	public var hss: Int?

	public var pss: Int?

	public var water: SwimType?

	public var terrain: RunType?

	public var poolLength: Int?

	public var poolLengthUnits: UnitMeasurement?

	// average training time per lap
	public var averageLapTime: Int?

	// number of swimming laps
	public var lapCount: Int?

	// A csv list of SwimStroke ordinals
	public var strokeTypes: Int?

	public var frontTireMinimum: Int?

	public var frontTireMaximum: Int?

	public var frontTireAverage: Int?

	public var rearTireMinimum: Int?

	public var rearTireMaximum: Int?

	public var rearTireAverage: Int?

	public init() {}

	// MARK: Codable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case aerobicDec = "aerobicDec"
		case wscore
		case averagePace = "avgPace"
		case averagePacePercentage = "avgPaceP"
		case maximumPace = "maxPace"
		case maximumPacePercentage = "maxPaceP"
		case averagePaceAboveThreshold = "avgPaceAboveThres"
		case averagePaceBelowThreshold = "avgPaceBelowThres"
		case secsAbovePaceThreshold = "secsAbovePaceThres"
		case adjustedPace = "adjPace"
		case thresholdPace
		case estimatedThresholdPace = "estThresPace"
		case averageStrokeCount = "avgStrokeCount"
		case averageStrokeLength = "avgStrokeLen"
		case averageStepLength = "avgStepLen"
		case steps
		case averageFormWatts = "avgFormWatts"
		case averageFormRatio = "avgFormR"
		case averageLegSS = "avgLegSS"
		case averageLegSSKg = "avgLegSSKg"
		case averageVerticalOscillation = "avgVertOss"
		case averageVerticalOscillationRatio = "avgVertOssR"
		case averageGroundTime = "avgGroundTime"
		case averageStanceTime = "avgStanceTime"
		case averageStanceTimePercentage = "avgStanceTimeP"
		case averageStanceTimeBalance = "avgStanceTimeBal"
		case efficiencyPace = "efPace"
		case powerPaceRatio = "pwrPaceR"
		case averageThrustTime = "avgThrustTime"
		case maximumThrustTime = "maxThrustTime"
		case parentID = "parentId"
		case rss
		case hss
		case pss
		case water
		case terrain
		case poolLength = "poolLen"
		case poolLengthUnits = "poolLenUnits"
		case averageLapTime = "avgLap"
		case lapCount = "lapCnt"
		case strokeTypes
		case frontTireMinimum = "frontTireMin"
		case frontTireMaximum = "frontTireMax"
		case frontTireAverage = "frontTireAvg"
		case rearTireMinimum = "rearTireMin"
		case rearTireMaximum = "rearTireMax"
		case rearTireAverage = "rearTireAvg"
	}

	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String? = nil) -> [String] {
		mapFieldsToSearchStrings(fields: fields, prefix: prefix)
	}
}
