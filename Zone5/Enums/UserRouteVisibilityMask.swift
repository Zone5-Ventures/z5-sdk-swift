import Foundation

/// A representation of who is able to access details of the associated route.
public enum UserRouteVisibilityMask: String, Codable {

	/// This route is visible to any one in the route's company
	case company

	/// This route is visible to any of my friends
	case friends

	/// This route is visible to everyone
	case any

}
