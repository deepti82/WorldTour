//
//  LoadingOverlay.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/24/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    public class LoadingOverlay {
        
        var overlayView = UIView()
        var activityIndicator = UIActivityIndicatorView()
        
//        class var shared: LoadingOverlay {
//            struct Static {
//                static let instance: LoadingOverlay = LoadingOverlay()
//            }
//            return Static.instance
//        }
        
        func showOverlay(view: UIView) {
            
            overlayView.frame = CGRectMake(0, 0, 80, 80)
            overlayView.center = view.center
            overlayView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
            overlayView.clipsToBounds = true
            overlayView.layer.cornerRadius = 10
            
            activityIndicator.frame = CGRectMake(0, 0, 40, 40)
            activityIndicator.activityIndicatorViewStyle = .WhiteLarge
            activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
            
            overlayView.addSubview(activityIndicator)
            view.addSubview(overlayView)
            
            activityIndicator.startAnimating()
        }
        
        func hideOverlayView() {
            activityIndicator.stopAnimating()
            overlayView.removeFromSuperview()
        }
        
    }
}