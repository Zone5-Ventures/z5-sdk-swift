//
//  PaymentsView.swift
//  Zone5
//
//  Created by Jean Hall on 24/11/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public class PaymentsView: APIView {

	private enum Endpoints: String, RequestEndpoint {
		case iapProductIds = "/rest/apps/products{app}"
		case iapTransactionVerify = "/rest/payments/verification/verify{app}";
	}
	
	/// Request a list of available products for purchase for the given app
	/// - Parameters:
	///   - app: Return all products available for this app
	///   - completion: Function called with the `Products` results matching the given criteria, or the error if one occurred.
	@discardableResult
	public func products(for app: String = "", completion: @escaping Zone5.ResultHandler<Products>) -> PendingRequest? {
		let endpoint = Endpoints.iapProductIds.replacingTokens(["app": app.isEmpty ? app : "/\(app)"])
		return get(endpoint, with: completion)
	}
	
	/// Verify payment by sending up the receipt
	/// - Parameters:
	///   - app: app that this purchase relates to
	///   - completion: Function called with the `Products` results matching the given criteria, or the error if one occurred.
	@discardableResult
	public func verify(for app: String = "", with receipt: PaymentVerification, completion: @escaping Zone5.ResultHandler<PaymentVerification>) -> PendingRequest? {
		let endpoint = Endpoints.iapTransactionVerify.replacingTokens(["app": (app.isEmpty ? app : "/\(app)")])
		return post(endpoint, body: receipt, with: completion)
	}
}
