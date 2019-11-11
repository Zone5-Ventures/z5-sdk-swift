//
//  Terrain.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

public enum Terrain: String, Codable {

	case flat
	
	case rolling
	
	case climbShort = "climb_short"
	
	case climbMedium = "climb_medium"
	
	case climbLong = "climb_long"
	
	case crit
	
	case dirtTech = "dirt_tech"
	
	case dirtTechClimb = "dirt_tech_climb"
	
	case dirtTechDescent = "dirt_tech_descent"
	
	case dirt
	
	case dirtClimb = "dirt_climb"
	
	case dirtDescent = "dirt_descent"
	
	case boards

}
	
