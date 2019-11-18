import Foundation

public enum UserRouteOutputType: String, Codable, CustomStringConvertible {

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
