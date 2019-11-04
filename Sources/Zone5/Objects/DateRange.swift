import Foundation

public struct DateRange: Encodable {

	public var name: String?

	/// The low end timestamp in this range. A unix timestamp in milliseconds.
	public var floor: TimeInterval

	/// The low end timestamp in this range. A unix timestamp in milliseconds.
	public var ceiling: TimeInterval

	public var timezone: TimeZone

	public init(name: String? = nil, floor: TimeInterval, ceiling: TimeInterval, timezone: TimeZone = DateRange.calendar.timeZone) {
		self.name = name
		self.floor = floor
		self.ceiling = ceiling
		self.timezone = timezone
	}

	public init(name: String? = nil, floor: Date, ceiling: Date, timezone: TimeZone = DateRange.calendar.timeZone) {
		self.name = name
		self.floor = floor.timeIntervalSince1970
		self.ceiling = ceiling.timeIntervalSince1970
		self.timezone = timezone
	}

	public init?(name: String? = nil, component: Calendar.Component, value: Int, starting: Date = .init()) {
		guard let ending = DateRange.calendar.date(byAdding: component, value: value, to: starting) else {
			return nil
		}

		if ending >= starting {
			self.init(name: name, floor: starting, ceiling: ending, timezone: DateRange.calendar.timeZone)
		}
		else {
			self.init(name: name, floor: ending, ceiling: starting, timezone: DateRange.calendar.timeZone)
		}
	}

	public static var calendar: Calendar = {
		var calendar = Calendar(identifier: .iso8601)
		calendar.timeZone = .current
		return calendar
	}()

	// MARK: Encodable

	enum CodingKeys: String, CodingKey {
		case name
		case floor = "floorTs"
		case ceiling = "ceilTs"
		case timezone = "tz"
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(name, forKey: .name)
		try container.encode(Int(floor * 1000), forKey: .floor)
		try container.encode(Int(ceiling * 1000), forKey: .ceiling)
		try container.encode(timezone.identifier, forKey: .timezone)
	}

}
