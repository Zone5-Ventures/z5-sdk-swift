import Foundation

/// Protocol defining the requirements for endpoints accepted when generating requests for the API.
protocol HTTPEndpoint {

	/// The string value containing the endpoint's actual URI.
	/// - Note: This value may contain tokens wrapped in braces that can be replaced at runtime with dynamic values.
	/// - SeeAlso: `HTTPEndpoint.replacingTokens(_:)`
	var uri: String { get }

	/// Optional flag to indicate if the endpoint requires signing with a user's access token.
	/// - Note: If not implemented by the conforming class, the protocol includes a default implementation that always
	/// 	indicates that the endpoint requires the user's access token (returning true).
	var requiresAccessToken: Bool { get }

}

extension HTTPEndpoint {

	/// Default implementation that always indicates that the endpoint requires the user's access token.
	var requiresAccessToken: Bool {
		return true
	}

}

/// An extension on `HTTPEndpoint` which allows it to return the `rawValue` as its `uri` when the conforming
/// implementation also conforms to `RawRepresentable`.
extension HTTPEndpoint where Self: RawRepresentable, Self.RawValue == String {

	var uri: String {
		return rawValue
	}

}
