//
//  ConfigurationView.swift
//  Zone5 Example
//
//  Created by Daniel Farrelly on 25/10/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import SwiftUI
import Zone5

struct ConfigurationView: View {

	let apiClient: Zone5

	@State var keyValueStore: KeyValueStore = .shared

	@Environment(\.presentationMode) var presentationMode

	@State private var pickerIndex = 0

	@State private var isLoading = false

	@State private var error: Zone5.Error? {
		didSet { displayingError = (error != nil) }
	}

	@State private var displayingError = false

	init(apiClient: Zone5 = .shared, keyValueStore: KeyValueStore = .shared) {
		self.apiClient = apiClient
		self.keyValueStore = keyValueStore
	}

	var body: some View {
		NavigationView {
			VStack(alignment: HorizontalAlignment.center, spacing: 0) {
				Picker("Boop", selection: $pickerIndex) {
					Text("OAuth Client").tag(0)
					Text("Access Token").tag(1)
				}
				.pickerStyle(SegmentedPickerStyle())
				.padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
				.background(Color(.systemGroupedBackground))

				Form {
					Section(header: Text("Base URL"), footer: Text("The URL for the server the SDK should communicate with.")) {
						TextField("Base URL", text: $keyValueStore.baseURLString)
							.textContentType(.URL)
							.keyboardType(.URL)
					}

					if self.pickerIndex == 0 {
						Section(header: Text("Client Details"), footer: Text("These values are used to identify your application during user authentication.")) {
							TextField("ID", text: $keyValueStore.clientID)
							TextField("Secret", text: $keyValueStore.clientSecret)
						}
						Section(header: Text("User Details")) {
							TextField("Username", text: $keyValueStore.username)
								.textContentType(.emailAddress)
								.keyboardType(.emailAddress)
							SecureField("Password", text: $keyValueStore.password)
								.textContentType(.password)
						}
					}
					else if self.pickerIndex == 1 {
						Section(header: Text("Access Token"), footer: Text("You can completely bypass the client configuration and authentication steps by configuring the SDK with a valid user token that is either stored from a previous session, or sourced externally.")) {
							TextField("Token", text: $keyValueStore.accessTokenString)
						}
					}
				}
				.listStyle(GroupedListStyle())
			}
			.alert(isPresented: $displayingError) {
				let title = Text("An Error Occurred")
				let message = Text(error?.debugDescription ?? "nil")
				return Alert(title: title,
							 message: message,
							 primaryButton: .cancel(),
							 secondaryButton: .default(Text("Try Again"), action: self.configureAndDismiss))
			}
			.navigationBarItems(leading: HStack {
				if apiClient.isConfigured {
					Button(action: dismiss, label: {
						Text("Cancel")
					})
				}
			}, trailing: HStack {
				ActivityIndicator(isAnimating: $isLoading)
				Button(action: configureAndDismiss, label: {
					Text("Save")
				})
			})
			.navigationBarTitle("Configuration", displayMode: .inline)
		}
		.navigationViewStyle(StackNavigationViewStyle())
	}

	func configureAndDismiss() {
		error = nil

		// There are two ways to prepare your client for accessing the Zone5 API. If you already have a valid access
		// token, you can simply configure using that, as it identifies both your user and your application.
		//
		// Otherwise, you'll need to first configure your application with a valid `clientID` and `clientSecret` before
		// then authenticating the user to retrieve an access token.
		if pickerIndex == 0 {
			// First we'll configure our client using the `baseURL`, `clientID` and `clientSecret` entered via the UI.
			// These values would normally be embedded in your application and thus hidden from the user, as they
			// identify your application.
			apiClient.configure(for: keyValueStore.baseURL, clientID: keyValueStore.clientID, clientSecret: keyValueStore.clientSecret)

			// Once we've configured the client, we can retrieve an access token for the user, using the credentials
			// given in the UI.
			isLoading = true
			apiClient.oAuth.accessToken(username: keyValueStore.username, password: keyValueStore.password) { result in
				self.isLoading = false

				switch result {
				case .failure(let error):
					// We have an error, so we should surface that. You may want to handle different errors in different
					// ways, as some may not be directly relevant to the user, but for the purposes of this example,
					// we're just going to throw up an alert.
					self.error = error

				case .success(let accessToken):
					// We'll hold on to the access token for later.
					self.keyValueStore.accessToken = accessToken

					// Now that we've successfully authenticated, we can dismiss this screen.
					self.dismiss()
				}
			}
		}
		else if pickerIndex == 1,
			let accessToken = keyValueStore.accessToken {

			// If you already have a valid access token, you can completely bypass the client configuration and
			// authentication steps, and opt for directly providing the access token.
			apiClient.configure(for: keyValueStore.baseURL, accessToken: accessToken)

			// Now that we've successfully authenticated, we can dismiss this screen.
			dismiss()
		}
		else {
			error = .invalidConfiguration
		}
	}

	func dismiss() {
		self.presentationMode.wrappedValue.dismiss()
	}

}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
