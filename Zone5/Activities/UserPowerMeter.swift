//
//  UserPowerMeter.swift
//  Zone5
//
//  Created by Daniel Farrelly on 14/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct UserPowerMeter: Searchable {

	public var id: Int?

	public var user: User?

	public var timestamp: Milliseconds?

	/// Ant+ id
	public var manufacturerID: Int?

	/// Ant+ manufacturer
	public var manufacturer: String?

	/// Last battery level - volts
	public var batteryVolts: Double?

	/// Last battery level - percentage
	public var batteryPercentage: Int?

	public var zeroOffset: Int?

	public var slope: Int?

	/// Accumulated operating time (secs)
	public var operatingTime: TimeInterval?

	/// Current version
	public var version: String?

	/// Serial number
	public var serial: String?

	/// Alternate serial number
	public var alternateSerial: String?

	/// Power offset adjustment (+-%)
	public var powerOffsetAdjustment: Int?

	/// Ant+ number
	public var antID: Int?

	/// Product name
	public var product: String?

	/// User display name
	public var name: String?

	/// Equipment mapping
	public var equipment: Equipment?

	/// Has this meter been retired / no longer used
	public var isRetired: Int?

	// MARK: Codable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case id
		case user
		case timestamp = "ts"
		case manufacturerID = "manufacturerId"
		case manufacturer
		case batteryVolts = "battery"
		case batteryPercentage = "batteryP"
		case zeroOffset
		case slope
		case operatingTime
		case version
		case serial
		case alternateSerial = "altSerial"
		case powerOffsetAdjustment = "adjP"
		case antID = "antid"
		case product
		case name
		case equipment
		case isRetired = "retired"
	}
	
	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String? = nil) -> [String] {
		mapFieldsToSearchStrings(fields: fields, prefix: prefix)
	}

}
