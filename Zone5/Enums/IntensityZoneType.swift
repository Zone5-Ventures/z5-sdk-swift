//
//  IntensityZoneType.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

public enum IntensityZoneType: Int, Codable, CustomStringConvertible {

	/// Watts/Kg
	case wpkg = 0
	
	/// percentage of maxhr
	case maxhr = 1
	
	/// Watts zones (percentage of ftp)
	case pwr = 2
	
	/// BPM zones (percentage of athr)
	case bpm = 3
	
	/// Torque
	case nm = 4
	
	case pace = 5
	
	case rpm = 6

	public var description: String {
		switch self {
		case .wpkg: return "wpkg"
		case .maxhr: return "maxhr"
		case .pwr: return "pwr"
		case .bpm: return "bpm"
		case .nm: return "nm"
		case .pace: return "pace"
		case .rpm: return "rpm"
		}
	}

}
