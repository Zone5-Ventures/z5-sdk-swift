//
//  ActivityType.swift
//  Zone5
//
//  Created by Daniel Farrelly on 14/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public enum ActivityType: String, Codable {

	case ride

	case run

	case swim

	case brick

	case xtrain

	case xcski

	case row

	case gym

	case walk

	case yoga

	case other

	case multisport // a special case we use for tagging an outer activity file

	case transition // a special case for tagging transitions in tri files

}
