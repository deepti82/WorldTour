//
//  Styles.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


func addShadow(_ myView: UIView, offset: CGSize, opacity: CGFloat, shadowRadius: CGFloat, cornerRadius: CGFloat) {
    
    myView.layer.shadowOffset = CGSize(width: 2, height: 1)
    myView.layer.shadowOpacity = 0.2
    myView.layer.shadowRadius = 1
    myView.layer.cornerRadius = 3
    
}

func makeButtonGreyTranslucent(_ button: UIButton, textData: String) -> Void {
    
    button.backgroundColor = UIColor(red: 189/255, green: 193/255, blue: 211/255, alpha: 0.3)
    button.layer.borderColor = UIColor.white.cgColor
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 1.5
    //button.titleLabel?.text = "Hii Midhet"
    //button.titleLabel?.textColor = UIColor.whiteColor()
    button.setTitle(textData, for: UIControlState())
    button.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 18)
    
}

func getBackGround(_ myVC: UIViewController) -> Void {
    
//    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "bg")
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    myVC.view.addSubview(bgImage)
    
}

func segueFromPagerStrip(_ vc: UINavigationController, nextVC: UIViewController) {
    
    print("inside global fn")
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let edVC = storyboard.instantiateViewControllerWithIdentifier("exploreDestinations") as! ExploreDestinationsViewController
    vc.pushViewController(nextVC, animated: true)
    
}


func getDarkBackGround(_ myVC: UIViewController) -> Void {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "darkBgNew")
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    myVC.view.addSubview(bgImage)
    
//    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
    
}

func getDarkBackGroundBlur(_ myVC: UIViewController) -> Void {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "darkBg")
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    
    myVC.view.addSubview(bgImage)
    
    //    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
    
}

func getDarkBackGroundBlue(_ myVC: UIViewController) {
    
    let bgImage = UIImageView(frame: myVC.view.frame)
    bgImage.image = UIImage(named: "darkBgNew")
    bgImage.layer.zPosition = -1
    bgImage.isUserInteractionEnabled = false
    
    myVC.view.addSubview(bgImage)
    
    //    myVC.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
    
}

class LeftPaddedLabel:  UILabel {
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 10)
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    // Override -intrinsicContentSize: for Auto layout code
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    // Override -sizeThatFits: for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let heigth = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
}

open class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    open func showOverlay(_ view: UIView) {
        
        overlayView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    open func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}

func makeTLProfilePicture(_ image: UIImageView) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.layer.borderWidth = 3.0
    image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    
}
func makeTLProfilePicture(_ image: UIButton) {
    
    image.layer.cornerRadius = (37/100) * image.frame.width
    image.layer.borderWidth = 3.0
    image.layer.borderColor = UIColor.white.cgColor
    image.clipsToBounds = true
    
}

//LoadingOverlay.shared.showOverlay(self.view)
////To to long tasks
//LoadingOverlay.shared.hideOverlayView()
