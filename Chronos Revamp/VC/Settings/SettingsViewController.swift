//
//  SettingsViewController.swift
//  STEM Chronos- Comp. Fair
//
//  Created by Nick Viscomi on 2/28/20.
//  Copyright © 2020 Nick Viscomi. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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

    fileprivate let tableView: UITableView = {
        let field = UITableView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return field
    }()
    
    var rowIndex: Int?
    var grade: String = ""
    let defaults = UserDefaults.standard
    
    var linkData = [String:String]()
    var links = [String]()
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addViews()
        setConstraints()
        
        //constant time update
        _ = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)

        dayInfo.text = "Settings"

        tableView.delegate = self
        tableView.dataSource = self
        
        getLinks()
    }
    
    func getLinks() {
        group.enter()
        DatabaseManager.shared.getLinksFromDatabase { (data) in
            guard let data = data else {
                print("failure in calling getLink function")
                return
            }
            self.linkData = data
            self.group.leave()
        }
        
        group.notify(queue: .main) { [self] in
            var keys = [String]()
            for (key, val) in linkData {
                keys.append(key)
                links.append(val)
            }
            sectionText.append(keys)
            headers = ["Settings","Resources"]
            tableView.reloadData()
        }
    }
    
    @objc func composeEmail(_ sender: UIButton) {
        //show the email view controller so they can send email to report bugs
        showMailComposer()
    }

    
    // MARK: - Table view data source
    //header of table view
    var headers = [String]()//["Settings","Resources"]
    
    //words in rows
    var sectionText = [["Change Grade"]]//[["Change Grade"],["Full Calender","Dasd.org","Infinite Campus","Patch Notes"]]

    func numberOfSections(in tableView: UITableView) -> Int {
        
        //number of sections
        return headers.count
//        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //number of rows
        return sectionText[section].count
//        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sectionText[indexPath.section][indexPath.row]
//        cell.textLabel?.text = "Please work"

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //set header
        return headers[section]
//        return "Title"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rowIndex = indexPath.row
        
        guard rowIndex != nil else {
            return
        }
        
        if indexPath.section == 1 {
            showSafari(websiteUrl: links[indexPath.row])
//            //open certian websites if a certain row is tapped
//            if rowIndex == 0 {
//                //open full calender
//                showSafari(websiteUrl: "https://www.dasd.org/Page/2#calendar1/20200305/month")
//            } else if rowIndex == 1 {
//                //open dasd.org
//                showSafari(websiteUrl: "https://www.dasd.org/Domain/4")
//            } else if rowIndex == 2 {
//                //open Infinite Campus
//                showSafari(websiteUrl: "https://campus.dasd.org/campus/portal/parents/downingtown.jsp")
//            } else if rowIndex == 3 {
//                //open patch notes
//                showSafari(websiteUrl: "https://docs.google.com/document/d/10qeoGjsGxCQrWGI_B3dlRDjLWEa3pcWSfrtoql6bDVM/edit?usp=sharing")
//            }
        }
        
        if indexPath.section == 0 {
            changeGrade()
        }
        
    }
    
    fileprivate func changeGrade() {
        print("change grade now")
        let vc = GradeSelectionViewController()
        present(vc, animated: true, completion: nil)
    }
    
    //show safair pop up with website url
    fileprivate func showSafari(websiteUrl: String) {
        guard let url = URL(string: websiteUrl) else {
            return
        }
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true)
        
    }

    //create the mail view controller so user can report bugs by emailing me
    fileprivate func showMailComposer() {
        
        guard MFMailComposeViewController.canSendMail() else {
            showAlert(title: "Error", message: "Device is unable to send mail")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["stemchronos@gmail.com","nicholasviscomi@gmail.com"])
        composer.setSubject("Suggestion for STEM Chronos")
        
        present(composer, animated: true)
    }
    
    @objc fileprivate func updateTime() {
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
            tableView.topAnchor.constraint(equalTo: topContainer.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        
        view.addSubview(tableView)
    }

}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    public func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        present(alertController, animated: true)
    }
    
    //show a mail controller on the screen
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        //make sure error = nil
        guard error == nil else {
            //show error
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            controller.dismiss(animated: true)
        case .failed:
            controller.dismiss(animated: true)
        case .saved:
            controller.dismiss(animated: true)
        case .sent:
            controller.dismiss(animated: true)
            showAlert(title: "Thank You!", message: "Thank you for sharing your input with us!")
        default:
            break
        }
        
    }
}
