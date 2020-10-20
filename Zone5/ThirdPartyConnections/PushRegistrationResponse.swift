//
//  PushRegistrationResponse.swift
//  Zone5
//
//  Created by Jean Hall on 19/10/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

/// Response to ThirdPartyConnectionsView.registerDeviceWithThirdParty
public struct PushRegistrationResponse: Codable {
	public let token: Int
}
