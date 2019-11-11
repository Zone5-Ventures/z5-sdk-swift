//
//  FileUploadState.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public enum FileUploadState: String, Codable {

	case pending

	case queued

	case processing

	case finished

	case error

}
