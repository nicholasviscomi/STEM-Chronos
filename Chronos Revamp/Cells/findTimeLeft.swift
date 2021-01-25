//
//  findTimeLeft.swift
//  STEM Chronos- Comp. Fair
//
//  Created by Nick Viscomi on 4/21/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

//extension ViewController {
//    //MARK: classify and find time left
//    @objc func classifyDayAndFindTimeLeft() {
//        let currentDate = Date()
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        let currentDateString = formatter.string(from: currentDate)
//
//        databaseHandle = ref?.child("summer").observe(.childAdded, with: { (snapshot) in
//            let isSummer = snapshot.value as? Bool
//            if isSummer ?? false {
//                self.databaseHandle = self.ref?.child("summer message").observe(.childAdded, with: { (snapshot) in
//                    let msg = snapshot.value as? String
//                    self.letterDay.text = ""
//                    self.dayInfo.text = msg
//                    self.timeLeftJunSen.text = msg
//                    self.timeLeftFreshSoph.text = msg
//                })
//            } else {
//
//                self.databaseHandle = self.ref?.child("\(currentDateString)/Letter day").observe(.childAdded) { (snapshot) in
//                guard snapshot.value != nil else {
//                    return
//                }
//                self.letterDay.text = snapshot.value as? String
//
//
//                //find if it is a regular, delayed, dissmissal or event schedule day so the schdeule can change
//                self.ref?.child("\(currentDateString)/Day schedule").observe(.childAdded) { (snapshot) in
//                    guard snapshot.value != nil else {
//                        return
//                    }
//                    self.daySchedule = (snapshot.value as? String)!
//
//                    //if the school day is regualar trigger the cooresponding schedule
//                    if self.daySchedule == "regular" {
//
//                        //if the letter day is a certain day, run 1-7 or 1-4 or 5-7 day
//                        if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 1-7 days
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeftOneSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeftOneSeven), userInfo: nil, repeats: true)
//
//                        } else if self.oneFourLetterDays.contains(self.letterDay.text!)  {
//
//                            //constantly updating the time left for 1-4 days
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeftOneFour), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeftOneFour), userInfo: nil, repeats: true)
//
//                        } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 5-7 days
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeftFiveSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeftFiveSeven), userInfo: nil, repeats: true)
//
//                        }
//                    } else if self.daySchedule == "events" {
//                        //ADD IN EVENT SCHEDULE
//                    } else if self.daySchedule == "2hr delay" {
//                        //ADD IN 2HR DELAY SCHEDULE
//                        if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 1-7 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrDelayOneSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrDelayOneSeven), userInfo: nil, repeats: true)
//
//                        } else if self.oneFourLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 1-4 days 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrDelayOneFour), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrDelayOneFour), userInfo: nil, repeats: true)
//
//                        } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 5-7 days 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrDelayFiveSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrDelayFiveSeven), userInfo: nil, repeats: true)
//
//                        }//end 5-7 2hr early
//                    } else if self.daySchedule == "2hr early" {
//                        //ADD IN 2HR EARLY DISSMISSAL SCHEDULE
//                        if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 1-7 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrEarlyOneSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrEarlyOneSeven), userInfo: nil, repeats: true)
//
//                        } else if self.oneFourLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 1-4 days 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrEarlyOneFour), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrEarlyOneFour), userInfo: nil, repeats: true)
//
//                        } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 5-7 days 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrEarlyFiveSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrEarlyFiveSeven), userInfo: nil, repeats: true)
//
//                        }//end 5-7 2hr early
//                    } else if self.daySchedule == "weekend" {
//
//                        //constant showing that its the weekend
//                        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.weekend), userInfo: nil, repeats: true)
//
//                    }//end weekend
//                }//end day schedule
//            }//end letter day
//            }
//        })
//    }
//
//
//func NewClassifyDayAndFindTimeLeft() {
//    let currentDate = Date()
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    let currentDateString = formatter.string(from: currentDate)
//
//    var FScurrentStart = [String]()
//    var FScurrentEnd = [String]()
//    var FScurrentPdName = [String]()
//
//    var JScurrentStart = [String]()
//    var JScurrentEnd = [String]()
//    var JScurrentPdName = [String]()
//
//    databaseHandle = ref?.child("summer").observe(.childAdded, with: { (snapshot) in
//        let isSummer = snapshot.value as? Bool
//        if isSummer ?? false {
//            self.databaseHandle = self.ref?.child("summer message").observe(.childAdded, with: { (snapshot) in
//                let msg = snapshot.value as? String
//                self.letterDay.text = ""
//                self.dayInfo.text = msg
//                self.timeLeftJunSen.text = msg
//                self.timeLeftFreshSoph.text = msg
//            })
//        } else {
//
//            self.databaseHandle = self.ref?.child("\(currentDateString)/Letter day").observe(.childAdded) { (snapshot) in
//            guard snapshot.value != nil else {
//                return
//            }
//            self.letterDay.text = snapshot.value as? String
//
//
//            //find if it is a regular, delayed, dissmissal or event schedule day so the schdeule can change
//            self.ref?.child("\(currentDateString)/Day schedule").observe(.childAdded) { (snapshot) in
//                guard snapshot.value != nil else {
//                    return
//                }
//                self.daySchedule = (snapshot.value as? String)!
//
//                //if the school day is regualar trigger the cooresponding schedule
//                if self.daySchedule == "regular" {
//
//                    //if the letter day is a certain day, run 1-7 or 1-4 or 5-7 day
//                    if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//                        FScurrentStart = Times.Regular.FS.OneSevenStartTimes
//                        FScurrentEnd = Times.Regular.FS.OneSevenEndTimes
//                        FScurrentPdName = Times.Regular.FS.OneSevenPeriodName
//
//                        JScurrentStart = Times.Regular.JS.OneSevenStartTimes
//                        JScurrentEnd = Times.Regular.JS.OneSevenEndTimes
//                        JScurrentPdName = Times.Regular.JS.OneSevenPeriodName
//
//                        self.FSfindTimeLeft(startTimes: FScurrentStart, endTimes: FScurrentEnd, periodNames: FScurrentPdName)
//
//                        self.FSfindTimeLeft(startTimes: JScurrentStart, endTimes: JScurrentEnd, periodNames: JScurrentPdName)
//
//                    } else if self.oneFourLetterDays.contains(self.letterDay.text!)  {
//
//
//                    } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//
//
//                    }
//                } else if self.daySchedule == "events" {
//                    //ADD IN EVENT SCHEDULE
//                } else if self.daySchedule == "2hr delay" {
//                    //ADD IN 2HR DELAY SCHEDULE
//                    if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//
//
//                    } else if self.oneFourLetterDays.contains(self.letterDay.text!) {
//
//
//                    } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//
//                    }//end 5-7 2hr early
//                } else if self.daySchedule == "2hr early" {
//                    //ADD IN 2HR EARLY DISSMISSAL SCHEDULE
//                    if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//
//                    } else if self.oneFourLetterDays.contains(self.letterDay.text!) {
//
//
//
//                    } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//
//
//                    }//end 5-7 2hr early
//                } else if self.daySchedule == "weekend" {
//
//                    //constant showing that its the weekend
//                    _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.weekend), userInfo: nil, repeats: true)
//
//                }//end weekend
//            }//end day schedule
//        }//end letter day
//        }
//    })
//}
//
//
//}//end extension

