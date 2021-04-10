//
//  DatabaseFuncs.swift
//  Chronos Revamp
//
//  Created by Nick Viscomi on 1/25/21.
//  Copyright © 2021 Nick Viscomi. All rights reserved.
//

import UIKit
import FirebaseDatabase


extension HomeViewController {
    
    @objc func getSchoolDayData(_ bypass: Bool) {
        if currentTime() == lastTime {
//            print(currentTime() + ":" + lastTime)print
            return
        } else if bypass || currentTime() != lastTime {
            lastTime = currentTime()
            //Find letter day from database and use it for different letter day schedules
            isSummer { (isSummer) in
                if let isSummer = isSummer {
                    guard !isSummer else {
                        //is currently long break/summer
                        print("long break/summer")
                        self.getSummerMessage()
                        return
                    }
                } else {
                    self.dayInfo.text = ""
                    self.periodLabel.text = ""
                }
            }
            
            DatabaseManager.shared.getSchoolDay { (schoolDay) in
                guard let schoolDay = schoolDay else {
                    self.dayInfo.text = ""
                    self.periodLabel.text = ""
                    print("school day error")
                    return
                }
                print("school day retrieved")
                
                guard schoolDay.daySchedule != .weekend else {
                    self.isWeekend()
                    print("weekend time!")
                    return
                }
                
                self.letterDay.text = schoolDay.letterDay
                
                DatabaseManager.shared.getSchoolSchedule(with: schoolDay) { (schedule) in
                    if let schedule = schedule {
                        print("congrats nick you are a great programmer lol")
//                        print(schedule.startTimes)
//                        print(schedule.endTimes)
//                        print(schedule.periodName)
                        self.getTimeLeft(schedule: schedule)
                    } else {
                        self.dayInfo.text = ""
                        self.periodLabel.text = ""
                        print("no schedule")
                    }
                }
            }
        }
    }
    
    fileprivate func getTimeLeft(schedule: Schedule) {
        guard !schedule.startTimes.isEmpty else { return }
        
        findTimeLeftHelper(startTimes: schedule.startTimes, endTimes: schedule.endTimes, periodNames: schedule.periodName)
    }
    
    fileprivate func findTimeLeftHelper(startTimes: [String], endTimes: [String], periodNames: [String]) {
        guard periodNames.count > 0 else { return }
        
        //MARK: loop through each start and end time, if the current time is between the start and end that period is the current one
        for i in 0...periodNames.count-1 {
            guard let userGrade = HomeViewController.grade else { print("error obtainng selected grade"); return }
            isTheTimeBetween(time1: startTimes[i], time2: endTimes[i], period: periodNames[i], grade: userGrade)
        }
        
    }
    
    
    fileprivate func isTheTimeBetween(time1: String, time2: String, period: String, grade: Grade) {
        
        //get current time - hh:mm
        let time = currentTime()
        
        //difference between start and end of period in integer form
        let diffCurrentTimeStartPeriod = findDateDiffInt(time1Str: time, time2Str: time1)
        let diffCurrentTimeEndPeriod = findDateDiffInt(time1Str: time, time2Str: time2)
        
        //period length
        let periodLength = findDateDiffInt(time1Str: time1, time2Str: time2)
        
        //is the time between function
        if isTimeBetweenHelper(diffCurrentTimeStartPeriod: diffCurrentTimeStartPeriod, diffCurrentTimeEndPeriod: diffCurrentTimeEndPeriod, periodLength: periodLength) {
            
            let timeLeft = findDateDiffInt(time1Str: time, time2Str: time2)
            HomeViewController.minutes = timeLeft
            
            
            if period == "after school" {
                isAfterSchool()
            } else if period == "before school" {
                isBeforeSchool()
            } else {
                //MARK: fill out UI on main thread
                DispatchQueue.main.async {
                    print(HomeViewController.minutes)
                    print(periodLength)
                    self.animateStroke(toValue: CGFloat(timeLeft)/CGFloat(periodLength))
                    self.periodLabel.text = period
                    self.messageLabel.text = ""
                    self.timeLeft.text = "\(timeLeft)"
                    self.timeLeft.textColor = timeLeft < 10 ? .systemRed : .label
                }
            }
            
        } else {
            return
        }//end if else
        
    }
    
