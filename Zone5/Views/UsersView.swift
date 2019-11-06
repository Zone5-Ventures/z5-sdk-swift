import Foundation

public class UsersView: APIView {

	private enum Endpoints: String, HTTPEndpoint {
		case me = "/rest/users/me"
	}

	public func me(completion: @escaping (_ result: Result<User, Zone5.Error>) -> Void) {
		get(Endpoints.me, with: completion)
	}

}
