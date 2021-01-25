//
//  GradeSelectionViewController.swift
//  Chronos Revamp
//
//  Created by Nick Viscomi on 8/14/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit

class GradeSelectionViewController: UIViewController {

    private let stackView: UIStackView = {
        let field = UIStackView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.axis = .vertical
        field.distribution = .equalSpacing
        field.spacing = 15
        field.backgroundColor = .none
        return field
    }()
    private let FS : UIButton = {
        let field = UIButton()
        field.titleLabel?.font = .systemFont(ofSize: 28, weight: .medium)
        field.layer.cornerRadius = 25
//        field.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        field.setTitle("Freshmen/Sophomore", for: .normal)
        field.setTitleColor(.systemBackground, for: .normal)
        field.backgroundColor = .schoolYellow
        field.titleLabel?.textAlignment = .center
        field.contentVerticalAlignment = .center
        return field
    }()
    
    private let JS : UIButton = {
        let field = UIButton()
        field.titleLabel?.font = .systemFont(ofSize: 28, weight: .medium)
        field.layer.cornerRadius = 25
//        field.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        field.setTitle("Junior/Senior", for: .normal)
        field.setTitleColor(.systemBackground, for: .normal)
        field.backgroundColor = .schoolPurple
        field.titleLabel?.textAlignment = .center
        field.contentVerticalAlignment = .center
        return field
    }()
    
    private let confirm : UIButton = {
        let field = UIButton()
        field.layer.cornerRadius = 25
        field.titleLabel?.font = .systemFont(ofSize: 28, weight: .regular)
        field.setTitle("Confirm", for: .normal)
        field.setTitleColor(.label, for: .normal)
        field.backgroundColor = .systemBackground
        return field
    }()
    
    private let header : UILabel = {
        let field = UILabel()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = .systemFont(ofSize: 32, weight: .heavy)
        field.text = "Select your \ncurrent grade"
        field.textColor = .label
        field.numberOfLines = 0
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 10
        field.textAlignment = .center
        return field
    }()
    
    var selectedGrade: Grade?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        stackView.addArrangedSubview(FS)
        stackView.addArrangedSubview(JS)
        stackView.addArrangedSubview(confirm)
        view.addSubview(header)
        
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame

        self.view.insertSubview(blurEffectView, at: 0)
        
        FS.addTarget(self, action: #selector(fsTapped), for: .touchUpInside)
        JS.addTarget(self, action: #selector(jsTapped), for: .touchUpInside)
        confirm.addTarget(self, action: #selector(confirmed), for: .touchUpInside)
    }
    
    @objc func fsTapped() {
        FS.backgroundColor = .link
        JS.backgroundColor = .secondaryLabel
        selectedGrade = .FS
    }
    
    @objc func jsTapped() {
        JS.backgroundColor = .link
        FS.backgroundColor = .secondaryLabel
        selectedGrade = .JS
    }
    
    @objc func confirmed() {
        guard let selectedGrade = selectedGrade else { return }
        
        HomeViewController.grade = selectedGrade
        HomeViewController.hasSelectedGrade = true
        
        defaults.set(HomeViewController.hasSelectedGrade, forKey: UDKeys.firstTimeOpening)
        defaults.set("\(selectedGrade)", forKey: UDKeys.grade)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: view.width-100),
            stackView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        NSLayoutConstraint.activate([
            header.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            header.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -30),
            header.widthAnchor.constraint(equalToConstant: view.width)
        ])
    }
    

}
