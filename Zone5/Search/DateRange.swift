import Foundation

public struct DateRange: Codable {

	/// An (optional) display name for the range.
	public var name: String?

	/// The low end timestamp in this range. A unix timestamp in milliseconds.
	public var floor: Milliseconds

	/// The high end timestamp in this range. A unix timestamp in milliseconds.
	public var ceiling: Milliseconds

	/// The timezone used as the basis of the timestamps this date range.
	public var timeZone: TimeZone

	/// The default calendar used in generating `DateRange` instances.
	/// This defaults to `Calendar.autoupdatingCurrent`, and is used both for default timezones as well as generating
	/// ranges based on calendar components via `DateRange.init(name:component:value:starting:)`.
	public static var calendar = Calendar.autoupdatingCurrent

	/// Creates a date range with the given values.
	/// - Parameters:
	///   - name: An (optional) display name for the range.
	///   - floor: The lowest timestamp covered by the range.
	///   - ceiling: The highest timestamp covered by the range.
	///   - timeZone: The timezone used as the basis of the timestamps this date range.
	public init(name: String? = nil, floor: Milliseconds, ceiling: Milliseconds, timeZone: TimeZone = DateRange.calendar.timeZone) {
		precondition(floor<=ceiling)

		self.name = name
		self.floor = floor
		self.ceiling = ceiling
		self.timeZone = timeZone
	}

	public init(name: String? = nil, floor: MillisecondsRepresentable, ceiling: MillisecondsRepresentable, timeZone: TimeZone = DateRange.calendar.timeZone) {
		self.init(name: name, floor: floor.milliseconds, ceiling: ceiling.milliseconds, timeZone: timeZone)
	}

	/// Creates a date range that covers a period defined by `component` multiplied by `value`, starting from the given `starting` unix timestamp.
	/// - Parameters:
	///   - name: An (optional) display name for the range.
	///   - component: A single component to add.
	///   - value: The number of the specified `component` to add.
	///   - starting: A unix timestamp in milliseconds to use as the starting point for generating the date range. Defaults to `Milliseconds.now`.
	public init?(name: String? = nil, component: Calendar.Component, value: Int, starting: Milliseconds = .now) {
		guard let ending = DateRange.calendar.date(byAdding: component, value: value, to: starting.date) else {
			return nil
		}

		if ending.milliseconds >= starting {
			self.init(name: name, floor: starting, ceiling: ending.milliseconds, timeZone: DateRange.calendar.timeZone)
		}
		else {
			self.init(name: name, floor: ending.milliseconds, ceiling: starting, timeZone: DateRange.calendar.timeZone)
		}
	}

	/// Creates a date range that covers a period defined by `component` multiplied by `value`, starting from the given `starting` unix timestamp.
	/// - Parameters:
	///   - name: An (optional) display name for the range.
	///   - component: A single component to add.
	///   - value: The number of the specified `component` to add.
	///   - starting: A unix timestamp in milliseconds to use as the starting point for generating the date range.
	public init?(name: String? = nil, component: Calendar.Component, value: Int, starting: MillisecondsRepresentable) {
		self.init(name: name, component: component, value: value, starting: starting.milliseconds)
	}

	// MARK: Encodable

	enum CodingKeys: String, CodingKey {
		case name
		case floor = "floorTs"
		case ceiling = "ceilTs"
		case timeZone = "tz"
	}

	enum DecodingError: Swift.Error {
		case invalidTimeZoneIdentifier(identifier: String)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		name = try container.decodeIfPresent(String.self, forKey: .name)
		floor = try container.decode(Milliseconds.self, forKey: .floor)
		ceiling = try container.decode(Milliseconds.self, forKey: .ceiling)

		if let timeZoneIdentifier = try container.decodeIfPresent(String.self, forKey: .timeZone) {
			guard let decodedTimezone = TimeZone(identifier: timeZoneIdentifier) else {
				throw DecodingError.invalidTimeZoneIdentifier(identifier: timeZoneIdentifier)
			}

			timeZone = decodedTimezone
		}
		else {
			timeZone = DateRange.calendar.timeZone
		}
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(name, forKey: .name)
		try container.encode(floor, forKey: .floor)
		try container.encode(ceiling, forKey: .ceiling)
		try container.encode(timeZone.identifier, forKey: .timeZone)
	}

}
