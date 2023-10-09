import XCTest
@testable import TimeDuration

final class TimeDurationTests: XCTestCase {
    
	
	func testInit() throws {
      
		let int = TimeDuration(1)
		XCTAssertEqual(int, "00:00:01.000")
		
		let int1000 = TimeDuration(3600)
		XCTAssertEqual(int1000, "01:00:00.000")
		
		let double = TimeDuration(12.345)
		XCTAssertEqual(double, "00:00:12.345")
		
		let double1000 = TimeDuration(3600.999)
		XCTAssertEqual(double1000, "01:00:00.999")
		
		
		let intLiteral: TimeDuration = 1
		XCTAssertEqual(intLiteral, "00:00:01.000")
		
		let doubleLiteral: TimeDuration = 12.345
		XCTAssertEqual(doubleLiteral, "00:00:12.345")
		
		let msec: TimeDuration = .milliseconds(1)
		XCTAssertEqual(msec, "00:00:00.001")
		
		let minutes: TimeDuration = .minutes(60)
		XCTAssertEqual(minutes, "01:00:00.000")
		
		
		let zero: TimeDuration = .zero
		XCTAssertEqual(zero, "00:00:00.000")
		
		let components: TimeDuration = .hours(2) + .minutes(32) + .seconds(10) + .milliseconds(001)
		XCTAssertEqual(components, "02:32:10.001")
		
		let ints = TimeDuration(hour: 2, min: 32, sec: 10, msec: 001)
		XCTAssertEqual(ints, "02:32:10.001")
		
		let mints = TimeDuration(msec: 9130001)
		XCTAssertEqual(mints, "02:32:10.001")
		
		let strings = TimeDuration(hour: "02", min: "32", sec: "10", msec: "001")
		XCTAssertEqual(strings, "02:32:10.001")
		
		let mstrings = TimeDuration(msec: "9130001")
		XCTAssertEqual(mstrings, "02:32:10.001")
		
		let timeCode = TimeDuration("02:32:10.001")
		XCTAssertEqual(timeCode, "02:32:10.001")
		
		let timeString = TimeDuration(string: "32:10.001")
		XCTAssertEqual(timeString, "00:32:10.001")
		
		let milliseconds = TimeDuration(msec: 9130001)
		XCTAssertEqual(milliseconds, "02:32:10.001")
		
		let tcc = TimeDuration.TCC(hour: 2, min: 32, sec: 10, msec: 001)
		let tcComponents = TimeDuration(tcc)
		XCTAssertEqual(tcComponents, "02:32:10.001")
		
		
    }
	
	
	func testArithmeticPlus() throws {
		
		let int1 = TimeDuration(1)
		let int2 = TimeDuration(2)
		XCTAssertEqual(int1 + int2, "00:00:03.000")
		
		let double1 = TimeDuration(60.111)
		let double2 = TimeDuration(60.222)
		XCTAssertEqual(double1 + double2, "00:02:00.333")
		
		let hours: TimeDuration = .hours(99)
		let minutes: TimeDuration = .minutes(59)
		let seconds: TimeDuration = .seconds(59)
		let mseconds: TimeDuration = .milliseconds(999)
		let msecondsOne: TimeDuration = .milliseconds(1)
		XCTAssertEqual(hours + minutes + seconds + mseconds + msecondsOne, "100:00:00.000")
		
	}
	
	func testArithmeticMinus() throws {
		
		let int2 = TimeDuration(2)
		let int1 = TimeDuration(1)
		XCTAssertEqual(int2 - int1, "00:00:01.000")
		
		let double2 = TimeDuration(12.346)
		let double1 = TimeDuration(12.345)
		XCTAssertEqual(double2 - double1, "00:00:00.001")
		
		let minutes: TimeDuration = .minutes(60)
		let seconds: TimeDuration = .seconds(60)
		XCTAssertEqual(minutes - seconds, "00:59:00.000")
		XCTAssertEqual(seconds - minutes, "00:00:00.000")
		
		
	}
	
	func testArithmeticMultDiv() throws {
		
		let int = TimeDuration(3)
		XCTAssertEqual(int * 2, "00:00:06.000")
		XCTAssertEqual(int / 2, "00:00:01.500")
		
		let seconds: TimeDuration = .seconds(30)
		XCTAssertEqual(seconds * 2, "00:01:00.000")
		XCTAssertEqual(seconds / 2, "00:00:15.000")
	
		
	}
	
	func testArithmeticInouts() throws {
		
		var inouts: TimeDuration = .hours(1)
		let minutes: TimeDuration = .minutes(1)
		
		inouts -= minutes
		XCTAssertEqual(inouts, "00:59:00.000")

		inouts += minutes
		XCTAssertEqual(inouts, "01:00:00.000")
		
		inouts *= 2
		XCTAssertEqual(inouts, "02:00:00.000")
		
		inouts /= 2
		XCTAssertEqual(inouts, "01:00:00.000")
		
		inouts += 1
		XCTAssertEqual(inouts, "01:00:01.000")
		

	}
	
	
	
	func testArithmeticString() throws {
		
		let max: TimeDuration = TimeDuration(msec: UINT64_MAX)
		XCTAssertEqual(max.description, "199591902:25:51.615")
		XCTAssertEqual(max.date, "593066617 year  214 day  14 hour  25 min  51 sec  615 msec")
		
		let day: TimeDuration = .hours(25)
		XCTAssertEqual(day.date, "1 day  1 hour  0 min  0 sec  0 msec")
		
		let month: TimeDuration = 42234.134
		XCTAssertEqual(month.date, "11 hour  43 min  54 sec  134 msec")

	}
	
	
	
	
}
