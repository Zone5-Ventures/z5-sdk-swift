//
//  CodingKeys+Prefix.swift
//  Zone5
//
//  Created by Jean Hall on 27/1/21.
//  Copyright © 2021 Zone5 Ventures. All rights reserved.
//

import Foundation

protocol Searchable: Codable {
}

extension CodingKey {
	func searchString(_ prefix: String? = nil) -> String {
		if let prefix = prefix {
			return "\(prefix).\(stringValue)"
		} else {
			return stringValue
		}
	}
}

extension Searchable {
	static func mapFieldsToSearchStrings(fields: [CodingKey], prefix: String? = nil) -> [String] {
		return fields.map( { $0.searchString(prefix) } )
	}
}
