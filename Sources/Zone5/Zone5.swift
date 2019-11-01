import Foundation

final public class Zone5 {

	/// Shared instance of the Zone5 SDK
	public static let shared = Zone5()

	init() {
		httpClient.zone5 = self
	}

	// MARK: Configuring the SDK

	public private(set) var baseURL: URL?

	/// The clientID, as provided by Zone5.
	public private(set) var clientID: String?

	/// The secret key, as provided by Zone5.
	public private(set) var clientSecret: String?

	/// The secret key, as provided by Zone5.
	public var redirectURI: String = "https://localhost"

	/// Configures the SDK to use the application specified by the given `clientID` and `secret`.
	/// - Parameter baseURL: The API url to use.
	/// - Parameter clientID: The clientID, as provided by Zone5.
	/// - Parameter clientSecret: The secret key, as provided by Zone5.
	public func configure(for baseURL: URL, clientID: String, clientSecret: String) {
		self.baseURL = baseURL
		self.clientID = clientID
		self.clientSecret = clientSecret
	}

	/// Flag that indicates if the receiver has been configured correctly. If the value of this property is `false`, the
	/// `configure(for:,clientID:,clientSecret:)` method will need to be called to configure the client for access to
	/// the Zone5 API.
	public var isConfigured: Bool {
		return baseURL != nil && clientID != nil && clientSecret != nil
	}

	// MARK: Communicating with the API

	let httpClient = HTTPClient()

	public var accessToken: AccessToken?

	// MARK: Views

	public lazy var oAuth: OAuthView = {
		return OAuthView(zone5: self)
	}()

	public lazy var users: UsersView = {
		return UsersView(zone5: self)
	}()

	// MARK: Errors

	public enum Error: Swift.Error, CustomDebugStringConvertible {
		case unknown
		case invalidConfiguration
		case requiresAccessToken
		case serverError(_ message: ServerMessage)
		case failedEncodingParameters
		case failedDecodingResponse(_ underlyingError: Swift.Error)
		case transportFailure(_ underlyingError: Swift.Error)

		public struct ServerMessage: Swift.Error, Codable {

			public let message: String

		}

		public var debugDescription: String {
			switch self {
			case .unknown: return ".unknown"
			case .invalidConfiguration: return ".invalidConfiguration"
			case .requiresAccessToken: return ".requiresAccessToken"
			case .serverError(let serverMessage): return ".serverError(message: \(serverMessage.message))"
			case .failedEncodingParameters: return ".failedEncodingParameters"
			case .failedDecodingResponse(let underlyingError): return ".failedDecodingResponse(underlyingError: \(underlyingError.localizedDescription))"
			case .transportFailure(let underlyingError): return ".transportFailure(underlyingError: \(underlyingError.localizedDescription))"
			}
		}

	}

}
