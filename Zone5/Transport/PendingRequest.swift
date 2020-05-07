//
//  PendingRequest.swift
//  Zone5
//
//  Created by Jean Hall on 7/5/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

public class PendingRequest: NSObject {

	private let task: URLSessionTask
	
	init(_ task: URLSessionTask) {
		self.task = task
	}
	
	public func cancel() {
		self.task.cancel()
	}
	
	public var isComplete: Bool {
		return self.task.progress.isFinished
	}
	
	public var isCancelled: Bool {
		return self.task.progress.isCancelled
	}
}
