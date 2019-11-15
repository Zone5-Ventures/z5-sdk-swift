import Foundation

struct ConvertFromJava {

	static let typeDef = "[\\w\\d\\<\\[\\>\\],:\\s]+?"

	///
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

	enum Action {
		case prepend(_ string: String)
		case append(_ string: String)
		case replace(_ target: String, with: String, options: String.CompareOptions = [])
		case remove(_ target: String, options: String.CompareOptions = [])
	}

	/// Create a project directory URL based on the source file's path.
	/// - Note: This value depends directly on the location of _this_ source file's path relative to the root directory.
	///		If the script is moved, this definition should be updated in order for the script to work as expected.
	let projectDirectory = URL(fileURLWithPath: #file).appendingPathComponent("../../Zone5").standardizedFileURL

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

ConvertFromJava()
