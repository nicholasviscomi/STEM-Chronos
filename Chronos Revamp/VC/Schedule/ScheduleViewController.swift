//
//  ScheduleViewController.swift
//  updated Chronos
//
//  Created by Nick Viscomi on 4/25/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //photos in the collection view
    let photos = ["JS regular", "FS regular", "JS 2hr early", "FS 2hr early","JS 2hr delay", "FS 2hr delay", "JS events", "FS events"]
    
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
        field.font = .systemFont(ofSize: 28, weight: .regular)
        field.textColor = .white
        field.numberOfLines = 5
        field.textAlignment = .left
        field.text = "Bell Schedules"
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
    
    let dateLabel: UILabel = { // shows the date
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textColor = .black
        field.font = .systemFont(ofSize: 25, weight: .regular)
        field.numberOfLines = 1
        field.textAlignment = .left
        return field
    }()
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0 //between item spacing
        let field = UICollectionView(frame: .zero, collectionViewLayout: layout)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.clipsToBounds = true
        field.backgroundColor = .clear
        field.register(ScheduleCell.self, forCellWithReuseIdentifier: "ScheduleCell")
//        field.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addViews()
        setConstraints()
        
        view.backgroundColor = .systemBackground
        //constant time update
        _ = Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //set the colors of the text inside the circle to be .label
        //MARK: the basic schedules should be hardcoded but there should be the option for a new schedule in the database. Under day schedule, if the value it finds is not one of the base values, it should take the value it gets and use it as the database path for the schedule
        addViews()
        setConstraints()
    }
    
    //update the time
    @objc func updateTime() {
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //how many photos in the collection view
        return 5
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //set cells
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCell", for: indexPath) as! ScheduleCell
        cell.setCell(imageName: photos[indexPath.row])
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = .systemRed
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailScheduleViewController(image: UIImage(named: photos[indexPath.row])!, imageTitle: photos[indexPath.row])
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.width-20, height: view.height/4)
    }
    
    fileprivate func setConstraints() {
        
        //Assemble top container
        NSLayoutConstraint.activate([
            topContainer.heightAnchor.constraint(equalToConstant: view.height/3 + view.safeAreaInsets.top + (view.height/13)),
            topContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
            topContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
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
            logoImage.widthAnchor.constraint(equalToConstant: view.width/3.5),
            logoImage.heightAnchor.constraint(equalToConstant: view.width/3.5)
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
        
        //Assemble bottom container
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    fileprivate func addViews() {
        view.addSubview(topContainer)
        topContainer.addSubview(topYellowBackground)
        topContainer.addSubview(topPurpleBackground)
        topContainer.addSubview(logoImage)
        topContainer.addSubview(dayInfo)
        topContainer.addSubview(timeLabel)
        topContainer.addSubview(dateLabel)
        view.addSubview(collectionView)
    }
    
}
