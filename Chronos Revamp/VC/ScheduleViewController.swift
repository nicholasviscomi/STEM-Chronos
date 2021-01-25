//
//  ScheduleViewController.swift
//  updated Chronos
//
//  Created by Nick Viscomi on 4/25/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //photos in the collection view
    let photos = ["JS regular", "FS regular", "JS 2hr early", "FS 2hr early","JS 2hr delay", "FS 2hr delay", "JS events", "FS events"]

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let bigPictureView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.alpha = 0
        field.contentMode = .scaleAspectFit
        return field
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bigPictureView)
        view.bringSubviewToFront(bigPictureView)
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 25, weight: .regular)
        timeLabel.numberOfLines = 1
        timeLabel.textAlignment = .left
        
        dateLabel.textColor = .black
        dateLabel.font = .systemFont(ofSize: 25, weight: .regular)
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .left
        //constant time update
        _ = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        NSLayoutConstraint.activate([
//            bigPictureView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            bigPictureView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            bigPictureView.widthAnchor.constraint(equalToConstant: view.width - 100),
//            bigPictureView.heightAnchor.constraint(equalToConstant: view.width - 100)
//        ])
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
        return photos.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //set cells
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gemCell", for: indexPath) as! ScheduleCell
        
        cell.setCell(imageName: photos[indexPath.row])
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(photos[indexPath.row])
        let vc = DetailScheduleViewController(image: UIImage(named: photos[indexPath.row])!, imageTitle: photos[indexPath.row])
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: true)

        
    }
    
}
