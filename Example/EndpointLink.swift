//
//  EndpointLink.swift
//  Zone5 Example
//
//  Created by Daniel Farrelly on 25/10/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import SwiftUI
import Zone5

protocol AnyParameter: class {

}

class Parameter<Value>: AnyParameter {

	var label: String

	var value: Value?

	init(label: String) {
		self.label = label
	}

}

struct EndpointLink<Response>: View {

	let title: String

	let handler: EndpointView<Response>.Handler

	init(_ title: String, handler: @escaping EndpointView<Response>.Handler) {
		self.title = title
		self.handler = handler
	}

	var body: some View {
		return NavigationLink(title, destination: EndpointView<Response>(title: title, handler: handler))
	}

}

struct EndpointLink_Previews: PreviewProvider {
    static var previews: some View {
		Form {
			EndpointLink<User>("User") { _, completion in
				var user = User()
				user.id = 12345
				user.email = "jane.smith@example.com"
				user.firstName = "Jane"
				user.lastName = "Smith"

				completion(.success(user))
			}
		}
    }
}

