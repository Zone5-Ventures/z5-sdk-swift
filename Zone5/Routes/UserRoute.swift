import Foundation

public struct UserRoute: Codable {

	public var id: Int?

	/// When this object was first created
	public var createdTime: Int?

	/// When this object was last modified
	public var modifedTime: Int?

	/// Who created this object
	public var createdBy: String?

	/// Who last modified this object
	public var modifedBy: String?

	/// Who owns this object
	public var user: User?

	// public var company: VCompany?

	/// The number of times this route should be completed
	public var rpt: Int?

	/// A nice name for this route
	public var name: String?

	/// The origin of how this route came into the system. ie created manually, cloned from an activity, synced from Strava etc
	public var source: String?

	/// The original UUID/id of this route in it's origin system
	public var sourceId: String?

	/// The locality of where this route begins
	public var locality: String?

	/// The mid locality of this route
	public var locality1: String?

	/// The locality of where this route ends
	public var locality2: String?

	/// The language that the way point messages are in
	public var locale: String?

	/// The metric/imperial that the way point messages are in
	public var units: UnitMeasurement?

	/// A description of this route
	public var descr: String?

	/// The total distance (meters) of this route
	public var distance: Double?

	/// The total elevation gain (meters) of this route
	public var ascent: Int?

	/// The total elevation loss (meters) of this route
	public var descent: Int?

	/// The estimated time for this route (seconds)
	public var duration: Int?

	/// The lowest altitude point in this route (meters)
	public var minAlt: Int?

	/// The highest altitude point in this route (meters)
	public var maxAlt: Int?

	/// The average altitude point in this route (meters)
	public var avgAlt: Int?

	/// Min latitude in this route - for geo boxing
	public var minLatitude: Int?

	/// Min longitude in this route - for geo boxing
	public var minIntitude: Int?

	/// Max latitude in this route - for geo boxing
	public var maxLatitude: Int?

	/// Max longitude in this route - for geo boxing
	public var maxIntitude: Int?

	/// The sport type for this route - ie cycling, running etc
	public var type: ActivityType?

	/// The recommended cycling equipment for this route - ie TT, road, mtb etc
	public var equipment: Set<Equipment>?

	/// User type of terrain in this route
	public var terrain: Set<Terrain>?

	/// User defined tags for this route
	public var tags: Set<String>?

	///// Use for tracking favorite etc
	//public var mask: Int?

	/// A bitmask used for tracking visibility / sharing of this route - see UserRouteVisibilityMask
	public var vmask: Int?

	/// Permissions which the current user has scope to on this object
	public var permissions: Set<DataAccessRequest>?

	/// The processing state - used when a route is imported or cloned from another source
	public var state: FileUploadState?

	/// Any processing / import error message (if any)
	public var message: String?

	/// Start location
	public var lat1: Double?
	public var lon1: Double?

	/// End location
	public var lat2: Double?
	public var lon2: Double?

	/// My rating of this route (if any)
	public var rating: Int?

	/// The overall rating of this route (if any)
	public var publicRating: Int?

	/// The number of public ratings (if any)
	public var publicRatingCnt: Int?

	public var uuid: String?

	public init() {}

}
