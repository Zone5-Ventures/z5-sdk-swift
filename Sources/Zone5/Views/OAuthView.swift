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
		perform(with: completion) { zone5 in
			guard let clientID = zone5.clientID, let clientSecret = zone5.clientSecret else {
				throw Zone5.Error.invalidConfiguration
			}

			var request = Request(endpoint: Endpoints.accessToken)
			request.parameters = [
				"username": username,
				"password": password,
				"client_id": clientID,
				"client_secret": clientSecret,
				"grant_type": "password",
				"redirect_uri": zone5.redirectURI,
			]

			zone5.httpClient.post(request, encoding: .url, expectedType: AccessToken.self) { result in
				defer { completion(result) }

				guard case .success(let accessToken) = result else {
					return
				}

				zone5.accessToken = accessToken
			}
		}
	}

}
