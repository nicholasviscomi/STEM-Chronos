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
        field.layer.cornerRadius = 20
        field.clipsToBounds = true
        field.contentMode = .scaleAspectFit
        return field
    }()
    
    func setCell(imageName:String) {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        imageView.image = UIImage(named: imageName)
    }
    
}

