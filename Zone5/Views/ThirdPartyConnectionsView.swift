//
//  ThirdPartyConnectionsView.swift
//  Zone5
//
//  Created by John Covele on Oct 14, 2020.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public class ThirdPartyConnectionsView: APIView {
	private enum Endpoints: String, RequestEndpoint {
		case registerDevice = "/push_registrations";
		case deregisterDevice = "/push_registrations/{token}";
		case getDeprecated = "/rest/users/scheduled/activities/api/v1/deprecated";
		case setThirdPartyConnection = "/rest/users/connections/api/v1/live_activities/set_third_party_token";
		case hasThirdPartyConnection = "/rest/users/connections/api/v1/live_activities/has_third_party_token";
		case removeThirdPartyConnection = "/rest/users/connections/api/v1/live_activities/delete_third_party_token";
	}

	///Register a device with a 3rd party such as Strava
	///- Parameters:
	/// - token: 3rd party access token
	/// - platform:
	/// - deviceId: ID of device being registered
	public func registerDeviceWithThirdParty(registration: PushRegistration, completion: @escaping Zone5.ResultHandler<Int64>) -> PendingRequest? {
		return post(Endpoints.registerDevice, body: registration, with: completion)
	}
	
	///Deregister a device with a 3rd party such as Strava
	///- Parameters:
	/// - token: 3rd party access token
	public func deregisterDeviceWithThirdParty(token: String, completion: @escaping Zone5.ResultHandler<VoidReply>) -> PendingRequest? {
		let endpoint = Endpoints.deregisterDevice.replacingTokens(["token": token])
		return delete(endpoint, body: nil, with: completion)
	}

	///Query whether an upgrade is available for the current user agent (client app).
	public func getDeprecated(completion: @escaping Zone5.ResultHandler<Bool>) -> PendingRequest? {
		return get(Endpoints.getDeprecated, with: completion)
	}

	public func setThirdPartyToken(type: UserConnectionsType, connection: ThirdPartyToken, completion: @escaping Zone5.ResultHandler<ThirdPartyTokenResponse>) -> PendingRequest? {
		return post(Endpoints.setThirdPartyConnection, body: connection, with: completion)
	}

	public func hasThirdPartyToken(type: UserConnectionsType, completion: @escaping Zone5.ResultHandler<ThirdPartyTokenResponse>) -> PendingRequest? {
		return get(Endpoints.hasThirdPartyConnection, with: completion)
	}

	public func removeThirdPartyToken(type: UserConnectionsType, completion: @escaping Zone5.ResultHandler<ThirdPartyTokenResponse>) -> PendingRequest? {
		return post(Endpoints.removeThirdPartyConnection, body: nil, with: completion)
	}
}
