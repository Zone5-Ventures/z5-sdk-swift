//
//  KeyValueStore.swift
//  Zone5 Example
//
//  Created by Daniel Farrelly on 8/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation
import Zone5

struct KeyValueStore {

	static var shared = KeyValueStore()

	let userDefaults: UserDefaults

	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults
	}

	// MARK: Values

	private let defaultURL = URL(string: "https://example.com")!

	var baseURLString: String {
		get { return userDefaults.string(forKey: "Zone5_baseURL") ?? defaultURL.absoluteString }
		set { userDefaults.set(newValue, forKey: "Zone5_baseURL") }
	}

	var baseURL: URL {
		get { return URL(string: baseURLString) ?? defaultURL }
		set { baseURLString = newValue.absoluteString }
	}

	var accessTokenString: String {
		get { return userDefaults.string(forKey: "Zone5_accessToken") ?? "" }
		set {
			if !newValue.isEmpty {
				userDefaults.set(newValue, forKey: "Zone5_accessToken")
			}
			else {
				userDefaults.removeObject(forKey: "Zone5_accessToken")
			}
		}
	}

	var accessToken: AccessToken? {
		get {
			guard !accessTokenString.isEmpty else {
				return nil
			}

			return OAuthToken(rawValue: accessTokenString)
		}
		set {
			accessTokenString = newValue?.rawValue ?? ""
		}
	}

	var clientID: String {
		get { return userDefaults.string(forKey: "Zone5_clientID") ?? "" }
		set {
			if !newValue.isEmpty {
				userDefaults.set(newValue, forKey: "Zone5_clientID")
			}
			else {
				userDefaults.removeObject(forKey: "Zone5_clientID")
			}
		}
	}

	var clientSecret: String {
		get { return userDefaults.string(forKey: "Zone5_clientSecret") ?? "" }
		set {
			if !newValue.isEmpty {
				userDefaults.set(newValue, forKey: "Zone5_clientSecret")
			}
			else {
				userDefaults.removeObject(forKey: "Zone5_clientSecret")
			}
		}
	}

	var username: String {
		get { return userDefaults.string(forKey: "Zone5_username") ?? "" }
		set {
			if !newValue.isEmpty {
				userDefaults.set(newValue, forKey: "Zone5_username")
			}
			else {
				userDefaults.removeObject(forKey: "Zone5_username")
			}
		}
	}

	var password: String {
		get { return userDefaults.string(forKey: "Zone5_password") ?? "" }
		set {
			if !newValue.isEmpty {
				userDefaults.set(newValue, forKey: "Zone5_password")
			}
			else {
				userDefaults.removeObject(forKey: "Zone5_password")
			}
		}
	}
	
	var userID: Int {
		get { return userDefaults.integer(forKey: "Zone5_userId")}
		set {
			if newValue > 0 {
				userDefaults.set(newValue, forKey: "Zone5_userId")
			}
			else {
				userDefaults.removeObject(forKey: "Zone5_userId")
			}
		}
	}

}
