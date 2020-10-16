import Foundation

public struct ThirdPartyToken: Codable, JSONEncodedBody {
    var serviceName: String?
	var token: String?
	var refreshToken: String?
	var expiresIn: Double?
	var scope: String?
}

public struct ThirdPartyTokenResponse: Codable {
	var available: Bool?
	var token: TokenResponse?
}

public struct TokenResponse: Codable {
	var token: String?
	var expiresIn: Double?
	var refreshToken: String?
	var scope: String?
}
