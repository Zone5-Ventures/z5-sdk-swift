//
//  FileUploadState.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

/// Reasons for not completing a workout
public enum UserWorkoutFailedReason: String, Codable {

	/// workout not completed due to weather
	case weather
	
	/// workout not completed due to accumulated fatigue
	case fatigue
	
	/// workout not completed due to injury
	case injury
	
	/// workout not completed due to health - cold/flu etc
	case health
	
	/// workout not completed due to misc "life" committments
	case life
	
	/// workout not completed due to equipment failure
	case equipment

}
