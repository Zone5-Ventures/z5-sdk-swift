public class Zone5 {

	/// Shared instance of the Zone5 SDK
	public static let shared = Zone5()

	// MARK: Configuring the SDK

	/// The clientID, as provided by Zone5.
	public private(set) var clientID: String?

	/// The secret key, as provided by Zone5.
	public private(set) var secret: String?

	/// The secret key, as provided by Zone5.
	public private(set) var redirect: String = "https://localhost"

	/// Configures the SDK to use the application specified by the given `clientID` and `secret`.
	/// - Parameter clientID: The clientID, as provided by Zone5.
	/// - Parameter secret: The secret key, as provided by Zone5.
	/// - Parameter redirect: The redirect value, as provided by Zone5.
	public func configure(clientID: String, secret: String, redirect: String) {
		self.clientID = clientID
		self.secret = secret
		self.redirect = redirect
	}

}
