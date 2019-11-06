import Foundation

public class OAuthView: APIView {

	private enum Endpoints: String, HTTPEndpoint {
		case accessToken = "/rest/oauth/access_token"

		var requiresAccessToken: Bool {
			switch self {
			case .accessToken: return false
			}
		}
	}

	public func accessToken(username: String, password: String, completion: @escaping (_ result: Result<AccessToken, Zone5.Error>) -> Void) {
		let body: URLEncodedBody = [
			"username": username,
			"password": password,
			"client_id": zone5?.clientID,
			"client_secret": zone5?.clientSecret,
			"grant_type": "password",
			"redirect_uri": zone5?.redirectURI,
		]

		post(Endpoints.accessToken, body: body, expectedType: AccessToken.self) { [weak self] result in
			defer { completion(result) }

			if let zone5 = self?.zone5, case .success(let accessToken) = result {
				zone5.accessToken = accessToken
			}
		}
	}

}
