import UIKit
import Photos
import imglyKit
import Spring
import Player
import DKChainableAnimationKit
import Crashlytics

var editedImage = UIImage()
var isEditedImage = false

class AddCaptionsViewController: UIViewController, UITextFieldDelegate, ToolStackControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, PlayerDelegate {
    
    @IBOutlet weak var editVisual: UIVisualEffectView!
    @IBOutlet weak var deleteVisual: UIVisualEffectView!
    @IBOutlet weak var blurBehindCaption: UIVisualEffectView!
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var collectionVi: UICollectionView!
    var imagesArray: [UIView] = []
    var addActivity:AddActivityNew!
    var currentImage = UIImage()
    var allImages: [UIButton] = []
    var quickIt:QuickIteneraryFive!
    var allIds: [Int] = []
    var imageIds: [Int] = []
    var allPhotos: [PhotoUpload] = []
    var currentId = 0
    let photoCount = 0
    var photoIndex: [String] = []
    var photoData: [Data] = []
    var photoURL: [URL] = []
    var photoImage: [UIImage] = []
    var imageArr:[PostImage] = []
    var isDeletedImage = false
    var currentImageIndex = 0;
    var type = ""
    var player:Player!
    var videoURL:URL!
    
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var deleteImage: UIButton!
    @IBOutlet var completeImages: [UIImageView]!
    @IBOutlet weak var captionTextView: UITextField!
    @IBOutlet weak var imageForCaption: SpringImageView!
    @IBOutlet weak var bottomStack: UIStackView!
//    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var editImageButton: UIButton!
    
    var index = 0
    var editedIndex: Int!
    var deletedIndex: Int!
    
    @IBAction func deletePhoto(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this Activtiy", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
            if(self.type != "videoCaption") {
                self.imageArr.remove(at: self.currentImageIndex)
                if self.addActivity != nil {
                    self.addActivity.imageArr = self.imageArr;
                    self.addActivity.addPhotoToLayout()
                } else if self.quickIt != nil {
                    self.quickIt.photosCollection.reloadData()
                }
                if(self.imageArr.count == 0) {
                    self.goBack(UIButton());
                }
                else {
                    self.collectionVi.reloadData()
                    self.previousImageCaption(UIButton())
                }
                
            } else {
                self.addActivity.removeVideoBlock()
                self.goBack(UIButton());
            }
        }))
        showPopover(optionsController: alert, sender: sender, vc: self)

//        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func editPhoto(_ sender: UIButton) {
        isGoingToEdit = true
        let photoEditViewController = PhotoEditViewController(photo: imageForCaption.image!)
        let toolStackController = ToolStackController(photoEditViewController: photoEditViewController)
        toolStackController.delegate = self
        toolStackController.navigationItem.title = "Editor"
        toolStackController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: photoEditViewController, action: #selector(PhotoEditViewController.save(_:)))
        let nvc = UINavigationController(rootViewController: toolStackController)
        nvc.navigationBar.isTranslucent = false
        nvc.navigationBar.barStyle = .black
        self.present(nvc, animated: true, completion: nil)
    }
    
    @IBAction func previousImageCaption(_ sender: AnyObject) {
        if(currentImageIndex == 0 ) {
            currentImageIndex = imageArr.count - 1;
        }
        else {
            currentImageIndex = currentImageIndex - 1;
        }
        changeImage(number: currentImageIndex)
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
        if(currentImageIndex == (imageArr.count - 1) ) {
            currentImageIndex = 0;
        }
        else {
            currentImageIndex = currentImageIndex + 1;
        }
        changeImage(number: currentImageIndex)
    }
    
    @IBAction func doneCaptions(_ sender: AnyObject) {
        if(self.type != "videoCaption") {
            if self.addActivity != nil {
                self.addActivity.imageArr = imageArr;
                self.addActivity.addPhotoToLayout()
            } else if self.quickIt != nil {
                self.quickIt.photosCollection.reloadData()
            }
        }
        
        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) { 
            
        }
    }
    
    override func viewDidLoad() {
        self.view.bringSubview(toFront: editImageButton)
        editImageButton.setTitle(String(format: "%C",faicon["magic"]!), for: .normal)
        super.viewDidLoad()
        isEditedImage = false
        print("new controller")
        self.captionTextView.delegate = self
        let leftButton = UIButton()
        leftButton.setTitle("Cancel", for: .normal)
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        
        let rightButton = UIButton()
        rightButton.setTitle("Done", for: UIControlState())
        rightButton.addTarget(self, action: #selector(self.doneCaptions(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        
       deleteImage.setTitle(String(format: "%C", faicon["trash"]!), for: UIControlState())
        self.videoContainer.isHidden = true
     
        
        self.customNavigationBar(left: leftButton, right: rightButton)
       
     
        deleteImage.layer.zPosition = 10
        captionTextView.layer.cornerRadius = 5.0
        captionTextView.clipsToBounds = true
        
        editVisual.layer.cornerRadius = 5.0
        deleteVisual.layer.cornerRadius = 5.0
        editVisual.clipsToBounds = true
        deleteVisual.clipsToBounds = true
        
        blurBehindCaption.layer.cornerRadius = 5.0
        blurBehindCaption.clipsToBounds = true
        
//        imageStackView.layer.zPosition = 1000
        

        NotificationCenter.default.addObserver(self, selector: #selector(AddCaptionsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddCaptionsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        if(type != "videoCaption") {
            
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AddCaptionsViewController.previousImageCaption(_:)))
            swipeRight.direction = UISwipeGestureRecognizerDirection.right
            self.view.addGestureRecognizer(swipeRight)
            
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AddCaptionsViewController.nextImageCaption(_:)))
            swipeLeft.direction = UISwipeGestureRecognizerDirection.left
            self.view.addGestureRecognizer(swipeLeft)
            
            for eachImage in allImages {
                
                let i = allImages.index(of: eachImage)
                editedImagesArray.append([i!: eachImage.currentImage!])
            }

            
            print(currentImageIndex);
            CLSNSLogv("AddCaptionsViewController.swift -> imageArr count %d :: currentIndex : %d", getVaList([imageArr.count, currentImageIndex]))
            if(currentImageIndex < imageArr.count){
                imageForCaption.image = imageArr[currentImageIndex].image
            }
            else{
                print("\n It would have crash : Cause: IndexOutOfBounds")
            }
            
            captionTextView.delegate = self
            captionTextView.returnKeyType = .done
            captionTextView.resignFirstResponder()
            
            if(imageArr[currentImageIndex].caption == "") {
                captionTextView.text = "  Add caption..."
            } else {
                captionTextView.text = imageArr[currentImageIndex].caption
            }
            
        
            let indexPath = IndexPath(row: currentImageIndex, section: 0)
            collectionVi.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        } else {
            if( self.addActivity.videoCaption != "") {
                self.captionTextView.text = self.addActivity.videoCaption
                
            }
            self.getVideo()
            self.editImageButton.isHidden = true
        }
        
        
        
        
