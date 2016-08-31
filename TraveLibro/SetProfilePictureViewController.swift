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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetProfilePictureViewController.chooseDisplayPic(_:)))
//        tap.delegate = self
        uploadView.addButtonPic.addGestureRecognizer(tap)
        
//        uploadView.addButton.addTarget(self, action: #selector(SetProfilePictureViewController.chooseDisplayPic(_:)), forControlEvents: .TouchUpInside)
        
        imagePicker.delegate = self
        
//        let url =
        let isUrl = verifyUrl(currentUser["profilePicture"].string!)
        
        if isUrl {
            
            let data = NSData(contentsOfURL: NSURL(string: currentUser["profilePicture"].string!)!)
            
            if data != nil {
                
//                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                uploadView.addButtonPic.image = UIImage(data:data!)
                makeTLProfilePicture(uploadView.addButtonPic)
                
            }
        }
        
        else {
            
            var imageName = ""
            
            if currentUser["profilePicture"] != nil {
                
                imageName = currentUser["profilePicture"].string!
                
            }
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + imageName + "&width=100"
            
            
            let data = NSData(contentsOfURL: NSURL(string: getImageUrl)!)
            
            if data != nil {
                
//                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                uploadView.addButtonPic.image = UIImage(data:data!)
                makeTLProfilePicture(uploadView.addButtonPic)
                
            }
            
//            request.getImageBytes(imageName, completion: {(response) in
//                
//                if response.error != nil {
//                    
//                    print("error: \(response.error?.localizedDescription)")
//                    
//                }
//                
//                else if response["value"] {
//                    
////                    print("")
////                    uploadView.addButton.setImage(UIImage(data: response), forState: .Normal)
//                    
//                }
//                
//                else {
//                    
//                    print("response error: \(response["data"])")
//                    
//                }
//                
//                
//            })
            
        }
        
        uploadView.username.text = "\(currentUser["firstName"]) \(currentUser["lastName"])"
        
    }
    
    func choosePreferences(sender: AnyObject) {
        
        let pagerVC = storyboard?.instantiateViewControllerWithIdentifier("DisplayCards") as! DisplayCardsViewController
        self.navigationController?.pushViewController(pagerVC, animated: true)
        
    }
    
    func chooseDisplayPic(sender: UITapGestureRecognizer? = nil) {
        
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
        
//        print(info[UIImagePickerControllerReferenceURL])
        
        //var tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        tempImage = info[UIImagePickerControllerEditedImage] as! UIImage
//        let imageData: NSData = UIImageJPEGRepresentation(tempImage, 1.0)!
        uploadView.addButtonPic.image = tempImage
        
        self.dismissViewControllerAnimated(true, completion:nil)
        
//        let imageUrl = info[UIImagePickerControllerReferenceURL] as! NSURL
//        print("image url: \(imageUrl)")
        
//        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
//        let imageName = NSURL(string: imageURL.path!)!.lastPathComponent
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
//        let localPath = paths.stringByAppendingString(imageName!)
//        
//        print("local path: \(localPath)")
        
        print("temp image: \(tempImage)")
        
//        let imagename = "profile.jpg";
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as String
//        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
//        var imageName = NSURL(string: imageURL.path!)!.lastPathComponent
//        imageName = imageName?.lowercaseString
//        print("image path : \(imageName)")
//        let destinationPath = "file:///"  + String(documentsPath) + "/" + imageName!
        
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentsDirectory = paths[0]
        
        let exportFilePath = "file://" + NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/image.jpg")
        
//        let fileManager = NSFileManager.defaultManager()
//        let pathToSave = "file:///"  + documentsPath + "/\(imagename)"

//        fileManager.createFileAtPath(pathToSave, contents: NSData(), attributes: nil)
//        print("file created")
        
//        let filemanager = NSFileManager.defaultManager()

        do {
            
//            try filemanager.removeItemAtPath("asset.jpg")
            
//            try filemanager.createFileAtPath("image.jpg", contents: NSData(), attributes: nil)
            
            try UIImageJPEGRepresentation(tempImage,1.0)!.writeToURL(NSURL(string: exportFilePath)!, atomically: false)
            print("file created")
            
            
        } catch let error as NSError {
            
            print("error creating file: \(error.localizedDescription)")
            
        }
        
        print("local path: \(exportFilePath)")
        
        request.uploadPhotos(NSURL(string: exportFilePath)!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                }
                else {
                    
                    if response["value"] {
                        
                        request.editUser(currentUser["_id"].string!, editField: "profilePicture", editFieldValue: response["data"][0].string!, completion: { _ in
                            
                            print("response arrived!")
                            
                        })
                    }
                }
            })
            
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
