//
//  TestHTTPClientURLSession.swift
//  Zone5Tests
//
//  Created by Daniel Farrelly on 7/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation
@testable import Zone5

extension Zone5 {

	static func prepareTestClient() -> (client: Zone5, urlSession: TestHTTPClientURLSession) {
		let urlSession = TestHTTPClientURLSession()

		let zone5 = Zone5(httpClient: HTTPClient(urlSession: urlSession))
		zone5.configure(for: URL(string: "http://localhost")!, clientID: "CLIENT_IDENTIFIER", clientSecret: "CLIENT_SECRET")

		return (client: zone5, urlSession: urlSession)
	}

}

class TestHTTPClientURLSession: HTTPClientURLSession {

	/// - Returns: Result enumeration containing either a JSON string or an error.
	var dataTaskHandler: (_ request: URLRequest) -> Result<String, Error> = { _ in fatalError() }

	func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		return DataTask {
			let result = self.dataTaskHandler(request)
			let response = HTTPURLResponse(url: request.url!, mimeType: "application/json", expectedContentLength: -1, textEncodingName: nil)

			switch result {
			case .failure(let error):
				completionHandler(nil, response, error)
			case .success(let json):
				completionHandler(json.data(using: .utf8), response, nil)
			}
		}
	}

	final class DataTask: URLSessionDataTask {

		let onResume: () -> Void

		init(onResume: @escaping () -> Void) {
			self.onResume = onResume
		}

		override func resume() {
			self.onResume()
		}

	}

}
