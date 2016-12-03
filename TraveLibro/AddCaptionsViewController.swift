//
//  AddCaptionsViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/5/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Photos
import imglyKit

class AddCaptionsViewController: UIViewController, UITextViewDelegate, ToolStackControllerDelegate {
    
    var imagesArray: [UIView] = []
    var currentImage = UIImage()
    var allImages: [UIButton] = []
    var currentSender = UIButton()
    let PhotosDB = Photo()
    var allIds: [Int] = []
    var imageIds: [Int] = []
    var allPhotos: [PhotoUpload] = []
    var currentId = 0
    
    let photoCount = 0
    var photoIndex: [String] = []
    var photoData: [Data] = []
    var photoURL: [URL] = []
    var photoImage: [UIImage] = []
    
    var editedImage = UIImage()
    var isEditedImage = false
    var isDeletedImage = false
    
    @IBOutlet var completeImages: [UIImageView]!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageForCaption: UIImageView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var editImageButton: UIButton!
    
    var index = 0
    var editedIndex: Int!
    var deletedIndex: Int!
    
    @IBAction func deletePhoto(_ sender: UIButton) {
        
        isDeletedImage = true
        
        if allImages.count == 1 {
            
            self.popVC(sender)
        }
        
        else if index == 0 {
            
            index += 1
            
            print("prev index: \(index - 1) current index: \(index)")
            
            deletedIndex = index - 1
            
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.deletedIndex = deletedIndex
            captionVC.currentImage = allImages[index].currentImage!
            captionVC.allIds = allIds
            captionVC.currentSender = allImages[index]
            captionVC.allPhotos = allPhotos
            captionVC.index = index
            captionVC.imageIds = imageIds
            captionVC.allImages = allImages
            self.navigationController!.pushViewController(captionVC, animated: false)
        }
        
        else if index >= allImages.count - 1 {
            
            index = 0
            
            print("prev index: \(index - 1) current index: \(index)")
            
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = [imagesArray.remove(at: allImages.count - 1)]
            captionVC.currentImage = allImages[index].currentImage!
            captionVC.allIds = [allIds.removeLast()]
            captionVC.currentSender = allImages[index]
            captionVC.allPhotos = [allPhotos.removeLast()]
            captionVC.index = index
            captionVC.imageIds = [imageIds.remove(at: allImages.count - 1)]
            captionVC.allImages = [allImages.remove(at: allImages.count - 1)]
            self.navigationController!.pushViewController(captionVC, animated: false)
        }
        
        else {
            
            index += 1
            
            print("prev index: \(index - 1) current index: \(index)")
            
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            self.navigationController!.pushViewController(captionVC, animated: false)
            captionVC.imagesArray = [imagesArray.remove(at: index - 1)]
            captionVC.currentImage = allImages[index - 1].currentImage!
            captionVC.allIds = [allIds.remove(at: index - 1)]
            captionVC.currentSender = allImages[index - 1]
            captionVC.allPhotos = allPhotos.filter({$0.serverId != allPhotos[index - 1].serverId})
            captionVC.index = index
            captionVC.imageIds = [imageIds.remove(at: index - 1)]
            captionVC.allImages = [allImages.remove(at: index - 1)]

        }
        
    }
    
