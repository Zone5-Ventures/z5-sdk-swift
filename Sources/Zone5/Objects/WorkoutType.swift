import Foundation

public enum WorkoutType: String, Codable {

	/// Training/social ride
	case training

	/// Event / race day etc
	case event

	/// Threshold or other test day
	case test

	/// Rest day
	case rest

}
