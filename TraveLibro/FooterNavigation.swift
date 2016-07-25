//
//  FooterNavigation.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func goToFeed (sender: UITapGestureRecognizer? = nil) {
        
        let feedVC = storyboard!.instantiateViewControllerWithIdentifier("Activity") as! ProfilePostsViewController
        navigationController?.pushViewController(feedVC, animated: true)
        
    }
    
    func gotoNotifications(sender: UITapGestureRecognizer) {
        
        let notifyVC = storyboard!.instantiateViewControllerWithIdentifier("notifications") as! NotificationsViewController
        navigationController?.pushViewController(notifyVC, animated: true)
        
    }
    
    func gotoLocalLife(sender: UITapGestureRecognizer) {
        
        let LLVC = storyboard!.instantiateViewControllerWithIdentifier("localLifePosts") as! LocalLifePostsViewController
        navigationController?.pushViewController(LLVC, animated: true)
        
    }
    
    func gotoTravelLife(sender: UITapGestureRecognizer) {
        
        let TLVC = storyboard!.instantiateViewControllerWithIdentifier("travelLife") as! OTGTimelineViewController
        navigationController?.pushViewController(TLVC, animated: true)
        
    }
    
}
