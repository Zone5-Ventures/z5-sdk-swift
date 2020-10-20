//
//  LoginResponse.swift
//  Zone5
//
//  Created by Jean Hall on 26/2/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct LoginResponse: Codable {
	/// Collection of companies which this user belongs / has a relationship with
	public var companies: [Int]?
	
	/// List of roles which this user has
	public var roles: [Roles]?
	
	/// Primary branding company (if any)
	public var branding: Company?
	
	/// The actual user
	public var user: User?
	
	/// Bearer token
	public var token: String?
	
	/// Bearer token expiry (ms since Epoch)
	public var tokenExp: Int?
	
	public var refresh: String?
	
	public init() { }
}
