//
//  SchoolDay.swift
//  Chronos Revamp
//
//  Created by Nick Viscomi on 8/15/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

enum DaySchedule {
    case twoHrEarly
    case twoHrDelay
    case Regular
    case events
    case weekend
    case databasePath
}

enum PeriodType {
    case OneSeven
    case OneFour
    case FiveSeven
}

class SchoolDay {
    var dateString: String
    var daySchedule: DaySchedule
    var periodType: PeriodType?
    var letterDay: String
    var dayInfo: String
    var path: String
    
    init(dateString: String, daySchedule: DaySchedule, periodType: PeriodType?, letterDay: String, dayInfo: String, path: String = "") {
        self.dateString = dateString
        self.daySchedule = daySchedule
        self.periodType = periodType
        self.letterDay = letterDay
        self.dayInfo = dayInfo
        self.path = path
    }
    
}
