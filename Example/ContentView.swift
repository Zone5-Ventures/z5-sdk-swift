//
//  ContentView.swift
//  Zone5 Example
//
//  Created by Daniel Farrelly on 8/10/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import SwiftUI
import Zone5

struct ContentView: View {

	let apiClient: Zone5

	@State var keyValueStore: KeyValueStore = .shared

	init(apiClient: Zone5 = .shared, keyValueStore: KeyValueStore = .shared) {
		self.apiClient = apiClient
		self.keyValueStore = keyValueStore

		// Do not use UserDefaults for storing user credentials in a production application. It is incredibly insecure,
		// and a terrible idea. Don't do it.
		//
		// If you have stored your AccessToken (nice and securely), you can quite easily configure the SDK to use that
		// at any point, and completely bypass configuring the clientID and clientSecret, which are only used as part of
		// the user authentication process.
		let baseURL = keyValueStore.baseURL
		if !keyValueStore.clientID.isEmpty, !keyValueStore.clientSecret.isEmpty {
			apiClient.configure(for: baseURL, clientID: keyValueStore.clientID, clientSecret: keyValueStore.clientSecret, accessToken: keyValueStore.accessToken)
		}
		else if let accessToken = keyValueStore.accessToken {
			apiClient.configure(for: baseURL, accessToken: accessToken)
		}
	}

	@State var displayConfiguration = false

	var body: some View {
		NavigationView {
			List {
				Section(header: Text("Zone5"), footer: Text("In order to test the endpoints for the Zone5 API, the app requires configuration of the API URL, and a valid access token.")) {
					Button("Configure Client", action: {
						self.displayConfiguration = true
					})
				}
				Section(header: Text("Users")) {
					EndpointLink("Me") { client, completion in
						client.users.me(completion: completion)
					}
				}
				Section(header: Text("Activities"), footer: Text("Attempting to view \"Next Page\" before performing a legitimate search request—such as by opening the \"Next 3 Months\" screen—will return an empty result.")) {
					EndpointLink<SearchResult<Activity>>("Next 3 Months") { client, completion in
						var criteria = UserWorkoutSearch()
						criteria.rangesTs = [DateRange(component: .month, value: 3)!]
						criteria.order = [.ascending(.timestamp)]

						let parameters = SearchInput(criteria: criteria)

						client.activities.search(parameters, offset: 0, count: 10, completion: completion)
					}
					EndpointLink("Next Page") { client, completion in
						client.activities.next(offset: 10, count: 10, completion: completion)
					}
				}
				Section(footer: Text("Uploads a test file to the API.")) {
					EndpointLink<DataFileUploadIndex>("Upload File") { client, completion in
						guard let fileURL = Bundle.main.url(forDevelopmentAsset: "2013-12-22-10-30-12", withExtension: "fit") else {
							completion(.failure(.unknown))

							return
						}

						var context = DataFileUploadContext()
						context.equipment = .gravel
						context.name = "Epic Ride"
						//context.bikeID = "d584c5cb-e81f-4fbe-bc0d-667e9bcd2c4c" // TODO: Does bikeID exist? It's not defined in java.

						client.activities.upload(fileURL, context: context, completion: completion)
					}
				}
			}
			.listStyle(GroupedListStyle())
			.navigationBarTitle("Zone5 Example")
		}
		.sheet(isPresented: $displayConfiguration) {
			ConfigurationView(apiClient: self.apiClient, keyValueStore: self.keyValueStore)
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
