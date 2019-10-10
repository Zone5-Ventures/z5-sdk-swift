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

	// MARK: Communicating with the API

	let httpClient = HTTPClient()

	// MARK: OAuth

	public func requestToken(username: String, password: String, completion: @escaping (_ result: Result<AccessToken, Zone5.Error>) -> Void) {
		guard let clientID = clientID, let clientSecret = clientSecret else {
			return
		}

		var request = Request(endpoint: "/rest/oauth/access_token")
		request.parameters = [
			"username": username,
			"password": password,
			"client_id": clientID,
			"client_secret": clientSecret,
			"grant_type": "password",
			"redirect_uri": redirectURI,
		]

		httpClient.post(request, encoding: .url, expectedType: AccessToken.self, completion: completion)
	}

	public func user(for accessToken: AccessToken, completion: @escaping (_ result: Result<User, Zone5.Error>) -> Void) {
		var request = Request(endpoint: "/rest/users/me")
		request.accessToken = accessToken

		httpClient.get(request, expectedType: User.self, completion: completion)
	}

	// MARK: Errors

	public enum Error: Swift.Error {
		case unknown
		case invalidConfiguration
		case failedEncodingParameters
		case failedDecodingResponse(_ underlyingError: Swift.Error)
		case transportFailure(_ underlyingError: Swift.Error)
	}

}
