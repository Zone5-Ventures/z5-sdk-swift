import Foundation

/// Representation of time as milliseconds.
///
/// On its own, a `Milliseconds` value does not represent a unique point in time, or a span between times.

public struct Milliseconds: RawRepresentable, Hashable, CustomStringConvertible {

	public var rawValue: Int

	public init(rawValue: Int) {
		self.rawValue = rawValue
	}

	/// Initializes a `Milliseconds` value relative to 00:00:00 UTC on 1 January 1970.
	public init() {
		self = .now
	}

	/// Returns a value relative to 00:00:00 UTC on 1 January 1970 by a given number of milliseconds.
	public static var now: Milliseconds {
		return Date().milliseconds
	}

	// MARK: Converting to other types

	/// Initializes a new `Milliseconds` value based on the given `timeInterval`.
	/// - Parameter timeInterval: The value in seconds.
	init(timeInterval: TimeInterval) {
		self.init(rawValue: Int((timeInterval * 1000).rounded()))
	}

	/// Representation of the value in seconds.
	var timeInterval: TimeInterval {
		return TimeInterval(self)
	}

	/// Initializes a new `Milliseconds` value based on the given `date`'s `timeIntervalSince1970`.
	/// - Parameter date: The date value.
	init(date: Date) {
		self.init(timeInterval: date.timeIntervalSince1970)
	}

	/// Representation of the value as a `Date` value.
	var date: Date {
		return Date(self)
	}

	// MARK: CustomStringConvertible

	public var description: String {
		return "\(rawValue) milliseconds"
	}

}

extension Milliseconds: ExpressibleByIntegerLiteral {

	/// Initializer to allow a milliseconds value to be defined via an integer literal.
	/// ```
	///	let milliseconds: Milliseconds = 1574048075352
	/// ```
	public init(integerLiteral value: Int) {
		self.init(rawValue: value)
	}

}

extension Milliseconds: SignedNumeric, Strideable, Equatable, Comparable {

	// MARK: Numeric

	public init?<T>(exactly source: T) where T : BinaryInteger {
		guard let rawValue = Int(exactly: source) else {
			return nil
		}

		self.init(rawValue: rawValue)
	}

	public var magnitude: UInt {
		return rawValue.magnitude
	}

	public static func * (lhs: Milliseconds, rhs: Milliseconds) -> Milliseconds {
		return Milliseconds(rawValue: lhs.rawValue * rhs.rawValue)
	}

	public static func *= (lhs: inout Milliseconds, rhs: Milliseconds) {
		lhs.rawValue *= rhs.rawValue
	}

	public static func / (lhs: Milliseconds, rhs: Milliseconds) -> Milliseconds {
		return Milliseconds(rawValue: lhs.rawValue / rhs.rawValue)
	}

	public static func /= (lhs: inout Milliseconds, rhs: Milliseconds) {
		lhs.rawValue /= rhs.rawValue
	}

	// MARK: Strideable

	public func advanced(by n: Milliseconds) -> Milliseconds {
		return Milliseconds(rawValue: rawValue.advanced(by: n.rawValue))
	}

	public func distance(to other: Milliseconds) -> Milliseconds {
		return Milliseconds(rawValue: rawValue.distance(to: other.rawValue))
	}

	// MARK: AdditiveArithmetic

	static public var zero: Milliseconds {
		return Milliseconds(rawValue: .zero)
	}

	public static func + (lhs: Milliseconds, rhs: Milliseconds) -> Milliseconds {
		return lhs.advanced(by: rhs)
	}

	public static func += (lhs: inout Milliseconds, rhs: Milliseconds) {
		lhs = lhs + rhs
	}

	public static func - (lhs: Milliseconds, rhs: Milliseconds) -> Milliseconds {
		return lhs.advanced(by: Milliseconds(rawValue: -rhs.rawValue))
	}

	public static func -= (lhs: inout Milliseconds, rhs: Milliseconds) {
		lhs = lhs - rhs
	}

	// MARK: Comparable

	public static func < (lhs: Milliseconds, rhs: Milliseconds) -> Bool {
		return lhs.distance(to: rhs).rawValue > 0
	}

	// MARK: Equatable

	public static func == (lhs: Milliseconds, rhs: Milliseconds) -> Bool {
		return lhs.distance(to: rhs).rawValue == 0
	}

}

extension Milliseconds: Codable {

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		rawValue = try container.decode(Int.self)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}

}

/// Requirements for types that can be converted to and from milliseconds.
public protocol MillisecondsRepresentable {

	/// Initializes a new instance based on the given `milliseconds` value.
	/// - Parameter milliseconds: The value in milliseconds.
	init(_ milliseconds: Milliseconds)

	/// The value in milliseconds.
	var milliseconds: Milliseconds { get }

}

public extension MillisecondsRepresentable {

	/// Initializes a new instance based on a value that conforms to the `MillisecondsRepresentable` protocol.
	/// - Parameter value: Value that can be represented as a time interval in milliseconds.
	init(converting value: MillisecondsRepresentable) {
		self.init(value.milliseconds)
	}

}

extension TimeInterval: MillisecondsRepresentable {

	/// Creates a `TimeInterval` value by converting the given `milliseconds` to seconds.
	public init(_ milliseconds: Milliseconds) {
		self = TimeInterval(milliseconds.rawValue) / 1000
	}

	/// Returns a `Milliseconds` value by converting the value to milliseconds.
	public var milliseconds: Milliseconds {
		return Milliseconds(rawValue: Int((self * 1000).rounded()))
	}

}

extension Date: MillisecondsRepresentable {

	/// Creates a date value initialized relative to 00:00:00 UTC on 1 January 1970 by a given number of milliseconds.
	public init(_ milliseconds: Milliseconds) {
		self.init(timeIntervalSince1970: milliseconds.timeInterval)
	}

	/// The interval between the date value and 00:00:00 UTC on 1 January 1970, specified in milliseconds.
	public var milliseconds: Milliseconds {
		return timeIntervalSince1970.milliseconds
	}

}
