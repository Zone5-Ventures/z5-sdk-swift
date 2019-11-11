//
//  DataAccessRequest.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public enum DataAccessRequest: String, Codable {

	/// Can view basic meta-data about this record
	case view1

	/// Can view advanced meta-data about this record
	case view2

	case view3

	/// Can insert a new record
	case add

	/// Can update basic meta-data about this record
	case edit1

	/// Can updated advanced meta-data about this record
	case edit2

	case edit3

	/// Can delete this record
	case delete = "del"

	/// A special case permission for limited reporting access
	case limitedReporting = "rpt"

	/// A special case permission for flagging that an object is locked
	case locked = "lock"

}
