import Foundation

/// Protocol defining the requirements for endpoints accepted when generating requests for the API.
protocol RequestEndpoint {

	/// The string value containing the endpoint's actual URI.
	/// - Note: This value may contain tokens wrapped in braces that can be replaced at runtime with dynamic values.
	/// - SeeAlso: `HTTPEndpoint.replacingTokens(_:)`
	var uri: String { get }

	/// Optional flag to indicate if the endpoint requires signing with a user's access token.
	/// - Note: If not implemented by the conforming class, the protocol includes a default implementation that always
	/// 	indicates that the endpoint requires the user's access token (returning true).
	var requiresAccessToken: Bool { get }

}

extension RequestEndpoint {

	/// Default implementation that always indicates that the endpoint requires the user's access token.
	var requiresAccessToken: Bool {
		return true
	}

	/// Returns a detokenized version of the endpoint.
	///
	/// Tokens in the `endpoint` URI are replaced with a value from the dictionary where the key matches occurrences of
	/// the same string found within the URI, wrapped in braces. For example, given an endpoint with the uri
	/// `/example/with/{token}`, and a `replacements` dictionary `["token": "the-ultimate-value"]` will result in a
	/// detokenized endpoint with the URI `/example/with/the-ultimate-value`.
	///
	/// - Parameter replacements: A dictionary that maps string-convertible values to the appropriate token names.
	func replacingTokens(_ replacements: [String: CustomStringConvertible]) -> RequestEndpoint {
		return DetokenizedHTTPEndpoint(self, replacements: replacements)
	}

}

/// An extension on `HTTPEndpoint` which allows it to return the `rawValue` as its `uri` when the conforming
/// implementation also conforms to `RawRepresentable`.
extension RequestEndpoint where Self: RawRepresentable, Self.RawValue == String {

	var uri: String {
		return rawValue
	}

}

/// A concrete endpoint implementation that takes another endpoint containing "tokens" (parts of the uri that can be
/// replaced with useful values, wrapped in braces, e.g. `/uri/containing/a/{token}`), which are then replaced with
/// given values, based on a dictionary of keys that match the token names.
private struct DetokenizedHTTPEndpoint: RequestEndpoint {

	/// Storage for the detokenized URI.
	let uri: String

	/// Creates a detokenized endpoint.
	///
	/// Tokens in the `endpoint` URI are replaced with a value from the dictionary where the key matches occurrences of
	/// the same string found within the URI, wrapped in braces. For example, given an endpoint with the uri
	/// `/example/with/{token}`, and a `replacements` dictionary `["token": "the-ultimate-value"]` will result in a
	/// detokenized endpoint with the URI `/example/with/the-ultimate-value`.
	///
	/// - Parameter endpoint: The endpoint to be used as a basis.
	/// - Parameter replacements: A dictionary that maps string-convertible values to the appropriate token names.
	/// - SeeAlso: `HTTPEndpoint.replacingTokens(_:)`
	init(_ endpoint: RequestEndpoint, replacements: [String: CustomStringConvertible]) {
		var uri = endpoint.uri

		for (token, value) in replacements {
			uri = uri.replacingOccurrences(of: "{\(token)}", with: value.description)
		}

		self.uri = uri
	}

}
