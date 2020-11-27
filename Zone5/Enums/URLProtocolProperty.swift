//
//  URLProtocolProperty.swift
//  Zone5
//
//  Created by Jean Hall on 18/11/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

internal enum URLProtocolProperty: String {
	case fileURL
	case requiresAccessToken
	case zone5
	case taskType
}

internal enum URLSessionTaskType {
	case data
	case upload
	case download
}
