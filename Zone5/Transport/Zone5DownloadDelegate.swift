//
//  Zone5DownloadDelegate.swift
//  Zone5
//
//  Created by Jean Hall on 11/12/20.
//  Copyright © 2020 Zone5 Ventures. All rights reserved.
//

import Foundation

/// Delegate class used for managing the various calls made by our `urlSession`. Delegate is only used by downloads. Upload and Data tasks use completion handler which automatically disables delegates.
/// Used by downloads to capture progress
final internal class Zone5DownloadDelegate: NSObject, URLSessionDownloadDelegate {
	internal static let downloadProgressNotification = Notification.Name("downloadProgressNotification")
	internal static let downloadCompleteNotification = Notification.Name("downloadCompleteNotification")
	
	let notificationCenter: NotificationCenter
	
	init(notificationCenter: NotificationCenter = .default) {
		self.notificationCenter = notificationCenter
	}
	
	func postCompleteNotification(response: URLResponse?, downloadTask: URLSessionDownloadTask, location: URL) {
		var userInfo: [String:Any] = ["location": location]
		if let response = response {
			userInfo["response"] = response
		}
		
		notificationCenter.post(name: Zone5DownloadDelegate.downloadCompleteNotification, object: downloadTask, userInfo: userInfo)
	}
	
	func postCompleteErrorNotification(response: URLResponse?, downloadTask: URLSessionDownloadTask, error: Swift.Error) {
		var userInfo: [String:Any] = ["error": error]
		if let response = response {
			userInfo["response"] = response
		}
		
		notificationCenter.post(name: Zone5DownloadDelegate.downloadCompleteNotification, object: downloadTask, userInfo: userInfo)
	}
	
	func postProgressNotification(downloadTask: URLSessionDownloadTask, bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		notificationCenter.post(name: Zone5DownloadDelegate.downloadProgressNotification, object: downloadTask, userInfo: [
			"bytesWritten": bytesWritten,
			"totalBytesWritten" : totalBytesWritten,
			"totalBytesExpectedToWrite" : totalBytesExpectedToWrite
		   ])
	}
	
	/// MARK: URLSessionDownloadDelegate
	
	// URLSessionDownloadDelegate: download complete. Call complete
	public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
		postCompleteNotification(response: downloadTask.response, downloadTask: downloadTask, location: location)
	}

	// URLSessionDownloadDelegate: download progress. Call progress
	public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
		postProgressNotification(downloadTask: downloadTask, bytesWritten: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
	}
	
	// URLSessionTaskDelegate: on success we would've called from urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL).
	public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Swift.Error?) {
		if let downloadTask = task as? URLSessionDownloadTask {
			if let error = error {
				postCompleteErrorNotification(response: downloadTask.response, downloadTask: downloadTask, error: error)
			} else {
				// if the file download was successful then urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
				// would've been called and the notification would've been posted and handled and the observer deregistered so this post will go unheard.
				// this is just a catch all to make sure there is no scenario that a completion handler is not called
				postCompleteErrorNotification(response: downloadTask.response, downloadTask: downloadTask, error: Zone5.Error.unknown)
			}
		}
	}
}
