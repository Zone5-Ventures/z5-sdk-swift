import Foundation

public class UsersView: APIView {

	public func me(completion: @escaping (_ result: Result<User, Zone5.Error>) -> Void) {
		perform(with: completion) { zone5 in
			guard let accessToken = zone5.accessToken else {
				throw Zone5.Error.requiresAccessToken
			}

			var request = Request(endpoint: "/rest/users/me")
			request.accessToken = accessToken

			zone5.httpClient.get(request, expectedType: User.self, completion: completion)
		}
	}

}
