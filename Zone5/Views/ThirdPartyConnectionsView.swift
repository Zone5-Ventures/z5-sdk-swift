//
//  ThirdPartyConnectionsView.swift
//  Zone5
//
//  Created by John Covele on Oct 14, 2020.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public class ThirdPartyConnectionsView: APIView {
	private enum Endpoints: String, InternalRequestEndpoint {
		case setThirdPartyConnection = "/rest/users/connections/api/v1/live_activities/set_third_party_token"
		case hasThirdPartyConnection = "/rest/users/connections/api/v1/live_activities/has_third_party_token"
		case removeThirdPartyConnection = "/rest/users/connections/api/v1/live_activities/delete_third_party_token"
		case registerDeviceWithThirdParty = "/rest/users/scheduled/activities/api/v1/push_registrations"
		case deregisterDeviceWithThirdParty = "/rest/users/scheduled/activities/api/v1/push_registrations/{token}"
	}
	
	private let serviceKey: String = "service_name"
	internal func queryParams(_ serviceType: UserConnectionType) -> URLEncodedBody {
		let queryParams: URLEncodedBody = [ serviceKey : "\(serviceType)" ]
		return queryParams
	}

	/// Register a push token for a device with a 3rd party
	///- Parameters:
	/// - PushRegistration (token, platform, deviceId): Push registration for a device with a third party
	@discardableResult
	public func registerDeviceWithThirdParty(registration: PushRegistration, completion: @escaping Zone5.ResultHandler<PushRegistrationResponse>) -> PendingRequest? {
		return post(Endpoints.registerDeviceWithThirdParty, body: registration, with: completion)
	}
	
	/// Deregister a push token for a device with a 3rd party
	/// - Parameters:
	/// - token: 3rd party push token to deregister
	@discardableResult
	public func deregisterDeviceWithThirdParty(token: String, completion: @escaping Zone5.ResultHandler<Zone5.VoidReply>) -> PendingRequest? {
		let endpoint = Endpoints.deregisterDeviceWithThirdParty.replacingTokens(["token": token])
		return delete(endpoint, with: completion)
	}

	/// Set an access token for the current user for the given 3rd party type
	/// - Parameters
	
	@discardableResult
	public func setThirdPartyToken(type: UserConnectionType, connection: ThirdPartyToken, completion: @escaping Zone5.ResultHandler<ThirdPartyResponse>) -> PendingRequest? {
		return post(Endpoints.setThirdPartyConnection, parameters: queryParams(type), body: connection, with: completion)
	}

	@discardableResult
	public func hasThirdPartyToken(type: UserConnectionType, completion: @escaping Zone5.ResultHandler<ThirdPartyTokenResponse>) -> PendingRequest? {
		return get(Endpoints.hasThirdPartyConnection, parameters: queryParams(type), with: completion)
	}

	@discardableResult
	public func removeThirdPartyToken(type: UserConnectionType, completion: @escaping Zone5.ResultHandler<ThirdPartyResponse>) -> PendingRequest? {
		return post(Endpoints.removeThirdPartyConnection, parameters: queryParams(type), body: nil, with: completion)
	}
}
