import Foundation

/// This is a view object related to activity data. It has a lot of possible fields, but most are only populated if a
/// specific field is requested via the Activities API.
///
/// Some fields are also sport specific - and will only be set on activities of the relevant sport type.
public struct UserWorkoutResult: Codable {

	/// UserWorkoutResult.id
	public var id: Int?

	/// The year that this activity was completed
	public var year: Int?

	/// The day of year that this activity was completed
	public var dayOfYear: Int?

	/// A unix timestamp (ms) of when this activity was last modified
	public var modifedTime: Int?

	/// A unix timestamp (ms) of when this activity was created in the system (not the actual activity start time)
	public var createdTime: Int?

	/// Flag to track if this workout is tagged as a favorite/bookmarked
	public var favorite: Bool?

	/// Metadata on the head unit used to complete this activity
	public var headunit: UserHeadunit?

	/// Metadata on the power meter used to complete this activity
	public var powermeter: UserPowerMeter?

	/// A generic count param - often used to convey the number of records which comprise an aggregate calculation
	public var count: Int?

	/// Metadata related to day attributes on the day this activity was scheduled/completed
	//public var day: VUserDay?

	/// Metadata related to HRV on the day this activity was scheduled/completed
	//public var hrv: VUserDayHRV?

	/// Metadata related to sleep on the day this activity was scheduled/completed
	//public var sleep: VUserDaySleep?

	/// Metadata related to subjective ratings completed on the day this activity was scheduled/completed
	//public var rating: VUserDayRatings?

	/// Metadata related to route used for this activity
	public var route: UserRoute?

	/// Rating of the scheduled workout
	//public var sessionrating: VUserWorkoutResultRating?

	/// Metadata related to a scheduled workout/event
	public var scheduled: UserWorkoutDetails?

	/// Metadata related to a scheduled workout/event
	//public var event: VUserEvent?

	/// Metadata related to the training plan this activity relates to
	//public var plan: VUserPlan?

	/// A flag indicating how this activity result came into the system
	public var source: ResultSource?

	/// Locality based of geolocation data
	public var locality: String?

	/// A bitmask tracking which fields have been manually modified in the activity results
	public var fieldOverrideMask: Int?

	/// A bitmask tracking which fields have been manually modified in the activity results
	public var fieldOverrideMask2: Int?

	/// A bitmask tracking potential data integrity issues with this activity data
	public var reviewMask: Int?

	/// A bitmask tracking which data channels are available in this activity
	public var channelMask: Int?

	/// A bitmask tracking which file processing features have run
	public var featureMask: Int?

	/// A bitmask tracking which time in zones have been calculated for this activity
	public var zoneMask: Int?

	public var notes: Int?

	public var user: User?

	/// Start location of the activity
	public var lat1: Double?
	/// Start location of the activity
	public var lon1: Double?

	/// End location of the activity
	public var lat2: Double?
	/// End location of the activity
	public var lon2: Double?

	/// Power efficiency - a relation of power to heart rate
	public var ef: Double?

	/// ascent / training/60/60
	public var vam: Double?

	/// subjective rating - rate of perceived effort
	public var rpe: Double?

	/// subjective rating - pain score / leg quality score
	public var pain: Double?

	/// subjective rating - total quality recovery
	public var tqr: Double?

	/// Avg torque (nm)
	public var avgNm: Int?

	/// Max torque (nm)
	public var maxNm: Int?

	/// Cafe time - time difference between training and elapsed time (seconds)
	public var idle: Int?

	/// Number of seconds where no power was being produced
	public var noPower: Int?

	/// avg Power / Heart Rate / RPE/// 1000
	public var gscore: Int?

	/// average heart rate / RPE
	public var rpeh: Double?

	/// aPower:HR (altitude corrected average power / average heart rate)
	public var rpeef: Double?

	/// aPower:RPE (altitude corrected average power / RPE)
	public var rpep: Double?

	/// State of the workout - ie completed, did not start, pending etc
	public var state: UserWorkoutState?

	/// Flag for tracking whether this activity has been reviewed or has data integrity issues
	public var review: ResultReview?

	/// Reason why a workout was not completed
	public var reason: UserWorkoutFailedReason?

