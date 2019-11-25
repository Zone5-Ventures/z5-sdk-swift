import Foundation

@dynamicMemberLookup
/// An enumeration that provides indirection for recursive structures through a single case, `.indirect(_:)`. It has a
/// number of conditional protocol conformances that allow an `Indirect` value to be treated as if if was the wrapped
/// value it contains.
public indirect enum Indirect<Wrapped> {

	/// Case containing the structure's wrapped value.
	case indirect(Wrapped)

	/// Property that provides access to the indirect value.
	var value: Wrapped {
		switch self {
		case .indirect(let value): return value
		}
	}

	/// This subscript allows us to access properties on the wrapped object as if we were accessing them directly.
    subscript<T>(dynamicMember keyPath: KeyPath<Wrapped, T>) -> T {
		return value[keyPath: keyPath]
    }

}

extension Indirect: Equatable where Wrapped: Equatable {

	public static func == (_ lhs: Indirect<Wrapped>, _ rhs: Indirect<Wrapped>) -> Bool {
		return lhs.value == rhs.value
	}

}

extension Indirect: Hashable where Wrapped: Hashable {

	public func hash(into hasher: inout Hasher) {
		hasher.combine(value)
	}

}

extension Indirect: Decodable where Wrapped: Decodable {

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let value = try container.decode(Wrapped.self)

		self = .indirect(value)
	}

}

extension Indirect: Encodable where Wrapped: Encodable {

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(value)
	}

}
