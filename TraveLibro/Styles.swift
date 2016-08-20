//
//  Styles.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


func addShadow(myView: UIView, offset: CGSize, opacity: CGFloat, shadowRadius: CGFloat, cornerRadius: CGFloat) {
    
    myView.layer.shadowOffset = CGSize(width: 2, height: 2)
    myView.layer.shadowOpacity = 0.2
    myView.layer.shadowRadius = 1
    myView.layer.cornerRadius = 3
    
}

func makeButtonGreyTranslucent(button: UIButton, textData: String) -> Void {
    
    button.backgroundColor = UIColor(red: 189/255, green: 193/255, blue: 211/255, alpha: 0.3)
    button.layer.borderColor = UIColor.whiteColor().CGColor
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 1.5
    //button.titleLabel?.text = "Hii Midhet"
    //button.titleLabel?.textColor = UIColor.whiteColor()
    button.setTitle(textData, forState: .Normal)
    button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 18)
    
}

func getBackGround(myVC: UIViewController) -> Void {
    
//    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "bg")
    bgImage.layer.zPosition = -1
    bgImage.userInteractionEnabled = false
    myVC.view.addSubview(bgImage)
    
}

func segueFromPagerStrip(vc: UINavigationController, nextVC: UIViewController) {
    
    print("inside global fn")
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let edVC = storyboard.instantiateViewControllerWithIdentifier("exploreDestinations") as! ExploreDestinationsViewController
    vc.pushViewController(nextVC, animated: true)
    
}


func getDarkBackGround(myVC: UIViewController) -> Void {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "darkBgNew")
    bgImage.layer.zPosition = -1
    bgImage.userInteractionEnabled = false
    myVC.view.addSubview(bgImage)
    
//    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
    
}

func getDarkBackGroundBlur(myVC: UIViewController) -> Void {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "darkBg")
    bgImage.layer.zPosition = -1
    bgImage.userInteractionEnabled = false
    
    myVC.view.addSubview(bgImage)
    
    //    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
    
}

func getDarkBackGroundBlue(myVC: UIViewController) {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "blueopacitybg")
    bgImage.layer.zPosition = -1
    bgImage.userInteractionEnabled = false
    
    myVC.view.addSubview(bgImage)
    
    //    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
    
}

class LeftPaddedLabel:  UILabel {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, padding))
    }
    // Override -intrinsicContentSize: for Auto layout code
    override func intrinsicContentSize() -> CGSize {
        let superContentSize = super.intrinsicContentSize()
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    // Override -sizeThatFits: for Springs & Struts code
    override func sizeThatFits(size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
}

public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        
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
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}

//LoadingOverlay.shared.showOverlay(self.view)
////To to long tasks
//LoadingOverlay.shared.hideOverlayView()
