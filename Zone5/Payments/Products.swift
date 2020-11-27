//
//  Products.swift
//  Zone5
//
//  Created by Jean Hall on 24/11/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct Products: Codable, JSONEncodedBody {
	public let bundle: String?
	public var secret: String?
	public var monthlyPlanId: String?
	
	private enum CodingKeys: String, CodingKey {
		case bundle = "APP_BUNDLE"
		case secret = "APP_SECRET"
		case monthlyPlanId = "PRODUCT_MONTH_PLAN"
	}
}
