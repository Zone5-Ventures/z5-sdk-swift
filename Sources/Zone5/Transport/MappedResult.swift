import Foundation

public struct MappedResult<Result: Codable>: Codable, RandomAccessCollection {

	public var results: [Result]

	public var fields: [String: String]

	public var keys: [String]

	// MARK: Random access collection

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
