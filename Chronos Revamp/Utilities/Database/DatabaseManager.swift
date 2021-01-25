//
//  DatabaseManager.swift
//  Chronos Revamp
//
//  Created by Nick Viscomi on 8/15/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
}

extension DatabaseManager {
    public func getSchoolDay(completion: @escaping (SchoolDay?) -> Void) {
        let currentDateString = currentDate()
        
        database.child("\(currentDateString)").observe(.value) { (snapshot) in
            guard let data = snapshot.value as? [String: Any] else {
                completion(nil)
                return
                //["Letter day": ["info": " "], "Type of day": ["info": ""], "Day Schedule": ["info": "weekend"]]
            }
            
            guard let letterDay = data["Letter Day"] as? String, let typeOfDay = data["Day Info"] as? String, let item = data["Day Schedule"] as? String else {
                completion(nil)
                return
            }
            
            var daySchedule: DaySchedule!
            switch item {
            case "2hr delay":
                daySchedule = .twoHrDelay
                break
            case "2hr early":
                daySchedule = .twoHrEarly
                break
            case "events":
                daySchedule = .events
                break
            case "regular":
                daySchedule = .Regular
                break
            case "weekend":
                daySchedule = .weekend
                break
            default:
                completion(nil)
                break
            }
            
            var periodType: PeriodType?
            let oneSevenLetterDays = ["A","D","E","H","I","L"]
            let oneFourLetterDays = ["B","F","J"]
            let fiveSevenLetterDays = ["C","G","K"]
            
            if oneSevenLetterDays.contains(letterDay) {
                periodType = .OneSeven
            } else if oneFourLetterDays.contains(letterDay) {
                periodType = .OneFour
            } else if fiveSevenLetterDays.contains(letterDay) {
                periodType = .FiveSeven
            } else {
                periodType = nil
            }
            
            
            let schoolDay = SchoolDay(dateString: currentDate(), daySchedule: daySchedule, periodType: periodType, letterDay: letterDay, dayInfo: typeOfDay)
            
            completion(schoolDay)
            
        }
    }
    
    public func getSchoolSchedule(with schoolDay: SchoolDay, completion: (Schedule?) -> Void) {
        guard HomeViewController.hasSelectedGrade, let grade = HomeViewController.grade else {
            print("no grade selected")
            return
        }
        if schoolDay.daySchedule == .weekend {
            isWeekend()
            return
        }

        let periodTimes = PeriodTimes(schoolDay: schoolDay, grade: grade)
        guard let startTimes = periodTimes.startTimes, let endTimes = periodTimes.endTimes, let periodNames = periodTimes.periodNames else { print("you suck bruh"); return }
        
        let schedule = Schedule(grade: grade, startTimes: startTimes, endTimes: endTimes, periodName: periodNames)
        
        completion(schedule)
    }
    
    public func getDayInfo(completion: @escaping (String?) -> Void) {
        let currentDateString = currentDate()
        print(currentDateString)
        //Set the values of type of day and letter day
        database.child("\(currentDateString)/Day Info").observe(.value) { (snapshot) in
            guard let info = snapshot.value as? String  else {
                completion(nil)
                return
            }
            
            completion(info)
        }
    }
    
    public func isWeekend() {
        //MARK: fill out this with weekend information
    }
}
