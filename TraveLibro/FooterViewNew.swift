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
    
    @IBOutlet weak var activityButton: UIButton!
    @IBOutlet weak var traveLifeButton: UIButton!
    @IBOutlet weak var myLifeButton: UIButton!
    @IBOutlet weak var locaLifeButton: UIButton!
    @IBOutlet weak var alertButton : UIButton!
    
    @IBOutlet weak var activityTextButton: UIButton!
    @IBOutlet weak var traveLifeTextButton: UIButton!
    @IBOutlet weak var myLifeTextButton: UIButton!
    @IBOutlet weak var locaLifeTextButton: UIButton!
    @IBOutlet weak var alertTextButton: UIButton!
    
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var travelView: UIView!
    @IBOutlet weak var myLifeView: UIView!
    @IBOutlet weak var localView: UIView!
    @IBOutlet weak var notificationView: UIView!
    
    var allButtons: [UIButton]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib ()
        let tapout = UITapGestureRecognizer(target: self, action: #selector(self.gotoActivity))
        activityView.addGestureRecognizer(tapout)

        let tapout1 = UITapGestureRecognizer(target: self, action: #selector(self.gotoTraveLife))
        travelView.addGestureRecognizer(tapout1)

        let tapout2 = UITapGestureRecognizer(target: self, action: #selector(self.gotoMyLife))
        myLifeView.addGestureRecognizer(tapout2)

        let tapout3 = UITapGestureRecognizer(target: self, action: #selector(self.gotoLocaLife))
        localView.addGestureRecognizer(tapout3)

        let tapout4 = UITapGestureRecognizer(target: self, action: #selector(self.gotoAlerts))
        notificationView.addGestureRecognizer(tapout4)

        allButtons = [activityButton, activityTextButton, traveLifeButton, traveLifeTextButton, myLifeButton, myLifeTextButton, locaLifeButton, locaLifeTextButton, alertButton, alertTextButton]
        
//        for btn in allButtons {
//            self.setupButton(button: btn)
//        }
        
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
    }
    
    func setupButton(button: UIButton) {
        let spacing: CGFloat = -10.0
        let imageSize: CGSize = button.imageView!.image!.size //button.imageView!.frame.size
        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0)
        let labelString = NSString(string: button.titleLabel!.text!)
        let titleSize = labelString.size(attributes: [NSFontAttributeName: button.titleLabel!.font])
        button.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)        
        button.contentEdgeInsets = UIEdgeInsetsMake(3.0, 0.0, 7.0, 0.0)
    }
    
    
    //MARK:- Footer Actions
    
    @IBAction func activityButtonTabbed(_ sender: UIButton) {
        gotoActivity()
    }
   
    @IBAction func activityTextBtnTabbed(_ sender: UIButton) {
        gotoActivity()
    }
    
    func gotoActivity() {
        if currentUser != nil {
            setFooterDefaultState()
            setHighlightState(btn: self.activityButton, color: mainOrangeColor)
            setHighlightState(btn: self.activityTextButton, color: mainOrangeColor)
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
    
    @IBAction func traveLifeButtonTabbed(_ sender: UIButton) {
        gotoTraveLife()
    }
    
    @IBAction func traveLifeTextBtnTabbed(_ sender: UIButton) {
        gotoTraveLife()
    }
    
    func gotoTraveLife() {
        if currentUser != nil {
            setFooterDefaultState()
            setHighlightState(btn: self.traveLifeButton, color: mainOrangeColor)
            setHighlightState(btn: self.traveLifeTextButton, color: mainOrangeColor)
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
    
    @IBAction func myLifeButtonTabbed(_ sender: UIButton) {        
        gotoMyLife()
    }
    
    @IBAction func myLifeTextBtnTabbed(_ sender: UIButton) {
        gotoMyLife()
    }
    
    func gotoMyLife() {
        if currentUser != nil {
            setFooterDefaultState()
            setHighlightState(btn: self.myLifeButton, color: mainOrangeColor)
            setHighlightState(btn: self.myLifeTextButton, color: mainOrangeColor)
            request.getUserFromCache(user.getExistingUser(), completion: { (response) in
                DispatchQueue.main.async {
                    currentUser = response["data"]
                    let vc = storyboard?.instantiateViewController(withIdentifier: "myLife") as! MyLifeViewController
                    vc.isFromFooter = true
                    self.setVC(newViewController: vc)
                }
            })
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: ["type":1])
        }
    }
    
    @IBAction func locaLifeButtonTabbed(_ sender: UIButton) {
        gotoLocaLife()
    }
    
    @IBAction func locaLifeTextBtnTabbed(_ sender: UIButton) {
        gotoLocaLife()
    }
    
    func gotoLocaLife() {
        if currentUser != nil {
            setFooterDefaultState()
            setHighlightState(btn: self.locaLifeButton, color: mainGreenColor)
            setHighlightState(btn: self.locaLifeTextButton, color: mainGreenColor)
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
    
    @IBAction func alertButtonTabbed(_ sender: UIButton) {
        gotoAlerts()
    }
    
    @IBAction func alertTextBtnTabbed(_ sender: UIButton) {
        gotoAlerts()
    }
    
    func gotoAlerts() {
        if currentUser != nil {
            setFooterDefaultState()
            setHighlightState(btn: self.alertButton, color: mainOrangeColor)
            setHighlightState(btn: self.alertTextButton, color: mainGreenColor)
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
    
    
    //MARK: - Button State
    
    func setFooterDefaultState() {
        for btn in allButtons {
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.tintColor = UIColor.white
        }
    }
    
    func setHighlightState(btn: UIButton, color: UIColor) {
        btn.setTitleColor(color, for: .normal)
        btn.tintColor = color
    }
}
