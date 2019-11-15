//
//  UserWorkoutDetails.swift
//  Zone5
//
//  Created by Daniel Farrelly on 14/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct UserWorkoutDetails: Codable {

	/// A workout ID
	public var id: Int?

	/// Timestamp of when this workout is scheduled
	public var day: Int?

	/// Test, training or event
	public var workout: WorkoutType?

	/// Sport
	public var type: ActivityType?

	public var time: TimeOfDay?

	public var name: String?

	public var descr: String?

	public var preDescr: String?

	public var media: String?

	/// Estimated / scheduled tscore
	public var tscorepwr: Double?

	/// Estimated / scheduled duration
	public var durationSecs: Int?

	/// Estimated / scheduled distance
	public var distance: Double?

	/// Estimated / scheduled pace
	public var pace: Double?

	public var mask: Int?

	/// if true, then this is an unstructured workout and has no intervals
	public var simple: Bool?

	/// Estimated / scheduled elevation gain
	public var ascent: Int?

	/// Estimated / scheduled elevation loss
	public var descent: Int?

	/// Estimated / scheduled intensity
	public var intensityFactor: Int?

	/// Athlete
	public var user: User?

	/// Coach who created the workout
	public var author: User?

	/// timezone
	public var tz: String?

	//public var ext: UserWorkoutExt

	public var equipment: Set<Equipment>?

	public var terrain: Set<Terrain>?

	//public var goals: Set<Goal>?

	public var state: UserWorkoutState?

	public var reason: UserWorkoutFailedReason?

	//public var intervals: [UserWorkoutInterval]?

	/// Number of power zones this workout was designed for
	public var zoneSize: Int?

	/// Number of heart rate zones this workout was designed for
	public var zoneHrSize: Int?

	/// Number of pace zones this workout was designed for
	public var zonePaceSize: Int?

	// MARK: Codable

	private enum Field: String, CodingKey {
		case id
		case day
		case workout
		case type
		case time
		case name
		case descr
		case preDescr
		case media
		case tscorepwr
		case durationSecs
		case distance
		case pace
		case mask
		case simple
		case ascent
		case descent
		case intensityFactor
		case user
		case author
		case tz
		case ext
		case equipment
		case terrain
		case goals
		case state
		case reason
		case intervals
		case zoneSize
		case zoneHrSize
		case zonePaceSize
	}

}
