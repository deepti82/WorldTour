import UIKit
import Photos
import imglyKit
import Spring
var editedImage = UIImage()
var isEditedImage = false

class AddCaptionsViewController: UIViewController, UITextViewDelegate, ToolStackControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    
    @IBOutlet var completeImages: [UIImageView]!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageForCaption: SpringImageView!
    @IBOutlet weak var bottomStack: UIStackView!
//    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var editImageButton: UIButton!
    
    var index = 0
    var editedIndex: Int!
    var deletedIndex: Int!
    
    @IBAction func deletePhoto(_ sender: UIButton) {
        imageArr.remove(at: currentImageIndex)
        if self.addActivity != nil {
            self.addActivity.imageArr = imageArr;
            self.addActivity.addPhotoToLayout()
        } else if self.quickIt != nil {
            self.quickIt.photosCollection.reloadData()
        }
        if(imageArr.count == 0) {
            self.goBack(UIButton());
        }
        else {
            collectionVi.reloadData()
            self.previousImageCaption(UIButton())
        }
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
        if self.addActivity != nil {
            self.addActivity.imageArr = imageArr;
            self.addActivity.addPhotoToLayout()
        } else if self.quickIt != nil {
            self.quickIt.photosCollection.reloadData()
        }
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) { 
            
        }
    }
    
    override func viewDidLoad() {
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
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
       
        captionTextView.layer.cornerRadius = 5.0
        captionTextView.clipsToBounds = true
        captionTextView.layer.zPosition = 1000
//        imageStackView.layer.zPosition = 1000
        captionTextView.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10)

        NotificationCenter.default.addObserver(self, selector: #selector(AddCaptionsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddCaptionsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
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
        imageForCaption.image = imageArr[currentImageIndex].image
        
        captionTextView.delegate = self
        captionTextView.returnKeyType = .done
        captionTextView.resignFirstResponder()
        
        if(imageArr[currentImageIndex].caption == "") {
            captionTextView.text = "Add a caption..."
        } else {
            captionTextView.text = imageArr[currentImageIndex].caption
        }
        captionTextView.scrollRangeToVisible(NSRange(location:0, length:0))
       
        let indexPath = IndexPath(row: currentImageIndex, section: 0)
        collectionVi.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        
        
//        collectionVi.scrollToItem(at: NSIndexPath(index: currentImageIndex) as IndexPath,at:UICollectionViewScrollPosition(rawValue: UInt(currentImageIndex)), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.title = "Photos (\(imageArr.count))"
        return imageArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImages", for: indexPath) as! addImages

//        cell.backgroundColor = UIColor.brown
        cell.addImagesCollection.image = imageArr[indexPath.row].image
        cell.addImagesCollection.contentMode = UIViewContentMode.scaleAspectFill
        cell.addImagesCollection.layer.cornerRadius = 5
        cell.addImagesCollection.clipsToBounds = true;
        captionTextView.scrollRangeToVisible(NSRange(location:0, length:0))
        
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
        
        self.imageForCaption.animation = "fall";
        
        imageForCaption.animateToNext {
            self.imageForCaption.image = self.imageArr[self.currentImageIndex].image
            self.imageForCaption.animation = "pop";
            self.imageForCaption.animate();
        }

        if(imageArr[currentImageIndex].caption == "") {
            captionTextView.text = "Add a caption..."
        } else {
            captionTextView.text = imageArr[currentImageIndex].caption
        }
        captionTextView.scrollRangeToVisible(NSRange(location:0, length:0))
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        print("in view did appear")
        if (isEditedImage) {
            updateImage()
        }
    }
   
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            captionTextView.resignFirstResponder()
            if captionTextView.text == "" {
                captionTextView.text = "Add a caption..."
                 captionTextView.scrollRangeToVisible(NSRange(location:0, length:0))
            }
            return true
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if captionTextView.text == "Add a caption..." {
            captionTextView.text = ""
             captionTextView.scrollRangeToVisible(NSRange(location:0, length:0))
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        imageArr[currentImageIndex].caption = captionTextView.text
         captionTextView.scrollRangeToVisible(NSRange(location:0, length:0))
    }
    
    func goBack(_ sender: UIButton) {
        if self.addActivity != nil {
            self.addActivity.imageArr = imageArr;
            self.addActivity.addPhotoToLayout()
        } else if self.quickIt != nil {
            self.quickIt.photosCollection.reloadData()
        }
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true) {
            
        }
        
    }
//    var viewHeight1 = 0
    
    func keyboardWillShow(_ notification: Notification) {
//        view.frame.origin.y = CGFloat(viewHeight1)
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            
            //            if !keyboardHidden {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -=  keyboardSize.height
                print("heightminusdikha\(keyboardSize.height)")
                //                keyboardHidden = true
                //            }
            }
        }
        
    }
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                print("height dikha\(keyboardSize.height)")
                self.view.frame.origin.y += 216.0
            }
        }
    }

    
}

class addImages: UICollectionViewCell {
    @IBOutlet weak var addImagesCollection: UIImageView!
}
