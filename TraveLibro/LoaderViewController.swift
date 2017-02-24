//
//  LoaderViewController.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 23/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//


//import UIKit
//
//
//class LoaderViewController: UIViewController {
//    
//    
//    
//}
//
//
//public class LoadingOverlay{
//    
//    var overlayView = UIView()
//    var activityIndicator = UIActivityIndicatorView()
//    var blurView: UIVisualEffectView!
//    
////    class var shared: LoadingOverlay {
////        struct Static {
////            static let instance: LoadingOverlay = LoadingOverlay()
////            
////        }
////        return Static.instance
////    }
//    
//    public func showOverlay(view: UIView) {
//        
//        overlayView.frame = CGRectMake(0, 0, 80, 80)
//        overlayView.center = view.center
//        overlayView.backgroundColor = UIColor(red: 244/255, green: 121/255, blue: 32/255, alpha: 0.7)
//        overlayView.clipsToBounds = true
//        overlayView.layer.cornerRadius = 10
//        
//        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//        blurView = UIVisualEffectView(effect: darkBlur)
//        blurView.frame.size.height = view.frame.height
//        blurView.frame.size.width = view.frame.width
//        blurView.userInteractionEnabled = false
//        blurView.addSubview(overlayView)
//        
//        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
//        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
//        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
//        
//        overlayView.addSubview(activityIndicator)
//        view.addSubview(blurView)
//        
//        activityIndicator.startAnimating()
//    }
//    
//    public func hideOverlayView() {
//        activityIndicator.stopAnimating()
//        blurView.removeFromSuperview()
//    }
//}