//
//extension NewHomeViewController {
//    //MARK: classify and find time left
//    @objc func classifyDayAndFindTimeLeft() {
//        let currentDate = Date()
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        let currentDateString = formatter.string(from: currentDate)
//
//        databaseHandle = ref?.child("summer").observe(.childAdded, with: { (snapshot) in
//            let isSummer = snapshot.value as? Bool
//            if isSummer ?? false {
//                self.databaseHandle = self.ref?.child("summer message").observe(.childAdded, with: { (snapshot) in
//                    let msg = snapshot.value as? String
//                    self.letterDay.text = ""
//                    self.dayInfo.text = msg
////                    self.timeLeftJunSen.text = msg
////                    self.timeLeftFreshSoph.text = msg
//                })
//            } else {
//
//                self.databaseHandle = self.ref?.child("\(currentDateString)/Letter day").observe(.childAdded) { (snapshot) in
//                guard snapshot.value != nil else {
//                    return
//                }
//                self.letterDay.text = snapshot.value as? String
//
//
//                //find if it is a regular, delayed, dissmissal or event schedule day so the schdeule can change
//                self.ref?.child("\(currentDateString)/Day schedule").observe(.childAdded) { (snapshot) in
//                    guard snapshot.value != nil else {
//                        return
//                    }
//                    self.daySchedule = (snapshot.value as? String)!
//
//                    //if the school day is regualar trigger the cooresponding schedule
//                    if self.daySchedule == "regular" {
//
//                        //if the letter day is a certain day, run 1-7 or 1-4 or 5-7 day
//                        if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 1-7 days
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeftOneSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeftOneSeven), userInfo: nil, repeats: true)
//
//                        } else if self.oneFourLetterDays.contains(self.letterDay.text!)  {
//
//                            //constantly updating the time left for 1-4 days
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeftOneFour), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeftOneFour), userInfo: nil, repeats: true)
//
//                        } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 5-7 days
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeftFiveSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeftFiveSeven), userInfo: nil, repeats: true)
//
//                        }
//                    } else if self.daySchedule == "events" {
//                        //ADD IN EVENT SCHEDULE
//                    } else if self.daySchedule == "2hr delay" {
//                        //ADD IN 2HR DELAY SCHEDULE
//                        if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 1-7 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrDelayOneSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrDelayOneSeven), userInfo: nil, repeats: true)
//
//                        } else if self.oneFourLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 1-4 days 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrDelayOneFour), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrDelayOneFour), userInfo: nil, repeats: true)
//
//                        } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 5-7 days 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrDelayFiveSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrDelayFiveSeven), userInfo: nil, repeats: true)
//
//                        }//end 5-7 2hr early
//                    } else if self.daySchedule == "2hr early" {
//                        //ADD IN 2HR EARLY DISSMISSAL SCHEDULE
//                        if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 1-7 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrEarlyOneSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrEarlyOneSeven), userInfo: nil, repeats: true)
//
//                        } else if self.oneFourLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 1-4 days 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrEarlyOneFour), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrEarlyOneFour), userInfo: nil, repeats: true)
//
//                        } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//                                //constantly updating the time left for 5-7 days 2hr early dissmissal
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.findTimeLeft2hrEarlyFiveSeven), userInfo: nil, repeats: true)
//                                _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.JSfindTimeLeft2hrEarlyFiveSeven), userInfo: nil, repeats: true)
//
//                        }//end 5-7 2hr early
//                    } else if self.daySchedule == "weekend" {
//
//                        //constant showing that its the weekend
//                        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.weekend), userInfo: nil, repeats: true)
//
//                    }//end weekend
//                }//end day schedule
//            }//end letter day
//            }
//        })
//    }
//
//
func NewClassifyDayAndFindTimeLeft() {
//    let currentDate = Date()
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    let currentDateString = formatter.string(from: currentDate)
//
//    var FScurrentStart = [String]()
//    var FScurrentEnd = [String]()
//    var FScurrentPdName = [String]()
//
//    var JScurrentStart = [String]()
//    var JScurrentEnd = [String]()
//    var JScurrentPdName = [String]()
//
//    databaseHandle = ref?.child("summer").observe(.childAdded, with: { (snapshot) in
//        let isSummer = snapshot.value as? Bool
//        if isSummer ?? false {
//            self.databaseHandle = self.ref?.child("summer message").observe(.childAdded, with: { (snapshot) in
//                let msg = snapshot.value as? String
//                self.letterDay.text = ""
//                self.dayInfo.text = msg
////                self.timeLeftJunSen.text = msg
////                self.timeLeftFreshSoph.text = msg
//            })
//        } else {
//
//            self.databaseHandle = self.ref?.child("\(currentDateString)/Letter day").observe(.childAdded) { (snapshot) in
//            guard snapshot.value != nil else {
//                return
//            }
//            self.letterDay.text = snapshot.value as? String
//
//
//            //find if it is a regular, delayed, dissmissal or event schedule day so the schdeule can change
//            self.ref?.child("\(currentDateString)/Day schedule").observe(.childAdded) { (snapshot) in
//                guard snapshot.value != nil else {
//                    return
//                }
//                self.daySchedule = (snapshot.value as? String)!
//
//                //if the school day is regualar trigger the cooresponding schedule
//                if self.daySchedule == "regular" {
//
//                    //if the letter day is a certain day, run 1-7 or 1-4 or 5-7 day
//                    if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//                        FScurrentStart = Times.Regular.FS.OneSevenStartTimes
//                        FScurrentEnd = Times.Regular.FS.OneSevenEndTimes
//                        FScurrentPdName = Times.Regular.FS.OneSevenPeriodName
//
//                        JScurrentStart = Times.Regular.JS.OneSevenStartTimes
//                        JScurrentEnd = Times.Regular.JS.OneSevenEndTimes
//                        JScurrentPdName = Times.Regular.JS.OneSevenPeriodName
//
//                        self.FSfindTimeLeft(startTimes: FScurrentStart, endTimes: FScurrentEnd, periodNames: FScurrentPdName)
//
//                        self.FSfindTimeLeft(startTimes: JScurrentStart, endTimes: JScurrentEnd, periodNames: JScurrentPdName)
//
//                    } else if self.oneFourLetterDays.contains(self.letterDay.text!)  {
//
//
//                    } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//
//
//                    }
//                } else if self.daySchedule == "events" {
//                    //ADD IN EVENT SCHEDULE
//                } else if self.daySchedule == "2hr delay" {
//                    //ADD IN 2HR DELAY SCHEDULE
//                    if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//
//
//                    } else if self.oneFourLetterDays.contains(self.letterDay.text!) {
//
//
//                    } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//
//                    }//end 5-7 2hr early
//                } else if self.daySchedule == "2hr early" {
//                    //ADD IN 2HR EARLY DISSMISSAL SCHEDULE
//                    if self.oneSevenLetterDays.contains(self.letterDay.text!) {
//
//
//                    } else if self.oneFourLetterDays.contains(self.letterDay.text!) {
//
//
//
//                    } else if self.fiveSevenLetterDays.contains(self.letterDay.text!) {
//
//
//
//                    }//end 5-7 2hr early
//                } else if self.daySchedule == "weekend" {
//
//                    //constant showing that its the weekend
//                    _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.weekend), userInfo: nil, repeats: true)
//
//                }//end weekend
//            }//end day schedule
//        }//end letter day
//        }
//    })
}


//}//end extension
