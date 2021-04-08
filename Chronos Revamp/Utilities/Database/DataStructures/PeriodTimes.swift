//
//  PeriodTimes.swift
//  Chronos Revamp
//
//  Created by Nick Viscomi on 8/18/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class PeriodTimes {
    var schoolDay: SchoolDay
    var grade: Grade
    var dm = DatabaseManager()
    var FSaltStart = [String]()
    var FSaltEnd = [String]()
    var FSaltName = [String]()
    
    var JSaltStart = [String]()
    var JSaltEnd = [String]()
    var JSaltName = [String]()
    
    let group = DispatchGroup()
    
    init(schoolDay: SchoolDay, grade: Grade, completion: @escaping (Bool) -> Void) {
        
        self.schoolDay = schoolDay
        self.grade = grade
        
        //MARK: maybe try using a protocol to get the correct values in here. If not, try saving the array to the cache and then retrieving in in DatabaseFuncs.swift. Else, try having static vars in HomeVC and then set those in the completion handler
         
        if (schoolDay.daySchedule == .databasePath) {
            group.enter()
            dm.FSScheduleFromPath(path: schoolDay.path) {  [self] (start, end, names) in
                guard let start = start, let end = end, let names = names else { return }
                setArray(arr: &FSaltStart, val: start)
                setArray(arr: &FSaltEnd, val: end)
                setArray(arr: &FSaltName, val: names)
                print("done 1")
                group.leave()
            }

            group.enter()
            dm.JSScheduleFromPath(path: schoolDay.path) { [self] (start, end, names) in
                guard let start = start, let end = end, let names = names else { return }
                setArray(arr: &JSaltStart, val: start)
                setArray(arr: &JSaltEnd, val: end)
                setArray(arr: &JSaltName, val: names)
                print("done 2")
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [self] in
//            if schoolDay.daySchedule == .databasePath {
                print("Period Times")
                print(FSaltStart)
                print(FSaltEnd)
                print(FSaltName)
                
                print(JSaltStart)
                print(JSaltEnd)
                print(JSaltName)
                
                startTimes = setStartTimes()
                endTimes = setEndTimes()
                periodNames = setPeriodNames()
                completion(true)
                return
//            }
        }
        
    }
    
    func setArray(arr: inout [String], val: [String]) {
        arr = val
        return
    }
    
    //MARK: Start here, make it so you can create a periodtime object with the params and off that object you can get start and end times along with period names. From ther you can use the isThetimeBetween func to fill out the UI
    var startTimes: [String]? = nil
    
    func setStartTimes() -> [String]? {
        if grade == .FS {
            switch schoolDay.daySchedule {
            case .Regular:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.Regular.FS.OneSeven.OneSevenStartTimes
                case .OneFour:
                    return Times.Regular.FS.OneFour.OneFourStartTimes
                case .FiveSeven:
                    return Times.Regular.FS.FiveSeven.FiveSevenStartTimes
                default:
                    return nil
                }
                //end .regular
            case .twoHrEarly:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrEarly.FS.OneSeven.OneSevenStartTimes
                case .OneFour:
                    return Times.TwoHrEarly.FS.OneFour.OneFourStartTimes
                case .FiveSeven:
                    return Times.TwoHrEarly.FS.FiveSeven.FiveSevenStartTimes
                default:
                    return nil
                }
                //end .twoHrEarly
            case .twoHrDelay:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrDelay.FS.OneSeven.OneSevenStartTimes
                case .OneFour:
                    return Times.TwoHrDelay.FS.OneFour.OneFourStartTimes
                case .FiveSeven:
                    return Times.TwoHrDelay.FS.FiveSeven.FiveSevenStartTimes
                default:
                    return nil
                }
                //end .twoHrDelay
            case .events:
                return nil
            case .weekend:
                return nil

            case .databasePath:
                return FSaltStart
            }
        }
        
        if grade == .JS {
            switch schoolDay.daySchedule {
            case .Regular:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.Regular.JS.OneSeven.OneSevenStartTimes
                case .OneFour:
                    return Times.Regular.JS.OneFour.OneFourStartTimes
                case .FiveSeven:
                    return Times.Regular.JS.FiveSeven.FiveSevenStartTimes
                default:
                    return nil
                }
                //end .regular
            case .twoHrEarly:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrEarly.JS.OneSeven.OneSevenStartTimes
                case .OneFour:
                    return Times.TwoHrEarly.JS.OneFour.OneFourStartTimes
                case .FiveSeven:
                    return Times.TwoHrEarly.JS.FiveSeven.FiveSevenStartTimes
                default:
                    return nil
                }
                //end .twoHrEarly
            case .twoHrDelay:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrDelay.JS.OneSeven.OneSevenStartTimes
                case .OneFour:
                    return Times.TwoHrDelay.JS.OneFour.OneFourStartTimes
                case .FiveSeven:
                    return Times.TwoHrDelay.JS.FiveSeven.FiveSevenStartTimes
                default:
                    return nil
                }
                //end .twoHrDelay
            case .events:
                return nil
            case .weekend:
                return nil

            case .databasePath:
                return JSaltStart
            }
        }
        return nil
    }
    
    var endTimes: [String]? = nil
    
    func setEndTimes() -> [String]? {
        if grade == .FS {
            switch schoolDay.daySchedule {
            case .Regular:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.Regular.FS.OneSeven.OneSevenEndTimes
                case .OneFour:
                    return Times.Regular.FS.OneFour.OneFourEndTimes
                case .FiveSeven:
                    return Times.Regular.FS.FiveSeven.FiveSevenEndTimes
                default:
                    return nil
                }
                //end .regular
            case .twoHrEarly:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrEarly.FS.OneSeven.OneSevenEndTimes
                case .OneFour:
                    return Times.TwoHrEarly.FS.OneFour.OneFourEndTimes
                case .FiveSeven:
                    return Times.TwoHrEarly.FS.FiveSeven.FiveSevenEndTimes
                default:
                    return nil
                }
                //end .twoHrEarly
            case .twoHrDelay:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrDelay.FS.OneSeven.OneSevenEndTimes
                case .OneFour:
                    return Times.TwoHrDelay.FS.OneFour.OneFourEndTimes
                case .FiveSeven:
                    return Times.TwoHrDelay.FS.FiveSeven.FiveSevenEndTimes
                default:
                    return nil
                }
                //end .twoHrDelay
            case .events:
                return nil
            case .weekend:
                return nil

            case .databasePath:
                return FSaltEnd
            }
        }
        
        if grade == .JS {
            switch schoolDay.daySchedule {
            case .Regular:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.Regular.JS.OneSeven.OneSevenEndTimes
                case .OneFour:
                    return Times.Regular.JS.OneFour.OneFourEndTimes
                case .FiveSeven:
                    return Times.Regular.JS.FiveSeven.FiveSevenEndTimes
                default:
                    return nil
                }
                //end .regular
            case .twoHrEarly:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrEarly.JS.OneSeven.OneSevenEndTimes
                case .OneFour:
                    return Times.TwoHrEarly.JS.OneFour.OneFourEndTimes
                case .FiveSeven:
                    return Times.TwoHrEarly.JS.FiveSeven.FiveSevenEndTimes
                default:
                    return nil
                }
                //end .twoHrEarly
            case .twoHrDelay:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrDelay.JS.OneSeven.OneSevenEndTimes
                case .OneFour:
                    return Times.TwoHrDelay.JS.OneFour.OneFourEndTimes
                case .FiveSeven:
                    return Times.TwoHrDelay.JS.FiveSeven.FiveSevenEndTimes
                default:
                    return nil
                }
                //end .twoHrDelay
            case .events:
                return nil
            case .weekend:
                return nil

            case .databasePath:
                return JSaltEnd
            }
        }
        return nil
    }
    
    var periodNames: [String]? = nil
    
    func setPeriodNames() -> [String]? {
        if grade == .FS {
            switch schoolDay.daySchedule {
            case .Regular:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.Regular.FS.OneSeven.OneSevenPeriodName
                case .OneFour:
                    return Times.Regular.FS.OneFour.OneFourPeriodName
                case .FiveSeven:
                    return Times.Regular.FS.FiveSeven.FiveSevenPeriodName
                default:
                    return nil
                }
                //end .regular
            case .twoHrEarly:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrEarly.FS.OneSeven.OneSevenPeriodName
                case .OneFour:
                    return Times.TwoHrEarly.FS.OneFour.OneFourPeriodName
                case .FiveSeven:
                    return Times.TwoHrEarly.FS.FiveSeven.FiveSevenPeriodName
                default:
                    return nil
                }
                //end .twoHrEarly
            case .twoHrDelay:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrDelay.FS.OneSeven.OneSevenPeriodName
                case .OneFour:
                    return Times.TwoHrDelay.FS.OneFour.OneFourPeriodName
                case .FiveSeven:
                    return Times.TwoHrDelay.FS.FiveSeven.FiveSevenPeriodName
                default:
                    return nil
                }
                //end .twoHrDelay
            case .events:
                return nil
            case .weekend:
                return nil

            case .databasePath:
                return FSaltName
            }
        }
        
        if grade == .JS {
            switch schoolDay.daySchedule {
            case .Regular:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.Regular.JS.OneSeven.OneSevenPeriodName
                case .OneFour:
                    return Times.Regular.JS.OneFour.OneFourPeriodName
                case .FiveSeven:
                    return Times.Regular.JS.FiveSeven.FiveSevenPeriodName
                default:
                    return nil
                }
                //end .regular
            case .twoHrEarly:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrEarly.JS.OneSeven.OneSevenPeriodName
                case .OneFour:
                    return Times.TwoHrEarly.JS.OneFour.OneFourPeriodName
                case .FiveSeven:
                    return Times.TwoHrEarly.JS.FiveSeven.FiveSevenPeriodName
                default:
                    return nil
                }
                //end .twoHrEarly
            case .twoHrDelay:
                switch schoolDay.periodType {
                case .OneSeven:
                    return Times.TwoHrDelay.JS.OneSeven.OneSevenPeriodName
                case .OneFour:
                    return Times.TwoHrDelay.JS.OneFour.OneFourPeriodName
                case .FiveSeven:
                    return Times.TwoHrDelay.JS.FiveSeven.FiveSevenPeriodName
                default:
                    return nil
                }
                //end .twoHrDelay
            case .events:
                return nil
            case .weekend:
                return nil

            case .databasePath:
                return JSaltName
            }
        }
        return nil
    }
    
}
