//
//  EditSettingsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class EditSettingsViewController: UIViewController, UIWebViewDelegate {
    
    internal var whichView = "noView"
    var report:ReportProblem = ReportProblem()
    var MAMtextView = MoreAboutMe()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.automaticallyAdjustsScrollViewInsets = false
        
        print("view: \(whichView)")
        
        switch whichView {
        case "MAMView":
            self.title = "More About Me"
 
            let titleText = NSMutableAttributedString(string: "Click here", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
                                                                                         NSFontAttributeName : UIFont(name: "Avenir-Heavy", size: 14)!,
                                                                                         NSForegroundColorAttributeName: mainBlueColor])
            titleText.append(getRegularString(string: " to change your travel preferences"))
            
            let titleView = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
            titleView.center = CGPoint(x: self.view.frame.width/2 , y: 100)
            titleView.setAttributedTitle(titleText, for: .normal)
            titleView.titleLabel?.font = avenirFont!
            titleView.setTitleColor(UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1), for: UIControlState())
            titleView.backgroundColor = UIColor.clear
            titleView.addTarget(self, action: #selector(EditSettingsViewController.editPreferences(_:)), for: .touchUpInside)
            self.view.addSubview(titleView)
            
            MAMtextView = MoreAboutMe(frame: CGRect(x: 0, y: 140, width: self.view.frame.width, height: 150))
            MAMtextView.backgroundColor = UIColor.white
            self.view.addSubview(MAMtextView)
            break        
        
        case "ReportView":
            self.title = "Report a problem"
            report = ReportProblem(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: 300))
            report.submitButton.addTarget(self, action: #selector(EditSettingsViewController.submitComplaint(_:)), for: .touchUpInside)
            self.view.addSubview(report)
            break
            
        case "terms&conditions":
            fallthrough
        case "AboutUsView":
            var pdfPath : URL!
            if whichView == "terms&conditions" {
                 pdfPath = NSURL(fileURLWithPath: (Bundle.main.path(forResource: "Terms&Conditions", ofType:"pdf"))!) as URL
            }
            else {
                pdfPath = NSURL(string: "http://travelibro.net/#/about-travelibro")! as URL
            }
            
            self.view.backgroundColor = UIColor.clear
            self.title = (whichView == "AboutUsView") ? "About us" : "Terms & Conditions" 
            let aboutUsWebView = UIWebView(frame: CGRect(x: 0, y: 65, width: screenWidth, height: screenHeight-65))
            aboutUsWebView.delegate = self
            aboutUsWebView.loadRequest(NSURLRequest(url: pdfPath) as URLRequest)
            aboutUsWebView.backgroundColor = UIColor.clear
            self.view.addSubview(aboutUsWebView)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Actions
    
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

    
    //MARK:- Webview Delegates
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("\n\n webViewDidStartLoad \n\n")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("\n\n webViewDidFinishLoad \n\n")
    }
    
}
