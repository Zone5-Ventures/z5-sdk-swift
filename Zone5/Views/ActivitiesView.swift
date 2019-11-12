import Foundation

public class ActivitiesView: APIView {

	private enum Endpoints: String, RequestEndpoint {
		case search = "/rest/users/activities/search/{offset}/{count}"
		case next = "/rest/users/activities/page/{offset}/{count}";

		case upload = "/rest/files/upload";
		case delete = "/rest/users/activities/rem/{activityType}/{activityId}/false";
		case fileIndexStatus = "/rest/v2/files/get/{indexId}";

		case downloadFIT = "/rest/files/download/{fileID}";
		case downloadRaw3 = "/rest/users/activities/download/files/{fileID}/raw3";
		case downloadCSV = "/rest/plans/files/csv/{fileID}";
		case downloadMap = "/rest/users/activities/map/{fileID}";

		case timeInZone = "/rest/reports/activity/{zoneType}/get";

		case peakPower = "/rest/reports/activity/maxpeaks/get";
		case peakHeartrate = "/rest/reports/activity/maxpeaksbpm/get";
		case peakWKG = "/rest/reports/activity/peakwkg/get";
		case peakPace = "/rest/reports/activity/peakspace/get";
		case peakLSS = "/rest/reports/activity/peakslss/get";
		case peakLSSKG = "/rest/reports/activity/peakslsskg/get";

		case metrics = "/rest/reports/metrics/summary/get";
	}

	// MARK: Browsing activities

	public typealias ActivitySearchResult = Result<SearchResult<Activity>, Zone5.Error>

	public func search(_ parameters: SearchInput<UserWorkoutSearch>, offset: Int, count: Int, completion: @escaping (_ result: ActivitySearchResult) -> Void) {
		let endpoint = Endpoints.search.replacingTokens(["offset": offset, "count": count])
		post(endpoint, body: parameters, with: completion)
	}

	public func next(offset: Int, count: Int, completion: @escaping (_ result: ActivitySearchResult) -> Void) {
		let endpoint = Endpoints.next.replacingTokens(["offset": offset, "count": count])
		get(endpoint, with: completion)
	}

	// MARK: Uploads

	public func upload(_ fileURL: URL, context: DataFileUploadContext, completion: @escaping (_ result: Result<DataFileUploadIndex, Zone5.Error>) -> Void) {
		upload(Endpoints.upload, contentsOf: fileURL, body: context, with: completion)
	}

}
