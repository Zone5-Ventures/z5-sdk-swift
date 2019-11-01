import Foundation

public class UsersView: APIView {

	private enum Endpoints: String, HTTPEndpoint {
		case me = "/rest/users/me"
	}

	public func me(completion: @escaping (_ result: Result<User, Zone5.Error>) -> Void) {
		perform(with: completion) { zone5 in
			var request = Request(endpoint: Endpoints.me)

			zone5.httpClient.get(request, expectedType: User.self, completion: completion)
		}
	}

}
