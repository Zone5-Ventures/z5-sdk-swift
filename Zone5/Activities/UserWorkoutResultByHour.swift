import Foundation

/// By hour averages
public struct UserWorkoutResultByHour: Codable {

	/// Average watts in hour 1
	public var avgW1: Int?
	/// kj in hour 1
	public var kj1: Int?
	/// kj per kg in hour 1
	public var kjhkg1: Double?

	public var avgW2: Int?
	public var kj2: Int?
	public var kjhkg2: Double?

	public var avgW3: Int?
	public var kj3: Int?
	public var kjhkg3: Double?

	public var avgW4: Int?
	public var kj4: Int?
	public var kjhkg4: Double?

	public var avgW5: Int?
	public var kj5: Int?
	public var kjhkg5: Double?

	public var avgW6: Int?
	public var kj6: Int?
	public var kjhkg6: Double?

	public var avgW7: Int?
	public var kj7: Int?
	public var kjhkg7: Double?

	public var avgW8: Int?
	public var kj8: Int?
	public var kjhkg8: Double?

	public var avgW9: Int?
	public var kj9: Int?
	public var kjhkg9: Double?

	public var avgW10: Int?
	public var kj10: Int?
	public var kjhkg10: Double?

	public var avgW11: Int?
	public var kj11: Int?
	public var kjhkg11: Double?

	public var avgW12: Int?
	public var kj12: Int?
	public var kjhkg12: Double?

	public init() {}
	
	public enum CodingKeys: String, CodingKey, CaseIterable {
		case avgW1
		case kj1
		case kjhkg1
		case avgW2
		case kj2
		case kjhkg2
		case avgW3
		case kj3
		case kjhkg3
		case avgW4
		case kj4
		case kjhkg4
		case avgW5
		case kj5
		case kjhkg5
		case avgW6
		case kj6
		case kjhkg6
		case avgW7
		case kj7
		case kjhkg7
		case avgW8
		case kj8
		case kjhkg8
		case avgW9
		case kj9
		case kjhkg9
		case avgW10
		case kj10
		case kjhkg10
		case avgW11
		case kj11
		case kjhkg11
		case avgW12
		case kj12
		case kjhkg12
	}

	public static func fields(_ fields: [CodingKeys] = CodingKeys.allCases, prefix: String) -> [String] {
		return fields.map { "\(prefix).\($0.rawValue)" }
	}
}
