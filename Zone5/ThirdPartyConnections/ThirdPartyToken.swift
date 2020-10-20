import Foundation

public struct ThirdPartyToken: Codable, JSONEncodedBody {
    let token: String
	var expiresIn: Int?
	var refreshToken: String?
	var scope: String?
	
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
