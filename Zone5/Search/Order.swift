import Foundation

/// A structure that defines an ordering to be applied when returning a list of results.
public struct Order: Codable {

	/// The field to that the order should be applied to.
	public let field: String

	/// The direction of the sort order.
	public let direction: Direction

	/// Options for defining the direction of the sort order.
	public enum Direction: String, Codable {

		/// Indicates that values should be sorted by lowest to highest.
		case ascending = "asc"

		/// Indicates that values should be sorted by highest to lowest.
		case descending = "desc"

	}

	/// Initialises an instance of `Order`, sorting the given `field` in the given `direction`.
	private init(field: String, direction: Direction) {
		self.field = field
		self.direction = direction
	}

	// MARK: Defining order

	/// Defines an `Order` that indicates sorting by the given `field`, in ascending order.
	/// - Parameter field: The field to sort by.
	public static func ascending(_ field: String) -> Order {
		return Order(field: field, direction: .ascending)
	}

	/// Defines an `Order` that indicates sorting by the given `field`, in descending order.
	/// - Parameter field: The field to sort by.
	public static func descending(_ field: String) -> Order {
		return Order(field: field, direction: .descending)
	}

	// MARK: Codable

	enum CodingKeys: String, CodingKey {
		case field
		case direction = "order"
	}

}
