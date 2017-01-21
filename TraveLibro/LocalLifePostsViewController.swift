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
        
        checkInPost.rateButton.addTarget(self, action: #selector(LocalLifePostsViewController.rateButtonTapped(_:)), for: .touchUpInside)
        
        
        checkInPost.optionsButton.addTarget(self, action: #selector(LocalLifePostsViewController.addOption(_:)), for: .touchUpInside)
        
    }
    
    func rateButtonTapped(_ sender: AnyObject) {
        
        blackBg = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        blackBg.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addSubview(blackBg)
        
        let closeButton = UIButton(frame: CGRect(x: 8, y: 20, width: 20, height: 20))
        let close = String(format: "%C", faicon["close"]!)
        
        closeButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
        closeButton.setTitle(close, for: UIControlState())
        closeButton.addTarget(self, action: #selector(LocalLifePostsViewController.exitDialog(_:)), for: .touchUpInside)
        blackBg.addSubview(closeButton)
        
        let ratingDialog = AddRating(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 400))
        ratingDialog.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        
        ratingDialog.postReview.addTarget(self, action: #selector(LocalLifePostsViewController.closeDialog(_:)), for: .touchUpInside)
        blackBg.addSubview(ratingDialog)
        
    }
    
    func closeDialog(_ sender: AnyObject) {
        
        blackBg.isHidden = true
        checkInPost.rateButton.isHidden = true
        checkInPost.ratingLabel.isHidden = false
        checkInPost.ratingStack.isHidden = false
        
    }
    
    func exitDialog(_ sender: AnyObject) {
        
        blackBg.isHidden = true
        checkInPost.rateButton.isHidden = true
        checkInPost.ratingLabel.isHidden = false
        checkInPost.ratingStack.isHidden = false
        
    }
    
    func addOption(_ sender: AnyObject) {
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
            
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let editCheckInActionButton: UIAlertAction = UIAlertAction(title: "Edit Check In", style: .default)
        { action -> Void in
            
            let editCheckInVC = self.storyboard?.instantiateViewController(withIdentifier: "addCheckIn") as! AddCheckInViewController
            self.navigationController?.pushViewController(editCheckInVC, animated: true)
            
        }
        actionSheetControllerIOS8.addAction(editCheckInActionButton)
        
        let changeDateActionButton: UIAlertAction = UIAlertAction(title: "Change Date & Time", style: .default)
        { action -> Void in
            
            self.changeDateTimeActionSheet = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .actionSheet)
            self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 35, width: self.changeDateTimeActionSheet.view.frame.width, height: 200))
            self.datePickerView.datePickerMode = .dateAndTime
//            self.datePickerView.backgroundColor = UIColor.redColor()
            
            let viewDatePicker: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.changeDateTimeActionSheet.view.frame.width, height: 300))
            viewDatePicker.addSubview(self.datePickerView)
            
            let buttonView = UIView(frame: CGRect(x: 0, y: 0, width: self.changeDateTimeActionSheet.view.frame.width, height: 100))
            viewDatePicker.addSubview(buttonView)
            
            let saveButton = UIButton(frame: CGRect(x: self.view.frame.width - 100, y: 10, width: 80, height: 40))
            saveButton.titleLabel?.font = avenirFont
            saveButton.setTitleColor(UIColor.blue, for: UIControlState())
            saveButton.setTitle("Save", for: UIControlState())
            saveButton.addTarget(self, action: #selector(LocalLifePostsViewController.saveDateChange(_:)), for: .touchUpInside)
//            saveButton.backgroundColor = UIColor.brownColor()
            buttonView.addSubview(saveButton)

            let cancelButton = UIButton(frame: CGRect(x: 10, y: 10, width: 80, height: 40))
            cancelButton.titleLabel?.font = avenirFont
            cancelButton.setTitle("Cancel", for: UIControlState())
            cancelButton.addTarget(self, action: #selector(LocalLifePostsViewController.cancelDateChange(_:)), for: .touchUpInside)
            cancelButton.setTitleColor(UIColor.blue, for: UIControlState())
            buttonView.addSubview(cancelButton)
            
//            viewDatePicker.backgroundColor = UIColor.blueColor()
            viewDatePicker.clipsToBounds = true
            self.changeDateTimeActionSheet.view.addSubview(viewDatePicker)
            
            self.present(self.changeDateTimeActionSheet, animated: true, completion: nil)
            

            
        }
        actionSheetControllerIOS8.addAction(changeDateActionButton)
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Delete", style: .default)
        { action -> Void in
            
            let actionSheetForDelete: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                
                
            }
            actionSheetForDelete.addAction(cancelActionButton)
            
            let deletePostActionButton: UIAlertAction = UIAlertAction(title: "Delete Post", style: .destructive) { action -> Void in
                
                
            }
            actionSheetForDelete.addAction(deletePostActionButton)
            self.present(actionSheetForDelete, animated: true, completion: nil)
            
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        let copyURLActionButton: UIAlertAction = UIAlertAction(title: "Copy Share URL", style: .default)
        { action -> Void in
            
            
        }
        actionSheetControllerIOS8.addAction(copyURLActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
        
        
        
    }
    
    func cancelDateChange(_ sender: AnyObject) {
        
        print("In Cancel Date function")
        self.changeDateTimeActionSheet.dismiss(animated: true, completion: nil)
        
        
    }
    
    func saveDateChange(_ sender: AnyObject) {
        
        print("In save Date function")
        self.changeDateTimeActionSheet.dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setTopNavigation(text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.gotoLocalLife(_:)), for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 10, y: 10, width: 30, height: 20)
        rightButton.setImage(UIImage(named: "nearMe"), for: UIControlState())
        rightButton.imageView?.contentMode = .scaleAspectFit
        rightButton.imageView?.clipsToBounds = true
        rightButton.addTarget(self, action: #selector(self.gotoNearMe(_:)), for: .touchUpInside)

        
        //        rightButton.setTitle("i", for: UIControlState())
        //        rightButton.layer.borderWidth = 1.5
        //        rightButton.layer.borderColor = UIColor.white.cgColor
        //        rightButton.layer.cornerRadius = rightButton.frame.width / 2
        self.title = text
        self.customNavigationBar(left: leftButton, right: rightButton)

        
    }
    
    func gotoProfile(_ sender:AnyObject) {
        
    }
    func gotoNearMe(_ sender:AnyObject) {
        
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
