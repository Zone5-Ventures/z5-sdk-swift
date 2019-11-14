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

	// MARK: Data tasks

	/// - Returns: Result enumeration containing either a JSON string or an error.
	var dataTaskHandler: (_ request: URLRequest) -> Result<String, Error> = { _ in fatalError() }

	func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
		return DataTask {
			let result = self.dataTaskHandler(request)
			let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [
				"Content-Type": "application/json",
			])

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

	// MARK: Upload tasks

	/// - Returns: Result enumeration containing either a JSON string or an error.
	var uploadTaskHandler: (_ request: URLRequest) -> Result<String, Error> = { _ in fatalError() }

	func uploadTask(with request: URLRequest, fromFile fileURL: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask {
		return UploadTask {
			let result = self.dataTaskHandler(request)
			let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [
				"Content-Type": "application/json",
			])

			switch result {
			case .failure(let error):
				completionHandler(nil, response!, error)
			case .success(let json):
				completionHandler(json.data(using: .utf8), response, nil)
			}
		}
	}

	final class UploadTask: URLSessionUploadTask {

		let onResume: () -> Void

		init(onResume: @escaping () -> Void) {
			self.onResume = onResume
		}

		override func resume() {
			self.onResume()
		}

	}

	// MARK: Download tasks

	/// - Returns: Result enumeration containing either a file URL or an error.
	var downloadTaskHandler: (_ request: URLRequest) -> Result<URL, Error> = { _ in fatalError() }

	func downloadTask(with request: URLRequest, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask {
		return DownloadTask {
			let result = self.downloadTaskHandler(request)

			switch result {
			case .failure(let error):
				let response = HTTPURLResponse.init(url: request.url!, statusCode: 500, httpVersion: "HTTP/1.1", headerFields: [
					"Content-Type": "application/json",
				])

				completionHandler(nil, response!, error)
			case .success(let url):
				let response = HTTPURLResponse.init(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: [
					"Content-Disposition": "attachment; filename=\"\(url.lastPathComponent)\"",
					"Content-Type": "application/octet-stream",
				])

				completionHandler(url, response!, nil)
			}
		}
	}

	final class DownloadTask: URLSessionDownloadTask {

		let onResume: () -> Void

		init(onResume: @escaping () -> Void) {
			self.onResume = onResume
		}

		override func resume() {
			self.onResume()
		}

	}

}