//        collectionVi.scrollToItem(at: NSIndexPath(index: currentImageIndex) as IndexPath,at:UICollectionViewScrollPosition(rawValue: UInt(currentImageIndex)), animated: true)
    }
    
    func getVideo() {
        self.videoContainer.isHidden = false
        self.player = Player()
        self.player.delegate = self
        self.player.playbackLoops = true
        self.player.muted = false
        self.player.view.frame = self.videoContainer.bounds
        self.player.setUrl(self.videoURL)
        self.videoContainer.addSubview(self.player.view)
        self.imageForCaption.isHidden = true
        self.collectionVi.isHidden = true
    }
    
    func playerReady(_ player: Player) {
        player.playFromBeginning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(type != "videoCaption") {
            self.title = "Photos (\(imageArr.count))"
        } else {
            self.title = "Video"
        }
        
        return imageArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImages", for: indexPath) as! addImages

//        cell.frame.origin.y = -64
        
//        cell.backgroundColor = UIColor.brown
        cell.addImagesCollection.image = imageArr[indexPath.row].image
        cell.addImagesCollection.contentMode = UIViewContentMode.scaleAspectFill
        cell.addImagesCollection.layer.cornerRadius = 5
        cell.addImagesCollection.clipsToBounds = true;
        
        
        if(currentImageIndex == indexPath.row) {
            cell.addImagesCollection.layer.borderWidth = 1
            cell.addImagesCollection.layer.borderColor = mainOrangeColor.cgColor
        } else {
            cell.addImagesCollection.layer.borderWidth = 0
        }
        
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeImage(number:indexPath.row);
    }
    
    func changeImage(number:Int) {
        currentImageIndex = number
        captionTextView.resignFirstResponder()
        self.imageForCaption.duration = 0.25
        self.imageForCaption.animation = "fadeOut";
        
        imageForCaption.animateToNext {
            self.imageForCaption.image = self.imageArr[self.currentImageIndex].image
            self.imageForCaption.animation = "fadeIn";
            self.imageForCaption.animate();
        }

        if(imageArr[currentImageIndex].caption == "") {
            captionTextView.text = "  Add caption..."
        } else {
            captionTextView.text = imageArr[currentImageIndex].caption
        }
        
        collectionVi.reloadData()
        
        let indexPath = IndexPath(row: currentImageIndex, section: 0)
        collectionVi.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
//        collectionVi.scrollToItem(at: NSIndexPath(index: number) as IndexPath,at:UICollectionViewScrollPosition(rawValue: UInt(number)), animated: true)
    
    }
    
    var editedImagesArray: [Dictionary<Int,UIImage>] = []
    
    func updateImage() {
        imageForCaption.image = editedImage
        imageArr[currentImageIndex].image = editedImage
        loader.hideOverlayView()
        collectionVi.reloadData()
    }
    
    var loader = LoadingOverlay()
    
    var isGoingToEdit = true
    
    override func viewDidAppear(_ animated: Bool) {
        setAnalytics(name: "Add Caption to Image")

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        print("in view did appear")
        if (isEditedImage) {
            updateImage()
        }
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            captionTextView.resignFirstResponder()
            if captionTextView.text == "" {
                captionTextView.text = "  Add caption..."
            }
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if captionTextView.text == "  Add caption..." {
            captionTextView.text = ""
        }
    }
    
    @available(iOS 10.0, *)
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if(type != "videoCaption") {
            imageArr[currentImageIndex].caption = captionTextView.text!
        } else {
            self.addActivity.videoCaption = captionTextView.text!
        }
    }
    
    func goBack(_ sender: UIButton) {
        if(self.type != "videoCaption") {
            if self.addActivity != nil {
                self.addActivity.imageArr = imageArr;
                self.addActivity.addPhotoToLayout()
            } else if self.quickIt != nil {
                self.quickIt.photosCollection.reloadData()
            }
        }
        _ = navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            
        }
        
    }
//    var viewHeight1 = 0
    
    func keyboardWillShow(_ notification: Notification) {
//        view.frame.origin.y = CGFloat(viewHeight1)
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            //            if !keyboardHidden {
            if self.view.frame.origin.y == 64{
                self.view.frame.origin.y -=  keyboardSize.height
                print("heightminusdikha\(keyboardSize.height)")
                //                keyboardHidden = true
                //            }
            }
        }
        
    }
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 64{
                print("height dikha\(keyboardSize.height)")
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    
}

class addImages: UICollectionViewCell {
    @IBOutlet weak var addImagesCollection: UIImageView!
}
