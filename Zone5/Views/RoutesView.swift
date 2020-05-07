import Foundation

public class RoutesView: APIView {

	private enum Endpoints: String, RequestEndpoint {
		case search = "/rest/users/route/search/{offset}/{count}";
		case next = "/rest/users/route/page/{offset}/{count}";
		case summary = "/rest/users/route/get/{routeID}/0";
		case detailed = "/rest/users/route/get/{routeID}/1";
		case update = "/rest/users/route/set/{routeID}";
		case delete = "/rest/users/route/rem/{routeID}";
		case upload = "/rest/users/route/upload/v2/{format}";
		case uploadUpdate = "/rest/users/route/upload/v2/{routeID}/{format}";
		case downloadPNG = "/rest/users/route/download/v2/{routeID}/png";
		case downloadFIT = "/rest/users/route/download/v2/{routeID}/fit";
		case downloadGPX = "/rest/users/route/download/v2/{routeID}/gpx";
		case downloadStagesSRO = "/rest/users/route/download/{routeID}/stages";
		case downloadStagesFIT = "/rest/users/route/download/{routeID}/fit";
		case cloneActivity = "/rest/users/route/clone/files/{fileID}";
		case cloneRoute = "/rest/users/route/clone/route/{routeID}";
	}

	// MARK: Browsing routes

	/// Perform a search for routes matching the given `parameters`.
	/// - Parameters:
	///   - parameters: The criteria to use when performing the search.
	///   - offset: The pagination offset for the retrieved set of `UserRoute` values.
	///   - count: The number of `UserRoute` values to retrieve.
	///   - completion: Function called with the `UserRoute` results matching the given criteria, or the error if one occurred.
	@discardableResult
	public func search(_ parameters: SearchInput<UserRouteSearch>, offset: Int, count: Int, completion: @escaping Zone5.ResultHandler<SearchResult<UserRoute>>) -> PendingRequest? {
		let endpoint = Endpoints.search.replacingTokens(["offset": offset, "count": count])
		return post(endpoint, body: parameters, with: completion)
	}

	/// Get the next paginated set from the previous search.
	/// - Parameters:
	///   - offset: The pagination offset for the retrieved set of `UserRoute` values.
	///   - count: The number of `UserRoute` values to retrieve.
	///   - completion: Function called with the `UserRoute` results matching the given criteria, or the error if one occurred.
	@discardableResult
	public func next(offset: Int, count: Int, completion: @escaping Zone5.ResultHandler<SearchResult<UserRoute>>) -> PendingRequest? {
		let endpoint = Endpoints.next.replacingTokens(["offset": offset, "count": count])
		return get(endpoint, with: completion)
	}

	/// Get a summary view of a route (just route meta-data, does not include raw points)
	/// - Parameters:
	///   - routeID: The identifier for the route, either the route's `id` or `uuid`.
	///   - completion: Function called with the `UserRoute` summary, or the error if one occurred.
	@discardableResult
	public func summaryView(of identifier: UserRouteServerIdentifier, completion: @escaping Zone5.ResultHandler<UserRoute>) -> PendingRequest? {
		let endpoint = Endpoints.summary.replacingTokens(["routeID": identifier])
		return get(endpoint, with: completion)
	}

	/// Get a detailed view of a route (just route meta-data, does not include raw points)
	/// - Parameters:
	///   - routeID: The identifier for the route, either the route's `id` or `uuid`.
	///   - completion: Function called with the detailed `UserRoute` value, or the error if one occurred.
	@discardableResult
	public func detailedView(of identifier: UserRouteServerIdentifier, completion: @escaping Zone5.ResultHandler<UserRoute>) -> PendingRequest? {
		let endpoint = Endpoints.detailed.replacingTokens(["routeID": identifier])
		return get(endpoint, with: completion)
	}

	// MARK: Downloading files

	/// Download a PNG map image of the route.
	///	- Note: The cached file is deleted upon return of the completion handler, and so the file should be copied to an
	///		alternate location before performing any asynchronous tasks, or before returning from the closure.
	/// - Parameters:
	///   - routeID: The identifier for the route to be downloaded, either the route's `id` or `uuid`.
	///   - completion: Function called with the location of the downloaded file on disk, or the error if one occurred.
	@discardableResult
	public func downloadPNG(for identifier: UserRouteServerIdentifier, completion: @escaping Zone5.ResultHandler<URL>) -> PendingRequest? {
		let endpoint = Endpoints.downloadPNG.replacingTokens(["routeID": identifier])
		return download(endpoint, with: completion)
	}

