import Foundation

public struct UserWorkoutSearch: Encodable {

	/// Search for a name or filename which contains this name
	public var name: String?

	/// Limit search results to activities with localities containing this text
	public var locality: String?

	/// Search for files with a start timestamp >= this value. Value is a unix timestamp in milliseconds
	public var fromTs: Int?

	/// Search for files with a start timestamp <= this value. Value is a unix timestamp in milliseconds
	public var toTs: Int?

	/// Search for activities which occurred on or are scheduled on this day of the year
	public var day: Int?

	/// Search for activities which occurred on or are scheduled in this year
	public var year: Int?

	/// Search for activities which occurred in these date ranges - use this for unix timestamps + timezone
	public var rangesTs: [DateRange]?

	/// Search for activities which occurred in these date ranges - use this for year + day of year
	public var rangesDay: [DayRange]?

	// fieldName --> min,max
	/// Search for completed activities which have attributes in the given ranges. ie all rides with a distance between 100 - 150km
	public var ranges: [String: [Double]]?

	/// Limit the search results to activities of this workout type
	public var workout: WorkoutType?

//	/// Limit the search results to activities of this equipment
//	public var equipment: Equipment?
//
//	/// Limit the search results to activities with this source type
//	public var source: ResultSource?
//
//	/// Limit the search results to activities with this review type
//	public var review: ResultReview?
//
//	/// Limit the search results to activities with this state
//	public var state: UserWorkoutState?
//
//	/// Limit the search results to activities of this workout incomplete reason
//	public var reason: UserWorkoutFailedReason?

	public var reviewMask: Int?

//	/// Limit the search results to activities completed with this power meter
//	public var meter: VUserPowerMeter?
//
//	/// Limit the search results to activities completed with this headunit meter
//	public var headunit: VUserHeadunit?

	public var pwrManufacturer: String?

	public var pwrVersion: String?

	public var pwrSerial: String?

	public var pwrProduct: String?

	public var pwrDisplay: String?

	/// Search for files related to the given user
	public var user: User?

	/// Search for files related to the given group
	//public var group: VUserGroupingSummary?

	/// Limit the search results to activities who have null entries for the given fields
	public var isNull: [String]?

	/// Limit the search results to activities who do not have null entries for the given fields
	public var isNotNull: [String]?

	/// Limit the search results to activities related to these userIds
	public var userIds: [Int]?

	public var orderBy: String?

	/// Order the results according to these fields
	public var order: [Order]?

	/// Limit the search results to these activities. Set the id and type in the `Activity`.
	public var activities: [Activity]?

	/// Limit the search results to exclude activities of this workout type
	public var excludeWorkouts: [WorkoutType]?

	/// Limit the search results to activities of these sport
	public var sports: [Activity.Sport]?

	public var meta: [String: String]?

	public init() {}

}
