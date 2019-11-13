//
//  EndpointController.swift
//  Zone5 Example
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation
import Combine
import Zone5

class EndpointController<Response>: ObservableObject {

	typealias Handler = (_ client: Zone5, _ completion: @escaping (_ result: Result<Response, Zone5.Error>) -> Void) -> Void

	let apiClient: Zone5

	let handler: Handler

	init(apiClient: Zone5 = .shared, handler: @escaping Handler) {
		self.apiClient = apiClient
		self.handler = handler
	}

	@Published var isLoading = false

	@Published var shouldDisplayError = false

	@Published var result: Result<Response, Zone5.Error>? {
		didSet {
			switch result {
			case .none:
				shouldDisplayError = false

			case .success(_):
				shouldDisplayError = false

			case .failure(_):
				shouldDisplayError = true
			}
		}
	}

	var response: Response? {
		switch result {
		case .success(let response): return response
		default: return nil
		}
	}

	var error: Zone5.Error? {
		switch result {
		case .failure(let error): return error
		default: return nil
		}
	}

	func perform() -> Void {
		isLoading = true
		handler(apiClient, handlerDidComplete)
	}

	private func handlerDidComplete(_ incomingResult: Result<Response, Zone5.Error>) -> Void {
		DispatchQueue.main.async { [weak self] in
			self?.result = incomingResult
			self?.isLoading = false
		}
	}

}
