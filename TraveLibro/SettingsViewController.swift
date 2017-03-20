//
//  SettingTableViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    internal var dataSourceOption: String = ""
    internal var labels = ["Cellular and WiFi", "WiFi"]
    let localLoggedInUser = user.getUser(currentUser["_id"].stringValue)
    
    var selectedOption = ""
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var heightConstraintTable: NSLayoutConstraint!
            
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        let count: CGFloat = CGFloat(labels.count)
        heightConstraintTable?.constant = count * 75
        print("NSLayoutConstraint: \(heightConstraintTable)")
        
        if dataSourceOption == "dataUploadOptions" {
            labels = ["Cellular and WiFi", "WiFi"]
        }
        else {
            labels = ["Public - Everyone", "Private - My Followers"]
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if dataSourceOption == "privacyOptions" {
            self.title = "Privacy"
        }
        else {
            self.title = "Data Upload"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var index:Int? = (currentUser["status"].stringValue == "private") ? 1 : 0
        
        if dataSourceOption == "dataUploadOptions" {
            index = labels.indexOf(value: localLoggedInUser.dataupload)
            if index == nil {
                index = 1   //Default: WiFi
            }
            self.tableView(settingsTableView, didSelectRowAt: IndexPath(row: index!, section: 0))
        }
        else {
            index = labels.indexOf(value: localLoggedInUser.Privacy)
            if index == nil {
                index = 1   //Default: Private - My Followers
            }
            self.tableView(settingsTableView, didSelectRowAt: IndexPath(row: index!, section: 0))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveOption()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    //MARK:- TableView datasource and delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! EditSettingsTableViewCell
        cell.checkLabel.text = labels[(indexPath as NSIndexPath).item]
        return cell
    }    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        if selectedCell?.accessoryType == .checkmark {
            
            selectedCell?.accessoryType = .none
            selectedOption = ""
        }
        
        else {
            if selectedOption != "" {
                if dataSourceOption == "dataUploadOptions" {
                    let index = labels.indexOf(value: localLoggedInUser.dataupload)
                    if index != nil {
                        self.tableView(settingsTableView, didDeselectRowAt: IndexPath(row: index!, section: 0))
                    }
                }
                else {
                    let index = labels.indexOf(value: localLoggedInUser.Privacy)
                    if index != nil {
                        self.tableView(settingsTableView, didDeselectRowAt: IndexPath(row: index!, section: 0))
                    }
                }
            }
            selectedCell?.accessoryType = .checkmark
            selectedOption = labels[indexPath.row]
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        if selectedCell?.accessoryType == .checkmark {
            
            selectedCell?.accessoryType = .none
            selectedOption = ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if dataSourceOption == "privacyOptions" {
            let footerLabel = UILabel(frame: CGRect(x: 0, y: 0, 
                                                    width: tableView.frame.size.width, 
                                                    height: self.tableView(tableView, heightForFooterInSection: section)))
            footerLabel.font = avenirFont
            footerLabel.text = "When you select your account to be private only, your followers can view your My Life - Journeys, Moments abd Reviews."
            footerLabel.textColor = UIColor.white
            footerLabel.textAlignment = .center
            footerLabel.numberOfLines = 0
            footerLabel.lineBreakMode = .byWordWrapping
            footerLabel.backgroundColor = UIColor.clear
            footerLabel.sizeToFit()
            return footerLabel
        }
        
        return UIView()
    }
    
    
    //MARK:- Save function
    
    func saveOption() {
        
        //TODO: check if any option must be selected or not
        
        if selectedOption != "" {
            
            if dataSourceOption == "dataUploadOptions" {
                if localLoggedInUser.dataupload != selectedOption {
                    user.updateUserDataUploadMethod(currentUser["_id"].stringValue, dataUpload: selectedOption)
                    Toast(text:"Profile updated").show()
                }
            }
            else {
                if localLoggedInUser.Privacy != selectedOption {
                    request.editUser(currentUser["_id"].stringValue, editField: "status", editFieldValue: (selectedOption == "Private - My Followers") ? "private" : "public", completion: { (response) in
                        DispatchQueue.main.async(execute: {
                            if response["value"].bool!{
                                currentUser = response["data"]
                                user.updateUserPrivacy(currentUser["_id"].stringValue, privacy: self.selectedOption)
                                Toast(text:"Profile updated").show()
                            }
                        })
                    })
                }
            }           
        }
    }
}



class EditSettingsTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var checkLabel: UILabel!
    
//    @IBAction func optionChecked(sender: UIButton) {
//        
//        if sender.titleLabel!.tintColor == mainOrangeColor {
//            
//         sender.titleLabel!.tintColor = UIColor.lightGrayColor()
//            
//        }
//        
//        else {
//            
//            sender.titleLabel!.tintColor = mainOrangeColor
//        }
//    }
    
}
