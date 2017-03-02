//
//  EditSettingsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class EditSettingsViewController: UIViewController {
    
    internal var whichView = "noView"
    var report:ReportProblem = ReportProblem()
    var MAMtextView = MoreAboutMe()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.automaticallyAdjustsScrollViewInsets = false
        
        print("view: \(whichView)")
        
        switch whichView {
        case "MAMView":
            self.title = "Edit More About Me"
            let titleView = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
            titleView.center = CGPoint(x: self.view.frame.width/2 , y: 100)
            titleView.setTitle("Click here to change your travel preferences", for: UIControlState())
            titleView.titleLabel?.font = avenirFont!
            titleView.setTitleColor(UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1), for: UIControlState())
            titleView.backgroundColor = UIColor.clear
            titleView.addTarget(self, action: #selector(EditSettingsViewController.editPreferences(_:)), for: .touchUpInside)
            self.view.addSubview(titleView)
            
            MAMtextView = MoreAboutMe(frame: CGRect(x: 0, y: 140, width: self.view.frame.width, height: 150))
            MAMtextView.backgroundColor = UIColor.white
            self.view.addSubview(MAMtextView)
            break
            
        case "NewPswdView":
            self.title = "Reset Password"
            print("in new pswd view")
            let resetpswd = ResetPassword(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: 250))
            self.view.addSubview(resetpswd)
            break
        
        case "ReportView":
            self.title = "Report a problem"
            report = ReportProblem(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: 300))
            report.submitButton.addTarget(self, action: #selector(EditSettingsViewController.submitComplaint(_:)), for: .touchUpInside)
            self.view.addSubview(report)
            break
            
        case "AboutUsView":
            self.view.backgroundColor = UIColor.groupTableViewBackground
            self.title = "About us"
            let aboutUsTextView = UITextView(frame: CGRect(x: 10, y: 80, width: screenWidth-20, height: screenHeight-90))
            aboutUsTextView.textAlignment = .left
            aboutUsTextView.isEditable = false
            aboutUsTextView.backgroundColor = UIColor.white
            aboutUsTextView.font = UIFont(name: "Avenir-Medium", size: 14)
            aboutUsTextView.text = getAboutUsData()
            self.view.addSubview(aboutUsTextView)
            break
            
        default:
            break
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if whichView == "MAMView" {
            MAMtextView.reloadTravelPrefeces()
        }
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editPreferences(_ sender: UIButton) {
        
        let displayCardsVC = storyboard?.instantiateViewController(withIdentifier: "DisplayCards") as! DisplayCardsViewController
        displayCardsVC.isFromSettings = true
        self.navigationController?.pushViewController(displayCardsVC, animated: true)
    }
    
    func submitComplaint(_ sender: UIButton) {
        
        Toast(text: "Please wait...").show()
        report.theTextView.resignFirstResponder()
        
        DispatchQueue.global().async {
            
            request.reportProblem(currentUser["_id"].stringValue, problemMessage: self.report.theTextView.text) { (response) in
                
                DispatchQueue.main.async(execute: {
                    if response.error != nil {
                        print("error: \(response.error?.localizedDescription)")
                    } else {
                        if response["value"] == true {
                            ToastCenter.default.cancelAll()
                            
                            let alert = UIAlertController(title: nil, message: "Successfully Reported!", preferredStyle: .alert)
                            self.present(alert, animated: false, completion: nil)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{action in
                                self.report.theTextView.text = nil
                                self.report.textViewDidEndEditing(self.report.theTextView)
                                alert.dismiss(animated: true, completion: nil)
                            }))
                        } 
                        else {
                            ToastCenter.default.cancelAll()
                            Toast(text: "Problem reporting failed").show()
                        }
                    }                
                })
            }
        }
    }
    
    func getAboutUsData() -> String {
        return "\n TraveLibro is a portal and app, conceptualized and developed for the ones who love to travel. Stemming from the sole love for travel, TraveLibro aspires to be the space where one can plan, save, share and cherish their travel memories. \n\n Sorting through the truckload of information on travel can be a tedious task. Keeping that in mind, we have well researched information customized to the kind of traveller you are. \n\n A romantic getaway or backpacking with friends, a luxurious extravaganza or a pocket friendly trip, we have all the information you need exactly the way you’d want it. \n\n TraveLibro's On-The-Go App auto-creates a beautiful travel timeline of your journey, as you simply check-in to places, leave a quick note or update your status & pictures. That’s not all; you can add your travel buddies and create shared memories of your journey, to etch your precious memories for a lifetime! \n\n TraveLibro is a portal and app, conceptualized and developed for the ones who love to travel. Stemming from the sole love for travel, TraveLibro aspires to be the space where one can plan, save, share and cherish their travel memories. \n\n Sorting through the truckload of information on travel can be a tedious task. Keeping that in mind, we have well researched information customized to the kind of traveller you are. \n\n A romantic getaway or backpacking with friends, a luxurious extravaganza or a pocket friendly trip, we have all the information you need exactly the way you’d want it. \n\n TraveLibro's On-The-Go App auto-creates a beautiful travel timeline of your journey, as you simply check-in to places, leave a quick note or update your status & pictures. That’s not all; you can add your travel buddies and create shared memories of your journey, to etch your precious memories for a lifetime! \n\n TraveLibro is a portal and app, conceptualized and developed for the ones who love to travel. Stemming from the sole love for travel, TraveLibro aspires to be the space where one can plan, save, share and cherish their travel memories. \n\n Sorting through the truckload of information on travel can be a tedious task. Keeping that in mind, we have well researched information customized to the kind of traveller you are. \n\n A romantic getaway or backpacking with friends, a luxurious extravaganza or a pocket friendly trip, we have all the information you need exactly the way you’d want it. \n\n TraveLibro's On-The-Go App auto-creates a beautiful travel timeline of your journey, as you simply check-in to places, leave a quick note or update your status & pictures. That’s not all; you can add your travel buddies and create shared memories of your journey, to etch your precious memories for a lifetime! \n\n TraveLibro is a portal and app, conceptualized and developed for the ones who love to travel. Stemming from the sole love for travel, TraveLibro aspires to be the space where one can plan, save, share and cherish their travel memories. \n\n Sorting through the truckload of information on travel can be a tedious task. Keeping that in mind, we have well researched information customized to the kind of traveller you are. \n\n A romantic getaway or backpacking with friends, a luxurious extravaganza or a pocket friendly trip, we have all the information you need exactly the way you’d want it. \n\n TraveLibro's On-The-Go App auto-creates a beautiful travel timeline of your journey, as you simply check-in to places, leave a quick note or update your status & pictures. That’s not all; you can add your travel buddies and create shared memories of your journey, to etch your precious memories for a lifetime!"
    }

}
