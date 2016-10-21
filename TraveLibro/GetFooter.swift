//
//  GetFooter.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


class getFooter: UIView, UIGestureRecognizerDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("In the get footer init method")
        print("Superview is: \(self)")
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        footer.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height)

        let footerDown = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 45))
        footerDown.center = CGPoint(x: footer.frame.size.width / 2, y: 0)
        footerDown.backgroundColor = mainBlueColor
        footer.addSubview(footerDown)

        let footerFeed = FooterView(frame: CGRect(x: 0, y: 0, width: footer.frame.size.width/3, height: 30))
        footerFeed.footerText.text = "Feed"
        footerFeed.footerText.textColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)

        footerFeed.footerImage.image = UIImage(named: "feed_icon")
        footerFeed.footerImage.tintColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        footerFeed.center = CGPoint(x: footer.frame.size.width/8, y: footer.frame.size.height/4+5)
        footerDown.addSubview(footerFeed)

        let footerNotification = FooterView(frame: CGRect(x: 0, y: 0, width: footer.frame.size.width/3, height: 50))
        footerNotification.footerText.text = "Notifications"
        footerNotification.footerText.textColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        footerNotification.footerImage.image = UIImage(named: "notification_icon")
        footerNotification.footerImage.tintColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        footerNotification.center = CGPoint(x: (footer.frame.size.width/8) * 7, y: footer.frame.size.height/4+5)
        footerDown.addSubview(footerNotification)

        let footerUp = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width/2, height: 45))
        footerUp.center = CGPoint(x: self.frame.size.width/2, y: -10)
        footerUp.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 255/255) // #232d4a
        footerUp.layer.borderWidth = 1
        footerUp.layer.borderColor = UIColor(red: 57/255, green: 66/255, blue: 106/255, alpha: 255/255).cgColor // #39426a
        footerUp.layer.cornerRadius = footerUp.frame.self.width / 10
        footer.addSubview(footerUp)

        let drawPartition = drawFooterLine(frame: CGRect(x: self.frame.size.width/4, y: 0, width: 20, height: 45))
        drawPartition.backgroundColor = UIColor.clear
        footerUp.addSubview(drawPartition)

        let footerTravel = FooterView(frame: CGRect(x: 0, y: 0, width: footer.frame.size.width/2, height: 50))
        footerTravel.footerText.text = "Travel Life"
        footerTravel.footerImage.image = UIImage(named: "travel_life_icon")
        footerTravel.footerImage.frame.size.width = 50.0
        footerTravel.center = CGPoint(x: footerUp.frame.size.width/4, y: footerUp.frame.size.height/4+5)
        footerUp.addSubview(footerTravel)

        let footerLocal = FooterView(frame: CGRect(x: 0, y: 0, width: footer.frame.size.width/2, height: 50))
        footerLocal.footerText.text = "Local Life"
        footerLocal.footerImage.image = UIImage(named: "local_life_icon")
        //footerLocal.footerImage.sizeThatFits(CGSize(width: 10, height: 10))
        //footerLocal.clipsToBounds = true
        footerLocal.autoresizesSubviews = true
        footerLocal.center = CGPoint(x: (footerUp.frame.size.width/4) * 3, y: footerUp.frame.size.height/4+5)
        footerUp.addSubview(footerLocal)
        
        self.addSubview(footer)
        
        
        
        
    }
    
    func feedTap (_ sender: UITapGestureRecognizer? = nil) {
        
//        self.changeViewController("Feed")
        
        print("feed tapped")
        
    }
//
//    func notifyTap (sender: UITapGestureRecognizer? = nil) {
//        
//        self.changeViewController("Notify")
//        
//    }
//    
//    func localLifeTap (sender: UITapGestureRecognizer? = nil) {
//        
//        self.changeViewController("LocalLife")
//        
//    }
//    
//    func travelLifeTap (sender: UITapGestureRecognizer? = nil) {
//        
//        self.changeViewController("TravelLife")
//        
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
