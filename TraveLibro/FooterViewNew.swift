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
        
        upperMainView.layer.cornerRadius = 18
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
    
    
    func gotoOTG(_ sender: UITapGestureRecognizer) {
        let tlVC = storyboard!.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
        tlVC.isJourney = false
        if(currentUser["journeyId"].stringValue == "-1") {
            isJourneyOngoing = false
            tlVC.showJourneyOngoing(journey: JSON(""))
            //                self.navigationController?.navigationBar.isHidden = true
        }
        globalNavigationController?.pushViewController(tlVC, animated: false)
    }
    
    func gotoFeed(_ sender: UITapGestureRecognizer) {
        
        let tlVC = storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
        globalNavigationController?.pushViewController(tlVC, animated: false)
        
    }
    
    func openNotifications(_ sender: UITapGestureRecognizer) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "notifySub") as! NotificationSubViewController
        vc.whichView = "Notify"
        globalNavigationController?.pushViewController(vc, animated: false)
        
        
    }
    
    func goToLocalLife(_ sender : AnyObject) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "localLife") as! LocalLifeRecommendationViewController
        globalNavigationController?.pushViewController(vc, animated: false)
    }
    
    
    
}
