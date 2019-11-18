import Foundation

public class ActivitiesView: APIView {

	private enum Endpoints: String, RequestEndpoint {
		case search = "/rest/users/activities/search/{offset}/{count}"
		case next = "/rest/users/activities/page/{offset}/{count}";
		case upload = "/rest/files/upload";
		case uploadStatus = "/rest/v2/files/get/{indexID}";
		case delete = "/rest/users/activities/rem/{activityType}/{activityID}/false";
		case downloadOriginal = "/rest/files/download/{fileID}";
		case downloadRaw = "/rest/users/activities/download/files/{fileID}/raw3";
		case downloadCSV = "/rest/plans/files/csv/{fileID}";
		case downloadPNG = "/rest/users/activities/map/{fileID}";
		case timeInZones = "/rest/reports/activity/{zoneType}/get";
		case peakPowerCurve = "/rest/reports/activity/maxpeaks/get";
		case peakHeartRateCurve = "/rest/reports/activity/maxpeaksbpm/get";
		case peakWKgCurve = "/rest/reports/activity/peakwkg/get";
		case peakPaceCurve = "/rest/reports/activity/peakspace/get";
		case peakLSSCurve = "/rest/reports/activity/peakslss/get";
		case peakLSSKgCurve = "/rest/reports/activity/peakslsskg/get";
		case metrics = "/rest/reports/metrics/summary/get";

		// Specialized only
		case setBike = "/rest/users/activities/set/bike/{activityType}/{activityID}/{bikeID}";
		case removeBike = "/rest/users/activities/rem/bike/{activityType}/{activityID}";
	}

	// MARK: Browsing activities

	/// Perform a search for activities matching the given `parameters`.
	/// - Parameters:
	///   - parameters: The criteria to use when performing the search.
	///   - offset: The pagination offset for the retrieved set of `UserWorkoutResult` values.
	///   - count: The number of `UserWorkoutResult` values to retrieve.
	///   - completion: Function called with the `UserWorkoutResult` results matching the given criteria, or the error if one occurred.
	public func search(_ parameters: SearchInput<UserWorkoutFileSearch>, offset: Int, count: Int, completion: @escaping Zone5.ResultHandler<SearchResult<UserWorkoutResult>>) {
		let endpoint = Endpoints.search.replacingTokens(["offset": offset, "count": count])
		post(endpoint, body: parameters, with: completion)
	}

	/// Get the next paginated set from the previous search.
	/// - Parameters:
	///   - offset: The pagination offset for the retrieved set of `UserWorkoutResult` values.
	///   - count: The number of `UserWorkoutResult` values to retrieve.
	///   - completion: Function called with the `UserWorkoutResult` results matching the given criteria, or the error if one occurred.
	public func next(offset: Int, count: Int, completion: @escaping Zone5.ResultHandler<SearchResult<UserWorkoutResult>>) {
		let endpoint = Endpoints.next.replacingTokens(["offset": offset, "count": count])
		get(endpoint, with: completion)
	}

	// MARK: Uploading files

	public func upload(_ fileURL: URL, context: DataFileUploadContext, completion: @escaping Zone5.ResultHandler<DataFileUploadIndex>) {
		upload(Endpoints.upload, contentsOf: fileURL, body: context, with: completion)
	}

	/// Request the processing status of an uploaded file with the given `indexID`.
	/// - Parameters:
	///   - indexID: The `id` from the result of a previous upload's `DataFileUploadIndex` response.
	///   - completion: Function called with the upload status for the requested file, or the error if one occurred.
	public func uploadStatus(of indexID: Int, completion: @escaping Zone5.ResultHandler<DataFileUploadIndex>) {
		let endpoint = Endpoints.uploadStatus.replacingTokens(["indexID": indexID])
		get(endpoint, with: completion)
	}

	// MARK: Downloading files

	/// Download the originally uploaded file.
	///	- Note: The cached file is deleted upon return of the completion handler, and so the file should be copied to an
	///		alternate location before performing any asynchronous tasks, or before returning from the closure.
	/// - Parameters:
	///   - fileID: The identifier for the file to be downloaded.
	///   - completion: Function called with the location of the downloaded file on disk, or the error if one occurred.
	public func downloadOriginal(_ fileID: Int, completion: @escaping Zone5.ResultHandler<URL>) {
		let endpoint = Endpoints.downloadOriginal.replacingTokens(["fileID": fileID])
		download(endpoint, with: completion)
	}

