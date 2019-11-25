import Foundation

public struct UserWorkoutResultChannel: Codable {

	/// A nice field display name
	public var name: String?

	/// The mapped field type
	public var type: MappedFieldType?

	/// The native record number
	public var recordNumber: Int?

	public init() {}

	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case name
		case type
		case recordNumber = "num"
	}

}
