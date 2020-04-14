//
//  MetricsView.swift
//  Zone5
//
//  Created by Jean Hall on 14/4/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public class MetricsView: APIView {
	private enum Endpoints: String, RequestEndpoint {
		case metrics = "/rest/reports/metrics/summary/get";
	}

	
	///Get aggregate metrics for a given set of users and date ranges.<br>
	///Supported aggregates include;
	///<ol>
	///<li>avg - simple average
	///<li>min - minimum value
	///<li>max - maximim value
	///<li>wavg - weighted average (weighted by time)
	///<li>sum - sum of values
	///</ol>
	///- Parameters:
	/// - sport: required - the sport type
	/// - userIds: required - 1 or more userIds can be requested
	/// - ranges: the date ranges - 1 or more ranges can be requested. If the ranges overlap it is indeterministic which range the metrics will be included in.
	/// - fields: the aggregate fields being requested
	/// - completion: Function called with the `UserWorkoutResult` values returned by the server, or the error if one occurred.
	public func get(sport: ActivityType, userIds: [Int64], ranges: [DateRange], fields: [String], completion: @escaping Zone5.ResultHandler<MappedResult<UserWorkoutResult>>) {
		let criteria = SearchInputReport.forInstanceMetrics(sport: sport, userIDs: userIds, ranges: ranges, fields: fields)
		post(Endpoints.metrics, body: criteria, with: completion)
	}
	
	///Get aggregate metrics by bike.<br>
	///Supported aggregates include;
	///<ol>
	///<li>avg - simple average
	///<li>min - minimum value
	///<li>max - maximim value
	///<li>wavg - weighted average (weighted by time)
	///<li>sum - sum of values
	///</ol>
	///- Parameters:
	/// - ranges: may be null or empty, and will then default to all time
	/// - fields:  the aggregate fields being requested. This should not be null or empty
	/// - bikeUids: the UserBike.uuid entries which we will limit the search to and group by
	/// - completion: Function called with the `UserWorkoutResult` values returned by the server, or the error if one occurred.
	public func getBikeMetrics(ranges: [DateRange], fields: [String], bikeUids: [String], completion: @escaping Zone5.ResultHandler<MappedResult<UserWorkoutResult>>) {
		let criteria = SearchInputReport.forInstanceMetricsBikes(ranges: ranges, fields: fields, bikeUids: bikeUids)
		post(Endpoints.metrics, body: criteria, with: completion)
	}
}
