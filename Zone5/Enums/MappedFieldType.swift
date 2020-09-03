//
//  MappedFieldType.swift
//  Zone5
//
//  Created by Daniel Farrelly on 11/11/19.
//  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

public enum MappedFieldType: String, Codable {

	/// This field is a simple string
	case string
	
	/// This field is a numeric value. It should be treated as an int
	case number
	
	/// This field is a floating point / double value. UI field rules should determine precision
	@available(*, deprecated, message: "Use `decimal1` or `decimal2` instead")
	case decimal
	
	/// This field is a true/false
	case bool
	
	/// This field is a unix timestamp (ms) - it should be shown as a date - ensure you apply the correct timezone
	case date
	
	/// This field is a unix timestamp (ms) - it should be shown as a time - ensure you apply the correct timezone
	case time
	
	/// This field is a unix timestamp (ms) - it should be shown as a full date + time - ensure you apply the correct timezone
	case timestamp
	
	/// This field is a date of birth - it should be shown as a date with UTC applied as the timezone
	case dob
	
	/// This field is in cm - it should be shown as either cm (metric) or feet + inches (imperial)
	case height
	
	/// This field is in kg - it should be shown as either kg (metric) or lb (imperial)
	case weight
	
	/// This field is in km - it should be shown in either km (metric) or mi (imperial
	case distanceKilometers = "distancekm"
	
	/// This field is in meters/second - it should be shown in either km/h (metric) or mi/h (imperial)
	case speedMetersPerSecond = "speedms"
	
	/// This field is in km/hour - it should be shown in either km/h (metric) or mi/h (imperial)
	case speedKilometersPerHour = "speedkmh"
	
	/// This field is in meters - it should be shown in either km (metric) or mi (imperial).  Note also this may be negative
	case distanceFixedMeterToKilometersOrMiles = "distancefixedmtrtokmmi"
	
	/// This field is in meters - it should be shown in either meters (metric) or feet (imperial).  Note also this may be negative
	/// - Note: we use this for altitude
	case distanceFixedMeterToMetersOrFeet = "distancefixedmtrtomtrfeet"
	
	/// This field is in meters - it should be shown in either km (metric) or mi (imperial).  Note also this may be negative
	case distanceMeters = "distancemtr"
	
	/// This field is in watts. It should be an int value >= 0. A sane maxiumum value would be 2000
	case watts
	
	/// This field is in watts/kg. It should always be shown as w/kg regardless of metric/imperial preference
	case wattsPerKilogram = "wattskg"
	
	/// This field is in beats per minute. It should be an int value > 0. A sane value ramge would be 30 - 220
	case beatsPerMinute = "bpm"
	
	/// This field is in revolutions per minute. It should be an int value >= 0. A sane maxiumum value would be 200
	case revolutionsPerMinute = "rpm"
	
	/// This field is a timezone string. It could be either a short Java Timezone ID or a long timezone name
	case timezone
	
	/// This field is a locale string. It could be either a short or long Java locale name
	case locale
	
	/// This field is a enum. The enum value (name) will be returned in this field. See other meta data about this field for the class type
	case `enum` = "enumm"
	
	/// This field is a text field. It should use a multi-line formatted text input field. It may contain HTML
	case text
	
	/// This field is a collection. See other meta data about this field for collection member class
	case collection
	
	/// This field is a colour. It will be a hex #FFF style colour or a string based colour word.
	case colour
	
	/// This field is in seconds. It should be formatted as a duration
	case duration
	
	/// This field is in degrees celsius. It should be shown as C (metric) of F (imperial)
	case temperature
	
	/// This field is in neuton meters (torque). It will be an int value
	case neutonMeters = "nm"
	
	/// This field is a percentage (0-100) and represents haemoglobin percent
	case haemoglobinPercentage = "hbp"
	
	/// This field is haemoglobin concentrate
	case haemoglobinConcentrate = "hbc"
	
	/// This field represents gradient / slope. ie 7% climb
	case grade
	
