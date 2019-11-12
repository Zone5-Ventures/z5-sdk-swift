//
//  DataFileUploadIndex.swift
//  Zone5
//
//  Created by Daniel Farrelly on 12/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct DataFileUploadIndex: Codable {

	var id: Int

	var resultID: Int?

	var timestamp: Int?

	var filename: String?

	var state: FileUploadState?

	var message: Int?

	//var result: UserWorkoutResult?

	var user: User?

	var createdTime: Int?

	var qTs: Int?

	// MARK: Encodable

	private enum CodingKeys: String, CodingKey {
		case id
		case resultID = "resultId"
		case timestamp = "ts"
		case filename
		case state
		case message
		//case result
		case user
		case createdTime
		case qTs
	}

}
