//
//  PushRegistration.swift
//  Zone5
//
//  Created by John Covele on Oct 9, 2020
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct PushRegistration: Codable, JSONEncodedBody {
	
	public var token: String
	
	public var platform: String
	
	public var deviceId: String
	
	
	public init(token: String, platform: String, deviceId: String) {
		self.token = token
		self.platform = platform
		self.deviceId = deviceId
	}
	
	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case token
		case platform
		case deviceId
	}

}

public struct UpgradeAvailableResponse: Codable, JSONEncodedBody {
	
	public var upgrade: Bool
	
}

public struct PushRegistrationResponse: Codable, JSONEncodedBody {
	
	public var token: String
	
}
