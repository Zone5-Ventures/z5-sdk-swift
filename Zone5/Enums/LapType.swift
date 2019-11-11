//
//  LapType.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

/// The type of lag/segment
public enum LapType: String, Codable {

	/// Pre-race
	case pre

	/// Main race
	case main

	/// Climb or other interesting segment
	case segment

	/// Post-race
	case pst
	
	case climb
	
	case sprint

}
