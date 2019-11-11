//
//  IntensityZoneType.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

public enum IntensityZoneType: Int, Codable {

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

}
