import Foundation

public struct SearchResult<Result: Codable>: Codable, RandomAccessCollection {

	public var result: MappedResult<Result>

	public var total: Int

	public var offset: Int

    // MARK: Random access collection

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

	// MARK: Encodable

	enum CodingKeys: String, CodingKey {
		case result
		case total = "cnt"
		case offset
	}

}
