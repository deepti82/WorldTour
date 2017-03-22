//
//  FooterViewNew.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var footerSharedInstance: FooterViewNew? = nil

func sharedInstance(newFrame: CGRect) -> FooterViewNew {
    
    if footerSharedInstance == nil {
        footerSharedInstance = FooterViewNew(frame: newFrame)
    }
    
    footerSharedInstance?.setBadge()
    
    return footerSharedInstance!
}

class FooterViewNew: UIView {
    
    @IBOutlet var footerIconImages: [UIImageView]!
    @IBOutlet weak var localLifeIcon: UIImageView!
    @IBOutlet weak var travelLifeIcon: UIImageView!
    @IBOutlet weak var feedView: UIView!
    @IBOutlet weak var notifyView: UIView!
    @IBOutlet weak var LLView: UIView!
    @IBOutlet weak var TLView: UIView!
    @IBOutlet weak var lowerMainView: UIView!
    @IBOutlet weak var upperMainView: UIView!
    @IBOutlet weak var badgeButton: UIButton!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib ()
        
        for icon in footerIconImages {
            
            icon.tintColor = UIColor.white
            
        }
        
        upperMainView.layer.cornerRadius = 20
        upperMainView.layer.borderWidth = 2
        
        badgeButton.layer.cornerRadius = (badgeButton.frame.size.width/2)
        badgeButton.layer.zPosition = 10
        
        upperMainView.layer.borderColor = UIColor(red: 57/255, green: 66/255, blue: 106/255, alpha: 1).cgColor
        
        footerSharedInstance = self
        
        setBadge()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "footerNew", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
        
        let tlTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.gotoOTG(_:)))
        self.TLView.addGestureRecognizer(tlTap)
        
        let fvTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.gotoFeed(_:)))
        self.feedView.addGestureRecognizer(fvTap)
        
        let tapFour = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.openNotifications(_:)))
        self.notifyView.addGestureRecognizer(tapFour)
        
        let tapLocalLife = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.goToLocalLife(_:)))
        self.LLView.addGestureRecognizer(tapLocalLife)
    }
    
    
    //MARK:- Footer Actions
    
    func gotoOTG(_ sender: UITapGestureRecognizer) {
        
        if currentUser != nil {
            request.getUser(user.getExistingUser(), urlSlug: nil, completion: {(request) in
                DispatchQueue.main.async {
                    currentUser = request["data"]
                    let vc = storyboard!.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
                    vc.isJourney = false
                    if(currentUser["journeyId"].stringValue == "-1") {
                        isJourneyOngoing = false
                        vc.showJourneyOngoing(journey: JSON(""))
                    }
                    self.setVC(newViewController: vc)
                }
            })
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: ["type":0])
        }
        
        
    }
    
    func gotoFeed(_ sender: UITapGestureRecognizer) {
        if currentUser != nil {
            request.getUser(user.getExistingUser(), urlSlug: nil, completion: {(request) in
                DispatchQueue.main.async {
                    popularView = "activity"
                    currentUser = request["data"]
                    let vc = storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
                    vc.displayData = "activity"
                    popularView = "activity"
                    self.setVC(newViewController: vc)
                }
            })            
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil )
        }
    }
    
    func openNotifications(_ sender: UITapGestureRecognizer) {        
        if currentUser != nil {
            request.getUser(user.getExistingUser(), urlSlug: nil, completion: {(request) in
                DispatchQueue.main.async {
                    currentUser = request["data"]
                    let vc = storyboard?.instantiateViewController(withIdentifier: "notifySub") as! NotificationSubViewController
                    self.setVC(newViewController: vc)
                }
            })            
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil )
        }
    }
    
    func goToLocalLife(_ sender : AnyObject) {        
        if currentUser != nil {
            request.getUser(user.getExistingUser(), urlSlug: nil, completion: {(request) in
                DispatchQueue.main.async {
                    currentUser = request["data"]
                    let vc = storyboard?.instantiateViewController(withIdentifier: "localLife") as! LocalLifeRecommendationViewController
                    self.setVC(newViewController: vc)
                }
            })            
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: ["type":1])
        }        
    }
    
    func setVC(newViewController : UIViewController) {

        let nvc = UINavigationController(rootViewController: newViewController)
        leftViewController.mainViewController = nvc
        leftViewController.slideMenuController()?.changeMainViewController(leftViewController.mainViewController, close: true)
        
        UIViewController().customiseNavigation()
        nvc.delegate = UIApplication.shared.delegate as! UINavigationControllerDelegate? 
    }
    
    func setBadge() {
        if UserDefaults.standard.value(forKey: "notificationCount") != nil {
            let notificationCount = UserDefaults.standard.value(forKey: "notificationCount") as! Int            
            if notificationCount > 0 {
                self.badgeButton.isHidden = false
                self.badgeButton.setTitle(String(notificationCount), for: .normal)
                self.badgeButton.titleLabel?.sizeToFit()
                self.bringSubview(toFront: self.badgeButton)
            }
            else {
                self.badgeButton.isHidden = true
            }
        }
        else {
            self.badgeButton.isHidden = true
        }
    }
    
}
