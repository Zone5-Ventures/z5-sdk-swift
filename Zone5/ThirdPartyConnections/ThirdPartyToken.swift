import Foundation

public struct ThirdPartyToken: Codable, JSONEncodedBody {
    public let token: String
	public var expiresIn: Int?
	public var refreshToken: String?
	public var scope: String?
	
	public init(token: String, expiresIn: Int? = nil, refreshToken: String? = nil, scope: String? = nil) {
		self.token = token
		self.expiresIn = expiresIn;
		self.refreshToken = refreshToken
		self.scope = scope
	}
	
	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case token
		case expiresIn = "expires_in"
		case refreshToken = "refresh_token"
		case scope
	}
}
