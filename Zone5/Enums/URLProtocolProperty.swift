//
//  URLProtocolProperty.swift
//  Zone5
//
//  Created by Jean Hall on 18/11/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

internal enum URLProtocolProperty: String, CaseIterable {
	case fileURL
	case requiresAccessToken
	case zone5
	case taskType
	case isZone5Endpoint
}

internal enum URLSessionTaskType {
	case data
	case upload
	case download
}