	/// Activity name
	public var name: String?

	/// Activity description
	public var descr: String?

	/// Display name for the event course
	public var course: String?

	/// Event category
	public var category: EventTeamCategory?

	/// UserWorkout.id - if this result relates to a workout
	public var workoutId: Int?

	/// UserWorkoutFile.id - if this result relates to a file
	public var fileId: Int?

	/// UserEvent.id - if this result relates to an event
	public var eventId: Int?

	/// This id coupled with the ActivityResultType is a unique key for this activity
	public var activityId: Int?

	/// This value coupled with the activityId is a unique key for this activity
	public var activity: ActivityResultType?

	/// Timestamp of the result - this will match either the workout or event scheduled date or the start time of an adhoc ride
	public var ts: Milliseconds?

	/// Timestamp of when the activity actually commenced
	public var startTs: Milliseconds?

	/// The timezone this activity is scheduled or completed in
	public var tz: String?

	/// Type of activity - ie ride, run etc
	public var type: ActivityType?

	/// Equipment used in the activity (cycling)
	public var equipment: Equipment?

	/// Type of workout - ie training, event etc
	public var workout: WorkoutType?

	/// Lap number (if any - only set on intervals)
	public var lap: Int?

	/// Lap type (if any - only set on intervals)
	public var lapType: LapType?

	/// The user's weight at the time of the activity (kg)
	public var weight: Double?

	/// Actual movement time (seconds)
	public var training: Int?

	/// Elapsed time (seconds)
	public var elapsed: Int?

	public var vo2max: Double?

	/// Total distance
	public var distance: Double?

	/// Power based T-Score
	public var tscorepwr: Double?

	/// Heart rate based T-Score
	public var tscorehr: Double?

	/// Threshold heart rate
	public var atBpm: Int?

	/// Intensity factor
	public var intensityFactor: Int?

	/// Estimated calories for the activity
	public var calories: Int?

	/// Estimated kj for the activity
	public var kj: Int?

	/// Estimated kj/hour for the activity
	public var kjh: Double?

	/// Estimated kj/body weight (kg) for the activity
	public var kjkg: Double?

	/// Estimated kj/h/kg for the activity
	public var kjhkg: Double?

	/// Adjusted power for the activity
	public var np: Int?

	/// Variability index for the activity
	public var vi: Double?

	/// Intensity for the activity
	public var iff: Double?

	/// watts/kg
	public var wkg: Double?

	/// The threshold power when this activity was completed
	public var thresholdWatts: Int?

	/// The estimated threshold based on this activity
	public var estThresWatts: Int?

	public var estThresWattsKg: Int?

	/// The threshold type used for this activity
	public var thresholdType: PowerThresholdType?

	/// The tscore calculation used for this activity
	public var tscoreType: TScoreType?

	/// The threshold heart rate when this activity was completed
	public var thresholdBpm: Int?

	/// The threshold pace when this activity was completed
	public var thresholdPace: Int?

	/// The max heart rate set when this activity was completed (ie user profile maxHr, not the peak heart rate in the activity
	public var maxHr: Int?

	/// Total elevation gain
	public var ascent: Int?

	/// Total elevation loss
	public var descent: Int?

	/// Starting altitude
	public var startAlt: Int?

	/// Finishing altitude
	public var endAlt: Int?

	/// Min altitude
	public var minAlt: Int?

	/// Max altitude
	public var maxAlt: Int?

	/// Average altitude
	public var avgAlt: Int?

	/// Speed (km/h)
	public var avgSpeed: Double?

	/// Speed (km/h)
	public var maxSpeed: Double?

	/// Cadence (rpm)
	public var avgCadence: Int?

	/// Cadence (rpm)
	public var maxCadence: Int?

	/// Saturated Hb percent
	public var minSatHbP: Double?
	/// Saturated Hb percent
	public var maxSatHbP: Double?
	/// Saturated Hb percent
	public var avgSatHbP: Double?

	/// TotalHemoglobinConc
	public var minTotHbC: Double?
	/// TotalHemoglobinConc
	public var maxTotHbC: Double?
	/// TotalHemoglobinConc
	public var avgTotHbC: Double?

