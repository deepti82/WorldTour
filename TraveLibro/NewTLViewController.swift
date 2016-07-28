//
//  NewTLViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 26/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import EventKitUI

class NewTLViewController: UIViewController, UITextFieldDelegate {
    
    var height: CGFloat!
    var otgView: startOTGView!
    var showDetails = false
    var mainScroll: UIScrollView!
    var infoView: TripInfoOTG!
    
    @IBOutlet weak var addPostsButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
    @IBAction func infoCircle(sender: AnyObject) {
        
        infoView = TripInfoOTG(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
        infoView.summaryButton.addTarget(self, action: #selector(NewTLViewController.gotoSummaries(_:)), forControlEvents: .TouchUpInside)
        infoView.photosButton.addTarget(self, action: #selector(NewTLViewController.gotoPhotos(_:)), forControlEvents: .TouchUpInside)
        infoView.reviewsButton.addTarget(self, action: #selector(NewTLViewController.gotoReviews(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(infoView)
        infoView.animation.makeOpacity(1.0).animate(0.5)
        
    }
    
    @IBAction func addPosts(sender: AnyObject) {
        
        infoView = TripInfoOTG(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
        infoView.summaryButton.addTarget(self, action: #selector(NewTLViewController.gotoSummaries(_:)), forControlEvents: .TouchUpInside)
        infoView.photosButton.addTarget(self, action: #selector(NewTLViewController.gotoPhotos(_:)), forControlEvents: .TouchUpInside)
        infoView.reviewsButton.addTarget(self, action: #selector(NewTLViewController.gotoReviews(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(infoView)
        infoView.animation.makeOpacity(1.0).animate(0.5)
        
        
    }
    
    func closeInfo() {
        
        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.hidden = true
        
    }
    
    func gotoSummaries(sender: UIButton) {
        
        let summaryVC = storyboard?.instantiateViewControllerWithIdentifier("summaryTLVC") as! CollectionViewController
        self.navigationController?.pushViewController(summaryVC, animated: true)
        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.hidden = true
        
        
    }
    
    func gotoPhotos(sender: UIButton) {
        
        let photoVC = storyboard?.instantiateViewControllerWithIdentifier("photoGrid") as! TripSummaryPhotosViewController
        self.navigationController?.pushViewController(photoVC, animated: true)
        photoVC.whichView = "photo"
        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.hidden = true
        
    }
    
    func gotoReviews (sender: UIButton) {
        
        let ratingVC = storyboard?.instantiateViewControllerWithIdentifier("ratingTripSummary") as! AddYourRatingViewController
        self.navigationController?.pushViewController(ratingVC, animated: true)
        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.hidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)
        height = self.view.frame.height/2
        
        mainScroll = UIScrollView(frame: CGRect(x: 0, y: self.view.frame.height - height, width: self.view.frame.width, height: self.view.frame.height))
//        mainScroll.backgroundColor = UIColor.whiteColor()
        
        otgView = startOTGView(frame: CGRect(x: 0, y: 0, width: mainScroll.frame.width, height: 600))
        otgView.startJourneyButton.addTarget(self, action: #selector(NewTLViewController.startOTGJourney(_:)), forControlEvents: .TouchUpInside)
        otgView.selectCategoryButton.addTarget(self, action: #selector(NewTLViewController.journeyCategory(_:)), forControlEvents: .TouchUpInside)
        otgView.addBuddiesButton.addTarget(self, action: #selector(NewTLViewController.addBuddies(_:)), forControlEvents: .TouchUpInside)
        otgView.detectLocationButton.addTarget(self, action: #selector(NewTLViewController.detectLocation(_:)), forControlEvents: .TouchUpInside)
        
        if !showDetails {
            
            self.view.addSubview(mainScroll)
            mainScroll.addSubview(otgView)
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewTLViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewTLViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        otgView.nameJourneyTF.returnKeyType = .Done
        otgView.nameJourneyTF.delegate = self
        
        otgView.clipsToBounds = true
        mainScroll.clipsToBounds = true
        
        infoButton.hidden = true
        addPostsButton.hidden = true
        
        self.view.bringSubviewToFront(infoButton)
        self.view.bringSubviewToFront(addPostsButton)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        otgView.nameJourneyTF.resignFirstResponder()
//        otgView.nameJourneyTF.hidden = true
        otgView.nameJourneyView.hidden = true
        otgView.journeyName.hidden = false
        otgView.journeyName.text = otgView.nameJourneyTF.text
        height = 100.0
        mainScroll.animation.thenAfter(0.5).makeY(mainScroll.frame.origin.y - height).animate(0.5)
//        otgView.animation.makeY(mainScroll.frame.origin.y - height).animate(0.5)
        otgView.detectLocationView.layer.opacity = 0.0
        otgView.detectLocationView.hidden = false
        otgView.detectLocationView.animation.thenAfter(0.5).makeOpacity(1.0).animate(0.5)
        return true
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startOTGJourney(sender: UIButton) {
        
        sender.animation.makeHeight(0.0).animate(0.3)
        sender.hidden = true
        otgView.nameJourneyView.layer.opacity = 0.0
        otgView.nameJourneyView.hidden = false
        otgView.nameJourneyView.animation.makeOpacity(1.0).makeHeight(otgView.nameJourneyView.frame.height).animate(0.5)
        otgView.bonVoyageLabel.animation.makeScale(2.0).makeOpacity(0.0).animate(0.5)
        
    }

    func journeyCategory(sender: UIButton) {
        
        print("inside journey category button")
        let categoryVC = storyboard?.instantiateViewControllerWithIdentifier("kindOfJourneyVC") as! KindOfJourneyOTGViewController
        self.navigationController?.pushViewController(categoryVC, animated: true)
        showDetailsFn()
        
    }
    
    func showDetailsFn() {
        
            otgView.selectCategoryButton.hidden = true
            otgView.journeyDetails.hidden = false
            otgView.buddyStack.hidden = true
//            otgView.buddyStack.userInteractionEnabled = false
            otgView.addBuddiesButton.hidden = false
        
    }
    
    func addBuddies(sender: UIButton) {
        
        let addBuddies = storyboard?.instantiateViewControllerWithIdentifier("kindOfJourneyVC") as! KindOfJourneyOTGViewController
        self.navigationController?.pushViewController(addBuddies, animated: true)
        showBuddies()
//        mainScroll.layer.zPosition = -1
        infoButton.hidden = false
        addPostsButton.hidden = false
        
    }
    
    
    
    func showBuddies() {
        
        otgView.buddyStack.hidden = false
        otgView.addBuddiesButton.hidden = true
        
    }
    
    func detectLocation(sender: UIButton) {
        
        otgView.detectLocationView.animation.makeOpacity(0.0).animate(0.5)
        otgView.detectLocationView.hidden = true
        otgView.cityView.layer.opacity = 0.0
        otgView.cityView.hidden = false
        otgView.cityView.animation.makeOpacity(1.0).animate(0.5)
        otgView.journeyDetails.hidden = true
        otgView.selectCategoryButton.hidden = false
        height = 250.0
        mainScroll.animation.makeY(10.0).animate(0.7)
        otgView.animation.makeY(0.0).animate(0.7)
        
    }

}
