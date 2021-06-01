//
//  UserConnectionsType.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

public enum UserConnectionType: Int, Codable {
	
	case garminconnect = 0
	
	case fitbit = 1
	
	case withings = 2

	case myfitnesspal = 3
	
	case underarmour = 4
	
	case garminwellness = 5
	
	case trainingpeaks = 6
	
	case strava = 7
	
	case polar = 8
	
	case ridewithgps = 9
	
	case todaysplan = 10
	
	case suunto = 11
		
	case garmintraining = 12
		
	case turbo = 13
		
	// Specialized Ride
	case specialized = 14
		
	case nike = 15

}
