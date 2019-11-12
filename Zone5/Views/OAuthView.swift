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
	public func accessToken(username: String, password: String, completion: @escaping (_ result: Result<AccessToken, Zone5.Error>) -> Void) {
		guard let zone5 = zone5, let clientID = zone5.clientID, let clientSecret = zone5.clientSecret else {
			completion(.failure(.invalidConfiguration))

			return
		}

		let body: URLEncodedBody = [
			"username": username,
			"password": password,
			"client_id": clientID,
			"client_secret": clientSecret,
			"grant_type": "password",
			"redirect_uri": zone5.redirectURI,
		]

		post(Endpoints.accessToken, body: body, expectedType: AccessToken.self) { [weak self] result in
			defer { completion(result) }

			if let zone5 = self?.zone5, case .success(let accessToken) = result {
				zone5.accessToken = accessToken
			}
		}
	}

}
