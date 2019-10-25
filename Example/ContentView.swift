//
//  ContentView.swift
//  Zone5 Example
//
//  Created by Daniel Farrelly on 8/10/19.
//  Copyright © 2019 JellyStyle Media. All rights reserved.
//

import SwiftUI
import Zone5

struct ContentView: View {

	let apiClient: Zone5

	init(apiClient: Zone5 = .shared) {
		self.apiClient = apiClient
	}

	@State var displayConfiguration = false

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Zone5"), footer: Text("In order to test the endpoints for the Zone5 API, the app requires configuration of the API URL, the client's ID and secret, and user authentication details.")) {
					Button("Configure Client", action: {
						self.displayConfiguration = true
					})
				}
				Section(header: Text("Users")) {
					EndpointLink("Me") { client, completion in
						client.users.me(completion: completion)
					}
				}
			}
			.listStyle(GroupedListStyle())
			.navigationBarTitle("Zone5 Example")
		}
		.sheet(isPresented: $displayConfiguration) {
			ConfigurationView()
		}
		.onAppear {
			if !self.apiClient.isConfigured {
				self.displayConfiguration = true
			}
		}
	}

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
