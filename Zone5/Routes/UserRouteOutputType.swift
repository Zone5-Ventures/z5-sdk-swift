import Foundation

/// The file format that should be expected when creating a route from an uploaded file.
/// - Note: This is not really used outside of the `RoutesView` at this stage, and so is internal.
internal enum UserRouteOutputType: String, Codable, CustomStringConvertible {

	/// Stages L10 route format
	case sro

	/// Standard GPX output
	case gpx

	/// Stages L10 route files
	case tiles

	/// Standard FIT output
	case fit

	/// A FIT variant used for Stages Dash 2
	case dashfit

	/// Protobufs version of routes
	case pb

	/// Static map
	case png

	/// Web UI js format for saving a route
	case js

	public var description: String {
		return rawValue
	}

}
