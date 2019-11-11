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

	let title: String

	@ObservedObject var controller: EndpointController<Response>

	init(_ title: String, controller: EndpointController<Response>) {
		self.title = title
		self.controller = controller
	}

	init(_ title: String, apiClient: Zone5 = .shared, handler: @escaping EndpointController<Response>.Handler) {
		self.init(title, controller: EndpointController(apiClient: apiClient, handler: handler))
	}

	var body: some View {
		return ObjectView(object: controller.response ?? controller.error)
		.onAppear {
			guard self.controller.result == nil else {
				return
			}

			self.controller.perform()
		}
		.alert(isPresented: $controller.shouldDisplayError) {
			let title = Text("An Error Occurred")
			let message = Text(controller.error?.debugDescription ?? "nil")
			return Alert(title: title,
						 message: message,
						 primaryButton: .cancel(),
						 secondaryButton: .default(Text("Try Again"), action: self.controller.perform))
		}
		.navigationBarItems(trailing: HStack {
			ActivityIndicator(isAnimating: $controller.isLoading)

			if self.controller.result != nil {
				Button("Reload", action: self.controller.perform)
			}
		})
		.navigationBarTitle(title)
	}

}

struct EndpointView_Previews: PreviewProvider {
    static var previews: some View {
		Group {
			NavigationView {
				EndpointView<User>("User", handler: { _, completion in
					var user = User()
					user.id = 12345
					user.email = "jane.smith@example.com"
					user.firstName = "Jane"
					user.lastName = "Smith"

					completion(.success(user))
				})
			}
			NavigationView {
				EndpointView<[User]>("Users", handler: { _, completion in
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
