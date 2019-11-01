import Foundation

protocol HTTPEndpoint {

	var uri: String { get }

	var requiresAccessToken: Bool { get }

}

extension HTTPEndpoint {

	var requiresAccessToken: Bool {
		return true
	}

}

extension HTTPEndpoint where Self: RawRepresentable, Self.RawValue == String {

	var uri: String {
		return rawValue
	}

}