    fileprivate func isAfterSchool() {
        databaseHandle = ref?.child("after school msg").observe(.value) { (snapshot) in
            //change time left if its after school
            guard let data = snapshot.value as? [String : String] else { print("parse after school message failed"); return }
            
            if let msg = data["message"] {
                DispatchQueue.main.async {
                    self.messageLabel.text = msg
                    self.animateStroke(toValue: CGFloat(1))
                    self.periodLabel.text = "After School"
                    self.timeLeft.text = "00"
                    self.dayInfo.text = msg
                }
            } else {
                print("couldnt get message")
            }
        }
    }
    
    fileprivate func isBeforeSchool() {
        databaseHandle = ref?.child("before school msg").observe(.value) { (snapshot) in
            //change time left if its before school
            
            guard let data = snapshot.value as? [String : String] else { print("parse before school message failed"); return }
            
            if let msg = data["message"] {
                DispatchQueue.main.async {
                    self.messageLabel.text = msg
                    self.animateStroke(toValue: CGFloat(1))
                    self.periodLabel.text = "Before School"
                    self.timeLeft.text = "00"
                    self.dayInfo.text = msg
                }
            } else {
                print("couldnt get message")
            }
        }
    }
    
    fileprivate func isWeekend() {
        databaseHandle = ref?.child("weekend message").observe(.value) { (snapshot) in
            //change time left if its before school
            
            guard let data = snapshot.value as? [String : String] else { print("parse before school message failed"); return }
            
            if let msg = data["msg"] {
                DispatchQueue.main.async {
                    self.messageLabel.text = msg
                    self.strokeAnimation.toValue = 1
                    self.periodLabel.text = "Weekend"
                    self.timeLeft.text = "00"
                    self.accesoryTextLabel.text = ""
                    self.dayInfo.text = msg
                }
            } else {
                print("couldnt get message")
            }
        }
    }
    
    fileprivate func getSummerMessage() {
        self.databaseHandle = self.ref?.child("summer message").observe(.value) { (snapshot) in
            //change time left if its before school
            
            guard let data = snapshot.value as? [String : String] else { print("parse summer message failed"); return }
            
            if let msg = data["msg"] {
                DispatchQueue.main.async {
                    self.messageLabel.text = msg
                    self.strokeAnimation.toValue = 1
                    self.periodLabel.text = "Break"
                    self.timeLeft.text = "00"
                    self.dayInfo.text = msg
//                    self.accesoryTextLabel.text = ""
                }
            } else {
                print("couldnt get message")
            }
        }
    }
    
    fileprivate func isSummer(completion: @escaping (Bool?) -> Void) {
        databaseHandle = ref?.child("summer").observe(.value) { (snapshot) in
            //change time left if its before school
            
            guard let data = snapshot.value as? [String : Bool] else { print("parse isSummer message failed");  completion(nil); return }
            
            if let isSummer = data["info"] {
                if isSummer {
                    completion(true)
                    self.getSummerMessage()
                } else {
                    completion(false)
                }
            } else {
                completion(nil)
                print("couldnt get summer boolean")
            }
        }
    }
    
    //MARK: set day info
    func setDayInfo() {
        
        isSummer { (isSummer) in
            guard let isSummer = isSummer else { return }
            
            if isSummer {
                return
            }
        }
        
        DatabaseManager.shared.getDayInfo { (dayInfo) in
            if let dayInfo = dayInfo {
                self.dayInfo.text = dayInfo
            } else {
                self.dayInfo.text = " "
                self.periodLabel.text = " "
            }
        }
    }
    
    fileprivate func isTimeBetweenHelper(diffCurrentTimeStartPeriod: Int, diffCurrentTimeEndPeriod: Int, periodLength: Int) -> Bool{
        return diffCurrentTimeStartPeriod <= 0 && (diffCurrentTimeEndPeriod <= periodLength && diffCurrentTimeEndPeriod > 0)
    }
}
