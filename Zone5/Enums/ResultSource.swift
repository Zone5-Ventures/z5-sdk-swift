//
//  ResultSource.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

/// How an activity result got into the system
public enum ResultSource: String, Codable {

	case file

	case manual

	case `import` = "tpimport"

}
