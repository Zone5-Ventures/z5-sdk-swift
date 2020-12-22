import Foundation

/// Protocol defining internal endpoints accepted when generating requests for the API.
/// These endpoints contain relative uris and need to be wrapped by a RequestEndpoint to add server baseURL
public protocol InternalRequestEndpoint {

	/// The string value containing the endpoint's actual URI.
	/// - Note: This value may contain tokens wrapped in braces that can be replaced at runtime with dynamic values.
	/// - SeeAlso: `HTTPEndpoint.replacingTokens(_:)`
	var uri: String { get }

	/// Optional flag to indicate if the endpoint requires signing with a user's access token.
	/// - Note: If not implemented by the conforming class, the protocol includes a default implementation that always
	/// 	indicates that the endpoint requires the user's access token (returning true).
	var requiresAccessToken: Bool { get }

}

/// Protocol defining server endpoints with a url
public protocol RequestEndpoint: InternalRequestEndpoint {
	/// Converts the uri to a URL, this may include, for example, adding a baseURL
	var url: URL? { get }
}

public extension RequestEndpoint {
	/// Default implementation assumes the uri is a well formed URL
	/// Override this func to apply additional logic such as adding a baseURL
	var url: URL? {
		return URL(string: uri)
	}
}

public extension InternalRequestEndpoint {

	/// Default implementation that always indicates that the endpoint requires the user's access token.
	var requiresAccessToken: Bool {
		return true
	}
}

internal extension InternalRequestEndpoint {
	/// Returns a detokenized version of the endpoint.
	///
	/// Tokens in the `endpoint` URI are replaced with a value from the dictionary where the key matches occurrences of
	/// the same string found within the URI, wrapped in braces. For example, given an endpoint with the uri
	/// `/example/with/{token}`, and a `replacements` dictionary `["token": "the-ultimate-value"]` will result in a
	/// detokenized endpoint with the URI `/example/with/the-ultimate-value`.
	///
	/// - Parameter replacements: A dictionary that maps string-convertible values to the appropriate token names.
	func replacingTokens(_ replacements: [String: CustomStringConvertible]) -> InternalRequestEndpoint {
		return DetokenizedRequestEndpoint(self, replacements: replacements)
	}

}

/// An extension on `InternalRequestEndpoint` which allows it to return the `rawValue` as its `uri` when the conforming
/// implementation also conforms to `RawRepresentable`.
public extension InternalRequestEndpoint where Self: RawRepresentable, Self.RawValue == String {

	var uri: String {
		return rawValue
	}

}

/// A concrete endpoint implementation that takes another endpoint containing "tokens" (parts of the uri that can be
/// replaced with useful values, wrapped in braces, e.g. `/uri/containing/a/{token}`), which are then replaced with
/// given values, based on a dictionary of keys that match the token names.
private struct DetokenizedRequestEndpoint: InternalRequestEndpoint {

	/// Storage for the detokenized URI.
	let uri: String
	let requiresAccess: Bool

	/// Creates a detokenized endpoint.
	///
	/// Tokens in the `endpoint` URI are replaced with a value from the dictionary where the key matches occurrences of
	/// the same string found within the URI, wrapped in braces. For example, given an endpoint with the uri
	/// `/example/with/{token}`, and a `replacements` dictionary `["token": "the-ultimate-value"]` will result in a
	/// detokenized endpoint with the URI `/example/with/the-ultimate-value`.
	///
	/// - Parameter endpoint: The endpoint to be used as a basis.
	/// - Parameter replacements: A dictionary that maps string-convertible values to the appropriate token names.
	/// - SeeAlso: `RequestEndpoint.replacingTokens(_:)`
	init(_ endpoint: InternalRequestEndpoint, replacements: [String: CustomStringConvertible]) {
		var uri = endpoint.uri

		for (token, value) in replacements {
			uri = uri.replacingOccurrences(of: "{\(token)}", with: value.description)
		}

		self.uri = uri
		self.requiresAccess = endpoint.requiresAccessToken
	}
	
	var requiresAccessToken: Bool { return requiresAccess }

}

/// Turn an internally defined InternalRequestEndpoint with a String uri into a public RequestEndpoint with a URL
internal struct Zone5RequestEndpoint: RequestEndpoint {
	let uri: String
	var requiresAccessToken: Bool { return endpoint.requiresAccessToken }
	
	let endpoint: InternalRequestEndpoint
	
	init(_ endpoint: InternalRequestEndpoint, with zone5: Zone5) throws {
		guard let baseURL = zone5.baseURL else {
			throw Zone5.Error.invalidConfiguration
		}
		
		self.endpoint = endpoint
		
		// turn the uri into a well formed url
		self.uri = baseURL.appendingPathComponent(endpoint.uri).absoluteString
	}
}
