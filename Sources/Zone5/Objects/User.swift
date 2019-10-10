import Foundation

public struct User: Codable {

	public var id: Int

	public var uid: String?

	public var email: String?

	public var firstName: String?

	public var lastName: String?

	public var avatar: URL?

	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case id = "id"
		case uid = "uid"
		case email = "email"
		case firstName = "firstname"
		case lastName = "lastname"
		case avatar = "avatar"
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(Int.self, forKey: .id)
		uid = try container.decodeIfPresent(String.self, forKey: .uid)
		email = try container.decodeIfPresent(String.self, forKey: .email)
		firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
		lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
		avatar = try container.decodeIfPresent(URL.self, forKey: .avatar)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encodeIfPresent(uid, forKey: .uid)
		try container.encodeIfPresent(email, forKey: .email)
		try container.encodeIfPresent(firstName, forKey: .firstName)
		try container.encodeIfPresent(lastName, forKey: .lastName)
		try container.encodeIfPresent(avatar, forKey: .avatar)
	}

}
