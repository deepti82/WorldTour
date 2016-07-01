//
//  FooterNavigation.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func changeViewController(view: String) {
        
        switch view {
        case "Feed":
            let feedVC = storyboard!.instantiateViewControllerWithIdentifier("Activity") as! ProfilePostsViewController
            navigationController?.showViewController(feedVC, sender: nil)
            
        case "Notify":
//            let notifyVC = storyboard!.instantiateViewControllerWithIdentifier("Activity") as! ProfilePostsViewController
//            navigationController?.showViewController(feedVC, sender: nil)
            break
        case "LocalLife":
//            let feedVC = storyboard!.instantiateViewControllerWithIdentifier("Activity") as! ProfilePostsViewController
//            navigationController?.showViewController(feedVC, sender: nil)
            break
        case "TravelLife":
//            let feedVC = storyboard!.instantiateViewControllerWithIdentifier("Activity") as! ProfilePostsViewController
//            navigationController?.showViewController(feedVC, sender: nil)
            break
        default:
            break
        }
        
        
    }
    
}
