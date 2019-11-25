import Foundation

public struct UserWorkoutFileSearch: SearchInputCriteria {

	/// Search for a name or filename which contains this name
	public var name: String?

	/// Limit search results to activities with localities containing this text
	public var locality: String?

	/// Search for files with a start timestamp >= this value. Value is a unix timestamp in milliseconds
	public var fromTime: Milliseconds?

	/// Search for files with a start timestamp <= this value. Value is a unix timestamp in milliseconds
	public var toTime: Milliseconds?

	/// Search for activities which occurred on or are scheduled on this day of the year
	public var day: Int?

	/// Search for activities which occurred on or are scheduled in this year
	public var year: Int?

	/// Search for activities which occurred in these date ranges - use this for unix timestamps + timezone
	public var dateRanges: [DateRange]?

	/// Search for activities which occurred in these date ranges - use this for year + day of year
	public var dayRanges: [DayRange]?

	/// Search for completed activities which have attributes in the given ranges. ie all rides with a distance between 100 - 150km
	/// fieldName --> min,max
	public var ranges: [String: [Double]]?

	/// Limit the search results to activities of this workout type
	public var workout: WorkoutType?

	/// Limit the search results to activities of this equipment
	public var equipment: Equipment?

	/// Limit the search results to activities with this source type
	public var source: ResultSource?

	/// Limit the search results to activities with this review type
	public var review: ResultReview?

	/// Limit the search results to activities with this state
	public var state: UserWorkoutState?

	/// Limit the search results to activities of this workout incomplete reason
	public var reason: UserWorkoutFailedReason?

	public var reviewMask: Int?

//	/// Limit the search results to activities completed with this power meter
//	public var meter: VUserPowerMeter?
//
//	/// Limit the search results to activities completed with this headunit meter
//	public var headunit: VUserHeadunit?

	public var powerManufacturer: String?

	public var powerVersion: String?

	public var powerSerial: String?

	public var powerProduct: String?

	public var powerDisplay: String?

	/// Search for files related to the given user
	public var user: User?

	/// Search for files related to the given group
	//public var group: VUserGroupingSummary?

	/// Limit the search results to activities who have null entries for the given fields
	public var isNull: [String]?

	/// Limit the search results to activities who do not have null entries for the given fields
	public var isNotNull: [String]?

	/// Limit the search results to activities related to these userIds
	public var userIDs: [Int]?

	public var orderBy: String?

	/// Order the results according to these fields
	public var order: [Order]?

	/// Limit the search results to these activities. Set the id and type in the `Activity`.
	public var activities: [Activity]?

	/// Limit the search results to exclude activities of this workout type
	public var excludeWorkouts: [WorkoutType]?

	/// Limit the search results to activities of these sport
	public var sports: [ActivityType]?

	public var meta: [String: String]?

	public init() {}

	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case name
		case locality
		case fromTime = "fromTs"
		case toTime = "toTs"
		case day
		case year
		case dateRanges = "rangesTs"
		case dayRanges = "rangesDay"
		case ranges
		case workout
		case equipment
		case source
		case review
		case state
		case reason
		case reviewMask
		//case meter
		//case headunit
		case powerManufacturer = "pwrManufacturer"
		case powerVersion = "pwrVersion"
		case powerSerial = "pwrSerial"
		case powerProduct = "pwrProduct"
		case powerDisplay = "pwrDisplay"
		case user
		//case group
		case isNull
		case isNotNull
		case userIDs = "userIds"
		case orderBy
		case order
		case activities
		case excludeWorkouts
		case sports
		case meta
	}

}
