//
//  Method.swift
//  Zone5
//
//  Created by Jean Hall on 8/12/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public extension Zone5 {
	enum Method: String {
		case get = "GET"
		case head = "HEAD"
		case post = "POST"
		case put = "PUT"
		case delete = "DELETE"
		case connect = "CONNECT"
		case options = "OPTIONS"
		case trace = "TRACE"
		case patch = "PATCH"
	}
}