	/// Temperature (celsius)
	public var minTemp: Int?
	/// Temperature (celsius)
	public var maxTemp: Int?
	/// Temperature (celsius)
	public var avgTemp: Int?

	/// Heart rate (BPM)
	public var minBpm: Int?
	/// Heart rate (BPM)
	public var avgBpm: Int?
	/// Heart rate (BPM)
	public var maxBpm: Int?

	/// Percentage of maxHR
	public var avgBpmP: Double?

	/// Percentage of maxHR
	public var maxBpmP: Double?

	/// Average power
	public var avgWatts: Int?

	/// Estimated critical power
	public var cp: Int?

	/// Anaerobic work capacity - Joules
	public var awc: Int?

	public var tau: Double?

	/// Average power above threshold
	public var avgWattsAboveCP: Int?

	/// Average power below threshold
	public var avgWattsBelowCP: Int?

	/// Time above threshold
	public var timeAboveCP: Int?

	/// Maximum power
	public var maxWatts: Int?

	public var peak3secWatts: Int?
	public var peak3secWattsP: Int?
	public var peak3secWkg: Double?

	public var peak4secWatts: Int?
	public var peak4secWattsP: Int?
	public var peak4secWkg: Double?

	public var peak5secWatts: Int?
	public var peak5secWattsP: Int?
	public var peak5secWkg: Double?

	public var peak10secWatts: Int?
	public var peak10secWattsP: Int?
	public var peak10secWkg: Double?

	public var peak12secWatts: Int?
	public var peak12secWattsP: Int?
	public var peak12secWkg: Double?

	public var peak20secWatts: Int?
	public var peak20secWattsP: Int?
	public var peak20secWkg: Double?

	public var peak30secWatts: Int?
	public var peak30secWattsP: Int?
	public var peak30secWkg: Double?

	public var peak1minWatts: Int?
	public var peak1minWattsP: Int?
	public var peak1minWkg: Double?

	public var peak2minWatts: Int?
	public var peak2minWattsP: Int?
	public var peak2minWkg: Double?

	public var peak3minWatts: Int?
	public var peak3minWattsP: Int?
	public var peak3minWkg: Double?

	public var peak4minWatts: Int?
	public var peak4minWattsP: Int?
	public var peak4minWkg: Double?

	public var peak5minWatts: Int?
	public var peak5minWattsP: Int?
	public var peak5minWkg: Double?

	public var peak6minWatts: Int?
	public var peak6minWattsP: Int?
	public var peak6minWkg: Double?

	public var peak10minWatts: Int?
	public var peak10minWattsP: Int?
	public var peak10minWkg: Double?

	public var peak12minWatts: Int?
	public var peak12minWattsP: Int?
	public var peak12minWkg: Double?

	public var peak15minWatts: Int?
	public var peak15minWattsP: Int?
	public var peak15minWkg: Double?

	public var peak16minWatts: Int?
	public var peak16minWattsP: Int?
	public var peak16minWkg: Double?

	public var peak20minWatts: Int?
	public var peak20minWattsP: Int?
	public var peak20minWkg: Double?

	public var peak24minWatts: Int?
	public var peak24minWattsP: Int?
	public var peak24minWkg: Double?

	public var peak30minWatts: Int?
	public var peak30minWattsP: Int?
	public var peak30minWkg: Double?

	public var peak40minWatts: Int?
	public var peak40minWattsP: Int?
	public var peak40minWkg: Double?

	public var peak60minWatts: Int?
	public var peak60minWattsP: Int?
	public var peak60minWkg: Double?

	public var peak75minWatts: Int?
	public var peak75minWattsP: Int?
	public var peak75minWkg: Double?

	public var peak80minWatts: Int?
	public var peak80minWattsP: Int?
	public var peak80minWkg: Double?

	public var peak90minWatts: Int?
	public var peak90minWattsP: Int?
	public var peak90minWkg: Double?

	public var peak120minWatts: Int?
	public var peak120minWattsP: Int?
	public var peak120minWkg: Double?

	public var peak150minWatts: Int?
	public var peak150minWattsP: Int?
	public var peak150minWkg: Double?

	public var peak180minWatts: Int?
	public var peak180minWattsP: Int?
	public var peak180minWkg: Double?

