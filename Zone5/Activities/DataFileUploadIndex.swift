//
//  DataFileUploadIndex.swift
//  Zone5
//
//  Created by Daniel Farrelly on 12/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct DataFileUploadIndex: Searchable {

	public var id: Int

	public var resultID: Int?

	public var timestamp: Milliseconds?

	public var filename: String?

	public var state: FileUploadState?

	public var message: Int?

	public var result: UserWorkoutResult?

	public var user: User?

	public var createdTime: Milliseconds?

	public var qTs: Int?

	// MARK: Encodable

	public enum CodingKeys: String, CodingKey, CaseIterable {
		case id
		case resultID = "resultId"
		case timestamp = "ts"
		case filename
		case state
		case message
		case result
		case user
		case createdTime
		case qTs
	}

	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String? = nil) -> [String] {
		mapFieldsToSearchStrings(fields: fields, prefix: prefix)
	}
}
