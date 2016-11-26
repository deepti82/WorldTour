//
//  AddCaptionsViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/5/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Photos


class AddCaptionsViewController: UIViewController, UITextViewDelegate {
    
    var imagesArray: [UIView] = []
    var currentImage = UIImage()
    var allImages: [UIButton] = []
    var currentSender = UIButton()
    let PhotosDB = Photo()
    var allIds: [String] = []
    var imageIds: [String] = []
    var allPhotos: [JSON] = []
    var currentId = 0
    
    let photoCount = 0
    var photoIndex: [String] = []
    var photoData: [Data] = []
    var photoURL: [URL] = []
    var photoImage: [UIImage] = []
    
    @IBOutlet var completeImages: [UIImageView]!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageForCaption: UIImageView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    
    var index = 0
    
    @IBAction func editPhoto(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let imgLyKit = storyboard.instantiateViewController(withIdentifier: "ImgLyKit") as! ImgLyKitViewController
        imgLyKit.currentImage = currentImage
        self.present(imgLyKit, animated: true, completion: nil)
    }
    
    @IBAction func previousImageCaption(_ sender: AnyObject) {
        
        addToLocalDB()
        addNewCaption()
        
        index = index - 1
        
        if index >= 0 {
            
            print("previous caption")
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.currentImage = allImages[index].currentImage!
            captionVC.allIds = allIds
            captionVC.currentSender = allImages[index]
            captionVC.allPhotos = allPhotos
            captionVC.imageIds = imageIds
            captionVC.currentId = currentId - 1
            captionVC.allImages = allImages
            self.navigationController!.pushViewController(captionVC, animated: false)
            
        }
        
    }
    
    @IBAction func nextImageCaption(_ sender: AnyObject) {
        
        addToLocalDB()
        addNewCaption()
        
        index = index + 1
        
        if index < allImages.count {
            
            print("next caption")
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.currentImage = allImages[index].currentImage!
            captionVC.currentSender = allImages[index]
            captionVC.allPhotos = allPhotos
            captionVC.allIds = allIds
            captionVC.imageIds = imageIds
            captionVC.currentId = currentId + 1
            captionVC.allImages = allImages
            self.navigationController!.pushViewController(captionVC, animated: false)
            
        }
        
    }
    
    @IBAction func rotateImage(_ sender: AnyObject) {
        print("rotate image")
    }
    
    @IBAction func doneCaptions(_ sender: AnyObject) {
        
        let allSubviews = self.navigationController!.viewControllers
        
        for subview in allSubviews {
            
            if subview.isKind(of: NewTLViewController.self) {
                addToLocalDB()
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
        
        let leftButton = UIButton()
        leftButton.setTitle("Cancel", for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        
        let rightButton = UIButton()
        rightButton.setTitle("Done", for: UIControlState())
        rightButton.addTarget(self, action: #selector(self.doneCaptions(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        doneButton.isHidden = true
        captionTextView.layer.cornerRadius = 5.0
        captionTextView.clipsToBounds = true
        captionTextView.layer.zPosition = 1000
        imageStackView.layer.zPosition = 1000
        captionTextView.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AddCaptionsViewController.previousImageCaption(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AddCaptionsViewController.nextImageCaption(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        print("new controller")
        
//        for images in imagesArray {
//            
//            if images.tag != 1 {
//                print("in all images append")
//                allImages.append(images as! UIButton)
//            }
//            
//        }
        
        imageForCaption.image = currentImage
//        index = allImages.index(of: currentSender)!
        
        print("index is: \(index)")
        
        captionTextView.delegate = self
        captionTextView.returnKeyType = .done
        
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CommentsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        for image in completeImages {
            
            image.isHidden = true
            image.layer.cornerRadius = 2.0
            image.clipsToBounds = true
            image.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(AddCaptionsViewController.imageTapped(_:)))
            image.addGestureRecognizer(tap)
            
        }
        
        if allImages.count <= 5 {
            
            bottomStack.isHidden = true
            
        }
        
        for i in 0 ..< allImages.count {
            
            let image = allImages[i].currentImage
            print("image to be set: \(image)")
            completeImages[i].image = image
            completeImages[i].isHidden = false
            
            if completeImages[i].image == imageForCaption.image {
                
                print("inside equality")
                completeImages[i].layer.borderColor = mainOrangeColor.cgColor
                completeImages[i].layer.borderWidth = 1.0
                
            }
            
        }
        
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        
        print("image tapped")
        
        let senderImageView = sender.view as! UIImageView
        
        for image in allImages {
            
            if senderImageView.image == image.currentImage {
                
                index = allImages.index(of: image)!
                print("index in image tapped: \(index)")
                
            }
            
        }
        
        if index < allImages.count {
            
            addNewCaption()
            print("next caption")
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.currentImage = allImages[index].currentImage!
            captionVC.currentSender = allImages[index]
            captionVC.allPhotos = allPhotos
            captionVC.allIds = allIds
            captionVC.allImages = allImages
            self.navigationController!.pushViewController(captionVC, animated: false)
            
        }
        
    }
    
    func addToLocalDB() {
        print(currentId)
        let nextId = currentId + 1
        imageIds.append("\(nextId)")
        print(captionTextView.text)
        
        if captionTextView.text != nil && captionTextView.text != "Add a caption..." {
            PhotosDB.insertCaption(imageLocalId: Int64(currentId), caption: captionTextView.text)
        }
    }
    
    func addNewCaption() {
        
        var flag = 0
        
//        let imageData = UIImageJPEGRepresentation(currentImage, 0.5)
        
        for photo in allPhotos {
            
            if photo["name"].string! == allIds[index] && captionTextView.text == photo["caption"].string! {
                
                flag = 1
            }
            else if photo["name"].string! == allIds[index] && captionTextView.text != photo["caption"].string! {
                
                allPhotos.remove(at: allPhotos.index(of: photo)!)
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
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            captionTextView.resignFirstResponder()
            
            if captionTextView.text == "" {
                
                captionTextView.text = "Add Caption..."
                
            }
            return true
            
        }
        
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        captionTextView.text = ""
        
    }
    
    func goBack(_ sender: UIButton) {
        self.popVC(sender)
    }
    
}