	/// This field is in grams
	case grams
	
	/// This field is in mg
	case milligrams
	
	/// This field is in ml
	case milliliter
	
	/// This field is in kCal
	case calories
	
	/// This field is either a lat or long value
	case latlon
	
	/// This field is a URL string. It may be a full URL or a relative URL to this site
	case url
	
	/// This field is a bitmask - see additional metadata for a reference to the enum which defines the mask offsets
	case mask
	
	/// This field is an RPE score - 0 - 10. This may be a decimal on some systems and integers on others
	case rpeScore = "rpe"
	
	/// This field is an TQR score - 0 - 10. This may be a decimal on some systems and integers on others
	case tqrScore = "tqr"
	
	/// This field is a percentage
	case percentage
	
	/// This field is a numeric field and should be displayed to 1 decimal place
	case decimal1
	
	/// This field is a numeric field and should be displayed to 2 decimal place2
	case decimal2
	
	/// This field is in joules
	case joules
	
	case mbar
	
	/// This field is in degrees (ie wind direction)
	case degrees
	
	case millimeter
	
	/// This field is in kilo-joules
	case kilojoules = "kj"
	
	/// This field is in milliseconds - it should be parsed as a duration
	case milliseconds = "ms"
	
	case volts
	
	case tScore = "tscore"
	
	/// This field is vertical ascent meters (meters/second elevation gain) - it should always be shown as m/s regardless of metric/imperial
	case vam
	
	/// This field is in minutes and should be parsed as a duration
	case durationmins
	
	/// 1-10 (0 being unset 1 being worst 9 being best)
	case rating9
	
	/// 1-5 (0 being unset 1 being worst 5 being best)
	case rating5
	
	/// 1-5 - with 1/5 being bad and 3 being best
	case rating5m
	
	case zscore

	/// This field is in milliseconds and should be parsed as a duration
	case durationMilliseconds = "durationms"
	
	/// This field is in hours and should be parsed as a duration
	case durationHours = "durationhrs"
	
	/// This field is in days and should be parsed as a duration
	case durationDays = "durationdays"
	
	/// This field is a simple count. ie >=0 int
	case count
	
	case steps
	
	/// This field is either a URL to video media or it is a tag which can be used to play a YouTube video
	case media
	
	/// Urine Osmolality - mOsm/kg
	case mosmg
	
	/// 1-5 (0 being unset 5 being worst 1 being best)
	case rating51
	
	/// Percentage to 1 decimal place
	case percentage1
	
	/// blood oxygen saturation
	case spo2
	
	/// stroke per minute
	case strokePerMinute = "strokepm"
	
	/// stroke len (decimal in meters)
	case strokeLength = "strokelen"
	
	case zeroOffset = "zerooffset"
	
	case slope
	
	/// mins to complete a km or mile (running) - see PaceUtils*/
	case pace
	
	/// kN/m
	case knm
	
	/// centimetres
	case centimetres = "cm"
	
	/// thrust (s)
	case thrust
	
	/// Percentage to 2 decimal place
	case percentage2
	
	/// kN/m / kg
	case knmkg
	
	case tsb
	
	/// g-force
	case g
	
	/// rsscribe FootStrike
	case rsstrike
	
	/// Force[N]
	case n
		
	/// Acceleration
	case a
	
	/// Respiration rate - Breaths/minute
	case respiration
	
	/// Garmin MTB dynamics - 0-1 Smooth 1-20 Moderate 20+ rough
	case flow
	
	/// Garmin MTB dynamics - 0-20 (Easy) 20-40 (moderate) Hard 40+
	case grit
	
	/// Sum of all grit in a ride / 1000
	case kgrit
	
	/// watt-hour - unit of energy equivalent to one watt (1 W) of power expended for one hour (1 h) of time. The watt-hour is not a standard unit in any formal system but it is commonly used in electrical applications. An energy expenditure of 1 Wh represents 3600 joules (3.600 x 103 J)
	case wattHour = "wh"

}
