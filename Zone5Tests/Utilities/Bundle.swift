//
//  Bundle.swift
//  Zone5
//
//  Created by Daniel Farrelly on 12/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

extension Bundle {

    private class ClassInTestTarget { }

    static let tests: Bundle = {
        return Bundle(for: ClassInTestTarget.self)
    }()

	// MARK: Development assets

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

	private func developmentAssetsDirectory(with subdirectory: String?) -> String {
		var developmentAssetsDirectory = "Development Assets"

		if let subdirectory = subdirectory {
			developmentAssetsDirectory += "/\(subdirectory)"
		}

		return developmentAssetsDirectory
	}

	private func contents(of directoryURL: URL) -> [URL]? {
		return try? FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [])
	}

	func url(forDevelopmentAsset name: String, withExtension ext: String, subdirectory: String? = nil) -> URL? {
		let developmentAssetsSubdirectory = developmentAssetsDirectory(with: subdirectory)
		return url(forResource: name, withExtension: ext, subdirectory: developmentAssetsSubdirectory)
			?? developmentAssetsURL(with: subdirectory).appendingPathComponent("\(name).\(ext)")
	}

	func urls(forDevelopmentAssetsWithExtension ext: String, subdirectory: String? = nil) -> [URL]? {
		let developmentAssetsSubdirectory = developmentAssetsDirectory(with: subdirectory)
		return urls(forResourcesWithExtension: ext, subdirectory: developmentAssetsSubdirectory)
			?? contents(of: developmentAssetsURL(with: subdirectory))?.filter { $0.pathExtension == ext }
	}

	func urlsForDevelopmentAssets(subdirectory: String? = nil) -> [URL]? {
		let developmentAssetsSubdirectory = developmentAssetsDirectory(with: subdirectory)
		return urls(forResourcesWithExtension: nil, subdirectory: developmentAssetsSubdirectory)
			?? contents(of: developmentAssetsURL(with: subdirectory))
	}

}
