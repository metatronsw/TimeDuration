# TimeDuration

A simple swift structure representing a period of time. It is simply stored in a piece of unsigned UInt64. A negative time is not possible on the timeline, the minimum value is 00:00:00.000 and the maximum is 593066617 year 214 day 14 hour 25 min 51 sec 615 msec.

Why a separate structure when Swift already has its own Duration structure ? Because Swift Duration uses two components, and the fractional seconds are measured in attoseconds, which further complicates and slows down the traditional millisecond-based timecode time measurement.

Examples of use: 

		let enum: TimeDuration = .zero
		
		let components: TimeDuration = .hours(2) + .minutes(32) + .seconds(10) + .milliseconds(001)
		
		let timeCode = TimeDuration("02:32:10.001")
		
		let integers = TimeDuration(hour: 2, min: 32, sec: 10, msec: 001)

		let milliseconds = TimeDuration(msec: 9130001)
		
		
	
		
