//
//  UserDelegateRelationship.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

public enum UserDelegateRelationship: String, Codable {

	/// Coach/client relationship
	case coach
	
	/// Team manager/client relationship
	case manager
	
	/// Team mates
	case team
	
	/// Friend
	case friend

}
