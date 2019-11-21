import Foundation

public struct User: Codable {

	/// Unique user id (within Z5/TP database)
	public var id: Int?

	/// Unique user uuid within single sign on domain
	public var uid: String?

	/// Unique email address
	public var email: String?

	public var firstName: String?

	public var lastName: String?

	/// URL to an avatar image
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
