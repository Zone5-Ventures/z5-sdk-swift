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

	private func developmentAssetsDirectory(with subdirectory: String?) -> String {
		var developmentAssetsDirectory = "Development Assets"

		if let subdirectory = subdirectory {
			developmentAssetsDirectory += "/\(subdirectory)"
		}

		return developmentAssetsDirectory
	}

	func url(forDevelopmentAsset name: String, withExtension ext: String, subdirectory: String? = nil) -> URL? {
		let subdirectory = developmentAssetsDirectory(with: subdirectory)
		return url(forResource: name, withExtension: ext, subdirectory: subdirectory)
	}

	func urls(forDevelopmentAssetsWithExtension ext: String, subdirectory: String? = nil) -> [URL]? {
		let subdirectory = developmentAssetsDirectory(with: subdirectory)
		return urls(forResourcesWithExtension: ext, subdirectory: subdirectory)
	}

	func urlsForDevelopmentAssets(subdirectory: String? = nil) -> [URL]? {
		let subdirectory = developmentAssetsDirectory(with: subdirectory)
		return urls(forResourcesWithExtension: nil, subdirectory: subdirectory)
	}

}
