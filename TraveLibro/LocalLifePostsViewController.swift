//
//  LocalLifePostsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 30/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LocalLifePostsViewController: UIViewController {
    
    var blackBg: UIView!
    var checkInPost: CheckInLocalLife!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        
        let selfScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        selfScrollView.contentSize.height = 1000
        self.view.addSubview(selfScrollView)
        
        checkInPost = CheckInLocalLife(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 800))
        checkInPost.layer.cornerRadius = 5.0
        checkInPost.clipsToBounds = true
        selfScrollView.addSubview(checkInPost)
        
        checkInPost.rateButton.addTarget(self, action: #selector(LocalLifePostsViewController.rateButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        
        checkInPost.optionsButton.addTarget(self, action: #selector(LocalLifePostsViewController.addOption(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    func rateButtonTapped(sender: AnyObject) {
        
        blackBg = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        blackBg.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.view.addSubview(blackBg)
        
        let closeButton = UIButton(frame: CGRect(x: 8, y: 20, width: 20, height: 20))
        let close = String(format: "%C", faicon["close"]!)
        
        closeButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
        closeButton.setTitle(close, forState: .Normal)
        closeButton.addTarget(self, action: #selector(LocalLifePostsViewController.exitDialog(_:)), forControlEvents: .TouchUpInside)
        blackBg.addSubview(closeButton)
        
        let ratingDialog = AddRating(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 400))
        ratingDialog.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        
        ratingDialog.closeReview.addTarget(self, action: #selector(LocalLifePostsViewController.closeDialog(_:)), forControlEvents: .TouchUpInside)
        blackBg.addSubview(ratingDialog)
        
    }
    
    func closeDialog(sender: AnyObject) {
        
        blackBg.hidden = true
        checkInPost.rateButton.hidden = true
        checkInPost.ratingLabel.hidden = false
        checkInPost.ratingStack.hidden = false
        
    }
    
    func exitDialog(sender: AnyObject) {
        
        blackBg.hidden = true
        checkInPost.rateButton.hidden = true
        checkInPost.ratingLabel.hidden = false
        checkInPost.ratingStack.hidden = false
        
    }
    
    func addOption(sender: AnyObject) {
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
            
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let editCheckInActionButton: UIAlertAction = UIAlertAction(title: "Edit Check In", style: .Default)
        { action -> Void in
            
            
        }
        actionSheetControllerIOS8.addAction(editCheckInActionButton)
        
        let changeDateActionButton: UIAlertAction = UIAlertAction(title: "Change Date & Time", style: .Default)
        { action -> Void in
            
            
        }
        actionSheetControllerIOS8.addAction(changeDateActionButton)
        let changeDateActionButton: UIAlertAction = UIAlertAction(title: "Delete", style: .Default)
        { action -> Void in
            
            
        }
        actionSheetControllerIOS8.addAction(changeDateActionButton)
        let changeDateActionButton: UIAlertAction = UIAlertAction(title: "Copy Share URL", style: .Default)
        { action -> Void in
            
            
        }
        actionSheetControllerIOS8.addAction(changeDateActionButton)
        self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
