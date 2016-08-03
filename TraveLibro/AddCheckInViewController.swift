//
//  AddCheckInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import MediaPlayer
import MobileCoreServices
import BSImagePicker
import Photos

class AddCheckInViewController: UIViewController, UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var whichView = "LL"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if whichView == "TL" {
            
            getBackGround(self)
        }
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(self.previewCheckIn(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        let checkInBox = AddCheckIn(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: 300))
        self.view.addSubview(checkInBox)
        
        checkInBox.cameraButton.addTarget(self, action: #selector(AddCheckInViewController.cameraTapped(_:)), forControlEvents: .TouchUpInside)
        checkInBox.addFriendButton.addTarget(self, action: #selector(AddCheckInViewController.addFriendTapped(_:)), forControlEvents: .TouchUpInside)
        checkInBox.videoButton.addTarget(self, action: #selector(AddCheckInViewController.videoTapped(_:)), forControlEvents: .TouchUpInside)
        
        if whichView == "TL" {
            
            checkInBox.locationButton.setBackgroundImage(UIImage(named: "orangeBox"), forState: .Normal)
            
        }
        
    }
    
    func previewCheckIn(sender: UIButton) {
        
        let localLifeVC = storyboard?.instantiateViewControllerWithIdentifier("localLifePosts") as! LocalLifePostsViewController
        self.navigationController?.pushViewController(localLifeVC, animated: true)
        
    }
    
    func cameraTapped(sender: AnyObject) {
        
        print("Camera tapped")
        
        let multipleImage = BSImagePickerViewController()
        multipleImage.maxNumberOfSelections = 200
        
        bs_presentImagePickerController(multipleImage, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            print("Selected: \(asset)")
            }, deselect: { (asset: PHAsset) -> Void in
                print("Deselected: \(asset)")
            }, cancel: { (assets: [PHAsset]) -> Void in
                print("Cancel: \(assets)")
            }, finish: { (assets: [PHAsset]) -> Void in
                print("Finish: \(assets)")
            }, completion: nil)
        
//        self.presentViewController(multipleImage, animated: true, completion: nil)
        
    }
    
    func addFriendTapped(sender: AnyObject) {
        
        print("Add friend tapped")
        let addBuddies = storyboard?.instantiateViewControllerWithIdentifier("addBuddies") as! AddBuddiesViewController
        addBuddies.whichView = self.whichView
        self.navigationController?.pushViewController(addBuddies, animated: true)
        
    }
    
    func videoTapped(sender: AnyObject) {
        
        print("Video tapped")
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .PhotoLibrary
        self.imagePicker.mediaTypes = [kUTTypeMovie as String]
        self.presentViewController(self.imagePicker, animated: true, completion: nil)
        
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
