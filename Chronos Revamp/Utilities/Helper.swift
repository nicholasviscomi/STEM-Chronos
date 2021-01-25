//
//  Helper.swift
//  Final Chronos
//
//  Created by Nick Viscomi on 8/9/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

struct UDKeys {
    static let firstTimeOpening = "firstTime"
    static let grade = "grade"
    static let previousStrokeEnd = "prev"
}
//MARK: String time between two dates
func findDateDiff(time1Str: String, time2Str: String) -> String {
    let timeformatter = DateFormatter()
    timeformatter.dateFormat = "hh:mm a"
    guard let time1 = timeformatter.date(from: time1Str),
        let time2 = timeformatter.date(from: time2Str) else { return "" }
    
    let interval = time2.timeIntervalSince(time1)
    let hour = interval / 3600;
    let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
    let intervalInt = Int(interval)
    return "\(intervalInt < 0 ? "" : "") \(Int(hour)) hours \(Int(minute)) minutes"
}

//MARK:Int time between 2 dates in minutes
func findDateDiffInt(time1Str: String, time2Str: String) -> Int {
    let timeformatter = DateFormatter()
    timeformatter.dateFormat = "hh:mm a"
    guard let time1 = timeformatter.date(from: time1Str),
        let time2 = timeformatter.date(from: time2Str) else { return 0 }
    
    let interval = time2.timeIntervalSince(time1)
    let hour = interval / 3600;
    let minute = interval.truncatingRemainder(dividingBy: 3600) / 60
    return (Int(hour) * 60) + (Int(minute))
}

func currentDate() -> String {
    let date = Date()
    let dateformatter = DateFormatter()
    dateformatter.dateStyle = .medium
    return dateformatter.string(from: date)
}

func currentTime() -> String {
    let date = Date()
    let dateformatter = DateFormatter()
    dateformatter.timeStyle = .short
    return dateformatter.string(from: date)
}
