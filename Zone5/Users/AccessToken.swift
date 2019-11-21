import Foundation

/// Token provided by the OAuth API that can be used to sign relevant requests as the user it represents.
public struct AccessToken: RawRepresentable, Equatable, Hashable {

	/// The string value of the token.
	public var rawValue: String

	public init(rawValue: String) {
		self.rawValue = rawValue
	}

}

extension AccessToken: Decodable {

	private enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		rawValue = try container.decode(String.self, forKey: .accessToken)
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
