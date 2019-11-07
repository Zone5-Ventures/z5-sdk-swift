//
//  Result.swift
//  Zone5Tests
//
//  Created by Daniel Farrelly on 7/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

extension Result {

	static func success(_ closure: () -> Success) -> Self {
		return .success(closure())
	}

	static func failure(_ closure: () -> Failure) -> Self {
		return .failure(closure())
	}

}
