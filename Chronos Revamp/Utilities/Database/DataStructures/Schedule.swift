//
//  Schedule.swift
//  Chronos Revamp
//
//  Created by Nick Viscomi on 8/15/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class Schedule {
    var grade: Grade
    var startTimes: [String]
    var endTimes: [String]
    var periodName: [String]
    
    init(grade: Grade, startTimes: [String], endTimes: [String], periodName: [String]) {
        self.grade = grade
        self.startTimes = startTimes
        self.endTimes = endTimes
        self.periodName = periodName
    }
}
