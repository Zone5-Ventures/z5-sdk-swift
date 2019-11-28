import Foundation

/// Definition of a script that can be used to help convert a basic Java class to Swift format. It is not intended to
/// cover all scenarios, and the files output will require manual cleanup before being used.
struct ConvertFromJava {

	/// A regex pattern that should cover _most_ Java type definitions, i.e. `Map<String, List<Int, Boolean>>`
	static let typeDef = "[\\w\\d\\<\\[\\>\\],:\\s]+?"

	/// The various actions performed, in the sequence that they are defined.
	var actions: [Action] = [
		.remove("(package|import)\\s+[\\w\\d\\.]+;", options: .regularExpression),
		.replace("public\\s+class\\s+(\(ConvertFromJava.typeDef))\\s*\\{", with: "public struct $1 {", options: .regularExpression),
		.replace("public\\s+(\(ConvertFromJava.typeDef))\\(\\)\\s*\\{\\s*\\}", with: "public init() {}", options: .regularExpression),
		.prepend("import Foundation\n\n"),

		// Removes getters and setters
		.replace("private\\s+(\(ConvertFromJava.typeDef))\\s+([\\w\\d]+);", with: "public var $2: $1?", options: .regularExpression),
		.remove("public\\s+(\(ConvertFromJava.typeDef))\\s+(get|set)[\\w\\d]+\\([^\\)]*\\)\\s*\\{[^\\{\\}]*\\}", options: .regularExpression),

		// Replace types
		.replace("Map<(\(ConvertFromJava.typeDef)), (\(ConvertFromJava.typeDef))>", with: "[$1: $2]", options: .regularExpression),
		.replace("List<(\(ConvertFromJava.typeDef))>", with: "[$1]", options: .regularExpression),
		.replace("Boolean", with: "Bool"),
		.replace("Long", with: "Int"),
		.replace("Integer", with: "Int"),
		.replace("Short", with: "Int"),

		// Convert comments to swift doc
		.replace("/\\*\\*\\s+(\\*\\s+)*", with: "/// ", options: .regularExpression),
		.remove("(\\s+\\*\\s+)*\\s+\\*/", options: .regularExpression),
		.replace("[ \\t]+\\*[ \\t]*", with: "/// ", options: .regularExpression),

		// Cleans up newlines
		.replace("[ \\t]+\n", with: "\n", options: .regularExpression),
		.replace("\\n{3,}", with: "\n\n", options: .regularExpression),
	]

	/// Definitions of the basic actions that can be performed in the `actions` collection defined above.
	enum Action {

		/// Adds the given string to the beginning of the file's contents.
		case prepend(_ string: String)

		/// Adds the given string to the end of the file's contents.
		case append(_ string: String)

		/// Replaces occurrences of the `target` string with the given replacement, using the given options.
		case replace(_ target: String, with: String, options: String.CompareOptions = [])

		/// Replaces occurrences of the `target` string with an empty string, using the given options.
		case remove(_ target: String, options: String.CompareOptions = [])

	}

	/// Create a project directory URL based on the source file's path.
	/// - Note: This value depends directly on the location of _this_ source file's path relative to the root directory.
	///		If the script is moved, this definition should be updated in order for the script to work as expected.
	let projectDirectory = URL(fileURLWithPath: #file).appendingPathComponent("../../Zone5").standardizedFileURL

	/// Initialises an instance of `ConvertFromJava`, but also performs the `actions` defined on all files found with a
	/// `.java` file extension and creates a new `.swift` file with the result.
	/// - Warning: Existing Swift files with the same name as a Java file _will be overwritten_.
	@discardableResult init() {
		let enumerator = FileManager.default.enumerator(at: projectDirectory, includingPropertiesForKeys: nil)

		print("Converting files:")

		while let sourceURL = enumerator?.nextObject() as? URL {
			guard sourceURL.pathExtension == "java" else {
				continue
			}

			let outputURL = sourceURL.deletingPathExtension().appendingPathExtension("swift")
			let sourcePath = sourceURL.absoluteString.replacingOccurrences(of: projectDirectory.absoluteString, with: "")
			let outputPath = outputURL.absoluteString.replacingOccurrences(of: projectDirectory.absoluteString, with: "")

			print("- \(sourcePath)", terminator: "")

			do {
				let data = try Data(contentsOf: sourceURL)
				guard var content = String(data: data, encoding: .utf8) else {
					continue
				}

				for step in actions {
					switch step {
					case .prepend(let string):
						content = string + content

					case .append(let string):
						content = content + string

					case .remove(let target, let options):
						content = content.replacingOccurrences(of: target, with: "", options: options, range: nil)

					case .replace(let target, let replacement, let options):
						content = content.replacingOccurrences(of: target, with: replacement, options: options, range: nil)
					}
				}

				try content.write(to: outputURL, atomically: true, encoding: .utf8)

				print(" -> \(outputPath)")
			}
			catch {
				print("\n    ERROR: \(error)")

				continue
			}
		}

		print("DONE")
	}

}

/// Initialise the `ConvertFromJava` object and run the script.
ConvertFromJava()
