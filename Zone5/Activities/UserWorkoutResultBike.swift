//
//  UserWorkoutResultBike.swift
//  Zone5
//
//  Created by Jean Hall on 26/2/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct UserWorkoutResultBike: Codable {
	/** Display name for the bike */
	public var name: String?
	
	/** Description of the bike */
	public var description: String?
	
	/** Serial number of the bike */
	public var serial: String?
	
	/** External system bike_id */
	public var uuid: String?
	
	public var registrationId: String?
	
	public var bikeUuid: String?
	
	/** URL image */
	public var avatar: String?
	
	public init() {}
	
	// MARK: Codable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case name = "name"
		case description = "descr"
		case serial = "serial"
		case uuid = "uuid"
		case avatar = "avatar"
		case bikeUuid = "bikeUuid"
		case registrationId = "registrationId"
	}
	
	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String) -> [String] {
		return fields.map { "\(prefix).\($0.rawValue)" }
	}
}
