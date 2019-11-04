import Foundation

public struct Activity: Codable {

	public var id: Int?

	public var category: Category?

	public enum Category: String, Codable {
		case event = "events"
		case workout = "workouts"
		case file = "files"
	}

	public var sport: Sport?

	public enum Sport: String, Codable {
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

	public init() { }

	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case id
		case category = "activity"
		case sport = "type"
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decodeIfPresent(Int.self, forKey: .id)
		category = try container.decodeIfPresent(Category.self, forKey: .category)
		sport = try container.decodeIfPresent(Sport.self, forKey: .sport)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encodeIfPresent(id, forKey: .id)
		try container.encodeIfPresent(category, forKey: .category)
		try container.encodeIfPresent(sport, forKey: .sport)
	}

}