	public var peak210minWatts: Int?
	public var peak210minWattsP: Int?
	public var peak210minWkg: Double?

	public var peak240minWatts: Int?
	public var peak240minWattsP: Int?
	public var peak240minWkg: Double?

	public var peak360minWatts: Int?
	public var peak360minWattsP: Int?
	public var peak360minWkg: Double?

	public var peak5secBpm: Int?
	public var peak5secBpmP: Int?

	public var peak10secBpm: Int?
	public var peak10secBpmP: Int?

	public var peak1minBpm: Int?
	public var peak1minBpmP: Int?

	public var peak5minBpm: Int?
	public var peak5minBpmP: Int?

	public var peak10minBpm: Int?
	public var peak10minBpmP: Int?

	public var peak20minBpm: Int?
	public var peak20minBpmP: Int?

	public var peak30minBpm: Int?
	public var peak30minBpmP: Int?

	public var peak60minBpm: Int?
	public var peak60minBpmP: Int?

	public var peak120minBpm: Int?
	public var peak120minBpmP: Int?

	public var peak180minBpm: Int?
	public var peak180minBpmP: Int?

	/// di2 gearing
	public var minGear: String?
	public var maxGear: String?
	public var avgGear: String?
	public var gearChangeCnt: Int?

	/// gradient %
	public var minGrade: Double?
	public var maxGrade: Double?
	public var avgGrade: Double?

	public var bpmSampleRate: Double?
	public var bpmSampleCnt: Int?

	public var pwrSampleRate: Double?
	public var pwrSampleCnt: Int?

	/// power meter info
	public var pwrDisplay: String?
	public var pwrBattery: Double?
	public var pwrBatteryP: Int?
	public var pwrOffset: Int?
	public var pwrSlope: Int?
	public var pwrManufacturer: String?
	public var pwrManufacturerId: Int?
	public var pwrVersion: String?
	public var pwrSerial: String?
	public var pwrProduct: String?
	public var pwrId: String?
	public var pwrBalance: Int?
	public var pwrDiscardCnt: Int?

	/// Time in zones
	public var secsInZonePwr: [Int: Int]?
	public var secsInSurface: [String: Int]?
	public var secsInZonePace: [Int: Int]?
	public var secsInZoneWkg: [Int: Int]?
	public var secsInZoneNm: [Int: Int]?
	public var secsInZoneBpm: [Int: Int]?
	public var secsInZoneMaxHr: [Int: Int]?

	public var wkgZones: [UserIntensityZoneRange]?
	public var bpmZones: [UserIntensityZoneRange]?
	public var maxHrZones: [UserIntensityZoneRange]?
	public var pwrZones: [UserIntensityZoneRange]?
	public var nmZones: [UserIntensityZoneRange]?
	public var paceZones: [UserIntensityZoneRange]?
	public var bpmZoneNames: [Int: String]?

	public var laps: [UserWorkoutResult]?

	public var distributions: [DataFileChannel: [Int: Int]]?

	//public var swimLaps: [VUserWorkoutResultSwimLap]?

	/// used for multisport and brick? sub-activities
	// TODO: Value type `UserWorkoutResult` cannot have a stored property that recursively contains it
	//public var children: [UserWorkoutResult]?
	//public var related: [UserWorkoutResult]?
	//public var parent: UserWorkoutResult?

	//public var metadata: [String: Any]?

	public var permissions: [DataAccessRequest]?

	public var aap: UserWorkoutResultAlt?

	public var ext: UserWorkoutResultExt?

	public var ext2: UserWorkoutResultExt2?

	public var pace: UserWorkoutResultPeakPace?

	public var lss: UserWorkoutResultPeakLss?

	public var hour: UserWorkoutResultByHour?

	public var turbo: UserWorkoutResultTurbo?

	public var channels: [UserWorkoutResultChannel]?

	// MARK: UserWorkoutResultAggregates

	// TODO: Value type `UserWorkoutResult` cannot have a stored property that recursively contains it
	//public var sum: UserWorkoutResult?
	//public var min: UserWorkoutResult?
	//public var max: UserWorkoutResult?
	//public var avg: UserWorkoutResult?
	//public var wavg: UserWorkoutResult?

	public init() {}

}
