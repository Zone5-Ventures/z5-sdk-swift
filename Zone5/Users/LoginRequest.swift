//
//  LoginRequest.swift
//  Zone5
//
//  Created by Jean Hall on 2/3/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

struct LoginRequest: JSONEncodedBody {
	var email: String
	var password: String
	let token: String = "true"
	var clientID: String?
	var clientSecret: String?
	var accept: [String]?
	
	private enum CodingKeys: String, CodingKey {
		case email = "username"
		case password
		case token
		case clientID = "clientId"
		case clientSecret
	}
	
	public init(email: String, password: String, clientID: String? = nil, clientSecret: String? = nil, accept: [String]? = nil) {
		self.email = email
		self.password = password
		self.clientID = clientID
		self.clientSecret = clientSecret
		self.accept = accept
	}
}