	/// Download a normalized FIT file which contains typed numeric data channels.
	/// Use this for time series graphs or raw channel analysis.
	///	- Note: The cached file is deleted upon return of the completion handler, and so the file should be copied to an
	///		alternate location before performing any asynchronous tasks, or before returning from the closure.
	/// - Parameters:
	///   - fileID: The identifier for the file to be downloaded.
	///   - completion: Function called with the location of the downloaded file on disk, or the error if one occurred.
	public func downloadRaw(_ fileID: Int, completion: @escaping Zone5.ResultHandler<URL>) {
		let endpoint = Endpoints.downloadRaw.replacingTokens(["fileID": fileID])
		download(endpoint, with: completion)
	}

	/// Download the normalized CSV file.
	///	- Note: The cached file is deleted upon return of the completion handler, and so the file should be copied to an
	///		alternate location before performing any asynchronous tasks, or before returning from the closure.
	/// - Parameters:
	///   - fileID: The identifier for the file to be downloaded.
	///   - completion: Function called with the location of the downloaded file on disk, or the error if one occurred.
	public func downloadCSV(_ fileID: Int, completion: @escaping Zone5.ResultHandler<URL>) {
		let endpoint = Endpoints.downloadCSV.replacingTokens(["fileID": fileID])
		download(endpoint, with: completion)
	}

	/// Download a PNG image with the ride plotted on a map.
	///	- Note: The cached file is deleted upon return of the completion handler, and so the file should be copied to an
	///		alternate location before performing any asynchronous tasks, or before returning from the closure.
	/// - Parameters:
	///   - fileID: The identifier for the file to be downloaded.
	///   - completion: Function called with the location of the downloaded file on disk, or the error if one occurred.
	public func downloadMap(_ fileID: Int, completion: @escaping Zone5.ResultHandler<URL>) {
		let endpoint = Endpoints.downloadPNG.replacingTokens(["fileID": fileID])
		download(endpoint, with: completion)
	}

	// MARK: Deleting

	/// Delete a file, event or workout using its `id`.
	/// - Parameters:
	///   - type: The result type of the activity to be deleted.
	///   - id: The identifier for the activity to be deleted.
	///   - completion: Function called with the result of the deletion, or the error if one occurred.
	public func delete(type: ActivityResultType, id: Int, completion: @escaping Zone5.ResultHandler<Bool>) {
		let endpoint = Endpoints.delete.replacingTokens(["activityType": type, "activityID": id])
		get(endpoint, with: completion)
	}

	// MARK: Time in Zones

	public func timeInZones(type: ActivityResultType, id: Int, zoneType: IntensityZoneType, completion: @escaping Zone5.ResultHandler<MappedResult<UserWorkoutResult>>) {
		let input = SearchInputReport.forInstance(activityType: type, identifier: id)
		let endpoint = Endpoints.timeInZones.replacingTokens(["zoneType": zoneType.description])
		post(endpoint, body: input, with: completion)
	}

	// MARK: Instance Peak Curves

	/// Get the peak power curve for this activity, and include a reference series.
	/// - Parameters:
	///   - type: The result type of the activity in question.
	///   - id: The identifier for the activity in question.
	///   - referencePeriod: The optional reference period to use for the search. Defaults to `nil`.
	///   - completion: Function called with the `UserWorkoutResult` values returned by the server, or the error if one occurred.
	public func peakPowerCurve(type: ActivityResultType, id: Int, referencePeriod: RelativePeriod? = nil, completion: @escaping Zone5.ResultHandler<MappedResult<UserWorkoutResult>>) {
		let searchInputReport = SearchInputReport.forInstancePeaksCurve(activityType: type, identifier: id, referencePeriod: referencePeriod)
		post(Endpoints.peakPowerCurve, body: searchInputReport, with: completion)
	}

	/// Get the peak heart rate curve for this activity, and include a reference series.
	/// - Parameters:
	///   - type: The result type of the activity in question.
	///   - id: The identifier for the activity in question.
	///   - referencePeriod: The optional reference period to use for the search. Defaults to `nil`.
	///   - completion: Function called with the `UserWorkoutResult` values returned by the server, or the error if one occurred.
	public func peakHeartRateCurve(type: ActivityResultType, id: Int, referencePeriod: RelativePeriod? = nil, completion: @escaping Zone5.ResultHandler<MappedResult<UserWorkoutResult>>) {
		let searchInputReport = SearchInputReport.forInstancePeaksCurve(activityType: type, identifier: id, referencePeriod: referencePeriod)
		post(Endpoints.peakHeartRateCurve, body: searchInputReport, with: completion)
	}

