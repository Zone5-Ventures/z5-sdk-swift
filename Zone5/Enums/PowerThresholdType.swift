//
//  PowerThresholdType.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

/// The formula we use for estimating / calculating threshold
public enum PowerThresholdType: String, Codable {

	/// FTP - take a peak X power and multiply by an adjustment to normalize to a peak 60min
	case ftp
	
	/// Critical power - use a n point regression line to calculate a theoretical sustainable power
	case cp
	
	/// 40 minute power
	case fp

	/// disabled
	case none

}
