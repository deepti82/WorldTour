//
//  FooterViewNew.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        for icon in footerIconImages {
            
            icon.tintColor = UIColor.white
            
        }
        
        upperMainView.layer.cornerRadius = 20
        upperMainView.layer.borderWidth = 2
        
        upperMainView.layer.borderColor = UIColor(red: 57/255, green: 66/255, blue: 106/255, alpha: 1).cgColor
        
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
        print("user which which user")
        print(user.getExistingUser())
        
        request.getUser(user.getExistingUser(), completion: {(request) in
            DispatchQueue.main.async {
                currentUser = request["data"]
                let tlVC = storyboard!.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
                tlVC.isJourney = false
                if(currentUser["journeyId"].stringValue == "-1") {
                    isJourneyOngoing = false
                    tlVC.showJourneyOngoing(journey: JSON(""))
                    //                self.navigationController?.navigationBar.isHidden = true
                }
                globalNavigationController?.pushViewController(tlVC, animated: false)
            }
        })
        
    }
    
    func gotoFeed(_ sender: UITapGestureRecognizer) {
        request.getUser(user.getExistingUser(), completion: {(request) in
            DispatchQueue.main.async {
                currentUser = request["data"]
                let tlVC = storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
                tlVC.displayData = "activity"
                globalNavigationController?.pushViewController(tlVC, animated: false)
            }
        })
    }
    
    func openNotifications(_ sender: UITapGestureRecognizer) {
        request.getUser(user.getExistingUser(), completion: {(request) in
            DispatchQueue.main.async {
                currentUser = request["data"]
                let vc = storyboard?.instantiateViewController(withIdentifier: "notifySub") as! NotificationSubViewController                
                globalNavigationController?.pushViewController(vc, animated: false)
            }
        })
        
    }
    
    func goToLocalLife(_ sender : AnyObject) {
        request.getUser(user.getExistingUser(), completion: {(request) in
            DispatchQueue.main.async {
                currentUser = request["data"]
                let vc = storyboard?.instantiateViewController(withIdentifier: "localLife") as! LocalLifeRecommendationViewController
                globalNavigationController?.pushViewController(vc, animated: false)
            }
        })
    }
    
    
    
}
