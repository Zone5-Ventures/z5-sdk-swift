//
//  UserWorkoutResultTurboExt.swift
//  Zone5
//
//  Created by Jean Hall on 20/11/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct UserWorkoutResultTurboExt: Searchable {
	public var minimumBattery1Temperature: Int? // celsius
	public var averageBattery1Temperature: Int? // celsius
	public var maximumBattery1Temperature: Int? // celsius
	public var minimumBattery2Temperature: Int? // celsius
	public var averageBattery2Temperature: Int? // celsius
	public var maximumBattery2Temperature: Int? // celsius
	public var battery1DecayP: Int? // %
	public var battery2DecayP: Int? // %
	public var battery1DecayWh: Int? // Watt hours
	public var battery2DecayWh: Int? // Watt hours
	public var batteryTotalDecayP: Int? // %
	public var batteryTotalDecayWh: Int? // Watt hours
	public var bat1DecayAssist0Wh: Int? // Watt hours
	public var bat1DecayAssist1Wh: Int? // Watt hours
	public var bat1DecayAssist2Wh: Int? // Watt hours
	public var bat1DecayAssist3Wh: Int? // Watt hours
	public var bat1DecayAssist4Wh: Int? // Watt hours
	//public var bat1DecayAssist5Wh: Int? // Watt hours
	//public var bat1DecayAssist6Wh: Int? // Watt hours
	public var bat2DecayAssist0Wh: Int? // Watt hours
	public var bat2DecayAssist1Wh: Int? // Watt hours
	public var bat2DecayAssist2Wh: Int? // Watt hours
	public var bat2DecayAssist3Wh: Int? // Watt hours
	public var bat2DecayAssist4Wh: Int? // Watt hours
	//public var bat2DecayAssist5Wh: Int? // Watt hours
	//public var bat2DecayAssist6Wh: Int? // Watt hours
	public var supportFactorAssist0: Double? // ratio
	public var supportFactorAssist1: Double? // ratio
	public var supportFactorAssist2: Double? // ratio
	public var supportFactorAssist3: Double? // ratio
	public var supportFactorAssist4: Double? // ratio
	//public var supportFactorAssist5: Double? // ratio // future proof
	//public var supportFactorAssist6: Double? // ratio // future proof
	public var averageGPSSpeed: Double?
	
	public init() {}

	// MARK: Codable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case minimumBattery1Temperature = "minBattery1Temperature"
		case averageBattery1Temperature = "avgBattery1Temperature"
		case maximumBattery1Temperature = "maxBattery1Temperature"
		case minimumBattery2Temperature = "minBattery2Temperature"
		case averageBattery2Temperature = "avgBattery2Temperature"
		case maximumBattery2Temperature = "maxBattery2Temperature"
		case battery1DecayP
		case battery2DecayP
		case battery1DecayWh
		case battery2DecayWh
		case batteryTotalDecayP
		case batteryTotalDecayWh
		case bat1DecayAssist0Wh
		case bat1DecayAssist1Wh
		case bat1DecayAssist2Wh
		case bat1DecayAssist3Wh
		case bat1DecayAssist4Wh
		//case bat1DecayAssist5Wh
		//case bat1DecayAssist6Wh
		case bat2DecayAssist0Wh
		case bat2DecayAssist1Wh
		case bat2DecayAssist2Wh
		case bat2DecayAssist3Wh
		case bat2DecayAssist4Wh
		//case bat2DecayAssist5Wh
		//case bat2DecayAssist6Wh
		case supportFactorAssist0
		case supportFactorAssist1
		case supportFactorAssist2
		case supportFactorAssist3
		case supportFactorAssist4
		//case supportFactorAssist5
		//case supportFactorAssist6
		case averageGPSSpeed = "avgGPSSpeed"
	}
	
	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String? = nil) -> [String] {
		mapFieldsToSearchStrings(fields: fields, prefix: prefix)
	}
}


