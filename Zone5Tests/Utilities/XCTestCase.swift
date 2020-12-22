//
//  XCTestCase.swift
//  Zone5Tests
//
//  Created by Daniel Farrelly on 19/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import XCTest
@testable import Zone5

extension XCTestCase {

	struct ConfigurationForTesting {

		var accessToken: AccessToken? = OAuthToken(rawValue: "ACCESS_TOKEN")

		var baseURL: URL? = URL(string: "http://localhost")!

		var clientID: String? = "CLIENT_IDENTIFIER"

		var clientSecret: String? = "CLIENT_SECRET"

		var redirectURI: String = "https://localhost"

	}

	enum EndpointsForTesting: String, RequestEndpoint {

		/// Basic endpoint that does not require an access token.
		case `default` = "/endpoint/default"

		/// Basic endpoint that requires an access token.
		case requiresAccessToken = "/endpoint/noAccessTokenRequired"

		/// Endpoint with a replaceable `{token}` that does not require an access token.
		case withReplaceableTokens = "/endpoint/with/{token}"

		var requiresAccessToken: Bool {
			switch self {
			case .requiresAccessToken: return true
			default: return false
			}
		}
	}
	
	func createNewZone5() -> Zone5 {
		let urlSession = TestHTTPClientURLSession()
		let httpClient = Zone5HTTPClient(urlSession: urlSession)
		return Zone5(httpClient: httpClient)
	}
	

	func execute(configuration: ConfigurationForTesting = .init(), _ tests: (_ zone5: Zone5, _ httpClient: Zone5HTTPClient, _ urlSession: TestHTTPClientURLSession) throws -> Void) rethrows {
		let urlSession = TestHTTPClientURLSession()
		let httpClient = Zone5HTTPClient(urlSession: urlSession)
		
		let zone5 = Zone5(httpClient: httpClient)
		zone5.configure(with: configuration)

		try tests(zone5, httpClient, urlSession)
	}

	func execute<T>(with parameters: [T], configuration: ConfigurationForTesting = .init(), _ tests: (_ zone5: Zone5, _ httpClient: Zone5HTTPClient, _ urlSession: TestHTTPClientURLSession, _ parameters: T) throws -> Void) rethrows {
		try parameters.forEach { parameters in
			try execute(configuration: configuration) { zone5, httpClient, urlSession in
				try tests(zone5, httpClient, urlSession, parameters)
			}
		}
	}

	/// Convenience method to quickly decode a JSON string as the given `expectedType`.
	func decode<T: Decodable>(json: String, as expectedType: T.Type) throws -> T {
		return try JSONDecoder().decode(expectedType, from: json.data(using: .utf8)!)
	}

	/// Convenience method to quickly decode a JSON string as the given `expectedType`.
	func encode<T: Encodable>(_ value: T) throws -> String {
		let data = try JSONEncoder().encode(value)
		return String(data: data, encoding: .utf8)!
	}

}

extension Zone5 {

	func configure(with configuration: XCTestCase.ConfigurationForTesting) {
		redirectURI = configuration.redirectURI
		accessToken = configuration.accessToken

		if let baseURL = configuration.baseURL, let clientID = configuration.clientID, let clientSecret = configuration.clientSecret {
			configure(for: baseURL, clientID: clientID, clientSecret: clientSecret)
		}
		else {
			baseURL = configuration.baseURL
			clientID = configuration.clientID
			clientSecret = configuration.clientSecret
		}
	}

}
