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
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(self.previewCheckIn(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        let checkInBox = AddCheckIn(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: 300))
        self.view.addSubview(checkInBox)
        
        checkInBox.cameraButton.addTarget(self, action: #selector(AddCheckInViewController.cameraTapped(_:)), for: .touchUpInside)
        checkInBox.addFriendButton.addTarget(self, action: #selector(AddCheckInViewController.addFriendTapped(_:)), for: .touchUpInside)
        checkInBox.videoButton.addTarget(self, action: #selector(AddCheckInViewController.videoTapped(_:)), for: .touchUpInside)
        
        if whichView == "TL" {
            
            checkInBox.locationButton.setBackgroundImage(UIImage(named: "orangebox_shadow"), for: UIControlState())
            
        }
        
    }
    
    func previewCheckIn(_ sender: UIButton) {
        let localLifeVC = storyboard?.instantiateViewController(withIdentifier: "localLifePosts") as! LocalLifePostsViewController
        self.navigationController?.pushViewController(localLifeVC, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setAnalytics(name: "Check In")

    }
    
    func cameraTapped(_ sender: AnyObject) {
        
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
    
    func addFriendTapped(_ sender: AnyObject) {
        
        print("Add friend tapped")
        let addBuddies = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
        addBuddies.whichView = self.whichView
        self.navigationController?.pushViewController(addBuddies, animated: true)
        
    }
    
    func videoTapped(_ sender: AnyObject) {
        
        print("Video tapped")
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = [kUTTypeMovie as String]
        self.present(self.imagePicker, animated: true, completion: nil)
        
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
