//
//  UserConnectionsType.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

public enum UserConnectionsType: Int, Codable {
	
	case garminConnect = 0
	
	case fitbit = 1
	
	case withings = 2

	case myFitnessPal = 3
	
	case underarmour = 4
	
	case garminWellness = 5
	
	case trainingPeaks = 6
	
	case strava = 7
	
	case polar = 8
	
	case rideWithGPS = 9
	
	case todaysPlan = 10

}
