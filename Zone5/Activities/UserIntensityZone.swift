//
//  UserIntensityZone.swift
//  Zone5
//
//  Created by Daniel Farrelly on 14/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct UserIntensityZone: Codable {

	public var id: Int?

	public var type: IntensityZoneType?

	public var name: String?

	public var user: User?

	public var zones: [UserIntensityZoneRange]?

	// MARK: Codable

	private enum Field: String, CodingKey {
		case id
		case type
		case name
		case user
		case zones
	}

}
