//
//  UserDelegateState.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

public enum UserDelegateState: String, Codable {

	/// A request is pending - the coach needs to accept this request
	case pendingCoach = "pending_coach"
	
	/// A request is pending - the client needs to accept this request
	case pendingClient = "pending_client"
	
	/// The delegate relationship is active
	case active
	
	/// The delegate relationship was cancelled or declined
	case declined

}
