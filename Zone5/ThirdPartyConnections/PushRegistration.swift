//
//  PushRegistration.swift
//  Zone5
//
//  Created by John Covele on Oct 9, 2020
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct PushRegistration: Codable, JSONEncodedBody {
	
	public let token: String
	public let platform: String
	public let deviceId: String
	
	public init(token: String, platform: String, deviceId: String) {
		self.token = token
		self.platform = platform
		self.deviceId = deviceId
	}
	
	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case token
		case platform
		case deviceId = "device_id"
	}
}
