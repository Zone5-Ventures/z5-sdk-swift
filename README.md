# Zone5 SDK for Swift

![Unit Test Status](https://github.com/Zone5-Ventures/z5-sdk-swift/workflows/Unit%20Tests/badge.svg) ![Documentation Status](https://zone5-ventures.github.io/z5-sdk-swift/badge.svg)

## Installation

### Swift Package Manager
The most straightforward method of installing the SDK is as a [Swift Package](https://swift.org/package-manager/), which can be done by adding it as a dependency in `Package.swift`, or by following [Apple's documentation on adding package dependencies in Xcode](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).

```swift
import PackageDescription

let package = Package(
    [...]
    dependencies: [
        .package(url: "https://github.com/Zone5-Ventures/z5-sdk-swift.git", from: "1.0.0"),
    ]
)
```

### Carthage
Install the SDK via [Carthage](https://github.com/Carthage/Carthage) by adding the following line to your `Cartfile`:

```
github "Zone5-Ventures/z5-sdk-swift"
```

## Getting Started

Once you've installed the SDK, getting started with using it in your app only takes a handful of steps. Before using it, you'll need to configure it with the OAuth client details used to identify your app to the server:

```swift
import Zone5

let baseURL = URL(string: "https://your-zone5-server.com")!
let clientID = "YOUR-CLIENT-IDENTIFIER"
let clientSecret = "YOUR-CLIENT-SECRET"

Zone5.shared.configure(for: baseURL, clientID: clientID, clientSecret: clientSecret)
```

Once configured, you'll be able to authenticate users via the methods available through [`Zone5.shared.oAuth`](https://zone5-ventures.github.io/z5-sdk-swift/Classes/OAuthView.html):

```swift
let username = "EXAMPLE-USERNAME"
let password = "EXAMPLE-PASSWORD"

Zone5.shared.oAuth.accessToken(username: username, password: password) { result in
	switch result {
	case .failure(let error):
		// An error occurred and needs to be handled

	case .success(let accessToken):
		// The user was successfully authenticated. You should store this token securely
		// so that you can allow the user to stay authenticated across multiple sessions.
	}
}
```

Once the user successfully authenticates, these methods return an [`AccessToken`](https://zone5-ventures.github.io/z5-sdk-swift/Structs/AccessToken.html) object, but also update the [`Zone5.shared.accessToken`](https://zone5-ventures.github.io/z5-sdk-swift/Classes/Zone5.html#/s:5Zone5AAC11accessTokenAA06AccessC0VSgvp) with the returned token, allowing access to methods that require this token to be set.

```swift
Zone5.shared.users.me { result in
	switch result {
	case .failure(let error):
		// An error occurred and needs to be handled

	case .success(let user):
		// The user's information was successfully retrieved.
	}
}
```

## Unit Tests

Unit tests are included and can be run from both the Swift CLI and via Xcode. There may be some slight differences in how these two sources run tests, so if tests are failing in one, but not the other, this may be the cause. Tests are run automatically on push (of any branch) using the Swift CLI, via a [GitHub Action](https://github.com/Zone5-Ventures/z5-sdk-swift/blob/master/.github/workflows/unit-tests.yml), the result of which can be browsed via [the Actions tab](https://github.com/Zone5-Ventures/z5-sdk-swift/actions?query=workflow%3A%22Unit+Tests%22).

### Running Tests via Swift CLI

Run `swift test` from the repo's root directory. Test results will be logged directly to your terminal window.

### Running Tests via Xcode

In the _Product_ menu, select _Test_, or use the keyboard shortcut—typically &#8984;U. Test results are available from the Test Navigator (&#8984;6). Additional details—such as a coverage report—can be found in the Report Navigator (&#8984;9), by selecting the relevant Test report.

## Documentation
You can [find documentation for this project here](https://zone5-ventures.github.io/z5-sdk-swift/). This documentation is automatically generated with [jazzy](https://github.com/realm/jazzy) from a [GitHub Action](https://github.com/Zone5-Ventures/z5-sdk-swift/blob/master/.github/workflows/documentation.yml) and hosted with [GitHub Pages](https://pages.github.com/).

To generate documentation locally, run `make documentation` or `sh ./scripts/prepare_docs.sh` from the repo's root directory. The output will be generated in the docs folder, and should _not_ be included with commits (as the online documentation is automatically generated and updated).