    @IBAction func editPhoto(_ sender: Any) {
        
//        editImageButton.tag = index
        
        let photoEditViewController = PhotoEditViewController(photo: currentImage)
        let toolStackController = ToolStackController(photoEditViewController: photoEditViewController)
        toolStackController.delegate = self
        toolStackController.navigationItem.title = "Editor"
        
        //toolStackController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: photoEditViewController, action: #selector(ImgLyKitViewController.cancel(_:)))
        
        toolStackController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: photoEditViewController, action: #selector(PhotoEditViewController.save(_:)))
        
        let navigationController = UINavigationController(rootViewController: toolStackController)
        
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barStyle = .black
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func previousImageCaption(_ sender: AnyObject) {
        
        
        addToLocalDB(ind: index)
//        addNewCaption(ind: index)
        
        index = index - 1
        
        if index >= 0 {
            
            print("previous caption \(index)")
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.currentImage = allImages[index].currentImage!
            captionVC.allIds = allIds
            captionVC.currentSender = allImages[index]
            captionVC.allPhotos = allPhotos
            captionVC.index = index
            captionVC.imageIds = imageIds
//            captionVC.getPhotoCaption()
//            captionVC.currentId = allIds[index]
            captionVC.allImages = allImages
            self.navigationController!.pushViewController(captionVC, animated: false)
            
        }
        
        else {
            index = 0
        }
        
    }
    
    func toolStackController(_ toolStackController: ToolStackController, didFinishWith image: UIImage){
        
        print("in tool stack ctrl")
        isEditedImage = true
        editedImage = image
        dismiss(animated: true, completion: nil)
    }
    
    func toolStackControllerDidCancel(_ toolStackController: ToolStackController){
        
        print("on cancel toolstackcontroller")
        dismiss(animated: true, completion:nil)
    }
    
    func toolStackControllerDidFail(_ toolStackController: ToolStackController){
        print("on fail toolstackcontroller")
    }
    
    @IBAction func nextImageCaption(_ sender: AnyObject) {
        
        addToLocalDB(ind: index)
//        addNewCaption(ind: index)
        
        index = index + 1
        
        if index < allImages.count {
            
            print("next caption \(index)")
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.currentImage = allImages[index].currentImage!
            captionVC.currentSender = allImages[index]
            captionVC.allPhotos = allPhotos
            captionVC.index = index
            captionVC.allIds = allIds
            captionVC.imageIds = imageIds
//            captionVC.getPhotoCaption()
            captionVC.currentId = currentId + 1
            captionVC.allImages = allImages
            self.navigationController!.pushViewController(captionVC, animated: false)
        }
        
        else {
            index = index - 1
        }
        
    }
    
    @IBAction func rotateImage(_ sender: AnyObject) {
        print("rotate image")
    }
    
    @IBAction func doneCaptions(_ sender: AnyObject) {
        
        let allSubviews = self.navigationController!.viewControllers
        
        for subview in allSubviews {
            
            if subview.isKind(of: NewTLViewController.self) {
                addToLocalDB(ind: index)
//                addNewCaption(ind: index)
                print("done caption")
                let myView = subview as! NewTLViewController
                myView.photosToBeUploaded = allPhotos
                if isEditedImage {
                    myView.checkForEditedImages(editedImagesArray: editedImagesArray)
                    isEditedImage = false
                }
                self.navigationController!.popToViewController(myView, animated: true)
                
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIButton()
        leftButton.setTitle("Cancel", for: .normal)
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
        
        for eachImage in allImages {
            
            let i = allImages.index(of: eachImage)
            editedImagesArray.append([i!: eachImage.currentImage!])
        }
        
        
//        else{
//            
            imageForCaption.image = currentImage
//            print("in current image")
//        }
        
        //  jagruti's code
        
        index = getIndex()
        print("index is: \(index)")
//        getPhotoCaption()
        
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
    
    func getIndex() -> Int {
        
        return allImages.index(of: currentSender)!
    }
    
    var editedImagesArray: [Dictionary<Int,UIImage>] = []
    
    func updateImage() {
        
        editedImagesArray[index][index] = editedImage
        imageForCaption.image = editedImage
        
        print("index after editing is: \(index)")
        
        isEditedImage = false
//        allImages[editedIndex].setImage(editedImage, for: .normal)
//        updateImageInFile()
        
    }
    
    var loader = LoadingOverlay()
    
    func updateImageInFile() {
        
        let exportFileUrl = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/image\(editedIndex).jpg"
        
        print("export url: \(exportFileUrl)")
        
        loader.showOverlay(self.view)
        
        DispatchQueue.main.async(execute: {
            
            do {
                print("edited image: \(self.editedImage)")
                
                if let data = UIImageJPEGRepresentation(self.editedImage, 0.35) {
                    try data.write(to: URL(string: exportFileUrl)!, options: .atomic)
                }
                print("edit file created")
                self.editedImage = UIImage()
                print("in edit image")
                self.isEditedImage = false
                
            } catch let error as NSError {
                
                print("error creating file: \(error.localizedDescription)")
                
            }
            
        })
        
        loader.hideOverlayView()
    }
    
    func getPhotoIds(groupId: Int64) {
        
        allIds = photo.getPhotosIdsOfPost(photosGroup: groupId)
//        getPhotoCaption()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        getPhotoCaption(ind: index)
        
        if (isEditedImage) {
            
            updateImage()
        }
        
        else {
            
            index = getIndex()
        }
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
//        addNewCaption(ind: index)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func getPhotoCaption(ind: Int) {
        
//        let imageCaption = photo.getCaption(allIds[index])
        
        if allPhotos.count > 0 {
            
            print("\(#line) caption: \(ind) \(allPhotos[ind].caption)")
            if allPhotos[ind].caption != "" {
                captionTextView.text = allPhotos[ind].caption
            }
            else {
                captionTextView.text = "Add a caption..."
            }
            
            
        }
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        
        print("image tapped")
        
        addToLocalDB(ind: index)
        
        let senderImageView = sender.view as! UIImageView
        
        for image in allImages {
            
            if senderImageView.image == image.currentImage {
                
                index = allImages.index(of: image)!
                print("index in image tapped: \(index)")
                
            }
            
        }
        
        if index < allImages.count {
            
//            addNewCaption(ind: index)
            print("next caption")
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = imagesArray
            captionVC.currentImage = allImages[index].currentImage!
            captionVC.currentSender = allImages[index]
            captionVC.allPhotos = allPhotos
            captionVC.allIds = allIds
            captionVC.allImages = allImages
//            captionVC.getPhotoCaption()
            self.navigationController!.pushViewController(captionVC, animated: false)
            
        }
        
    }
    
    func addToLocalDB(ind: Int) {
        
        print(currentId)
        print(captionTextView.text)
        
        if captionTextView.text != nil && captionTextView.text != "Add a caption..." {
//            PhotosDB.insertCaption(imageLocalId: Int64(currentId), caption: captionTextView.text)
//            addNewCaption(ind: ind)
            allPhotos[ind].caption = captionTextView.text
        }
    }
    
    func addNewCaption(ind: Int) {
        
        for (i, eachPhoto) in allPhotos.enumerated() {
            
            print("searching error: \(eachPhoto.localId) \(Int64(allIds[index])) \(captionTextView.text)")
            
            if eachPhoto.localId == Int64(allIds[ind]) && captionTextView.text != "" {
                
                allPhotos[i].caption = captionTextView.text
            }
        }
        
    }
    
    func deletePhoto(deletedIndex: Int) {
        
        
        
        
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
            
//            photo.insertCaption(imageLocalId: Int64(allIds[index]), caption: captionTextView.text)
            
//            addNewCaption(ind: index)
            
            if captionTextView.text == "" {
                
                captionTextView.text = "Add a caption..."
                
            }
            return true
            
        }
        
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if captionTextView.text == "Add a caption..." {
            
            captionTextView.text = ""
        }
        
    }
    
    func goBack(_ sender: UIButton) {
        self.popVC(sender)
    }
    
}
