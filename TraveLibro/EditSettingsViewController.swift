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
    var indicator: UIActivityIndicatorView?    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.automaticallyAdjustsScrollViewInsets = false
        
        getDarkBackGround(self)
        
        switch whichView {
        case "MAMView":
            self.title = "More About Me"
 
            let titleText = NSMutableAttributedString(string: "Click here", attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue,
                                                                                         NSFontAttributeName : UIFont(name: "Avenir-Heavy", size: 14)!,
                                                                                         NSForegroundColorAttributeName: UIColor.white])
            titleText.append(NSMutableAttributedString(string: " to change your travel preferences." , 
                                                       attributes: [NSFontAttributeName: UIFont(name: "Avenir-Medium", size: CGFloat(12))!, NSForegroundColorAttributeName: UIColor.white]))
            
            let titleView = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
            titleView.center = CGPoint(x: self.view.frame.width/2 , y: 36)
            titleView.setAttributedTitle(titleText, for: .normal)
            titleView.titleLabel?.font = avenirFont!
            titleView.setTitleColor(UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1), for: UIControlState())
            titleView.backgroundColor = UIColor.clear
            titleView.addTarget(self, action: #selector(EditSettingsViewController.editPreferences(_:)), for: .touchUpInside)
            self.view.addSubview(titleView)
            
            MAMtextView = MoreAboutMe(frame: CGRect(x: 0, y: 76, width: self.view.frame.width, height: 150))
            MAMtextView.backgroundColor = UIColor(white: 1, alpha: 0.8)
            self.view.addSubview(MAMtextView)
            break        
        
        case "ReportView":
            self.title = "Report A Problem"
            report = ReportProblem(frame: CGRect(x: 0, y: 15, width: self.view.frame.width, height: 300))
            report.submitButton.addTarget(self, action: #selector(EditSettingsViewController.submitComplaint(_:)), for: .touchUpInside)
            self.view.addSubview(report)
            break
            
        case "terms&conditions":
            fallthrough
        case "privacyPolicy":
            fallthrough
        case "AboutUsView":
            var pdfPath : URL!
            if whichView == "terms&conditions" {
                self.title = "Terms & Conditions"
                pdfPath = NSURL(fileURLWithPath: (Bundle.main.path(forResource: "Terms&Conditions", ofType:"pdf"))!) as URL
            }
            else if whichView == "privacyPolicy" {
                self.title = "Privacy Policy"
                pdfPath = NSURL(fileURLWithPath: (Bundle.main.path(forResource: "PrivacyPolicy", ofType:"pdf"))!) as URL
            }
            else {
                self.title = "About Us"
                pdfPath = NSURL(string: "http://travelibro.net/#/about-travelibro")! as URL
            }
            
            self.view.backgroundColor = UIColor.clear
             
            let aboutUsWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight-65))
//            if whichView == "AboutUsView" {
//                aboutUsWebView.frame = CGRect(x: -5, y: -64, width: screenWidth+5, height: screenHeight)
//            }
            aboutUsWebView.delegate = self
            aboutUsWebView.scalesPageToFit = true
            aboutUsWebView.loadRequest(NSURLRequest(url: pdfPath) as URLRequest)
            aboutUsWebView.backgroundColor = UIColor.white
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
        if indicator == nil {
            indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            indicator?.center = self.view.center
            indicator?.activityIndicatorViewStyle = .gray
            indicator?.hidesWhenStopped = true
            indicator?.startAnimating()
            self.view.addSubview(indicator!)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if indicator != nil {
            indicator?.stopAnimating()
            indicator?.removeFromSuperview()
            indicator = nil
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("\n Webview loading failed with error : \(error.localizedDescription)")
    }
    
}
