//
//  SetProfilePictureViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SetProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var uploadView: AddDisplayPic!
    var tempImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(SetProfilePictureViewController.choosePreferences(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        uploadView = AddDisplayPic(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300))
        uploadView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3)
        self.view.addSubview(uploadView)
        
        uploadView.addButton.addTarget(self, action: #selector(SetProfilePictureViewController.chooseDisplayPic(_:)), forControlEvents: .TouchUpInside)
        
        imagePicker.delegate = self
        
    }
    
    func choosePreferences(sender: AnyObject) {
        
        let pagerVC = storyboard?.instantiateViewControllerWithIdentifier("DisplayCards") as! DisplayCardsViewController
        self.navigationController?.pushViewController(pagerVC, animated: true)
        
    }
    
    func chooseDisplayPic(sender: AnyObject) {
        
        let chooseSource: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
            
        }
        chooseSource.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .Default)
        { action -> Void in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .Camera
            self.presentViewController(self.imagePicker, animated: true, completion: {
                
                print("photo taken")
            })
            
        }
        chooseSource.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default)
        { action -> Void in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .PhotoLibrary
            self.presentViewController(self.imagePicker, animated: true, completion: {
                
                print("photo chosen")
                
            })
            
            
        }
        chooseSource.addAction(deleteActionButton)
        self.presentViewController(chooseSource, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        print(info)
        
        //var tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        tempImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        uploadView.addButton.setImage(tempImage, forState: .Normal)
        
        self.dismissViewControllerAnimated(true, completion:nil)
        
        let imageUrl = info[UIImagePickerControllerReferenceURL] as! NSURL
        print("image url: \(imageUrl)")
        
        request.uploadPhotos(imageUrl, completion: {(response) in

            print("response arrived!")

        })
        
//        PHImageManager.defaultManager().requestImageDataForAsset(tempImage, options: nil) {
//            imageData,dataUTI,orientation,info in
//            let imageURL = info!["PHImageFileURLKey"] as! NSURL
//            print("imageURL: \(imageURL)")
//            
//            request.uploadPhotos(imageURL, completion: {(response) in
//                
//                print("response arrived!")
//                
//            })
//            
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
