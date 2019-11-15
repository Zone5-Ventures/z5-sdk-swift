//
//  DataFileUploadContext.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct DataFileUploadContext: JSONEncodedBody {

	/// The user id who this file belongs to
	public var userID: Int?

	/// Override the sport type
	public var sport: ActivityType?

	/// The original filename
	public var filename: String?

	/// The activity type this file is to be associate with
	public var category: ActivityResultType?

	/// The activity id this file is to be associated with
	public var activityID: Int?

	/// Override the timestamps within this file to commence from this value
	public var startTime: Int?

	/// Alternate display name
	public var name: String?

	/// The equipment used for this activity
	public var equipment: Equipment?

	/// The workout type for this activity
	public var workout: WorkoutType?

	/// A HTTP/HTTPS URL we will call back when the file has been processed
	public var callbackURL: String?

	/// A bit mask of UserConnectionsType.java ordinals - which 3rd party sites should be try to upload this file to
	public var pushMask: Int?

	public init() {}

	// MARK: Encodable

	private enum CodingKeys: String, CodingKey {
		case userID = "userId"
		case sport
		case filename
		case category = "activityType"
		case activityID = "activityId"
		case startTime = "startTs"
		case name
		case equipment
		case workout
		case callbackURL = "callbackUrl"
		case pushMask
	}

}
