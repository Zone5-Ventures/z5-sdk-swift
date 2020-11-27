//
//  PaymentReceipt.swift
//  Zone5
//
//  Created by Jean Hall on 24/11/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct PaymentReceipt: Codable, JSONEncodedBody {
	public var provider: String
	public var data: String  // encrypted certificate
	public var productId: String
	public var productDesc: String // supply description
	public var currencyCode: String
	public var cost: Double
	public var retry: Bool?
	
	public init(provider: String = "apple", data: String, productId: String, productDesc: String, currencyCode: String, cost: Double) {
		self.provider = provider
		self.data = data
		self.productId = productId
		self.productDesc = productDesc
		self.currencyCode = currencyCode
		self.cost = cost
	}
}
