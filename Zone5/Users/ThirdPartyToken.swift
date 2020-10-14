import Foundation

public struct ThirdPartyToken: Codable, JSONEncodedBody {
    let serviceName: String
    let token: String
    let refreshToken: String
    let expiresIn: Double
    let scope: String
}

public struct ThirdPartyTokenResponse: Codable {
    let available: Bool
    let token: TokenResponse?
}

public struct TokenResponse: Codable {
    let token: String
    let expiresIn: Double
    let refreshToken: String
    let scope: String
}
