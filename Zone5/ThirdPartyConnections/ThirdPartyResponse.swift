//
//  ThirdPartyResponse.swift
//  Zone5
//
//  Created by Jean Hall on 20/10/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

/// Response from ThirdPartyConnectionsView.hasThirdPartyToken
struct ThirdPartyResponse: Codable {
    let type: String
    let enabled: Bool
}
