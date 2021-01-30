//
//  CacheManager.swift
//  Chronos Revamp
//
//  Created by Nick Viscomi on 1/27/21.
//  Copyright © 2021 Nick Viscomi. All rights reserved.
//

import Foundation

struct CacheKeys {
    static let startTimes = "startTimes"
    static let endTimes = "endTimes"
    static let periodNames = "periodNames"
    static let cachedSchedule = "cachedSchedule"
}

//to have the cache be succesful it will take a lot of nuance, so much that it might not even be worth it to have one
final class CacheManager {
    fileprivate let defaults = UserDefaults.standard
    //cache the current message and schedule for today
    private func cacheSchoolDay(schoolDay: SchoolDay) {
        
    }
    
    private func cacheSchedule(schedule: Schedule) {
        defaults.set(schedule.startTimes, forKey: CacheKeys.startTimes)
        defaults.set(schedule.endTimes, forKey: CacheKeys.endTimes)
        defaults.set(schedule.periodName, forKey: CacheKeys.periodNames)
    }
    
}
