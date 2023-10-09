//
//  Time Duration.swift
//  Created by Szerencsés Gábor on 2023.10.08.
//

import Foundation


/// Storage of elapsed time in a single UInt64 number. Initialization and conversion to timecode format
///
public struct TimeDuration: Codable, CustomStringConvertible {
	
	/// Time Code Components
	///
	public typealias TCC = (hour: UInt64, min: UInt64, sec: UInt64, msec: UInt64)
	
	/// Time value stored in milliseconds base
	///
	public var msec: UInt64
	
	/// Initialisation by exact value
	///
	public init(msec: UInt64) { self.msec = msec }
	
	
	
	/// Accurate and strict conversion from timecode string
	///
	static public func timeCodeToTcc(_ string: String) -> TCC? {
		
		let components = string.components(separatedBy: ":")
		guard components.count == 3, components[1].count == 2 else { return nil }
		
		let sec_msec = components[2].components(separatedBy: ".")
		guard sec_msec.count == 2, sec_msec.first!.count == 2 else { return nil }
		
		guard let h = UInt64(components[0]),
				let m = UInt64(components[1]),
				let s = UInt64(sec_msec.first!),
				let ms = UInt64(sec_msec.last!.prefix(3))
		else { return nil }
		
		return (hour: h, min: m, sec: s, msec: ms)
	}
	
	
	/// Allowing lazy conversion time from strings
	///
	static public func stringToTcc(_ string: String, separator: String = ":", decimal: String = ".") -> TCC? {
		
		let components = Array(string.components(separatedBy: separator).reversed())
		
		print(components)
		
		var tcc: TCC  = (hour: 0 , min: 0 , sec: 0 , msec: 0)
		
		let sec_msec = components[0].components(separatedBy: decimal)
		
		if sec_msec.count > 1 {
			if sec_msec[1].count > 3 {
				tcc.msec = UInt64(sec_msec[1].prefix(3)) ?? 0
			} else {
				tcc.msec = UInt64(sec_msec[1]) ?? 0
			}
		}
		
		tcc.sec = UInt64(sec_msec[0]) ?? 0
		
		if components.count > 1 { tcc.min = UInt64(components[1]) ?? 0 }
		if components.count > 2 { tcc.hour = UInt64(components[2]) ?? 0 }
		
		return tcc
	}
	
	
	/// Convert time units to milliseconds
	///
	static public func tccToMSec(_ tcc: TCC) -> UInt64 {
		return tcc.hour * 3600_000 + tcc.min * 60_000 + tcc.sec * 1_000 + tcc.msec
	}
	
	
	
	
	
	// INIT ----
	
	/// Initialisation from integer format on SECOND basis
	///
	public init(_ tcc: TCC) {
		self.msec = Self.tccToMSec(tcc)
	}
	
	
	/// Initialisation from floating point format on SECOND basis
	///
	public init(_ double: Double) {
		self.msec = UInt64(double * 1_000)
	}
	
	
	/// Initialisation by separated time units
	///
	public init?(hour: String, min: String, sec: String, msec: String) {
		guard let h = UInt64(hour), let m = UInt64(min), let s = UInt64(sec), let ms = UInt64(msec) else { return nil }
		self.msec = h * 3600_000 + m * 60_000 + s * 1_000 + ms
	}
	
	
	/// Initialization by any time format, or unofficial - freely formatted timecode
	///
	public init?(_ string: String, separator: String = ":", decimal: String = ".") {
		guard let tcc = TimeDuration.stringToTcc(string, separator: separator, decimal: decimal) else { return nil }
		self.init(tcc)
	}
	
	
	/// Initialisation according to official timecode format - 00:00:00.000
	///
	public init?(timecode: String) {
		guard let tcc = TimeDuration.timeCodeToTcc(timecode) else { return nil }
		self.init(tcc)
	}
	
	
	
	
	// FUNCTIONS ----
	
	/// The return value is the official timecode format - 00:00:00.000
	///
	public var timecode: String {
		let (hour, hrem) = msec.quotientAndRemainder(dividingBy: 3600_000)
		let (min, dsec) = hrem.quotientAndRemainder(dividingBy: 60_000)
		let (sec, msec) = dsec.quotientAndRemainder(dividingBy: 1_000)
		return String(format: "%02d:%02d:%02d.%03d", hour, min, sec , msec)
	}
	
	/// The return value is a touple of UInt64 numbers: (hour, min, sec, msec)
	///
	public var components: TCC {
		let (hour, hrem) = msec.quotientAndRemainder(dividingBy: 3600_000)
		let (min, dsec) = hrem.quotientAndRemainder(dividingBy: 60_000)
		let (sec, msec) = dsec.quotientAndRemainder(dividingBy: 1_000)
		return (hour: hour, min: min, sec: sec, msec: msec)
	}
	
	
	public var description: String {
		timecode
	}
	
