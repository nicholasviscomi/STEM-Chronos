//
//  NewHomeViewController.swift
//  Final Chronos
//
//  Created by Nick Viscomi on 8/9/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum Grade {
    case FS
    case JS
}

class HomeViewController: UIViewController {
    
    let dayInfo: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 24, weight: .regular)
        field.textColor = .white
        field.numberOfLines = 5
        field.textAlignment = .left
        return field
    }()
    
    let timeLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .white
        field.font = .systemFont(ofSize: 25, weight: .regular)
        field.numberOfLines = 1
        field.textAlignment = .left
        return field
    }()
    
    let dateLabel: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .black
        field.font = .systemFont(ofSize: 25, weight: .regular)
        field.numberOfLines = 1
        field.textAlignment = .left
        return field
    }()
    
    let letterDay: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .black
        field.font = .systemFont(ofSize: 53, weight: .medium)
        field.numberOfLines = 1
        field.textAlignment = .left
        return field
    }()
    
    public let timeLeft: UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 100, weight: .medium)
        //        field.font = .systemFont(ofSize: .zero, weight: .medium)
        //        field.adjustsFontSizeToFitWidth = true
        field.textColor = .label
        field.textAlignment = .center
        field.text = "00"
        return field
    }()
    
    public let accesoryTextLabel : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 28, weight: .light)
        field.textColor = .label
        field.textAlignment = .center
        field.text = "minutes left"
        return field
    }()
    
    public let periodLabel : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 32, weight: .semibold)
        field.textColor = .label
        field.textAlignment = .center
        field.text = ""
        return field
    }()
    
    public let messageLabel : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 24, weight: .regular)
        field.textColor = .label
        field.textAlignment = .center
        field.text = ""
        field.numberOfLines = 3
        return field
    }()
    
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    var daySchedule = ""
    
    var oneSevenLetterDays = ["A","D","E","H","I","L"]
    var oneFourLetterDays = ["B","F","J"]
    var fiveSevenLetterDays = ["C","G","K"]
    
    let shapeLayer = CAShapeLayer()
    let pulsatingLayer = CAShapeLayer()
    
    let container : UIView = {
        let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.clipsToBounds = false
        return field
    }()
    
    let timesContainer : UIView = {
        let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.clipsToBounds = false
        //        field.backgroundColor = .systemRed
        //        field.alpha = 0.3
        return field
    }()
    
    static var minutes = 00
    
    static var grade: Grade?
    
    static var hasSelectedGrade: Bool = false
    
    let defaults = UserDefaults.standard
    
    var dayData: Timer!
    
    var lastTime: String!
    
    //MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
    }//end view did load
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //add subviews to main view
        configureViews()
        
        //set the layout of the subviews
        layoutViews()
        
        //sef a refrence to database so data can be called
        ref = Database.database().reference()
        
        //constant time update
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        //check if open for first time
        checkIfOpenedForFirstTime()
        
        //swtup the main time left meter
        setupMeter()
        
        //display day info
        setDayInfo()
        
        //get data about the day from Firebase and fill out the UI
        getSchoolDayData(true)
        
        lastTime = currentTime()
        dayData = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getSchoolDayData), userInfo: nil, repeats: true)
        
    }
    
    @objc fileprivate func getSchoolDayData(_ bypass: Bool) {
        if currentTime() == lastTime {
            print(currentTime() + ":" + lastTime)
            return
        } else if bypass || currentTime() != lastTime {
            lastTime = currentTime()
            //Find letter day from database and use it for different letter day schedules
            isSummer { (isSummer) in
                if let isSummer = isSummer {
                    guard !isSummer else {
                        //is currently long break/summer
                        self.getSummerMessage()
                        return
                    }
                } else {
                    self.dayInfo.text = "..."
                    self.periodLabel.text = "none"
                }
            }
            
            DatabaseManager.shared.getSchoolDay { (schoolDay) in
                guard let schoolDay = schoolDay else {
                    self.dayInfo.text = "..."
                    self.periodLabel.text = "none"
                    return
                }
                print("school day retrieved")
                
                guard schoolDay.daySchedule != .weekend else {
                    self.isWeekend()
                    return
                }
                
                self.letterDay.text = schoolDay.letterDay
                
                DatabaseManager.shared.getSchoolSchedule(with: schoolDay) { (schedule) in
                    if let schedule = schedule {
                        print("congrats nick you are a great programmer lol")
                        self.getTimeLeft(schedule: schedule)
                    } else {
                        self.dayInfo.text = "..."
                        self.periodLabel.text = "none"
                        print("no schedule")
                    }
                }
            }
        }
    }
    
    fileprivate func getTimeLeft(schedule: Schedule) {
        findTimeLeftHelper(startTimes: schedule.startTimes, endTimes: schedule.endTimes, periodNames: schedule.periodName)
    }
    
    fileprivate func findTimeLeftHelper(startTimes: [String], endTimes: [String], periodNames: [String]) {
        
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
                    self.periodLabel.text = "Long Break"
                    self.timeLeft.text = "00"
                    self.dayInfo.text = "Long Break"
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
    fileprivate func setDayInfo() {
        DatabaseManager.shared.getDayInfo { (dayInfo) in
            if let dayInfo = dayInfo {
                self.dayInfo.text = dayInfo
            } else {
                self.dayInfo.text = "..."
                self.periodLabel.text = "none"
            }
        }
    }
    
    fileprivate func isTimeBetweenHelper(diffCurrentTimeStartPeriod: Int, diffCurrentTimeEndPeriod: Int, periodLength: Int) -> Bool{
        
        return diffCurrentTimeStartPeriod <= 0 && (diffCurrentTimeEndPeriod <= periodLength && diffCurrentTimeEndPeriod > 0)
    }
    
    fileprivate func checkIfOpenedForFirstTime() {
        let hasOpenedBefore = defaults.bool(forKey: UDKeys.firstTimeOpening)
        
        if !hasOpenedBefore {
            let vc = GradeSelectionViewController()
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
            return
        } else {
            HomeViewController.hasSelectedGrade = true
        }
        
        if let gradeString = defaults.string(forKey: UDKeys.grade) {
            let grade: Grade?
            
            switch gradeString {
            case "FS":
                grade = .FS
            case "JS":
                grade = .JS
            default:
                grade = nil
                
            }
            
            HomeViewController.grade = grade
            
        } else {
            let vc = GradeSelectionViewController()
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true)
            return
        }
        
        
    }
    
    private func layoutViews() {
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.widthAnchor.constraint(equalToConstant: view.width),
            container.heightAnchor.constraint(equalToConstant: view.height - 310 - view.safeAreaInsets.bottom - view.safeAreaInsets.top),
            container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        NSLayoutConstraint.activate([
            timesContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            timesContainer.widthAnchor.constraint(equalToConstant: view.width - 140 - 7.5 - 20),
            timesContainer.heightAnchor.constraint(equalToConstant: view.width - 140 - 7.5 - 20),
            timesContainer.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            timeLeft.centerXAnchor.constraint(equalTo: timesContainer.centerXAnchor),
            //            timeLeft.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -70),
            timeLeft.heightAnchor.constraint(equalToConstant: (view.width - 140 - 7.5 - 20)/2),
            timeLeft.widthAnchor.constraint(equalToConstant: (view.width - 140 - 7.5 - 20) - 40),
            timeLeft.topAnchor.constraint(equalTo: timesContainer.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            accesoryTextLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            accesoryTextLabel.widthAnchor.constraint(equalToConstant: 200),
            accesoryTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            accesoryTextLabel.topAnchor.constraint(equalTo: timesContainer.centerYAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            periodLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            periodLabel.topAnchor.constraint(equalTo: accesoryTextLabel.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            dayInfo.widthAnchor.constraint(equalToConstant: 235),
            dayInfo.heightAnchor.constraint(equalToConstant: 110),
            dayInfo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            dayInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24 + 110 + 6)
        ])
        
        NSLayoutConstraint.activate([
            letterDay.widthAnchor.constraint(equalToConstant: 67),
            letterDay.heightAnchor.constraint(equalToConstant: 81),
            letterDay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 211),
            letterDay.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.widthAnchor.constraint(equalToConstant: 271.5),
            timeLabel.heightAnchor.constraint(equalToConstant: 26),
            timeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 143),
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.widthAnchor.constraint(equalToConstant: 360),
            dateLabel.heightAnchor.constraint(equalToConstant: 26),
            dateLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: 0),
            dateLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0)
        ])
        
        //MARK: other views are set after the shape layer so I can take advantage of the shapelayers properties
        
        //        NSLayoutConstraint.activate([
        //            messageLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
        //            messageLabel.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 60 )
        //        ])
        
    }
    
    private func configureViews() {
        view.addSubview(container)
        view.layer.addSublayer(pulsatingLayer)
        view.layer.addSublayer(shapeLayer)
        view.addSubview(timesContainer)
        view.addSubview(dayInfo)
        view.addSubview(timeLabel)
        view.addSubview(dateLabel)
        view.addSubview(letterDay)
        timesContainer.addSubview(timeLeft)
        timesContainer.addSubview(accesoryTextLabel)
        timesContainer.addSubview(periodLabel)
        //        view.addSubview(messageLabel)
        
        
        //        container.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
    }
    
    let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
    let pulse = CABasicAnimation(keyPath: "transform.scale")
    
    fileprivate func setupMeter() {
        //        let containerHeight = view.height - 310 - view.safeAreaInsets.bottom - view.safeAreaInsets.top
        //        CGPoint(x: view.center.x, y: 335)
        let circularPath = UIBezierPath(arcCenter: .zero, radius: (view.width - 140)/2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 1, green: 0.8705882353, blue: 0.0862745098, alpha: 1)
        shapeLayer.lineWidth = 15
        shapeLayer.fillColor = UIColor.secondarySystemBackground.cgColor
        shapeLayer.lineCap = .round
        let containerHeight = view.height - 310 - view.safeAreaInsets.bottom - view.safeAreaInsets.top
        shapeLayer.position = CGPoint(x: view.center.x, y: view.safeAreaInsets.top + 310 + containerHeight/2 - 15)
        
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.label.cgColor
        pulsatingLayer.lineWidth = 15
        pulsatingLayer.fillColor = pulsatingLayer.strokeColor
        pulsatingLayer.lineCap = .round
        pulsatingLayer.position = shapeLayer.position
        pulsatingLayer.opacity = 0.7
        
        animatePulsatingLayer()
        
        //MARK: to rotate succesfully add a track layer under the main shapelayer that is rotated and add the main shape layers center equal to the track layer center
    }
    
    fileprivate func animateStroke(toValue: CGFloat) {
        strokeAnimation.toValue = toValue
        strokeAnimation.duration = 1.3
        strokeAnimation.fillMode = .forwards
        strokeAnimation.isRemovedOnCompletion = false
        shapeLayer.add(strokeAnimation, forKey: "stroke")
    }
    
    fileprivate func animatePulsatingLayer() {
        pulse.toValue = 1.2
        pulse.duration = 1.1
        pulse.timingFunction = CAMediaTimingFunction(name: .easeOut)
        pulse.autoreverses = true
        pulse.repeatCount = Float.infinity
        pulsatingLayer.add(pulse, forKey: "pulse")
    }
    
    //UTILITY FUNCTIONS
    //MARK: update the time
    @objc private func updateTime() {
        let currentDateTime = Date()
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .medium
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        let timeString = timeFormatter.string(from: currentDateTime)
        let dateString = dateFormatter.string(from: currentDateTime)
        //display time
        timeLabel.text = timeString
        dateLabel.text = dateString
        
    }//end update time
    
}



extension UIView {
    var width: CGFloat {
        return self.frame.width
    }
    var height: CGFloat {
        return self.frame.height
    }
    var top: CGFloat {
        return self.frame.origin.y
    }
    var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    var left: CGFloat {
        return self.frame.origin.x
    }
    var right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}

