import UIKit
import Photos
import imglyKit
import Spring
var editedImage = UIImage()
var isEditedImage = false

class AddCaptionsViewController: UIViewController, UITextViewDelegate, ToolStackControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var imagesArray: [UIView] = []
    var currentImage = UIImage()
    var allImages: [UIButton] = []
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
    var imageArr:[PostImage] = []
    var isDeletedImage = false
    var currentImageIndex = 0;
    
    @IBOutlet var completeImages: [UIImageView]!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageForCaption: SpringImageView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageStackView: UIStackView!
    @IBOutlet weak var editImageButton: UIButton!
    
    var index = 0
    var editedIndex: Int!
    var deletedIndex: Int!
    
    @IBAction func deletePhoto(_ sender: UIButton) {
    
    }
    
    @IBAction func editPhoto(_ sender: Any) {
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
        
        
    }
    
    @IBAction func doneCaptions(_ sender: AnyObject) {
        let allSubviews = self.navigationController!.viewControllers
        for subview in allSubviews {
            if subview.isKind(of: NewTLViewController.self) {
                let myView = subview as! NewTLViewController
                myView.photosToBeUploaded = allPhotos
                self.navigationController!.popToViewController(myView, animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        doneButton.isHidden = true
        captionTextView.layer.cornerRadius = 5.0
        captionTextView.clipsToBounds = true
        captionTextView.layer.zPosition = 1000
//        imageStackView.layer.zPosition = 1000
        captionTextView.textContainerInset = UIEdgeInsetsMake(5, 10, 5, 10)

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddCaptionsViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddCaptionsViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        if(imageArr[currentImageIndex].caption == "") {
            captionTextView.text = "Add a caption..."
        } else {
            captionTextView.text = imageArr[currentImageIndex].caption
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addImages", for: indexPath) as! addImages

//        cell.backgroundColor = UIColor.brown
        cell.addImagesCollection.image = imageArr[indexPath.row].image
        cell.addImagesCollection.layer.cornerRadius = 5
        cell.addImagesCollection.clipsToBounds = true;
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeImage(number:indexPath.row);
    }
    
    func changeImage(number:Int) {
        currentImageIndex = number
        captionTextView.resignFirstResponder()
        imageForCaption.animation = "flipX";
        imageForCaption.image = imageArr[currentImageIndex].image
        imageForCaption.animate();

        if(imageArr[currentImageIndex].caption == "") {
            captionTextView.text = "Add a caption..."
        } else {
            captionTextView.text = imageArr[currentImageIndex].caption
        }
        
        
    }
    
    var editedImagesArray: [Dictionary<Int,UIImage>] = []
    
    func updateImage() {
        imageForCaption.image = editedImage
        updateImageInFile()
    }
    
    var loader = LoadingOverlay()
    
    func updateImageInFile() {
        
        let exportFileUrl = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/image\(index).jpg"
        
        print("edited image export url: \(exportFileUrl)")
        
        loader.showOverlay(self.view)
        
        DispatchQueue.main.async(execute: {
            
            do {
                print("edited image: \(editedImage)")
                
                if let data = UIImageJPEGRepresentation(editedImage, 0.35) {
                    try data.write(to: URL(string: exportFileUrl)!, options: .atomic)
                }
                print("edit file created")
                editedImage = UIImage()
                print("in edit image")
                isEditedImage = false
                
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
    
    var isGoingToEdit = true
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        print("in view did appear")
        
        if (isEditedImage) {
            updateImage()
        }
        
        else if !isGoingToEdit {
            getPhotoCaption(ind: index)
        }
        
    }
    
    func getPhotoCaption(ind: Int) {
        
//        let imageCaption = photo.getCaption(allIds[index])
        
        if allPhotos.count > 0 {
            
            print("\(#line) caption: \(ind) \(allPhotos[ind].caption)")
            if allPhotos[ind].caption != "" {
                captionTextView.text = imageArr[ind].caption
            }
            else {
                captionTextView.text = "Add a caption..."
            }
            
            
        }
    }
    
    var viewHeight = 0
    func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = CGFloat(viewHeight)
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }

        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            captionTextView.resignFirstResponder()
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
    func textViewDidChange(_ textView: UITextView) {
        imageArr[currentImageIndex].caption = captionTextView.text
    }
    
    func goBack(_ sender: UIButton) {
        for viewController in self.navigationController!.viewControllers {
            if viewController.isKind(of: NewTLViewController.self) {
                let newtlVC = viewController as! NewTLViewController
                self.navigationController!.popToViewController(newtlVC, animated: true)
            }
        }
    }
    
}

class addImages: UICollectionViewCell {
    @IBOutlet weak var addImagesCollection: UIImageView!
}
