import Foundation

/// This is derived from the original VTeamMultiRidePeriod impl - it is used on aggregate reporting focused endpoints
public struct SearchInputReport: JSONEncodedBody, SearchInputCriteria {

	public var type: ActivityType?

	public var isAllTime: Bool?

	// /// Percentages - ie for use with days since last peak within X%
	// public var withinPercentages: [Int]?

	// public var period: AggregatePeriod?

	// public var depth: Int?

	public var userIDs: [Int]?

	// public var groupID: Int?

	public var ranges: [DateRange]?

	// public var teamActivities: [VTeamActivity]?

	public var activities: [Activity]?

	/// Only include results related to these activities
	public var limit: [Activity]?

	// public var groupBy: String?

	// public var exclude: VTeamMultiRidePeriod?

	// public var flag1: Bool?

	// public var flag2: Bool?

	// public var flag3: Bool?

	// public var extName: Bool?

	// public var noCache: Bool?

	// public var returnIDs: Bool?

	/// Flag that indicates if the search is inclusive (true) or exclusive (false).
	public var isInclusive: Bool?

	public var range: DateRange?

	private var opts: Int?

	/// Option to include zones - defaults to true and used in power curve
	public var shouldIncludeZones: Bool?

	public var references: [RelativePeriod]?

	/// Simple field list
	public var simpleFields: [String]?

	public var isNotNull: [String]?

	public var isNull: [String]?

	public var order: [Order]?

	// public var tags: Set<String>?

	public init() {
		opts = 3
		// search.opts = search.opts | (1 << 0); // set that we don't need the verbose field mapping
		// search.opts = search.opts | (1 << 1); // set a no-cache flag for this search
		// search.opts = search.opts | (1 << 3); // set a no-decorate flag for this search
	}

	// MARK: Creating reports

	/// Return a `SearchInputReport` which can be used for reporting endpoints, i.e. time in zone for a given activity.
	/// - Parameters:
	///   - activityType: The type of the activity we want a report on.
	///   - identifier: The id of the activity we want a report on.
	public static func forInstance(activityType: ActivityResultType, identifier: Int) -> SearchInputReport {
		var report = self.init()
		report.opts = 3
		report.activities = [Activity(id: identifier, activity: activityType, type: nil)]
		return report
    }

	/// Return a `SearchInputReport` which can be used for peak curve reporting endpoints.
	/// - Parameters:
	///   - activityType: The type of the activity we want a report on.
	///   - identifier: The id of the activity we want a report on.
	///   - referencePeriod: The comparison period to be included.
	public static func forInstancePeaksCurve(activityType: ActivityResultType, identifier: Int, referencePeriod: RelativePeriod?) -> SearchInputReport {
		var report = forInstance(activityType: activityType, identifier: identifier)

		if let referencePeriod = referencePeriod {
			report.references = [referencePeriod]
			report.isAllTime = true
		}

		return report
	}

	public static func forInstanceMetrics(sport: ActivityType, userIDs: [Int], ranges: [DateRange], fields: [String]) -> SearchInput<SearchInputReport> {
		precondition(!userIDs.isEmpty, "At least one user ID must be set.")
		precondition(!fields.isEmpty, "At least one field must be set.")

		var ranges = ranges
		if ranges.isEmpty {
			ranges.append(DateRange(floor: Date(timeIntervalSince1970: 0), ceiling: Date()))
		}

		var report = self.init()
		report.userIDs = userIDs
		report.ranges = ranges
		report.type = sport

		var input = SearchInput(criteria: report)
		input.fields = fields

		return input
	}

	// MARK: Codable

