//
//  FileUploadState.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

/// The state of a workout being completed
public enum UserWorkoutState: String, Codable {

	/// Workout has been completed
	case completed
	
	/// Workout is yet to be completed or acknowledged
	case pending
	
	/// Did not attempt / did not start
	case didNotStart = "dns"
	
	/// Did not finish / incomplete
	case didNotFinish = "dnf"

}
