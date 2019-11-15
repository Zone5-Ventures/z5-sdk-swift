import Foundation

/// A Search criteria for user routes.
public struct UserRouteSearch: SearchInputCriteria {

	/// Field name to a numeric range. ie minAlt: [1000,1500] - used to search a range for numeric fields
	public var ranges: [String: [Double]]?

	/// Route attributes to search on
	public var route: UserRoute?

	/// User Ids to search on
	public var userIds: [Int]?

	/// Order by fields ascending/descending
	public var orderBy: [Order]?

	/// Specific UserRoute id's to include in the query
	public var ids: [Int]?

	/// Geobound the search - use in conjunction of the route.lat1, route.lon1 etc (meters)
	public var radius: Int?

	public init() {}

}
