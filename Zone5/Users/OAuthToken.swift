//
//  OAuthToken.swift
//  Zone5
//
//  Created by Jean Hall on 27/2/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

/// OAuth token model returned by the server for accessToken requests
public struct OAuthToken: Codable, Equatable, AccessToken {
	/// String value of the OAuth token
	public var accessToken: String
	public var refreshToken: String?
	public var tokenType: String?
	public var expires: Int?
	
	public init(rawValue: String) {
		accessToken = rawValue
	}
	
	public var rawValue: String {
		return accessToken
	}
	
	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case accessToken = "access_token"
		case refreshToken = "refresh_token"
		case tokenType = "token_type"
		case expires
	}
}
