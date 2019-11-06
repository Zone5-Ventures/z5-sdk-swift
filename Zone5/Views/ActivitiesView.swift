import Foundation

public class ActivitiesView: APIView {

	private enum Endpoints: String, HTTPEndpoint {
		case search = "/rest/users/activities/search/{offset}/{count}"
		case next = "/rest/users/activities/page/{offset}/{count}";
		case upload = "/rest/files/upload";
		case delete = "/rest/users/activities/rem/{activityType}/{activityId}/false";
		case fileIndexStatus = "/rest/v2/files/get/{indexId}";

		case downloadFIT = "/rest/files/download/{fileId}";
		case downloadRaw3 = "/rest/users/activities/download/files/{fileId}/raw3";
		case downloadCSV = "/rest/plans/files/csv/{fileId}";
		case downloadMap = "/rest/users/activities/map/{fileId}";

		case timeInZone = "/rest/reports/activity/{zoneType}/get";

		case peakPower = "/rest/reports/activity/maxpeaks/get";
		case peakHeartrate = "/rest/reports/activity/maxpeaksbpm/get";
		case peakWKG = "/rest/reports/activity/peakwkg/get";
		case peakPace = "/rest/reports/activity/peakspace/get";
		case peakLSS = "/rest/reports/activity/peakslss/get";
		case peakLSSKG = "/rest/reports/activity/peakslsskg/get";

		case metrics = "/rest/reports/metrics/summary/get";
	}

	public func search(_ parameters: SearchInput<UserWorkoutSearch>, offset: Int, count: Int, completion: @escaping (_ result: Result<SearchResult<Activity>, Zone5.Error>) -> Void) {
		let endpoint = Endpoints.search.replacingTokens(["offset": offset, "count": count])
		post(endpoint, body: parameters, with: completion)
	}

	public func next(offset: Int, count: Int, completion: @escaping (_ result: Result<SearchResult<Activity>, Zone5.Error>) -> Void) {
		let endpoint = Endpoints.next.replacingTokens(["offset": offset, "count": count])
		get(endpoint, with: completion)
	}

}
