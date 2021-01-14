//
//  Logger.swift
//  Zone5
//
//  Created by John Keller on 12/10/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import os.log

extension OSLog {
    private static var subsystem = "com.zone5cloud.Zone5SDK"
    static let z5Log = OSLog(subsystem: subsystem, category: "Zone5SDK")
    static let z5DebugLog = OSLog(subsystem: subsystem, category: "Zone5SDK-Debug")
}

func z5Log(_ message: String, level: OSLogType = .default) {
    log(message, level: level, log: OSLog.z5Log)
}

func z5DebugLog(_ message: String, level: OSLogType = .default) {
	// only log if attached to an xcode debugger AND explicitly set
	#if DEBUG
		if Zone5.shared.debugLogging {
			log(message, level: level, log: OSLog.z5DebugLog)
		}
	#endif
}

// swiftlint:disable:next private_functions
private func log(_ message: String, level: OSLogType, log: OSLog) {
    os_log("%{public}@", log: log, type: level, message)
}
