//
//  UpgradeAvailableResponse.swift
//  Zone5
//
//  Created by Jean Hall on 19/10/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

/// Response to zone5.thirdPartyConnections.getDeprecated()
public struct UpgradeAvailableResponse: Codable {
	public let isUpgradeAvailable: Bool
	
	private enum CodingKeys: String, CodingKey {
		case isUpgradeAvailable = "upgrade"
	}
}
