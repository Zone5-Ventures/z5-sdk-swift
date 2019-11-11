// =  DataFileChannel.swift =  Zone5
// =  Created by Daniel Farrelly on 11/11/19. =  Copyright © 2019 Zone5 Ventures. All rights reserved.
//

import Foundation

public enum DataFileChannel: Int, Codable {

	/// Power
	case pwr = 0

	/// Heart rate
	case bpm = 1

	/// Cadence
	case rpm = 2

	/// % Hb concentrate
	case mo2 = 3

	/// Elevation / Altitude
	case alt = 4

	case speed = 5

	case temperature = 6

	case balance = 7

	case gears = 8

	/// torque / nm
	case nm = 9

	/// adjusted / normalized power
	case np = 10

	/// equated power
	case ep = 11

	/// The average wattage for each hr point
	case hrpwr = 12

	/// Simple running averages by km
	case perkm = 13

	/// Simple running averages by mi
	case permi = 14

	/// leg string stiffness
	case lss = 15

	/// pace
	case pace = 16

	case geo = 17

	case distance = 18

	/// The average pace at each hr point
	case hrpace = 19

	/// rs pod contact ms
	case contacttimems = 20

	/// rs pod impact G
	case impactg = 21

	/// rs pod braking G
	case brakingg = 22

	/// rs pod foot strike
	case footstrike = 23

	/// rs pronation degrees
	case pronation = 24

	/// ms
	case stancetime = 25

	/// mm
	case verticaloscillation = 26

	case flow = 27

	case respiration = 28

	case grit = 29

}
