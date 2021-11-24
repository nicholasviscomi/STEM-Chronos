//
//  cell.swift
//  updated Chronos
//
//  Created by Nick Viscomi on 4/25/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class ScheduleCell: UICollectionViewCell {
    
    fileprivate let imageView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    func setCell(imageName:String) {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        imageView.image = UIImage(named: imageName)
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
    }
    
}

