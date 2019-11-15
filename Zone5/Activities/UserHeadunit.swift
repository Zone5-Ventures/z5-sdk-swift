//
//  UserHeadunit.swift
//  Zone5
//
//  Created by Daniel Farrelly on 14/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct UserHeadunit: Codable {

	public var name: String?

	public var model: String?

	public var serial: String?

	public var product: String?

	public var hardwareVersion: String?

	public var softwareVersion: String?

	public var build: Double?

	public var hardwareBuild: Double?

	public var manufacturerID: Int?

	public var manufacturer: String?

	public var user: User?

	public var isRetired: Bool?

	// MARK: Codable

	private enum Field: String, CodingKey {
		case name
		case model
		case serial
		case product
		case hardwareVersion = "hwVersion"
		case softwareVersion = "swVersion"
		case build
		case hardwareBuild = "hwBuild"
		case manufacturerID = "manufacturerId"
		case manufacturer
		case user
		case isRetired = "retired"
	}

}
