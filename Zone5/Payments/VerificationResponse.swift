//
//  VerificationResponse.swift
//  Zone5
//
//  Created by Jean Hall on 24/11/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public struct VerificationResponse: Codable, JSONEncodedBody {
	public var id: Int?
	public var status: IAPVerificationStatus?
	public var errorId: IAPVerificationErrorId?
	public var message: String?
	public var provider: String // Payment provider to verify the receipt with
	public var data: String?
	public var currencyCode: String?
	public var cost: Double?
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
