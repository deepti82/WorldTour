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
    
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageForCaption: UIImageView!
    
    var index: Int!
    
    @IBAction func previousImageCaption(sender: AnyObject) {
        
        if captionTextView.text != "" &&  captionTextView.text != "Add Caption..." {
            
            allPhotos.append(["name": allIds[index], "caption": captionTextView.text])
            
        }
        else {
            
            allPhotos.append(["name": allIds[index], "caption": ""])
        }
        
        print("photos: \(allPhotos)")
        
        index = index - 1
        
        if index >= 0 {
            
            let captionVC = self.storyboard!.instantiateViewControllerWithIdentifier("addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.currentImage = allImages[index!].currentImage!
            captionVC.allIds = allIds
            captionVC.currentSender = allImages[index!]
            captionVC.allPhotos = allPhotos
            self.navigationController!.pushViewController(captionVC, animated: false)
            
        }
        
        
//        for button in allImages {
//            
//            let index = button.indexOf
//            
//            
//            
//        }
        
    }
    
    @IBAction func nextImageCaption(sender: AnyObject) {
        
        if captionTextView.text != "" &&  captionTextView.text != "Add Caption..." {
            
            allPhotos.append(["name": allIds[index], "caption": captionTextView.text])
            
        }
        else {
            
            allPhotos.append(["name": allIds[index], "caption": ""])
        }
        
        print("photos: \(allPhotos)")
        
        index = index + 1
        
        if index < allImages.count - 1 {
            
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
        
        if captionTextView.text != "" &&  captionTextView.text != "Add Caption..." {
            
            allPhotos.append(["name": allIds[index], "caption": captionTextView.text])
            
        }
        else {
            
            allPhotos.append(["name": allIds[index], "caption": ""])
        }
        
        let allSubviews = self.navigationController!.viewControllers
        
        for subview in allSubviews {
            
            if subview.isKindOfClass(NewTLViewController) {
                
                let myView = subview as! NewTLViewController
                myView.uploadedphotos = allPhotos
                self.navigationController!.popToViewController(myView, animated: true)
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for images in imagesArray {
            
            allImages.append(images as! UIButton)
            
        }
        
        imageForCaption.image = currentImage
        index = allImages.indexOf(currentSender)
        
        print("index is: \(index)")
        
//        captionTextView.text = allIds[index]
        captionTextView.delegate = self
        captionTextView.returnKeyType = .Done
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CommentsViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func addNewCaption() {
        
        
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
