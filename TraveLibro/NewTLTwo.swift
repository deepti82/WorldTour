//
//  NewTLTwo.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/30/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import UIKit
import EventKitUI
import SwiftyJSON
import BSImagePicker
import Photos
import CoreLocation
import ActiveLabel

extension NewTLViewController {
    
    func editPost(id: String) {
        
        for view in layout.subviews {
            
            if view.isKindOfClass(PhotosOTG) {
                
                let subview = view as! PhotosOTG
                
                if id == subview.optionsButton.titleLabel!.text! {
                    
                    print("inside removing subviews")
                    removeHeightFromLayout(subview.frame.height)
                    subview.removeFromSuperview()
                    
                }
                
            }
            
        }
        
        
    }
    
    func deleteFromLayout(id: String) {
        
        for view in layout.subviews {
            
            if view.isKindOfClass(PhotosOTG) {
                
                let subview = view as! PhotosOTG
                
                if  subview.optionsButton.titleLabel!.text! == id {
                    
                    print("inside delete subview")
                    removeHeightFromLayout(subview.frame.height)
                    subview.removeFromSuperview()
                    
                }
                
                
            }
            
            
        }
        
        
    }
    
    func buddyLeaves(post: JSON) {
        
        let buddyView = BuddyLeaves(frame: CGRect(x: 0, y: 10, width: 300, height: 215))
//        buddyView.profileName.text = post[]
        layout.addSubview(buddyView)
        addHeightToLayout(buddyView.frame.height)
        
    }
    
}

