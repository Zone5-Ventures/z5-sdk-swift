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

}
