//
//  ThirdPartyConnectionsView.swift
//  Zone5
//
//  Created by John Covele on Oct 14, 2020.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public class ThirdPartyConnectionsView: APIView {
    private class ThirdPartyEndpoint: InternalRequestEndpoint {
        let uri: String

        init(uri: String) {
            self.uri = uri
        }
    }
	private enum Endpoints: String, InternalRequestEndpoint {
        case initializePairing = "/rest/users/connections/pair/"
		case files = "/rest/files/"
        case userConnections = "/rest/users/connections"
		case removeThirdPartyConnection = "/rest/users/connections/rem/"
		case registerDeviceWithThirdParty = "/rest/users/scheduled/activities/api/v1/push_registrations"
		case deregisterDeviceWithThirdParty = "/rest/users/scheduled/activities/api/v1/push_registrations/{token}"
	}
	
	private let serviceKey: String = "service_name"
	private func queryParams(_ serviceType: UserConnectionsType) -> URLEncodedBody {
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

    /// Initialize a connection for the current user for the given 3rd party type
    /// - Parameters

    @discardableResult
    public func initializeThirdPartyConnection(type: UserConnectionsType, completion: @escaping Zone5.ResultHandler<ThirdPartyInitializeResponse>) -> PendingRequest? {
        let endpoint = ThirdPartyEndpoint(uri: Endpoints.initializePairing.rawValue + type.rawValue)
        return post(endpoint, body: EmptyBody(), with: completion)
    }

	/// Set an access token for the current user for the given 3rd party type
	/// - Parameters

	@discardableResult
    public func setThirdPartyToken(type: UserConnectionsType, parameters: URLEncodedBody?, completion: @escaping Zone5.ResultHandler<Zone5.VoidReply>) -> PendingRequest? {
        let endpoint = ThirdPartyEndpoint(uri: Endpoints.files.rawValue + type.rawValue + "/confirm")
        return get(endpoint, parameters: parameters, expectedType: Zone5.VoidReply.self, with: completion)
	}

	@discardableResult
	public func hasThirdPartyToken(type: UserConnectionsType, completion: @escaping Zone5.ResultHandler<Bool>) -> PendingRequest? {
        return get(Endpoints.userConnections, parameters: queryParams(type), expectedType: [ThirdPartyResponse].self) { result in
            switch result {
            case .success(let connections):
                guard connections.first(where: { $0.type == type.rawValue && $0.enabled == true }) != nil else {
                    completion(.success(false))
                    return
                }

                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
	}

	@discardableResult
	public func removeThirdPartyToken(type: UserConnectionsType, completion: @escaping Zone5.ResultHandler<Zone5.VoidReply>) -> PendingRequest? {
        let endpoint = ThirdPartyEndpoint(uri: Endpoints.removeThirdPartyConnection.rawValue + type.rawValue)
		return get(endpoint, with: completion)
	}
}
