import XCTest
@testable import Zone5

final class RequestTests: XCTestCase {

	enum Endpoints: String, RequestEndpoint {
		case test = "endpoint/uri"
	}

	func testExample() {
		let baseURL = URL(string: "https://localhost")!
		let accessToken = OAuthToken(rawValue: UUID().uuidString)

		let body: URLEncodedBody = [
			"example": "example"
		]

		let request = Request(endpoint: Endpoints.test, method: .post, body: body)

		do {
			let urlRequest = try request.urlRequest(with: baseURL, accessToken: accessToken)

			XCTAssertNotNil(urlRequest.httpBody)

//			let decoded = try JSONDecoder().decode(URLEncodedBody.self, from: urlRequest.httpBody!)
//
//			XCTAssertNotNil(decoded)
//			XCTAssertEqual(decoded, body)
		}
		catch {
			print(error)

			XCTFail()
		}
	}
	
	func testExample2() {
		let baseURL = URL(string: "https://localhost")!
		let accessToken = OAuthToken(rawValue: UUID().uuidString)
		
		let body: URLEncodedBody = [
			"example": nil
		]
		
		let request = Request(endpoint: Endpoints.test, method: .post, body: body)
		
		do {
			let urlRequest = try request.urlRequest(with: baseURL, accessToken: accessToken)
			
			XCTAssertNotNil(urlRequest.httpBody)
			
			//			let decoded = try JSONDecoder().decode(URLEncodedBody.self, from: urlRequest.httpBody!)
			//
			//			XCTAssertNotNil(decoded)
			//			XCTAssertEqual(decoded, body)
		}
		catch {
			print(error)
			
			XCTFail()
		}
	}
}
