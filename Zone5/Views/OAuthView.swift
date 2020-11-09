import Foundation

public class OAuthView: APIView {

	private enum Endpoints: String, RequestEndpoint {
		case accessToken = "/rest/oauth/access_token"

		var requiresAccessToken: Bool {
			switch self {
			case .accessToken: return false
			}
		}
	}

	/// Perform user authentication with the given `username` and `password`.
	///
	/// This method requires that the SDK has been configured with a valid `clientID` and `clientSecret`, using
	/// `Zone5.configure(baseURL:clientID:clientSecret)`. If this has not been done, the method will call the completion
	/// with `Zone5.Error.invalidConfiguration`.
	/// - Parameters:
	///   - username: The user's username.
	///   - password: The user's password.
	///   - completion: Handler called the authentication completes. If successful, the result will contain an access
	///   	token that can be stored and used to authenticate the user in future sessions, and otherwise will contain a
	///   	`Zone5.Error` value which represents the problem that occurred.
	public func accessToken(username: String, password: String, completion: @escaping (_ result: Result<OAuthToken, Zone5.Error>) -> Void) {
		guard let zone5 = zone5, zone5.isConfigured else {
			completion(.failure(.invalidConfiguration))

			return
		}

		let body: URLEncodedBody = [
			"username": username,
			"password": password,
			"client_id": zone5.clientID,
			"client_secret": zone5.clientSecret,
			"grant_type": "password",
			"redirect_uri": zone5.redirectURI,
		]

		_ = post(Endpoints.accessToken, body: body, expectedType: OAuthToken.self) { [weak self] result in
			defer { completion(result) }

			if let zone5 = self?.zone5, case .success(let token) = result {
				zone5.accessToken = token
			}
		}
	}
	
	/// Refresh the token that is already configured on the Zone5 entity
	/// This method requires that the SDK has been configured with a valid `clientID` and `clientSecret` and `token`, using
	/// `Zone5.configure(baseURL:clientID:clientSecret)`. If this has not been done, the method will call the completion
	/// with `Zone5.Error.invalidConfiguration`.
	/// - Parameters:
	/// 	- username: The user's username.
	///		- completion: Handler called the authentication completes. If successful, the result will contain an access
	///   	token that can be stored and used to authenticate the user in future sessions, and otherwise will contain a
	///   	`Zone5.Error` value which represents the problem that occurred.
	public func refreshAccessToken(username: String, completion: @escaping (_ result: Result<OAuthToken, Zone5.Error>) -> Void) {
		guard let zone5 = zone5, zone5.isConfigured, let token = zone5.accessToken as? OAuthToken, let refresh = token.refreshToken else {
			completion(.failure(.invalidConfiguration))

			return
		}
		
		return refreshAccessToken(username: username, refreshToken: refresh, completion: completion)
	}
	
	/// This method requires that the SDK has been configured with a valid `clientID` and `clientSecret`, using
	/// `Zone5.configure(baseURL:clientID:clientSecret)`. If this has not been done, the method will call the completion
	/// with `Zone5.Error.invalidConfiguration`.
	///
	/// Refresh the token with the given refresh token.
	/// - Parameters:
	/// 	- username: The user's username.
	/// 	- refreshToken: refresh token to use
	///		- completion: Handler called the authentication completes. If successful, the result will contain an access
	///   	token that can be stored and used to authenticate the user in future sessions, and otherwise will contain a
	///   	`Zone5.Error` value which represents the problem that occurred.
	public func refreshAccessToken(username: String, refreshToken: String, completion: @escaping (_ result: Result<OAuthToken, Zone5.Error>) -> Void) {
		guard let zone5 = zone5, zone5.isConfigured else {
			completion(.failure(.invalidConfiguration))

			return
		}

		let body: URLEncodedBody = [
			"username": username,
			"refresh_token": refreshToken,
			"client_id": zone5.clientID,
			"client_secret": zone5.clientSecret,
			"grant_type": "refresh_token"
		]

		_ = post(Endpoints.accessToken, body: body, expectedType: OAuthToken.self) { [weak self] result in
			defer { completion(result) }

			if let zone5 = self?.zone5, case .success(let token) = result {
				zone5.accessToken = token
			}
		}
	}

}
