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
    
    
    @IBOutlet weak var backView: UIView!
    
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
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var badgeButton: UIButton!
    @IBOutlet weak var badgeWidthConstraint: NSLayoutConstraint!
    
    var allButtons: [UIButton]!
    var allFooterViews: [UIView]!
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib ()
        
        backView.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
        
        badgeButton.layer.cornerRadius = (badgeButton.frame.size.width/2.0)
        self.alertView.bringSubview(toFront: badgeButton)
        
        let tapout = UITapGestureRecognizer(target: self, action: #selector(self.gotoActivity))
        activityView.addGestureRecognizer(tapout)

        let tapout1 = UITapGestureRecognizer(target: self, action: #selector(self.gotoTraveLife))
        travelView.addGestureRecognizer(tapout1)

        let tapout2 = UITapGestureRecognizer(target: self, action: #selector(self.gotoMyLife))
        myLifeView.addGestureRecognizer(tapout2)

        let tapout3 = UITapGestureRecognizer(target: self, action: #selector(self.gotoLocaLife))
        localView.addGestureRecognizer(tapout3)

        let tapout4 = UITapGestureRecognizer(target: self, action: #selector(self.gotoAlerts))
        alertView.addGestureRecognizer(tapout4)

        allButtons = [activityButton, activityTextButton, traveLifeButton, traveLifeTextButton, myLifeButton, myLifeTextButton, locaLifeButton, locaLifeTextButton, alertButton, alertTextButton]
        allFooterViews = [activityView, travelView, myLifeView, localView, alertView]
        
        self.setFooterDefaultState()              
        
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
            setHighlightStateForView(tag: 0, color: mainOrangeColor)
            request.getUserFromCache(user.getExistingUser(), completion: { (response) in
                DispatchQueue.main.async {
                    popularView = "activity"
                    currentUser = response["data"]
                    let vc = storyboard!.instantiateViewController(withIdentifier: "TLMainFeedsView") as! TLMainFeedsViewController
                    vc.pageType = viewType.VIEW_TYPE_ACTIVITY
//                    vc.displayData = "activity"
//                    popularView = "activity"
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
            setHighlightStateForView(tag: 1, color: mainOrangeColor)
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
            setHighlightStateForView(tag: 2, color: mainOrangeColor)
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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
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
            setHighlightStateForView(tag: 3, color: mainGreenColor)
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
            setHighlightStateForView(tag: 4, color: mainOrangeColor)
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
    
    
    //MARK: - Alert Badge
    
    func setBadge() {        
        if UserDefaults.standard.value(forKey: "notificationCount") != nil {
            let notificationCount = UserDefaults.standard.value(forKey: "notificationCount") as! Int            
            if notificationCount > 0 {
                self.badgeButton.isHidden = false
                self.badgeButton.setTitle(String(notificationCount), for: .normal)
                self.badgeButton.titleLabel?.adjustsFontSizeToFitWidth = true
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
    
    
    //MARK: - Button State
    
    func setFooterDefaultState() {
        for btn in allButtons {
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.tintColor = UIColor.white
            btn.isUserInteractionEnabled = true
        }
        
        for view in allFooterViews {
            view.isUserInteractionEnabled = true
        }
    }
    
    func setHighlightStateForView(tag: Int, color: UIColor) {
        switch tag {
        case 0:
            activityView.isUserInteractionEnabled = false
            
            activityButton.isUserInteractionEnabled = false
            activityButton.tintColor = color
            
            activityTextButton.isUserInteractionEnabled = false
            activityTextButton.setTitleColor(color, for: .normal)
            
            break
            
            
        case 1:
            travelView.isUserInteractionEnabled = false
            
            traveLifeButton.isUserInteractionEnabled = false
            traveLifeButton.tintColor = color
            
            traveLifeTextButton.isUserInteractionEnabled = false
            traveLifeTextButton.setTitleColor(color, for: .normal)
            
            break
            
            
        case 2:
            myLifeView.isUserInteractionEnabled = false
            
            myLifeButton.isUserInteractionEnabled = false
            myLifeButton.tintColor = color
            
            myLifeTextButton.isUserInteractionEnabled = false
            myLifeTextButton.setTitleColor(color, for: .normal)
            
            break
            
            
        case 3:
            localView.isUserInteractionEnabled = false
            
            locaLifeButton.isUserInteractionEnabled = false
            locaLifeButton.tintColor = color
            
            locaLifeTextButton.isUserInteractionEnabled = false
            locaLifeTextButton.setTitleColor(color, for: .normal)
            
            break
            
            
        case 4:
            alertView.isUserInteractionEnabled = false
            
            alertButton.isUserInteractionEnabled = false
            alertButton.tintColor = color
            
            alertTextButton.isUserInteractionEnabled = false
            alertTextButton.setTitleColor(color, for: .normal)
            
            break            
            
            
        default:
            print("Footer default : \(tag)")
            break
        }
    }
}