	/// Download a FIT version of the route.
	/// The resulting file includes all data points (location, elevation, elapsed distance etc), directions (if any),
	/// and course point markers.
	///	- Note: The cached file is deleted upon return of the completion handler, and so the file should be copied to an
	///		alternate location before performing any asynchronous tasks, or before returning from the closure.
	/// - Parameters:
	///   - routeID: The identifier for the route to be downloaded, either the route's `id` or `uuid`.
	///   - completion: Function called with the location of the downloaded file on disk, or the error if one occurred.
	@discardableResult
	public func downloadFIT(for identifier: UserRouteServerIdentifier, completion: @escaping Zone5.ResultHandler<URL>) -> PendingRequest? {
		let endpoint = Endpoints.downloadFIT.replacingTokens(["routeID": identifier])
		return download(endpoint, with: completion)
	}

	/// Download a GPX version of the route.
	///	- Note: The cached file is deleted upon return of the completion handler, and so the file should be copied to an
	///		alternate location before performing any asynchronous tasks, or before returning from the closure.
	/// - Parameters:
	///   - routeUUID: The identifier for the route to be downloaded, either the route's `id` or `uuid`.
	///   - completion: Function called with the location of the downloaded file on disk, or the error if one occurred.
	@discardableResult
	public func downloadGPX(for identifier: UserRouteServerIdentifier, completion: @escaping Zone5.ResultHandler<URL>) -> PendingRequest? {
		let endpoint = Endpoints.downloadGPX.replacingTokens(["routeID": identifier])
		return download(endpoint, with: completion)
	}

	/// Download a Stages Dash1 SRO Route file.
	///	- Note: The cached file is deleted upon return of the completion handler, and so the file should be copied to an
	///		alternate location before performing any asynchronous tasks, or before returning from the closure.
	/// - Parameters:
	///   - routeID: The identifier for the route to be downloaded.
	///   - completion: Function called with the location of the downloaded file on disk, or the error if one occurred.
	@discardableResult
	public func downloadStagesSRO(for routeID: Int64, completion: @escaping Zone5.ResultHandler<URL>) -> PendingRequest? {
		let endpoint = Endpoints.downloadStagesSRO.replacingTokens(["routeID": routeID])
		return download(endpoint, with: completion)
	}

	/// Download a Stages Dash2 Route FIT file.
	///	- Note: The cached file is deleted upon return of the completion handler, and so the file should be copied to an
	///		alternate location before performing any asynchronous tasks, or before returning from the closure.
	/// - Parameters:
	///   - routeID: The identifier for the route to be downloaded.
	///   - completion: Function called with the location of the downloaded file on disk, or the error if one occurred.
	@discardableResult
	public func downloadStagesFIT(for routeID: Int64, completion: @escaping Zone5.ResultHandler<URL>) -> PendingRequest? {
		let endpoint = Endpoints.downloadStagesFIT.replacingTokens(["routeID": routeID])
		return download(endpoint, with: completion)
	}

	// MARK: Modifying routes

	/// Create a new route from the given JSON file.
	/// The JSON file should follow the expected structure, e.g.:
	/// ```
	/// {
	///   "course_points": [
	///       // lat, lng, elapsed distance (m), fit course point type (ordinal), text
	///   	  [-420945877, 1778923344, 4572, 0, "Head northeast on Lady Denman Dr<br>Walk your bicycle"],
	///   	  ...
	///   ],
	///   "records": [
	///       // lat, lng, elapsed distance (m), altitude (m), grade (%)
	///       [-420751495, 1779320598, 0, 0, 0],
	///       ...
	///   ]
	/// }
	/// ```
	/// - Parameters:
	///   - fileURL: The URL for a JSON-formatted route file.
	///   - metadata: The metadata for the created route.
	///   - completion: Function called with the created route, or the error if one occurred.
	@discardableResult
	public func createRoute(fromJSON fileURL: URL, metadata: UserRoute, completion: @escaping Zone5.ResultHandler<UserRoute>) -> PendingRequest? {
		let endpoint = Endpoints.upload.replacingTokens(["format": UserRouteOutputType.js])
		return upload(endpoint, contentsOf: fileURL, body: metadata, with: completion)
	}

	/// Create a new route from the given FIT file.
	/// - Parameters:
	///   - fileURL: The URL for a FIT-based route file.
	///   - metadata: The metadata for the created route.
	///   - completion: Function called with the created route, or the error if one occurred.
	@discardableResult
	public func createRoute(fromFIT fileURL: URL, metadata: UserRoute, completion: @escaping Zone5.ResultHandler<UserRoute>) -> PendingRequest? {
		let endpoint = Endpoints.upload.replacingTokens(["format": UserRouteOutputType.fit])
		return upload(endpoint, contentsOf: fileURL, body: metadata, with: completion)
	}

