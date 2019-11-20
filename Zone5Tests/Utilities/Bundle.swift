//
//  Bundle.swift
//  Zone5
//
//  Created by Daniel Farrelly on 12/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

extension Bundle {

	/// Using `Bundle.main` doesn't work when calling from a test target, as it ends up producing the bundle for the
	/// container app, and not the test target, which isn't ideal. If we define a class and use `Bundle.init(for:)`, we
	/// can get the result we expect, so this class exists entirely to serve that purpose.
    private class ClassInTestTarget { }

	/// The bundle for the test target.
	/// - SeeAlso: `ClassInTestTarget`
    static let tests: Bundle = {
        return Bundle(for: ClassInTestTarget.self)
    }()

	// MARK: Development assets

	/// Retrieve the URL for a development asset that has the given `name` and `ext` in the given `subdirectory`.
	/// - Note: This works much the same as `Bundle.url(forResource:withExtension:subdirectory:)`, but has accomodations
	/// to allow for accessing development asset when running tests via the Swift CLI.
	/// - Parameters:
	///   - name: The file's name, i.e. `route`.
	///   - ext: The file extension, i.e. `json`.
	///   - subdirectory: The directory path, relative to the `Development Assets` directory.
	func url(forDevelopmentAsset name: String, withExtension ext: String, subdirectory: String? = nil) -> URL? {
		#if XCODE
		let developmentAssetsSubdirectory = developmentAssetsDirectory(with: subdirectory)
		return url(forResource: name, withExtension: ext, subdirectory: developmentAssetsSubdirectory)
		#else
		return urlsForDevelopmentAssets(subdirectory: subdirectory)?.first { $0.lastPathComponent == "\(name).\(ext)" }
		#endif
	}

	/// Retrieve URLs for development assets with the given `ext` in the given `subdirectory`.
	/// - Note: This works much the same as `Bundle.url(forResource:withExtension:subdirectory:)`, but has accomodations
	/// to allow for accessing development asset when running tests via the Swift CLI.
	/// - Parameters:
	///   - ext: The file extension, i.e. `json`.
	///   - subdirectory: The directory path, relative to the `Development Assets` directory.
	func urls(forDevelopmentAssetsWithExtension ext: String, subdirectory: String? = nil) -> [URL]? {
		#if XCODE
		let developmentAssetsSubdirectory = developmentAssetsDirectory(with: subdirectory)
		return urls(forResourcesWithExtension: nil, subdirectory: developmentAssetsSubdirectory)
		#else
		return urlsForDevelopmentAssets(subdirectory: subdirectory)?.filter { $0.pathExtension == ext }
		#endif
	}

	/// Retrieve URLs for development assets within the given `subdirectory`.
	/// - Note: This works much the same as `Bundle.url(forResource:withExtension:subdirectory:)`, but has accomodations
	/// to allow for accessing development asset when running tests via the Swift CLI.
	/// - Parameters:
	///   - subdirectory: The directory path, relative to the `Development Assets` directory.
	func urlsForDevelopmentAssets(subdirectory: String? = nil) -> [URL]? {
		#if XCODE
		let developmentAssetsSubdirectory = developmentAssetsDirectory(with: subdirectory)
		return urls(forResourcesWithExtension: nil, subdirectory: developmentAssetsSubdirectory)
		#else
		return try? FileManager.default.contentsOfDirectory(at: developmentAssetsURL(with: subdirectory), includingPropertiesForKeys: nil, options: [])
		#endif
	}

	// MARK: Utilities

	/// URL for the project source directory, used as a basis for accessing development assets from tests when run using
	/// Swift Package Manager, which doesn't have support for bundled resources at the time of writing.
	///
	/// The value is determined by creating a URL based on the path for this source file, and then manually walking up
	/// to the root directory for the project.
	private func developmentAssetsURL(with subdirectory: String?) -> URL {
		return URL(fileURLWithPath: #file)
			.deletingLastPathComponent() // Remove `Bundle.swift`
			.deletingLastPathComponent() // Remove `Utilities`
			.deletingLastPathComponent() // Remove `Zone5Tests`
			.appendingPathComponent(developmentAssetsDirectory(with: subdirectory))
	}

	/// Determine the full subdirectory path, incorporating the `Development Assets` directory.
	///  - Parameter subdirectory: The directory path, relative to the `Development Assets` directory.
	private func developmentAssetsDirectory(with subdirectory: String?) -> String {
		var developmentAssetsDirectory = "Development Assets"

		if let subdirectory = subdirectory {
			developmentAssetsDirectory += "/\(subdirectory)"
		}

		return developmentAssetsDirectory
	}

}
