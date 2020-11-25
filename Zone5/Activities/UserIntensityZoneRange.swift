//
//  UserIntensityZoneRange.swift
//  Zone5
//
//  Created by Daniel Farrelly on 14/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct UserIntensityZoneRange: Codable {

	/// For zones which are relative to a percentage (ie % threshold), this is the min % for the range. For non-relative
	/// zones (wkg, nm) this is an absolute value.
	public var min: Double?

	/// For zones which are relative to a percentage (ie % threshold), this is the max % for the range. For non-relative
	/// zones (wkg, nm) this is an absolute value.
	public var max: Double?

	/// Name of the range / zone - ie endurance.
	public var name: String?

	/// The display colour.
	public var colour: String?

	/// The duration (seconds) that the athlete spent in this training zone.
	public var duration: Double?

	/// The percentage of time the athlete spent in this training zone.
	public var percentage: Double?

	/// Indicates if the zone ranges are defined as a % (ie % threshold) or absolute values.
	public var zoneUnits: String?

	// MARK: Codable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case min
		case max
		case name
		case colour
		case duration
		case percentage
		case zoneUnits
	}

	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String) -> [String] {
		return fields.map { "\(prefix).\($0.rawValue)" }
	}
}
