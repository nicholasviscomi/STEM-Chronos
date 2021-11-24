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
    
    let topContainer: UIView = { //container for top of the screen
        let field = UIView()
        field.clipsToBounds = true
        field.translatesAutoresizingMaskIntoConstraints = false
        //maybe add in a background image
//        field.backgroundColor = .systemGreen
        return field
    }()
    
    let logoImage: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.image = UIImage(named: "Mask Group (1)")
        field.backgroundColor = .clear
        return field
    }()
    
    let topYellowBackground: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.image = UIImage(named: "Vector 2-1")
        field.backgroundColor = .clear
        field.contentMode = .scaleToFill
        return field
    }()
    
    let topPurpleBackground: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.image = UIImage(named: "Rectangle 12")
        field.contentMode = .scaleToFill
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
    
    public let minutesLeftLabel: UILabel = { //minutes left time label
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 28, weight: .light)
        field.textColor = .label
        field.textAlignment = .center
        field.text = "minutes left"
        return field
    }()
    
    public let periodLabel : UILabel = { //says the period name (i.e. lunch, 5th period, advisory)
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 30, weight: .semibold)
        field.textColor = .label
        field.textAlignment = .center
        field.text = ""
        return field
    }()
    
    public let messageLabel : UILabel = { //currently unused
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
    
    let bottomContainer : UIView = { //contianer for the bottom of the view
        let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.clipsToBounds = false
//        field.backgroundColor = .systemOrange
        return field
    }()
    
    //contianer for the time left stuff
    let timesContainer : UIView = {
        let field = UIView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.clipsToBounds = false
        field.backgroundColor = .systemRed
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
        addViews()
        
        //set the layout of the subviews
        setConstraints()
        
        //sef a refrence to database so data can be called
        ref = Database.database().reference()
        
        //constant time update
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        //check if open for first time
        wasOpenedForFirstTime()
        
        //swtup the main time left meter
        setupMeter()
                
        //get data about the day from Firebase and fill out the UI
        getSchoolDayData(true)
        
        lastTime = currentTime()
        dayData = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(getSchoolDayData), userInfo: nil, repeats: true)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //set the colors of the text inside the circle to be .label
        //MARK: the basic schedules should be hardcoded but there should be the option for a new schedule in the database. Under day schedule, if the value it finds is not one of the base values, it should take the value it gets and use it as the database path for the schedule
        addViews()
        setConstraints()
        setupMeter()
    }
    
    fileprivate func wasOpenedForFirstTime() {
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
        
        let bottomContainerHeight = view.height*2/3
        shapeLayer.position = CGPoint(x: view.center.x, y: view.height - bottomContainerHeight/2)
        
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
    
    
    private func setConstraints() {
        
        //Assemble top container
        NSLayoutConstraint.activate([
            topContainer.widthAnchor.constraint(equalToConstant: view.width),
            topContainer.heightAnchor.constraint(equalToConstant: view.height/3 + view.safeAreaInsets.top + (view.height/13)),
            topContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topContainer.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            topYellowBackground.topAnchor.constraint(equalTo: topContainer.topAnchor),
            topYellowBackground.bottomAnchor.constraint(equalTo: topContainer.bottomAnchor),
            topYellowBackground.leftAnchor.constraint(equalTo: topContainer.leftAnchor),
            topYellowBackground.rightAnchor.constraint(equalTo: topContainer.rightAnchor)
        ])
        
        let topCHeight = view.height/3 + view.safeAreaInsets.top + (view.height/13)
        NSLayoutConstraint.activate([
            topPurpleBackground.topAnchor.constraint(equalTo: topYellowBackground.topAnchor),
            topPurpleBackground.leftAnchor.constraint(equalTo: topYellowBackground.leftAnchor),
            topPurpleBackground.rightAnchor.constraint(equalTo: topContainer.rightAnchor),
            topPurpleBackground.heightAnchor.constraint(equalToConstant: topCHeight/2 + 20)
        ])
        
        
        NSLayoutConstraint.activate([
            logoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            logoImage.centerYAnchor.constraint(equalTo: topPurpleBackground.centerYAnchor),
            logoImage.widthAnchor.constraint(equalToConstant: view.width/3.2),
            logoImage.heightAnchor.constraint(equalToConstant: view.width/3.2)
        ])
        
        NSLayoutConstraint.activate([
            dayInfo.leadingAnchor.constraint(equalTo: logoImage.trailingAnchor, constant: 20),
            dayInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            dayInfo.centerYAnchor.constraint(equalTo: logoImage.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: logoImage.leadingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: topPurpleBackground.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: topPurpleBackground.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            letterDay.centerXAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            letterDay.bottomAnchor.constraint(equalTo: topYellowBackground.bottomAnchor, constant: -40)
        ])
        
        //Assemble Bottom Container
        NSLayoutConstraint.activate([
            bottomContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            bottomContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            timesContainer.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),
//            timesContainer.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
//            timesContainer.widthAnchor.constraint(equalToConstant: view.width - (view.width * 0.1)),
//            timesContainer.heightAnchor.constraint(equalToConstant: bottomContainer.height - (bottomContainer.height * 0.2))
//        ])
        
        NSLayoutConstraint.activate([
            timeLeft.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),
            timeLeft.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor, constant: -(view.safeAreaInsets.bottom + 20))
        ])
        
        NSLayoutConstraint.activate([
            minutesLeftLabel.topAnchor.constraint(equalTo: timeLeft.bottomAnchor, constant: -20),
            minutesLeftLabel.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            periodLabel.topAnchor.constraint(equalTo: minutesLeftLabel.bottomAnchor),
            periodLabel.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor)
        ])
    }
    
    private func addViews() {
        view.layer.addSublayer(pulsatingLayer)
        view.layer.addSublayer(shapeLayer)
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(timeLeft)
        bottomContainer.addSubview(minutesLeftLabel)
        bottomContainer.addSubview(periodLabel)
        
        view.addSubview(topContainer)
        topContainer.addSubview(topYellowBackground)
        topContainer.addSubview(topPurpleBackground)
        topContainer.addSubview(logoImage)
        topContainer.addSubview(dayInfo)
        topContainer.addSubview(timeLabel)
        topContainer.addSubview(dateLabel)
        topContainer.addSubview(letterDay)
        
        
        
//        view.addSubview(timesContainer)
        
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

