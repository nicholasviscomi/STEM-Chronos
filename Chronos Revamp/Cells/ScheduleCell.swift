//
//  cell.swift
//  updated Chronos
//
//  Created by Nick Viscomi on 4/25/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class ScheduleCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setCell(imageName:String) {
        imageView.image = UIImage(named: imageName)
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
    }
    
}

