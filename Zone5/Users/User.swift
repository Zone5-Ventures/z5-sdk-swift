import Foundation

/// Model object representing a User
public struct User: Codable, JSONEncodedBody {

	/// Unique user id (within Z5/TP database)
	public var id: Int?

	/// Unique user uuid within single sign on domain
	public var uuid: String?
	
	/// User's log in password
	public var password: String?

	/// Unique email address
	public var email: String?

	public var firstName: String?

	public var lastName: String?

	/// URL to an avatar image
	public var avatar: URL?
	
	/// User's Locale
	public var locale: String?

	public init() { }
	public init(email: String, password: String, firstname: String, lastname: String) {
		self.email = email
		self.password = password
		self.firstName = firstname
		self.lastName = lastname
	}

	// MARK: Codable

	private enum CodingKeys: String, CodingKey {
		case id
		case uuid
		case password
		case email
		case firstName = "firstname"
		case lastName = "lastname"
		case avatar
		case locale
	}

}
