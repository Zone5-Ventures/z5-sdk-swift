import Foundation

public struct Activity: Codable, Hashable {

	/// The unique activity id.
	/// - Note: This is also referenced as a `workoutId`, `fileId` or `eventId`.
	public var id: Int?

	/// The type of activity this activity's `id` is related to.
	public var category: Category?

	public enum Category: String, Codable {
		// This enum maps to `ActivityResultType` in Java

		case event = "events"
		case workout = "workouts"
		case file = "files"
	}

	/// The sport related to this activity.
	public var sport: Sport?

	public enum Sport: String, Codable {
		// This enum maps to `ActivityType` in Java

		case ride
		case run
		case swim
		case brick
		case xtrain
		case xcski
		case row
		case gym
		case walk
		case yoga
		case other
		case multisport // a special case we use for tagging an outer activity file
		case transition // a special case for tagging transitions in tri files
	}

	/// The sport related to this activity.
	public var timestamp: Int?

	public init() { }

	// MARK: Hashable

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(category)
	}

	// MARK: Codable

	public enum Field: String, Codable, CodingKey {
		case id
		case category = "activity"
		case sport = "type"
		case timestamp = "ts"
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Field.self)
		id = try container.decodeIfPresent(Int.self, forKey: .id)
		category = try container.decodeIfPresent(Category.self, forKey: .category)
		sport = try container.decodeIfPresent(Sport.self, forKey: .sport)
		timestamp = try container.decodeIfPresent(Int.self, forKey: .timestamp)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: Field.self)
		try container.encodeIfPresent(id, forKey: .id)
		try container.encodeIfPresent(category, forKey: .category)
		try container.encodeIfPresent(sport, forKey: .sport)
		try container.encodeIfPresent(timestamp, forKey: .timestamp)
	}

}
