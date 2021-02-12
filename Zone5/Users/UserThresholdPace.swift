//
//  UserThresholdPace.swift
//  Zone5
//
//  Created by Jean Hall on 27/2/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct UserThresholdPace: Searchable {
	public var testDate: Int?
	public var threshold: Double?
	
	public init() { }
	
	public enum CodingKeys: String, CodingKey, CaseIterable {
		case testDate
		case threshold
	}
	
	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String? = nil) -> [String] {
		mapFieldsToSearchStrings(fields: fields, prefix: prefix)
	}
}