	enum Field: String, Codable, CodingKey {
		case type
		case isAllTime = "alltime"
		//case withinPercentages = "withinP"
		//case period
		//case depth
		case userIDs = "userIds"
		//case groupID = "groupId"
		case ranges
		//case teamActivities = "teamactivities"
		case activities
		case limit
		//case groupBy
		//case exclude
		//case flag1
		//case flag2
		//case flag3
		//case extName
		//case noCache
		//case returnIDs = "returnIds"
		case isInclusive = "in"
		case range
		case opts
		case shouldIncludeZones = "incZones"
		case references
		case simpleFields = "sfields"
		case isNotNull
		case isNull
		case order
		//case tags
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Field.self)
		type = try container.decodeIfPresent(ActivityType.self, forKey: .type)
		isAllTime = try container.decodeIfPresent(Bool.self, forKey: .isAllTime)
		//withinPercentages = try container.decodeIfPresent([Int].self, forKey: .withinPercentages)
		//period = try container.decodeIfPresent(AggregatePeriod.self, forKey: .period)
		//depth = try container.decodeIfPresent(Int.self, forKey: .depth)
		userIDs = try container.decodeIfPresent([Int].self, forKey: .userIDs)
		//groupID = try container.decodeIfPresent(Int.self, forKey: .groupID)
		ranges = try container.decodeIfPresent([DateRange].self, forKey: .ranges)
		//teamActivities = try container.decodeIfPresent([VTeamActivity].self, forKey: .teamActivities)
		activities = try container.decodeIfPresent([Activity].self, forKey: .activities)
		limit = try container.decodeIfPresent([Activity].self, forKey: .limit)
		//groupBy = try container.decodeIfPresent(String.self, forKey: .groupBy)
		//exclude = try container.decodeIfPresent(VTeamMultiRidePeriod.self, forKey: .exclude)
		//flag1 = try container.decodeIfPresent(Bool.self, forKey: .flag1)
		//flag2 = try container.decodeIfPresent(Bool.self, forKey: .flag2)
		//flag3 = try container.decodeIfPresent(Bool.self, forKey: .flag3)
		//extName = try container.decodeIfPresent(Bool.self, forKey: .extName)
		//noCache = try container.decodeIfPresent(Bool.self, forKey: .noCache)
		//returnIDs = try container.decodeIfPresent(Bool.self, forKey: .returnIDs)
		isInclusive = try container.decodeIfPresent(Bool.self, forKey: .isInclusive)
		range = try container.decodeIfPresent(DateRange.self, forKey: .range)
		opts = try container.decodeIfPresent(Int.self, forKey: .opts)
		shouldIncludeZones = try container.decodeIfPresent(Bool.self, forKey: .shouldIncludeZones)
		references = try container.decodeIfPresent([RelativePeriod].self, forKey: .references)
		simpleFields = try container.decodeIfPresent([String].self, forKey: .simpleFields)
		isNotNull = try container.decodeIfPresent([String].self, forKey: .isNotNull)
		isNull = try container.decodeIfPresent([String].self, forKey: .isNull)
		order = try container.decodeIfPresent([Order].self, forKey: .order)
		//tags = try container.decodeIfPresent(Set<String>.self, forKey: .tags)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: Field.self)
		try container.encodeIfPresent(type, forKey: .type)
		try container.encodeIfPresent(isAllTime, forKey: .isAllTime)
		//try container.encodeIfPresent(withinPercentages, forKey: .withinPercentages)
		//try container.encodeIfPresent(period, forKey: .period)
		//try container.encodeIfPresent(depth, forKey: .depth)
		try container.encodeIfPresent(userIDs, forKey: .userIDs)
		//try container.encodeIfPresent(groupID, forKey: .groupID)
		try container.encodeIfPresent(ranges, forKey: .ranges)
		//try container.encodeIfPresent(teamActivities, forKey: .teamActivities)
		try container.encodeIfPresent(activities, forKey: .activities)
		try container.encodeIfPresent(limit, forKey: .limit)
		//try container.encodeIfPresent(groupBy, forKey: .groupBy)
		//try container.encodeIfPresent(exclude, forKey: .exclude)
		//try container.encodeIfPresent(flag1, forKey: .flag1)
		//try container.encodeIfPresent(flag2, forKey: .flag2)
		//try container.encodeIfPresent(flag3, forKey: .flag3)
		//try container.encodeIfPresent(extName, forKey: .extName)
		//try container.encodeIfPresent(noCache, forKey: .noCache)
		//try container.encodeIfPresent(returnIDs, forKey: .returnIDs)
		try container.encodeIfPresent(isInclusive, forKey: .isInclusive)
		try container.encodeIfPresent(range, forKey: .range)
		try container.encodeIfPresent(opts, forKey: .opts)
		try container.encodeIfPresent(shouldIncludeZones, forKey: .shouldIncludeZones)
		try container.encodeIfPresent(references, forKey: .references)
		try container.encodeIfPresent(simpleFields, forKey: .simpleFields)
		try container.encodeIfPresent(isNotNull, forKey: .isNotNull)
		try container.encodeIfPresent(isNull, forKey: .isNull)
		try container.encodeIfPresent(order, forKey: .order)
		//try container.encodeIfPresent(tags, forKey: .tags)
	}

	
}
