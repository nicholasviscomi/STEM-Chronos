//
//  DetailScheduleViewController.swift
//  Chronos Revamp
//
//  Created by Nick Viscomi on 8/22/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class DetailScheduleViewController: UIViewController {

    var image: UIImage
    var imageTitle: String
    
    fileprivate let bigPictureView: UIImageView = {
        let field = UIImageView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.contentMode = .scaleAspectFit
        field.layer.cornerRadius = 20
//        field.layer.borderColor = UIColor.label.cgColor
//        field.layer.borderWidth = 2
        field.clipsToBounds = true
        return field
    }()
    
    
    init(image: UIImage, imageTitle: String) {
        self.image = image
        self.bigPictureView.image = image
        self.imageTitle = imageTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        view.insertSubview(visualEffectView, at: 0)
        visualEffectView.frame = view.bounds
        
        view.addSubview(bigPictureView)
        
        NSLayoutConstraint.activate([
            bigPictureView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bigPictureView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bigPictureView.widthAnchor.constraint(equalToConstant: view.width - 50),
            bigPictureView.heightAnchor.constraint(equalToConstant: view.width - 100)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        view.addGestureRecognizer(tap)
    }
    
    @objc func didTapBackground() {
        self.dismiss(animated: true, completion: nil)
    }


}
