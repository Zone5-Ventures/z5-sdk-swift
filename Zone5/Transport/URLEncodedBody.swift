import Foundation

/// Parameters that may be encoded as a URL query string, i.e. `key=value&otherKey=otherValue`.
///
/// This structure can be used all request types. For requests that can take a request body (i.e. POST), the output of
/// the `encodedData()` method is used. In instances where this is not the case, the `description` is appended to the
/// endpoint URL as a query string.
public struct URLEncodedBody: RequestBody, CustomStringConvertible, ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {

	private(set) var queryItems: [URLQueryItem]

	init(queryItems: [URLQueryItem]) {
		self.queryItems = queryItems
	}

	// MARK Custom string convertible

    public var description: String {
		return queryItems.map { item in
			var allowedCharacters: CharacterSet = .urlQueryAllowed
			allowedCharacters.remove("+")
			
			guard let encodedName = item.name.addingPercentEncoding(withAllowedCharacters: allowedCharacters) else {
				return item.name
			}

			if let encodedValue = item.value?.addingPercentEncoding(withAllowedCharacters: allowedCharacters) {
				return String(format: "%@=%@", encodedName, encodedValue)
			}
			else {
				return String(format: "%@", encodedName)
			}
		}.joined(separator: "&")
	}

	// MARK: Expressible by array literal

	public init(arrayLiteral elements: URLQueryItem...) {
		self.init(queryItems: elements)
	}

	// MARK: Expressibly by dictionary literal

    public init(dictionaryLiteral elements: (String, CustomStringConvertible?)...) {
        var queryItems: [URLQueryItem] = []

		for (key, value) in elements {
			queryItems.append(URLQueryItem(name: key, value: value?.description))
		}

		self.init(queryItems: queryItems.sorted { $0.name < $1.name })
	}

	// MARK: Request parameters

    public let contentType = "application/x-www-form-urlencoded"

    public func encodedData() throws -> Data {
		guard let data = description.data(using: .utf8) else {
			throw Error.requiresLossyConversion
		}

		return data
	}

	enum Error: Swift.Error {
		case requiresLossyConversion
	}

}
