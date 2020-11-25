//
//  OAuthTokenAlt.swift
//  Zone5
//
//  Created by Jean Hall on 27/2/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

/// OAuth token model returned by the server for gigya refresh token requests
/// These OAuth tokens are Gigya tokens
public struct OAuthTokenAlt: Codable, AccessToken {

	/// The string value of the token.
	public var token: String
	
	/// timestamp of when this token expires, ms since epoch
	public var tokenExp: Int? 
	
	public init(rawValue: String) {
		token = rawValue
	}
	
	public var rawValue: String {
		return token
	}
}