	/// Get the peak w/kg curve for this activity, and include a reference series.
	/// - Parameters:
	///   - type: The result type of the activity in question.
	///   - id: The identifier for the activity in question.
	///   - referencePeriod: The optional reference period to use for the search. Defaults to `nil`.
	///   - completion: Function called with the `UserWorkoutResult` values returned by the server, or the error if one occurred.
	public func peakWKgCurve(type: ActivityResultType, id: Int, referencePeriod: RelativePeriod? = nil, completion: @escaping Zone5.ResultHandler<MappedResult<UserWorkoutResult>>) {
		let searchInputReport = SearchInputReport.forInstancePeaksCurve(activityType: type, identifier: id, referencePeriod: referencePeriod)
		post(Endpoints.peakWKgCurve, body: searchInputReport, with: completion)
	}

	/// Get the peak pace curve for this activity, and include a reference series.
	/// - Parameters:
	///   - type: The result type of the activity in question.
	///   - id: The identifier for the activity in question.
	///   - referencePeriod: The optional reference period to use for the search. Defaults to `nil`.
	///   - completion: Function called with the `UserWorkoutResult` values returned by the server, or the error if one occurred.
	public func peakPaceCurve(type: ActivityResultType, id: Int, referencePeriod: RelativePeriod? = nil, completion: @escaping Zone5.ResultHandler<MappedResult<UserWorkoutResult>>) {
		let searchInputReport = SearchInputReport.forInstancePeaksCurve(activityType: type, identifier: id, referencePeriod: referencePeriod)
		post(Endpoints.peakPaceCurve, body: searchInputReport, with: completion)
	}

	/// Get the peak leg spring stiffness curve for this activity, and include a reference series.
	/// - Parameters:
	///   - type: The result type of the activity in question.
	///   - id: The identifier for the activity in question.
	///   - referencePeriod: The optional reference period to use for the search. Defaults to `nil`.
	///   - completion: Function called with the `UserWorkoutResult` values returned by the server, or the error if one occurred.
	public func peakLSSCurve(type: ActivityResultType, id: Int, referencePeriod: RelativePeriod? = nil, completion: @escaping Zone5.ResultHandler<MappedResult<UserWorkoutResult>>) {
		let searchInputReport = SearchInputReport.forInstancePeaksCurve(activityType: type, identifier: id, referencePeriod: referencePeriod)
		post(Endpoints.peakLSSCurve, body: searchInputReport, with: completion)
	}

	/// Get the peak leg spring stiffness/kg for this activity, and include a reference series.
	/// - Parameters:
	///   - type: The result type of the activity in question.
	///   - id: The identifier for the activity in question.
	///   - referencePeriod: The optional reference period to use for the search. Defaults to `nil`.
	///   - completion: Function called with the `UserWorkoutResult` values returned by the server, or the error if one occurred.
	public func peakLSSKgCurve(type: ActivityResultType, id: Int, referencePeriod: RelativePeriod? = nil, completion: @escaping Zone5.ResultHandler<MappedResult<UserWorkoutResult>>) {
		let searchInputReport = SearchInputReport.forInstancePeaksCurve(activityType: type, identifier: id, referencePeriod: referencePeriod)
		post(Endpoints.peakLSSKgCurve, body: searchInputReport, with: completion)
	}

	// MARK: Specialized Feature Set

	/// Set the Specialized bike for a completed activity, using the given `bikeID`.
	/// - Parameters:
	///   - type: The result type of the activity to add the bike to.
	///   - id: The identifier for the activity to add the bike to.
	///   - bikeID: The identifier for the bike to be added.
	///   - completion: Function called with the result of the bike addition, or the error if one occurred.
	/// - Warning: Specialized feature set only.
	public func setBike(type: ActivityResultType, id: Int, bikeID: String, completion: @escaping Zone5.ResultHandler<Bool>) {
		let endpoint = Endpoints.setBike.replacingTokens(["activityType": type, "activityID": id, "bikeID": bikeID])
		get(endpoint, with: completion)
	}

	/// Remove the Specialized bike from a completed activity.
	/// - Parameters:
	///   - type: The result type of the activity to remove the bike from.
	///   - id: The identifier for the activity to remove the bike from.
	///   - completion: Function called with the result of the bike removal, or the error if one occurred.
	/// - Warning: Specialized feature set only.
	public func removeBike(type: ActivityResultType, id: Int, completion: @escaping Zone5.ResultHandler<Bool>) {
		let endpoint = Endpoints.removeBike.replacingTokens(["activityType": type, "activityID": id])
		get(endpoint, with: completion)
	}

}
