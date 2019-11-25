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

	public var description: String?

	public var previewDescription: String?

	public var media: String?

	/// Estimated / scheduled tscore
	public var tscorePower: Double?

	/// Estimated / scheduled duration
	public var durationSeconds: TimeInterval?

	/// Estimated / scheduled distance
	public var distance: Double?

	/// Estimated / scheduled pace
	public var pace: Double?

	public var mask: Int?

	/// if true, then this is an unstructured workout and has no intervals
	public var isSimple: Bool?

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
	public var timeZone: String?

	//public var `extension`: UserWorkoutExt

	public var equipment: Set<Equipment>?

	public var terrain: Set<Terrain>?

	//public var goals: Set<Goal>?

	public var state: UserWorkoutState?

	public var reason: UserWorkoutFailedReason?

	//public var intervals: [UserWorkoutInterval]?

	/// Number of power zones this workout was designed for
	public var powerZoneCount: Int?

	/// Number of heart rate zones this workout was designed for
	public var heartRateZoneCount: Int?

	/// Number of pace zones this workout was designed for
	public var paceZoneCount: Int?

	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case id
		case day
		case workout
		case type
		case time
		case name
		case description = "descr"
		case previewDescription = "preDescr"
		case media
		case tscorePower = "tscorepwr"
		case durationSeconds = "durationSecs"
		case distance
		case pace
		case mask
		case isSimple = "simple"
		case ascent
		case descent
		case intensityFactor
		case user
		case author
		case timeZone = "tz"
		//case `extension` = "ext"
		case equipment
		case terrain
		//case goals
		case state
		case reason
		//case intervals
		case powerZoneCount = "zoneSize"
		case heartRateZoneCount = "zoneHrSize"
		case paceZoneCount = "zonePaceSize"
	}

}
