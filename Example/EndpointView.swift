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

	init(title: String, apiClient: Zone5 = .shared, handler: @escaping Handler) {
		self.title = title
		self.apiClient = apiClient
		self.handler = handler
	}

	@State private var list = ObjectView(object: nil)

	var body: some View {
		return list
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
		error = nil
		isLoading = true
		handler(apiClient, handlerDidComplete)
	}

	private func handlerDidComplete(_ result: Result<Response, Zone5.Error>) -> Void {
		defer { isLoading = false }

		switch result {
		case .success(let response):
			list = ObjectView(object: response)

		case .failure(let response):
			error = response
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
