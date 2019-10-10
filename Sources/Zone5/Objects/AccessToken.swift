import Foundation

/// Token provided by the OAuth API that can be used to sign relevant requests as the user it represents.
public struct AccessToken: RawRepresentable, Equatable, Hashable {

	/// The string value of the token.
	public var rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

	// MARK: Signing requests

	/// Signs the given `request` by adding an "Authorization" header.
	/// - Parameter request: The request to be signed.
	func sign(request: inout URLRequest) {
		request.setValue("Bearer \(rawValue)", forHTTPHeaderField: "Authorization")
	}

}

extension AccessToken: Codable {

	private enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		rawValue = try container.decode(String.self, forKey: .accessToken)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(rawValue, forKey: .accessToken)
	}

}

extension AccessToken: CustomStringConvertible {

	public var description: String {
		return rawValue
	}

}

extension AccessToken: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "\(type(of: self))(\(rawValue))"
	}

}
