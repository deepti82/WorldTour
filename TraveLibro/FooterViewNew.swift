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
        
    @IBOutlet weak var activityImage: UIButton!
    @IBOutlet weak var activityText: UIButton!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var traveLifeButton: UIButton!
    @IBOutlet weak var myLifeButton: UIButton!
    @IBOutlet weak var locaLifeButton: UIButton!
    @IBOutlet weak var alertButton
    : UIButton!

    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib ()
        
//        for icon in footerIconImages {
//            
//            icon.tintColor = UIColor.white
//            
//        }
//        
//        upperMainView.layer.cornerRadius = 20
//        upperMainView.layer.borderWidth = 2
//        
//        badgeButton.layer.cornerRadius = (badgeButton.frame.size.width/2)
//        badgeButton.layer.zPosition = 15000
//        
//        upperMainView.layer.borderColor = UIColor(red: 57/255, green: 66/255, blue: 106/255, alpha: 1).cgColor
//        
//        footerSharedInstance = self
//        
//        setBadge()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "footerItem", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
        
//        let tlTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.gotoOTG(_:)))
//        self.TLView.addGestureRecognizer(tlTap)
//        
//        let fvTap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.gotoFeed(_:)))
//        self.feedView.addGestureRecognizer(fvTap)
//        
//        let tapFour = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.openNotifications(_:)))
//        self.notifyView.addGestureRecognizer(tapFour)
//        
//        let tapLocalLife = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.goToLocalLife(_:)))
//        self.LLView.addGestureRecognizer(tapLocalLife)
    }
    
    func setupButton(button: UIButton) {
        let spacing: CGFloat = 0.0
        //        button.imageView?.frame = CGRect(x: (button.imageView?.frame.origin.x)!, y: (button.imageView?.frame.origin.y)!, width: 25, height: 25)
        let imageSize: CGSize = button.imageView!.image!.size //button.imageView!.frame.size
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
        let labelString = NSString(string: button.titleLabel!.text!)
        let titleSize = labelString.size(attributes: [NSFontAttributeName: button.titleLabel!.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)
        button.contentEdgeInsets = UIEdgeInsetsMake(5.0, 0.0, 5.0, 0.0)
    }
    
    //MARK:- Footer Actions
    
   
    @IBAction func showActivity(_ sender: UIButton) {
        gotoFeed()
    }
    
    @IBAction func showNotification(_ sender: UIButton) {
        openNotifications()
    }
    
    func gotoOTG(_ sender: UITapGestureRecognizer) {
        
        if currentUser != nil {
            setFooterDeafultState()
            self.traveLifeButton.tintColor = mainOrangeColor
            request.getUser(user.getExistingUser(), urlSlug: nil, completion: { (response) in
                DispatchQueue.main.async {
                    currentUser = response["data"]
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
    
    func gotoFeed() {
        if currentUser != nil {
            setFooterDeafultState()
            self.activityImage.imageView?.tintColor = mainOrangeColor
            self.activityText.setTitleColor(mainOrangeColor, for: .normal)
            
            request.getUserFromCache(user.getExistingUser(), completion: { (response) in
                DispatchQueue.main.async {
                    popularView = "activity"
                    currentUser = response["data"]
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
    
    func openNotifications() {
        if currentUser != nil {
            setFooterDeafultState()
//            self.notificationIcon.tintColor = mainOrangeColor
//            self.notifications.textColor = mainOrangeColor
            
            request.getUserFromCache(user.getExistingUser(), completion: { (response) in
                DispatchQueue.main.async {
                    currentUser = response["data"]
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
            setFooterDeafultState()
            self.locaLifeButton.tintColor = mainGreenColor
            
            request.getUserFromCache(user.getExistingUser(), completion: { (response) in
                DispatchQueue.main.async {
                    currentUser = response["data"]
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
    
    
    //MARK: - Notification Badge
    
    func setBadge() {
//        if UserDefaults.standard.value(forKey: "notificationCount") != nil {
//            let notificationCount = UserDefaults.standard.value(forKey: "notificationCount") as! Int            
//            if notificationCount > 0 {
//                self.badgeButton.isHidden = false
//                self.badgeButton.setTitle(String(notificationCount), for: .normal)
//                self.badgeButton.titleLabel?.sizeToFit()
//                self.bringSubview(toFront: self.badgeButton)
//            }
//            else {
//                self.badgeButton.isHidden = true
//            }
//        }
//        else {
//            self.badgeButton.isHidden = true
//        }
    }
    
    //MARK: - Clear State
    
    func setFooterDeafultState() {
//        self.travelLifeIcon.tintColor = UIColor.white
//        self.travelLife.textColor = UIColor.white
//        
//        self.activityImage.tintColor = UIColor.white
//        self.activityOrange.textColor = UIColor.white
//        
//        self.notificationIcon.tintColor = UIColor.white
//        self.notifications.textColor = UIColor.white
//        
//        self.localLifeIcon.tintColor = UIColor.white
//        self.localLife.textColor = UIColor.white        
    }
    
}
