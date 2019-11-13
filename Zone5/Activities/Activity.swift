import Foundation

public struct Activity: Codable, Hashable {

	/// The unique activity id.
	/// - Note: This is also referenced as a `workoutId`, `fileId` or `eventId`.
	public var id: Int

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

	///
	public var name: String?

	///
	public var timestamp: Int?

	///
	public var fileID: Int?

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
		case name
		case timestamp = "ts"
		case fileID = "fileId"
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: Field.self)
		id = try container.decode(Int.self, forKey: .id)
		category = try container.decodeIfPresent(Category.self, forKey: .category)
		sport = try container.decodeIfPresent(Sport.self, forKey: .sport)
		name = try container.decodeIfPresent(String.self, forKey: .name)
		timestamp = try container.decodeIfPresent(Int.self, forKey: .timestamp)
		fileID = try container.decodeIfPresent(Int.self, forKey: .fileID)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: Field.self)
		try container.encode(id, forKey: .id)
		try container.encodeIfPresent(category, forKey: .category)
		try container.encodeIfPresent(sport, forKey: .sport)
		try container.encodeIfPresent(name, forKey: .name)
		try container.encodeIfPresent(timestamp, forKey: .timestamp)
		try container.encodeIfPresent(fileID, forKey: .fileID)
	}

}
