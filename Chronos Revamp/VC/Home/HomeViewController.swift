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

class HomeViewController: UIViewController, GradeDelegate {
    
    let topContainer: UIView = {
        let field = UIView()
        field.clipsToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        //maybe add in a background image
        return field
    }()
    
    let logoImage: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.image = UIImage(named: "Mask Group (1)")
        field.backgroundColor = .clear
        return field
    }()
    
    let topBGImage: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.image = UIImage(named: "topBG")
        field.backgroundColor = .clear
        return field
    }()
    
    let dayInfo: UILabel = { //is the custon message from firebase that changes daily
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 20, weight: .regular)
        field.textColor = .white
        field.numberOfLines = 5
        field.textAlignment = .left
        return field
    }()
    
    let timeLabel: UILabel = { //shows the time
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .white
        field.font = .systemFont(ofSize: 25, weight: .regular)
        field.numberOfLines = 1
        field.textAlignment = .left
        return field
    }()
    
    let dateLabel: UILabel = {// shows the date
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .black
        field.font = .systemFont(ofSize: 25, weight: .regular)
        field.numberOfLines = 1
        field.textAlignment = .left
        return field
    }()
    
    let letterDay: UILabel = { //shows the letter day
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .black
        field.font = .systemFont(ofSize: 53, weight: .medium)
        field.numberOfLines = 1
        field.textAlignment = .left
        return field
    }()
    
    public let timeLeft: UILabel = { //shows the numerical time left
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
    
    public let accesoryTextLabel: UILabel = { //minutes left time label
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 28, weight: .light)
        field.textColor = .label
        field.textAlignment = .center
        field.text = "minutes left"
        return field
    }()
    
    public let periodLabel : UILabel = { //can say the period name (i.e. lunch, 5th period, advisory) or say it's break
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 30, weight: .semibold)
        field.textColor = .label
        field.textAlignment = .center
        field.text = ""
        return field
    }()
    
    public let messageLabel : UILabel = { // currently unused
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
        //MARK: will no longer be called right away because it causes a quick change between day info and before/after school message
//        setDayInfo()
        
        //get data about the day from Firebase and fill out the UI
        getSchoolDayData(true)
        
        lastTime = currentTime()
        dayData = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getSchoolDayData), userInfo: nil, repeats: true)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //set the colors of the text inside the circle to be .label
        //MARK: the basic schedules should be hardcoded but there should be the option for a new schedule in the database. Under day schedule, if the value it finds is not one of the base values, it should take the value it gets and use it as the database path for the schedule
        configureViews()
        layoutViews()
        setupMeter()
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
            vc.gradeDelegate = self
            present(vc, animated: true)
            return
        }
    }
    
    func didSelectGrade() {
        getSchoolDayData(true)
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
    
    func animateStroke(toValue: CGFloat) {
        strokeAnimation.toValue = toValue
        strokeAnimation.duration = 1.3
        strokeAnimation.fillMode = .forwards
        strokeAnimation.isRemovedOnCompletion = false
        shapeLayer.add(strokeAnimation, forKey: "stroke")
    }
    
    fileprivate func animatePulsatingLayer() {
        pulse.toValue = 1.15
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
            topContainer.widthAnchor.constraint(equalToConstant: view.width),
            topContainer.heightAnchor.constraint(equalToConstant: view.height/3 + view.safeAreaInsets.top),
            topContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topContainer.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            logoImage.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 10),
//            logoImage.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 10 + view.safeAreaInsets.top),
//            logoImage.widthAnchor.constraint(equalToConstant: view.width/3 - 10),
//            logoImage.heightAnchor.constraint(equalToConstant: view.width/3 - 10)
//        ])
//
//        NSLayoutConstraint.activate([
//            topBGImage.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: -20),
//            topBGImage.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: -20),
//            topBGImage.widthAnchor.constraint(equalToConstant: view.width + 40),
//            topBGImage.heightAnchor.constraint(equalToConstant: view.height/2.5 + view.safeAreaInsets.top + 30)
//        ])
        
        //TODO: make a full programmatic and dynamic UI!!!!
        
        NSLayoutConstraint.activate([
            dayInfo.widthAnchor.constraint(equalToConstant: 235),
            dayInfo.heightAnchor.constraint(equalToConstant: 110),
            dayInfo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            dayInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24 + 110 + 6)
//            dayInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            dayInfo.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)
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
            timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
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
        
        view.addSubview(topContainer)
//        topContainer.addSubview(topBGImage)
        topContainer.addSubview(dayInfo)
        topContainer.addSubview(timeLabel)
        topContainer.addSubview(dateLabel)
        topContainer.addSubview(letterDay)
//        topContainer.addSubview(logoImage)
        
        
        view.addSubview(timesContainer)
        timesContainer.addSubview(timeLeft)
        timesContainer.addSubview(accesoryTextLabel)
        timesContainer.addSubview(periodLabel)
        //        view.addSubview(messageLabel)
        
        
        //        container.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
    }
    
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