	/// Create a new route from an existing activity matching the given `fileID`.
	/// - Note: Actual conversation occurs asynchronously. The route will be available once it has been processed.
	/// - Parameters:
	///   - routeID: The fileID for the activity to be cloned.
	///   - completion: Function called with the created route, or the error if one occurred.
	@discardableResult
	public func createRoute(fromActivity fileID: Int64, completion: @escaping Zone5.ResultHandler<UserRoute>) -> PendingRequest? {
		let endpoint = Endpoints.cloneActivity.replacingTokens(["fileID": fileID])
		return get(endpoint, with: completion)
	}

	/// Create a new route from an existing route matching the given `routeID`.
	/// - Note: Actual conversation occurs asynchronously. The route will be available once it has been processed.
	/// - Parameters:
	///   - routeID: The identifier for the route to be cloned.
	///   - completion: Function called with the created route, or the error if one occurred.
	@discardableResult
	public func createRoute(fromRoute routeID: Int64, completion: @escaping Zone5.ResultHandler<UserRoute>) -> PendingRequest? {
		let endpoint = Endpoints.cloneRoute.replacingTokens(["routeID": routeID])
		return get(endpoint, with: completion)
	}

	/// Update a route from the given JSON file.
	/// The JSON file should follow the expected structure, e.g.:
	/// ```
	/// {
	///   "course_points": [
	///       // lat, lng, elapsed distance (m), fit course point type (ordinal), text
	///   	  [-420945877, 1778923344, 4572, 0, "Head northeast on Lady Denman Dr<br>Walk your bicycle"],
	///   	  ...
	///   ],
	///   "records": [
	///       // lat, lng, elapsed distance (m), altitude (m), grade (%)
	///       [-420751495, 1779320598, 0, 0, 0],
	///       ...
	///   ]
	/// }
	/// ```
	/// - Parameters:
	///   - routeID: The identifier for the route to be updated.
	///   - fileURL: The URL for a JSON-formatted route file for updating the route.
	///   - metadata: The updated metadata for the route.
	///   - completion: Function called with the updated route, or the error if one occurred.
	@discardableResult
	public func updateRoute(with routeID: Int64, fromJSON fileURL: URL, metadata: UserRoute, completion: @escaping Zone5.ResultHandler<UserRoute>) -> PendingRequest? {
		let endpoint = Endpoints.uploadUpdate.replacingTokens(["routeID": routeID, "format": UserRouteOutputType.js])
		return upload(endpoint, contentsOf: fileURL, body: metadata, with: completion)
	}

	/// Update a route from the given FIT file.
	/// - Parameters:
	///   - routeID: The identifier for the route to be updated.
	///   - fileURL: The URL for a FIT-based route file for updating the route.
	///   - metadata: The updated metadata for the route.
	///   - completion: Function called with the updated route, or the error if one occurred.
	@discardableResult
	public func updateRoute(with routeID: Int64, fromFIT fileURL: URL, metadata: UserRoute, completion: @escaping Zone5.ResultHandler<UserRoute>) -> PendingRequest? {
		let endpoint = Endpoints.uploadUpdate.replacingTokens(["routeID": routeID, "format": UserRouteOutputType.fit])
		return upload(endpoint, contentsOf: fileURL, body: metadata, with: completion)
	}

	/// Update the meta-data of this route, i.e. set equipment, terrain, name, description, tags, etc.
	/// Partial/shallow updates are supported.
	/// - Parameters:
	///   - routeID: The identifier for the route to be updated.
	///   - metadata: The updated metadata for the route.
	///   - completion: Function called with the updated route, or the error if one occurred.
	@discardableResult
	public func updateMetadata(for routeID: Int64, metadata: UserRoute, completion: @escaping Zone5.ResultHandler<Bool>) -> PendingRequest? {
		let endpoint = Endpoints.update.replacingTokens(["routeID": routeID])
		return post(endpoint, body: metadata, with: completion)
	}

	/// Delete a route.
	/// - Parameters:
	///   - routeID: The identifier for the route to be deleted.
	///   - completion: Function called with the result of the deletion attempt, or the error if one occurred.
	@discardableResult
	public func delete(routeID: Int64, completion: @escaping Zone5.ResultHandler<Bool>) -> PendingRequest? {
		let endpoint = Endpoints.delete.replacingTokens(["routeID": routeID])
		return get(endpoint, with: completion)
	}

}
