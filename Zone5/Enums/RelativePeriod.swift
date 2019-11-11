//
//  RelativePeriod.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

public enum RelativePeriod: String, Codable {
	
	/// Relative to the all time best - excluding the current activity/period
	case allTime = "alltime"
	
	/// Relative to the all time best - including the current activity/period
	case bestEver = "bestever"
	
	/// Relative to the time up until this activity/period
	case toDate = "todate"
	
	/// Relative to the time up until this activity/period minus 1 year
	case toDateLastYear = "todatelastyear"
	
	/// Relative to the given range
	case thisRange = "thisrange"
	
	/// Relative to the given range minus 1 year
	case thisRangeLastYear = "thisrangelastyear"
	
	/// Relative to the last 28 days prior to this activity/period
	case last28Days = "last28days"
	
	/// Relative to the last 3 months prior to this activity/period
	case last3Months = "last3months"
	
	/// Relative to the last 6 months prior to this activity/period
	case last6Months = "last6months"
	
	/// Relative to the last 12 months prior to this activity/period
	case last12Months = "last12months"
	
	/// Relative to the last 7 days prior to this activity/period
	case last7Days = "last7days"

}
