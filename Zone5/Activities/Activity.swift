import Foundation

public struct Activity: Codable, Hashable {

	/// The unique activity id.
	public var id: Int

	/// The type of activity this activity's `id` is related to.
	public var activity: ActivityResultType?

	/// The sport related to this activity.
	public var type: ActivityType?

	// MARK: Hashable

	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(activity)
	}

	// MARK: Codable

	private enum CodingKeys: String, Codable, CodingKey {
		case id
		case activity
		case type
	}

}
