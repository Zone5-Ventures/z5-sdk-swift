//
//  EndpointView.swift
//  Zone5 Example
//
//  Created by Daniel Farrelly on 25/10/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

import SwiftUI
import Zone5

struct EndpointView<Response>: View {

	typealias Handler = (_ client: Zone5, _ completion: @escaping (_ result: Result<Response, Zone5.Error>) -> Void) -> Void

	let apiClient: Zone5

	let title: String

	let handler: Handler

	@Environment(\.presentationMode) var presentationMode

	@State private var isLoading = true

	@State private var error: Zone5.Error? {
		didSet { displayingError = (error != nil) }
	}

	@State private var displayingError = false

	@State private var properties: [PropertyRepresentation] = []

	struct ObjectRepresentation: Identifiable {

		var id = UUID()

		var properties: [PropertyRepresentation]

	}

	struct PropertyRepresentation: Identifiable {

		var id = UUID()

		var label: String

		var value: Text

	}

	init(title: String, apiClient: Zone5 = .shared, handler: @escaping Handler) {
		self.title = title
		self.apiClient = apiClient
		self.handler = handler
	}

	var body: some View {
		List(properties, rowContent: { property in
			VStack(alignment: .leading, spacing: 5) {
				Text(property.label)
					.font(.footnote)
					.foregroundColor(.secondary)
				property.value
					.font(.system(.body, design: .monospaced))
			}
		})
		.onAppear {
			self.performHandler()
		}
		.alert(isPresented: $displayingError) {
			let title = Text("An Error Occurred")
			let message = Text(error?.debugDescription ?? "nil")
			return Alert(title: title,
						 message: message,
						 primaryButton: .cancel { self.presentationMode.wrappedValue.dismiss() },
						 secondaryButton: .default(Text("Try Again"), action: self.performHandler))
		}
		.listStyle(GroupedListStyle())
		.navigationBarItems(trailing: ActivityIndicator(isAnimating: $isLoading))
		.navigationBarTitle(title)
	}

	private func performHandler() -> Void {
		self.error = nil
		self.isLoading = true
		self.handler(self.apiClient, self.handlerDidComplete)
	}

	private func handlerDidComplete(_ result: Result<Response, Zone5.Error>) -> Void {
		defer { self.isLoading = false }

		switch result {
		case .success(let response):
			let mirrors: [Mirror]
			if let array = response as? Array<Any> {
				mirrors = array.map { Mirror(reflecting: $0) }
			}
			else {
				mirrors = [Mirror(reflecting: response)]
			}

			self.properties = mirrors.flatMap { $0.children }.compactMap { child in
				print(child)

				guard let label = child.label else {
					return nil
				}

				let value: Text

				if let optional = child.value as? OptionalProtocol {
					if optional.containsValue {
						value = Text("nil").foregroundColor(.secondary).italic()
					}
					else {
						value = displayValue(for: optional.wrappedValue)
					}
				}
				else {
					value = displayValue(for: child.value)
				}

				return PropertyRepresentation(label: label, value: value)
			}

		case .failure(let error):
			self.error = error
		}
	}

	private func displayValue(for value: Any) -> Text {
		let type = Swift.type(of: value)
		var foregroundColor: Color?

		if type == String.self {
			foregroundColor = .black
		}
		else if type == Int.self || type == Int8.self || type == Int16.self || type == Int32.self || type == Int64.self || type == UInt.self || type == UInt8.self || type == UInt16.self || type == UInt32.self || type == UInt64.self || type == Double.self || type == Float.self {
			foregroundColor = .blue
		}
		else {
			foregroundColor = .green
		}

		var displayValue = Text(String(describing: value))

		if let foregroundColor = foregroundColor {
			displayValue = displayValue.foregroundColor(foregroundColor)
		}

		return displayValue
	}

}

protocol OptionalProtocol {

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

struct EndpointView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			NavigationView {
				EndpointView<User>(title: "User", handler: { _, completion in
					var user = User()
					user.id = 12345
					user.email = "jane.smith@example.com"
					user.firstName = "Jane"
					user.lastName = "Smith"

					completion(.success(user))
				})
			}
			NavigationView {
				EndpointView<[User]>(title: "Users", handler: { _, completion in
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

					completion(.success([user1, user2]))
				})
			}
		}
    }
}
