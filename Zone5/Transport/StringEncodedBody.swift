//
//  TestEncodedBody.swift
//  Zone5
//
//  Created by Jean Hall on 28/2/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

struct StringEncodedBody: JSONEncodedBody {
	
	private let textBody: String
	
	public init(_ body: String) {
		self.textBody = body
	}
	
	// MARK: RequestBody

	func encodedData() throws -> Data {
		guard let data = textBody.data(using: .utf8) else {
			throw Error.requiresLossyConversion
		}

		return data
	}
	
	enum Error: Swift.Error {
		case requiresLossyConversion
	}
}
