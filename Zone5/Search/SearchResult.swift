import Foundation

public typealias MappedResult<Result: Decodable> = SearchResult<Result>.Page

/// A collection of results for a search request.
///
///
public struct SearchResult<Result: Decodable> {

	/// The paginated result set.
	public var result: Page

	/// The total number of results available.
	public var total: Int

	/// The result set's offset index.
	public var offset: Int

	/// Structure that defines a paginated result set.
	/// - Note: This structure is used even if the results are returned as an array.
	public struct Page {

		/// The collection of sorted results
		public var results: [Result]

		public var fields: [String: String]

		public var keys: [String]

		init(results: [Result] = [], fields: [String: String] = [:], keys: [String] = []) {
			self.results = results
			self.fields = fields
			self.keys = keys
		}

	}

}

// MARK: Random access collection

extension SearchResult: RandomAccessCollection {

	public var startIndex: Int {
		return result.startIndex
	}

	public var endIndex: Int {
		return result.endIndex
	}

	public func index(after i: Int) -> Int {
		return result.index(after: i)
	}

	public subscript(_ index: Int) -> Result {
		return result[index]
	}

}

extension SearchResult.Page: RandomAccessCollection {

	public var startIndex: Int {
		return results.startIndex
	}

	public var endIndex: Int {
		return results.endIndex
	}

	public func index(after i: Int) -> Int {
		return results.index(after: i)
	}

	public subscript(_ index: Int) -> Result {
		return results[index]
	}

}

// MARK: Decodable

extension SearchResult: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "\(type(of: self))(\(count) result\(count == 1 ? "" : "s"))"
	}

}

extension SearchResult.Page: CustomDebugStringConvertible {

	public var debugDescription: String {
		return "\(type(of: self))<\(Result.self)>(\(count) result\(count == 1 ? "" : "s"))"
	}

}

// MARK: Decodable

extension SearchResult: Decodable {

	enum CodingKeys: String, CodingKey {
		case result
		case total = "cnt"
		case offset
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		let decodedResult = try container.decodeIfPresent(Page.self, forKey: .result) ?? Page()

		result = decodedResult
		total = try container.decodeIfPresent(Int.self, forKey: .total) ?? decodedResult.count
		offset = try container.decodeIfPresent(Int.self, forKey: .offset) ?? 0
	}

}

extension SearchResult.Page: Decodable {

	enum CodingKeys: String, CodingKey {
		case results
		case fields
		case keys
	}

	public init(from decoder: Decoder) throws {
		if var container = try? decoder.unkeyedContainer() {
			// Attempt to decode an array of `Result` values.
			var decodedResults: [Result] = []

			while !container.isAtEnd {
				decodedResults.append(try container.decode(Result.self))
			}

			results = decodedResults
			fields = [:]
			keys = []
		}
		else {
			// Fall back to decoding based on `CodingKeys`.
			let container = try decoder.container(keyedBy: CodingKeys.self)
			results = try container.decodeIfPresent([Result].self, forKey: .results) ?? []
			fields = try container.decodeIfPresent([String: String].self, forKey: .fields) ?? [:]
			keys = try container.decodeIfPresent([String].self, forKey: .keys) ?? []
		}
	}

}
