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

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    
    var rowIndex: Int?
    var grade: String = ""
    let defaults = UserDefaults.standard
    
    var linkData = [String:String]()
    var links = [String]()
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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


        tableView.delegate = self
        tableView.dataSource = self
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
            print("Section Text \(sectionText)\nLinks: \(links)")
            tableView.reloadData()
        }
    }
    
    @IBAction func composeEmail(_ sender: UIButton) {
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
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //number of rows
        return sectionText[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //set cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = sectionText[indexPath.section][indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //set header
        return headers[section]
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
        composer.setSubject("Bug/Problem/Suggestion for STEM Chronos")
        
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
