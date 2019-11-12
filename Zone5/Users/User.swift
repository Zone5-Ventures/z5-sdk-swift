import Foundation

public struct User: Codable {

	public var id: Int?

	public var uid: String?

	public var email: String?

	public var firstName: String?

	public var lastName: String?

	public var avatar: URL?

	public init() { }

	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case id
		case uid
		case email
		case firstName = "firstname"
		case lastName = "lastname"
		case avatar
	}

}
