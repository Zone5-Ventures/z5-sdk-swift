import Foundation

public struct DateRange: Codable {

	public var name: String?

	/// The low end timestamp in this range. A unix timestamp in milliseconds.
	public var floor: TimeInterval

	/// The low end timestamp in this range. A unix timestamp in milliseconds.
	public var ceiling: TimeInterval

	public var timeZone: TimeZone

	public init(name: String? = nil, floor: TimeInterval, ceiling: TimeInterval, timeZone: TimeZone = DateRange.calendar.timeZone) {
		self.name = name
		self.floor = floor
		self.ceiling = ceiling
		self.timeZone = timeZone
	}

	public init(name: String? = nil, floor: Date, ceiling: Date, timeZone: TimeZone = DateRange.calendar.timeZone) {
		self.init(name: name, floor: floor.timeIntervalSince1970, ceiling: ceiling.timeIntervalSince1970, timeZone: timeZone)
	}

	public init?(name: String? = nil, component: Calendar.Component, value: Int, starting: Date = .init()) {
		guard let ending = DateRange.calendar.date(byAdding: component, value: value, to: starting) else {
			return nil
		}

		if ending >= starting {
			self.init(name: name, floor: starting, ceiling: ending, timeZone: DateRange.calendar.timeZone)
		}
		else {
			self.init(name: name, floor: ending, ceiling: starting, timeZone: DateRange.calendar.timeZone)
		}
	}

	public static var calendar = Calendar.autoupdatingCurrent

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
		floor = try container.decode(TimeInterval.self, forKey: .floor) / 1000
		ceiling = try container.decode(TimeInterval.self, forKey: .ceiling) / 1000

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
		try container.encode(Int(floor * 1000), forKey: .floor)
		try container.encode(Int(ceiling * 1000), forKey: .ceiling)
		try container.encode(timeZone.identifier, forKey: .timeZone)
	}

}
