//
//  SetProfilePictureViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 25/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SetProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    let imagePicker = UIImagePickerController()
    var uploadView: AddDisplayPic!
    var tempImage: UIImage!
    
    var kindOfJourney: [String] = []
    var youUsuallyGo: String = ""
    var preferToTravel: [String] = []
    var yourIdeal: [String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(SetProfilePictureViewController.choosePreferences(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        uploadView = AddDisplayPic(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 300))
        uploadView.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/3)
        self.view.addSubview(uploadView)
        
        uploadView.usernameTextField.returnKeyType = .done
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SetProfilePictureViewController.chooseDisplayPic(_:)))
//        tap.delegate = self
        uploadView.addButtonPic.addGestureRecognizer(tap)
        
//        uploadView.addButton.addTarget(self, action: #selector(SetProfilePictureViewController.chooseDisplayPic(_:)), forControlEvents: .TouchUpInside)
        
        imagePicker.delegate = self
        
//        let url =
        let isUrl = verifyUrl(currentUser["profilePicture"].string!)
        
        if isUrl {
            
            let data = try? Data(contentsOf: URL(string: currentUser["profilePicture"].string!)!)
            
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
            
            
            let data = try? Data(contentsOf: URL(string: getImageUrl)!)
            
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
//                else if response["value"].bool! {
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
        
        uploadView.usernameTextField.delegate = self
        let textTap = UITapGestureRecognizer(target: self, action: #selector(SetProfilePictureViewController.changeLabelText(_:)))
        uploadView.addGestureRecognizer(textTap)
        
    }
    
    func changeLabelText(_ sender: UIGestureRecognizer) {
        
        uploadView.usernameTextField.text = uploadView.username.text
        uploadView.username.isHidden = true
        uploadView.usernameTextField.isHidden = false
        uploadView.usernameTextField.becomeFirstResponder()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        uploadView.usernameTextField.text = ""
        
    }
    
//    func textFieldDidEndEditing(textField: UITextField) {
//        
//        uploadView.usernameTextField.resignFirstResponder()
//        uploadView.username.text = uploadView.usernameTextField.text
//        uploadView.usernameTextField.hidden = false
//        uploadView.username.hidden = true
//        
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        uploadView.usernameTextField.resignFirstResponder()
        
        if uploadView.usernameTextField.text != "" {
            
            uploadView.username.text = uploadView.usernameTextField.text
        }
        
        uploadView.usernameTextField.isHidden = false
        uploadView.username.isHidden = true
        return true
        
    }
    
    
    func choosePreferences(_ sender: AnyObject) {
        
        let pagerVC = storyboard?.instantiateViewController(withIdentifier: "displayOne") as! DisplayPagesOneViewController
        self.navigationController?.pushViewController(pagerVC, animated: true)
        
    }
    
    func chooseDisplayPic(_ sender: UITapGestureRecognizer?) {
        
        let chooseSource: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
            
        }
        chooseSource.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default)
        { action -> Void in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: {
                
                print("photo taken")
            })
            
        }
        chooseSource.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default)
        { action -> Void in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: {
                
                print("photo chosen")
                
            })
            
            
        }
        chooseSource.addAction(deleteActionButton)
        self.present(chooseSource, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        print(info[UIImagePickerControllerReferenceURL])
        
        //var tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        tempImage = info[UIImagePickerControllerEditedImage] as! UIImage
//        let imageData: NSData = UIImageJPEGRepresentation(tempImage, 1.0)!
        uploadView.addButtonPic.image = tempImage
        makeTLProfilePicture(uploadView.addButtonPic)
        
        self.dismiss(animated: true, completion:nil)
        
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
        
        let exportFilePath = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/image.jpg"
        
//        let fileManager = NSFileManager.defaultManager()
//        let pathToSave = "file:///"  + documentsPath + "/\(imagename)"

//        fileManager.createFileAtPath(pathToSave, contents: NSData(), attributes: nil)
//        print("file created")
        
//        let filemanager = NSFileManager.defaultManager()

        do {
            
//            try filemanager.removeItemAtPath("asset.jpg")
            
//            try filemanager.createFileAtPath("image.jpg", contents: NSData(), attributes: nil)
            
            try UIImageJPEGRepresentation(tempImage,1.0)!.write(to: URL(string: exportFilePath)!, options: [])
            print("file created")
            
            
        } catch let error as NSError {
            
            print("error creating file: \(error.localizedDescription)")
            
        }
        
        print("local path: \(exportFilePath)")
        
        request.uploadPhotos(URL(string: exportFilePath)!, localDbId: nil, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                }
                else {
                    
                    if response["value"].bool! {
                        
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
