//
//  UserAgentView.swift
//  Zone5
//
//  Created by Jean Hall on 7/12/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public class UserAgentView: APIView {
	private enum Endpoints: String, RequestEndpoint {
		case getDeprecated = "/rest/users/scheduled/activities/api/v1/deprecated"
	}
	
	/// Query whether the version of the current user agent (client app) has been deprecated and requires an upgrade.
	@discardableResult
	public func getDeprecated(completion: @escaping Zone5.ResultHandler<UpgradeAvailableResponse>) -> PendingRequest? {
		return get(Endpoints.getDeprecated, with: completion)
	}
}
