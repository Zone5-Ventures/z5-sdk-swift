import Foundation

public class APIView {

	internal weak var zone5: Zone5?

	internal init(zone5: Zone5) {
		self.zone5 = zone5
	}

	/// Executes the given `block`, calling the `completionHandler` if an error is thrown.
	internal func perform<T>(with completionHandler: @escaping (_ result: Result<T, Zone5.Error>) -> Void, _ block: (_ zone5: Zone5) throws -> Void) {
		do {
			guard let zone5 = zone5 else {
				throw Zone5.Error.unknown
			}

			try block(zone5)
		}
		catch {
			if let error = error as? Zone5.Error {
				completionHandler(.failure(error))
			}
			else {
				completionHandler(.failure(.unknown))
			}
		}
	}

}
