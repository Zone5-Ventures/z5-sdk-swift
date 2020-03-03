//
//  UserThresholdHeart.swift
//  Zone5
//
//  Created by Jean Hall on 27/2/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct UserThresholdHeart: Codable {
	public var maxHr: Int?
	public var testDate: Int?
	public var threshold: Int?
	
	public init() { }
}
