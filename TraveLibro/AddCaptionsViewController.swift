//
//  AddCaptionsViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/5/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Photos
import SwiftyJSON

class AddCaptionsViewController: UIViewController, UITextViewDelegate {
    
    var imagesArray: [UIView] = []
    var currentImage = UIImage()
    var allImages: [UIButton] = []
    var currentSender = UIButton()
//    var currentId = ""
    var allIds: [String] = []
    var allPhotos: [JSON] = []
    
    @IBOutlet var completeImages: [UIImageView]!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageForCaption: UIImageView!
    @IBOutlet weak var bottomStack: UIStackView!
    
    var index: Int!
    
    @IBAction func previousImageCaption(sender: AnyObject) {
        
        index = index - 1
        
        if index >= 0 {
            
            addNewCaption()
            print("previous caption")
            let captionVC = self.storyboard!.instantiateViewControllerWithIdentifier("addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.currentImage = allImages[index!].currentImage!
            captionVC.allIds = allIds
            captionVC.currentSender = allImages[index!]
            captionVC.allPhotos = allPhotos
            self.navigationController!.pushViewController(captionVC, animated: false)
            
        }
        
    }
    
    @IBAction func nextImageCaption(sender: AnyObject) {
        
        index = index + 1
        
        if index < allImages.count {
            
            addNewCaption()
            print("next caption")
            let captionVC = self.storyboard!.instantiateViewControllerWithIdentifier("addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.currentImage = allImages[index].currentImage!
            captionVC.currentSender = allImages[index]
            captionVC.allPhotos = allPhotos
            captionVC.allIds = allIds
            self.navigationController!.pushViewController(captionVC, animated: false)
            
        }
        
    }
    
    @IBAction func doneCaptions(sender: AnyObject) {
        
        let allSubviews = self.navigationController!.viewControllers
        
        for subview in allSubviews {
            
            if subview.isKindOfClass(NewTLViewController) {
                
                addNewCaption()
                print("done caption")
                let myView = subview as! NewTLViewController
                myView.uploadedphotos = allPhotos
                self.navigationController!.popToViewController(myView, animated: true)
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AddCaptionsViewController.previousImageCaption(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AddCaptionsViewController.nextImageCaption(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        print("new controller")
        
        for images in imagesArray {
            
            if images.tag != 2 {
            
                print("in all images append")
                allImages.append(images as! UIButton)
            }
            
        }
        
        imageForCaption.image = currentImage
        index = allImages.indexOf(currentSender)
        
        print("index is: \(index)")
        
//        captionTextView.text = allIds[index]
        captionTextView.delegate = self
        captionTextView.returnKeyType = .Done
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        for image in completeImages {
            
            image.hidden = true
            image.layer.cornerRadius = 5.0
            image.clipsToBounds = true
            image.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(AddCaptionsViewController.imageTapped(_:)))
            image.addGestureRecognizer(tap)
            
        }
        
        if allImages.count <= 5 {
            
            bottomStack.hidden = true
            
        }
        
        for i in 0 ..< allImages.count {
            
            let image = allImages[i].currentImage
            print("image to be set: \(image)")
            completeImages[i].image = image
            completeImages[i].hidden = false
            
            if completeImages[i].image == imageForCaption.image {
                
                print("inside equality")
                completeImages[i].layer.borderColor = mainBlueColor.CGColor
                completeImages[i].layer.borderWidth = 3.0
                
            }
            
        }
        
    }
    
    func imageTapped(sender: UITapGestureRecognizer) {
        
        print("image tapped")
        
        let senderImageView = sender.view as! UIImageView
        
        for image in allImages {
            
            if senderImageView.image == image.currentImage {
                
                index = allImages.indexOf(image)
                print("index in image tapped: \(index)")
                
            }
            
        }
        
        if index < allImages.count {
            
            addNewCaption()
            print("next caption")
            let captionVC = self.storyboard!.instantiateViewControllerWithIdentifier("addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.currentImage = allImages[index].currentImage!
            captionVC.currentSender = allImages[index]
            captionVC.allPhotos = allPhotos
            captionVC.allIds = allIds
            self.navigationController!.pushViewController(captionVC, animated: false)
            
        }
        
    }
    
    func addNewCaption() {
        
        var flag = 0
        
        for photo in allPhotos {
            
            if photo["name"].string! == allIds[index] && captionTextView.text == photo["caption"].string! {
                
                flag = 1
                break
            }
            else if photo["name"].string! == allIds[index] && captionTextView.text != photo["caption"].string! {
                
                allPhotos.removeAtIndex(allPhotos.indexOf(photo)!)
                break
            }
            
        }
        
        if flag == 0 {
            
            print("inside add caption")
            if captionTextView.text != "" &&  captionTextView.text != "Add a caption..." {
                
                allPhotos.append(["name": allIds[index], "caption": captionTextView.text])
                
            }
            else {
                
                allPhotos.append(["name": allIds[index], "caption": ""])
            }
        }
        
        print("photos: \(allPhotos)")
        
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
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            captionTextView.resignFirstResponder()
            
            if captionTextView.text == "" {
                
                captionTextView.text = "Add Caption..."
                
            }
            return true
            
        }
        
        return true
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        captionTextView.text = ""
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
