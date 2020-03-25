//
//  UserPreferences.swift
//  Zone5
//
//  Created by Jean Hall on 25/3/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct UsersPreferences: Codable, JSONEncodedBody {
	
	public var metric: UnitMeasurement?
	
	public init() { }
}
