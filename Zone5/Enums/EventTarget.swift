//
//  EventTarget.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public enum EventTarget: String, Codable {

	/// This is a high importance target event - pull out all the stops to hit this event
	case highImportance = "high"

	/// This is a medium importance event - best effort to be prepared for this event
	case mediumImportance = "med"

	/// This is a low importance event - train through it and don't care about results
	case lowImportance = "low"

}
