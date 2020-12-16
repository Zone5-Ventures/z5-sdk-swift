//
//  ObjectView.swift
//  Zone5 Example
//
//  Created by Daniel Farrelly on 25/10/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

import SwiftUI
import Zone5

struct ObjectView: View {

	let object: Any?

	init(object: Any?) {
		self.object = object
	}

	struct PropertyRepresentation: Identifiable {

		var id = UUID()

		var label: String

		var value: Text

		var object: Any?

	}

	private var properties: [PropertyRepresentation] {
		var properties: [PropertyRepresentation] = []

		if let array = object as? Array<Any> {
			for (i, element) in array.enumerated() {
				properties.append(property(for: element, label: "Index \(i)"))
			}
		}
		else if let dict = object as? Dictionary<String,Any> {
			for (_, (key, value)) in dict.enumerated() {
				properties.append(property(for: value, label: key))
			}
		}
		else if let b = object as? Bool {
			properties.append(property(for: b, label: "result"))
		}
		else if let s = object as? String{
			properties.append(property(for: s, label: "result"))
		}
		else if let url = object as? URL {
			properties.append(property(for: url, label: "url"))
			properties.append(property(for: (try? url.resourceValues(forKeys:[.fileSizeKey]).fileSize) ?? 0, label: "filesize"))
		}
		else if let object = object {
			for child in Mirror(reflecting: object).children {
				guard let label = child.label else {
					continue
				}

				properties.append(property(for: child.value, label: label))
			}
		}

		return properties
	}

	var body: some View {
		List {
			ForEach(properties) { property -> AnyView in
				let stack = VStack(alignment: .leading, spacing: 5) {
					Text(property.label)
						.font(.footnote)
						.foregroundColor(.secondary)
						.lineLimit(1)
					property.value
						.font(.system(.body, design: .monospaced))
						.lineLimit(property.object == nil ? 10 : 1)
				}

				if let object = property.object {
					let objectView = ObjectView(object: object)
						.navigationBarTitle("\(property.label)", displayMode: .inline)

					return AnyView(NavigationLink(destination: objectView) {
						return stack
					})
				}
				else {
					return AnyView(stack)
				}
			}
		}
		.listStyle(GroupedListStyle())
	}

	private func property(for value: Any, label: String) -> PropertyRepresentation {
		if let optional = value as? OptionalProtocol {
			if optional.containsValue {
				return property(for: optional.wrappedValue, label: label)
			}
			else {
				let value = Text("nil").foregroundColor(.secondary).italic()
				return PropertyRepresentation(label: label, value: value, object: nil)
			}
		}
		else {
			let mirror = Mirror(reflecting: value)
			var objectForNavigation: Any?
			let displayValue: Text

			if case .enum = mirror.displayStyle {
				displayValue = Text(String(describing: value))
					.foregroundColor(.purple)

				if let associatedValues = mirror.children.first?.value {
					objectForNavigation = associatedValues
				}
			}
			else if mirror.subjectType == String.self {
				displayValue = Text(String(describing: value))
			}
			else if mirror.subjectType == Int.self || mirror.subjectType == Int8.self || mirror.subjectType == Int16.self || mirror.subjectType == Int32.self || mirror.subjectType == Int64.self || mirror.subjectType == UInt.self || mirror.subjectType == UInt8.self || mirror.subjectType == UInt16.self || mirror.subjectType == UInt32.self || mirror.subjectType == UInt64.self || mirror.subjectType == Double.self || mirror.subjectType == Float.self {
				displayValue = Text(String(describing: value))
					.foregroundColor(.blue)
			}
			else {
				displayValue = Text(String(describing: value))
					.foregroundColor(.green)

				if !mirror.children.isEmpty {
					objectForNavigation = value
				}
			}

			return PropertyRepresentation(label: label, value: displayValue, object: objectForNavigation)
		}
	}

}

private protocol OptionalProtocol {

	var containsValue: Bool { get }

	var wrappedValue: Any { get }

}

extension Optional: OptionalProtocol {

	var containsValue: Bool {
		switch self {
		case .some(_): return true
		case .none: return false
		}
	}

	var wrappedValue: Any {
		switch self {
		case .some(let value): return value
		case .none: fatalError()
		}
	}

}

struct ObjectView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			NavigationView { () -> ObjectView in
				var user = User()
				user.id = 12345
				user.email = "jane.smith@example.com"
				user.firstName = "Jane"
				user.lastName = "Smith"

				return ObjectView(object: user)
			}
			NavigationView { () -> ObjectView in
				var user1 = User()
				user1.id = 12345
				user1.email = "jane.smith@example.com"
				user1.firstName = "Jane"
				user1.lastName = "Smith"

				var user2 = User()
				user2.id = 67890
				user2.email = "john.smith@example.com"
				user2.firstName = "John"
				user2.lastName = "Smith"

				return ObjectView(object: [user1, user2])
			}
		}
    }
}
