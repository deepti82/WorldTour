//
//  FooterNavigation.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func goToFeed (_ sender: UITapGestureRecognizer? = nil) {
        
        let feedVC = storyboard!.instantiateViewController(withIdentifier: "Activity") as! ProfilePostsViewController
        navigationController?.pushViewController(feedVC, animated: true)
        
    }
    
    func gotoNotifications(_ sender: UITapGestureRecognizer) {
        
        let notifyVC = storyboard!.instantiateViewController(withIdentifier: "notifications") as! NotificationsViewController
        navigationController?.pushViewController(notifyVC, animated: true)
        
    }
    
    func gotoLocalLife(_ sender: UITapGestureRecognizer) {
        
        let LLVC = storyboard!.instantiateViewController(withIdentifier: "localLifePosts") as! LocalLifePostsViewController
        navigationController?.pushViewController(LLVC, animated: true)
        
    }
    
    func gotoTravelLife(_ sender: UITapGestureRecognizer) {
        
        let TLVC = storyboard!.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
        navigationController?.pushViewController(TLVC, animated: true)
        
        
    }
    
}
