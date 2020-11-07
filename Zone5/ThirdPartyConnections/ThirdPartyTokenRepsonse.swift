//
//  ThirdPartyTokenRepsonse.swift
//  Zone5
//
//  Created by Jean Hall on 19/10/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

/// Response from ThirdPartyConnectionsView.hasThirdPartyToken
public struct ThirdPartyTokenResponse: Codable {
	public let available: Bool
	public var token: ThirdPartyToken?
}
