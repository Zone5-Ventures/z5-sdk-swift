//
//  PaymentVerification.swift
//  Zone5
//
//  Created by Jean Hall on 27/11/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct PaymentVerification: JSONEncodedBody, Codable {
	public var provider: String // Payment provider to verify the receipt with
	public var data: String // receipt
	public var id: Int?
	public var status: IAPVerificationStatus?
	public var message: String?
	public var currencyCode: String?
	public var cost: Double?
	public var productDescr: String // supply description
	public var retry: Bool?

	/// Initialise a PaymentVerification for uploading to the server
	public init(provider: String = "apple", data: String, productDescr: String, currencyCode: String, cost: Double) {
		self.provider = provider
		self.data = data
		self.productDescr = productDescr
		self.currencyCode = currencyCode
		self.cost = cost
	}

}
public enum IAPVerificationErrorId: String, Codable {
	case incorrectService = "error.payment.incorrect.service" // Incorrect service type.
	case transactionidConsumed = "error.payment.transactionid.consumed" // Transaction id has already been consumed : %s
	case productNotFound = "error.payment.product.not.found" // Unable to find matching product : %s
	case transactionNotFound = "error.payment.transaction.not.found" // In app purchase not found in receipt.
	case receiptNotFound = "error.payment.receipt.not.found" // Receipt not found.
	case vaildationFailed = "error.payment.vaildation.failed" // Failed validation status %s
}

public enum IAPVerificationStatus: String, Codable {
	case pending = "pending"
	case retry = "retry"
	case successful = "sucessful"
	case error = "error"
}