	public var date: String {
		let tcc = components
		
		if tcc.hour < 25 { return "\(tcc.hour) hour  \(tcc.min) min  \(tcc.sec) sec  \(tcc.msec) msec"}
		
		if tcc.hour < 169 {
			let (days, hours) = tcc.hour.quotientAndRemainder(dividingBy: 24)
			return "\(days) day  \(hours) hour  \(tcc.min) min  \(tcc.sec) sec  \(tcc.msec) msec"
		}
		
		let (years, hours) = tcc.hour.quotientAndRemainder(dividingBy: 8640)
		let (days, dhours) = hours.quotientAndRemainder(dividingBy: 24)
		return "\(years) year  \(days) day  \(dhours) hour  \(tcc.min) min  \(tcc.sec) sec  \(tcc.msec) msec"
	}
	
	
	public var seconds: Int { return Int(msec / 1_000) }
	
	
}





extension TimeDuration: AdditiveArithmetic, Hashable, Comparable, Equatable, ExpressibleByStringLiteral, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
	
	public typealias StringLiteralType = String
	public typealias IntegerLiteralType = UInt64
	public typealias FloatLiteralType = Double
	public typealias Magnitude = UInt64
	
	public var magnitude: UInt64 { msec }
	
	
	public init(integerLiteral value: UInt64) {
		self.init(msec: value * 1_000)
	}
	
	public init(stringLiteral string: String) {
		guard let tcc = TimeDuration.timeCodeToTcc(string) else { fatalError("Incorrect timecode string literal: \(string)") }
		self.init(tcc)
	}
	
	public init(floatLiteral float: Double) {
		self.init(float)
	}
	
	public init?<T>(exactly source: T) where T : BinaryInteger {
		self.init(msec: UInt64(source) * 1_000)
	}
	
	
	
	static public func + (lhs: TimeDuration, rhs: TimeDuration) -> TimeDuration {
		TimeDuration.init(msec: lhs.msec + rhs.msec)
	}
	
	static public func - (lhs: TimeDuration, rhs: TimeDuration) -> TimeDuration {
		let (value, over) = lhs.msec.subtractingReportingOverflow(rhs.msec)
		return TimeDuration.init(msec: over ? 0 : value)
	}
	
	
	static public func += (lhs: inout TimeDuration, rhs: TimeDuration) {
		lhs.msec += rhs.msec
	}
	
	static public func -= (lhs: inout TimeDuration, rhs: TimeDuration) {
		lhs.msec -= rhs.msec
	}

	
	static public func * (lhs: TimeDuration, rhs: UInt64) -> TimeDuration {
		TimeDuration.init(msec: lhs.msec * rhs)
	}
	
	static public func / (lhs: TimeDuration, rhs: UInt64) -> TimeDuration {
		TimeDuration.init(msec: lhs.msec / rhs)
	}
	
	
	static public func *= (lhs: inout TimeDuration, rhs: UInt64) {
		lhs.msec *= rhs
	}
	
	static public func /= (lhs: inout TimeDuration, rhs: UInt64) {
		lhs.msec /= rhs
	}
	

	
	
	static public func == (lhs: TimeDuration, rhs: TimeDuration) -> Bool {
		return lhs.msec == rhs.msec
	}
	
	static public func < (lhs: TimeDuration, rhs: TimeDuration) -> Bool {
		return lhs.msec < rhs.msec
	}
	
}



public extension TimeDuration {
	
	/// One hour time duration
	static let oneHour = TimeDuration(msec: 3600_000)
	
	/// One minute time duration
	static let oneMin = TimeDuration(msec: 60_000)
	
	/// One second time duration
	static let oneSec = TimeDuration(msec: 1_000)
	
	/// One Millisecond time duration
	static let oneMSec = TimeDuration(msec: 1)
	
	/// Zero time duration
	static let zero = TimeDuration(msec: 0)
	
	
	/// Static initialisation based on hour
	static func hours(_ hours: UInt64) -> TimeDuration { TimeDuration(msec: hours * 3600_000) }
	
	/// Static initialisation based on minute
	static func minutes(_ minutes: UInt64) -> TimeDuration { TimeDuration(msec: minutes * 60_000) }
	
	/// Static initialisation based on second
	static func seconds(_ seconds: UInt64) -> TimeDuration { TimeDuration(msec: seconds * 1_000) }
	
	/// Static initialisation based on millisecond
	static func milliseconds(_ mseconds: UInt64) -> TimeDuration { TimeDuration(msec: mseconds) }
	

}


