//
//  TScoreType.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

/// Various options for T-Score calculation
public enum TScoreType: String, Codable {

	/// Cycling TSS power - normalized / avg / adjusted power is a seperate param
	case ctpp
	
	/// Cycling TSS heart
	case ctph
	
	/// Cycling Total cycling load score 
	case tlc
	
	/// Run Stryd TSS
	case rss
	
	/// Run t-score power
	case rtpp
	
	/// Run t-score pace
	case rtpa
	
	/// Run t-score heart
	case rtph
	
	/// Plain old heart rate zone trimp
	case trimp
	
	/// Swim t-score pace
	case stpa

}
