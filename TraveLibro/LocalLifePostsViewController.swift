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
    var datePickerView:UIDatePicker = UIDatePicker()
    var changeDateTimeActionSheet: UIAlertController!
    
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
        
        ratingDialog.postReview.addTarget(self, action: #selector(LocalLifePostsViewController.closeDialog(_:)), forControlEvents: .TouchUpInside)
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
            
            let editCheckInVC = self.storyboard?.instantiateViewControllerWithIdentifier("addCheckIn") as! AddCheckInViewController
            self.navigationController?.pushViewController(editCheckInVC, animated: true)
            
        }
        actionSheetControllerIOS8.addAction(editCheckInActionButton)
        
        let changeDateActionButton: UIAlertAction = UIAlertAction(title: "Change Date & Time", style: .Default)
        { action -> Void in
            
            self.changeDateTimeActionSheet = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .ActionSheet)
            self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 35, width: self.changeDateTimeActionSheet.view.frame.width, height: 200))
            self.datePickerView.datePickerMode = .DateAndTime
//            self.datePickerView.backgroundColor = UIColor.redColor()
            
            let viewDatePicker: UIView = UIView(frame: CGRectMake(0, 0, self.changeDateTimeActionSheet.view.frame.width, 300))
            viewDatePicker.addSubview(self.datePickerView)
            
            let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: self.changeDateTimeActionSheet.view.frame.width, height: 100))
            viewDatePicker.addSubview(buttonView)
            
            let saveButton = UIButton(frame: CGRect(x: self.view.frame.width - 100, y: 10, width: 80, height: 40))
            saveButton.titleLabel?.font = avenirFont
            saveButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            saveButton.setTitle("Save", forState: .Normal)
            saveButton.addTarget(self, action: #selector(LocalLifePostsViewController.saveDateChange(_:)), forControlEvents: .TouchUpInside)
//            saveButton.backgroundColor = UIColor.brownColor()
            buttonView.addSubview(saveButton)

            let cancelButton = UIButton(frame: CGRect(x: 10, y: 10, width: 80, height: 40))
            cancelButton.titleLabel?.font = avenirFont
            cancelButton.setTitle("Cancel", forState: .Normal)
            cancelButton.addTarget(self, action: #selector(LocalLifePostsViewController.cancelDateChange(_:)), forControlEvents: .TouchUpInside)
            cancelButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            buttonView.addSubview(cancelButton)
            
//            viewDatePicker.backgroundColor = UIColor.blueColor()
            viewDatePicker.clipsToBounds = true
            self.changeDateTimeActionSheet.view.addSubview(viewDatePicker)
            
            self.presentViewController(self.changeDateTimeActionSheet, animated: true, completion: nil)
            

            
        }
        actionSheetControllerIOS8.addAction(changeDateActionButton)
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Delete", style: .Default)
        { action -> Void in
            
            let actionSheetForDelete: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                
                
            }
            actionSheetForDelete.addAction(cancelActionButton)
            
            let deletePostActionButton: UIAlertAction = UIAlertAction(title: "Delete Post", style: .Destructive) { action -> Void in
                
                
            }
            actionSheetForDelete.addAction(deletePostActionButton)
            self.presentViewController(actionSheetForDelete, animated: true, completion: nil)
            
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        let copyURLActionButton: UIAlertAction = UIAlertAction(title: "Copy Share URL", style: .Default)
        { action -> Void in
            
            
        }
        actionSheetControllerIOS8.addAction(copyURLActionButton)
        self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)
        
        
        
        
    }
    
    func cancelDateChange(sender: AnyObject) {
        
        print("In Cancel Date function")
        self.changeDateTimeActionSheet.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func saveDateChange(sender: AnyObject) {
        
        print("In save Date function")
        self.changeDateTimeActionSheet.dismissViewControllerAnimated(true, completion: nil)
        
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
