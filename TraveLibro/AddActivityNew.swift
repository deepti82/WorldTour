    import UIKit
import BSImagePicker
import Photos
import imglyKit
import Spring
var globalAddActivityNew:AddActivityNew!

class AddActivityNew: SpringView, UITextViewDelegate {
    
    
    
    @IBOutlet weak var finalImageTag: UIImageView!
    var typeOfAddActivtiy:String = ""
    var editPost:Post!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var photosIntialView: UIView!
    @IBOutlet weak var photosFinalView: UIView!
    @IBOutlet weak var videosInitialView: UIView!
    @IBOutlet weak var videosFinalView: UIView!
    @IBOutlet weak var thoughtsInitalView: UIView!
    @IBOutlet weak var thoughtsFinalView: UIView!
    @IBOutlet weak var tagFriendsView: UIView!
    @IBOutlet weak var thoughtsButton: UIButton!
    @IBOutlet weak var tagFriendButton: UIButton!
    @IBOutlet weak var videosButton: UIButton!
    
    var buddies:[Buddy] = []
    
    @IBOutlet weak var finalThoughtTag: UIImageView!
    @IBOutlet weak var photosCount: UILabel!
    @IBOutlet weak var videosCount: UILabel!
    
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var locationTag: UIImageView!
    
    @IBOutlet weak var photosStack: UIStackView!
    @IBOutlet weak var photosButton: UIButton!
    
    @IBOutlet var photosCollection: [UIImageView]!
    
    @IBOutlet weak var friendsCount: UIButton!
    @IBOutlet weak var friendsTag: UIImageView!
    
    @IBOutlet weak var thoughtsTextView: UITextView!
    @IBOutlet weak var thoughtsCharacterCount: UILabel!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postButtonUp: UIButton!
    
    @IBOutlet weak var facebookShare: UIButton!
    @IBOutlet weak var whatsappShare: UIButton!
    @IBOutlet weak var googleShare: UIButton!
    @IBOutlet weak var twitterShare: UIButton!
    @IBOutlet weak var moreOptions: UIButton!
    
    @IBOutlet weak var locationHorizontalScroll: UIScrollView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var editCategory: UIButton!
    
    @IBOutlet weak var editCategoryPickerView: UIPickerView!
    @IBOutlet weak var editCategoryPVBar: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var photoScroll: UIScrollView!
    @IBOutlet weak var postCancelButton: UIButton!
    @IBOutlet weak var photoTag: UIImageView!
    @IBOutlet weak var thoughtInitialTag: UIImageView!
    
    @IBOutlet weak var cancelLocationButton: UIButton!
    @IBOutlet weak var videoTag: UIImageView!
    
    
    var addedBuddies: [JSON] = []
    var tempAssets: [URL] = []
    var allImageIds: [Int] = []
    var localDbPhotoIds: [Int] = []
    
    var previouslyAddedPhotos: [URL]!
    var allAssets: [URL] = []
    
    var imageArr:[PostImage] = []
    
    var photosGroupId = 0
    var photosToBeUploaded: [PhotoUpload] = []
    
    
    let imagePicker = UIImagePickerController()
    var photosAddedMore = false
    var selectPhotosCount = 0
    
    var newScroll : UIScrollView!
    var locationArray: [JSON] = []
    var currentCity = ""
    var currentCountry = ""
    var currentLat: Float!
    var currentLong: Float!
    
    var eachButtonText = ""
    var buttonCollection: [UIButton] = []
    var horizontal: HorizontalLayout!
    var horizontalScrollForPhotos: HorizontalLayout!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        makeFAButton("fbSquare", button: facebookShare)
        makeFAButton("whatsapp", button: whatsappShare)
        makeFAButton("googleSquare", button: googleShare)
        makeFAButton("twitterSquare", button: twitterShare)
        makeFAButton("whatsapp", button: moreOptions)
        makeFAButton("edit", button: editCategory)
        
        horizontal = HorizontalLayout(height: locationHorizontalScroll.frame.height)
        horizontalScrollForPhotos = HorizontalLayout(height: photoScroll.frame.height)
        
        locationHorizontalScroll.addSubview(horizontal)
        photoScroll.addSubview(horizontalScrollForPhotos)
        
        getStylesOn(locationView)
        getStylesOn(photosIntialView)
        getStylesOn(photosFinalView)
        getStylesOn(videosInitialView)
        getStylesOn(videosFinalView)
        getStylesOn(thoughtsInitalView)
        getStylesOn(thoughtsFinalView)
        getStylesOn(tagFriendsView)
        
        thoughtsTextView.delegate = self
        thoughtsTextView.returnKeyType = .done
        
        postButton.layer.cornerRadius = 5.0
        postButton.layer.borderColor = UIColor.white.cgColor
        postButton.layer.borderWidth = 1.0
        self.locationTag.tintColor = mainBlueColor
        self.photoTag.tintColor = mainBlueColor
        self.thoughtInitialTag.tintColor = mainBlueColor
        self.videoTag.tintColor = mainBlueColor
        self.finalThoughtTag.tintColor = mainBlueColor
        self.cancelLocationButton.isHidden = true
        self.friendsCount.isHidden = true;
        self.friendsTag.tintColor = mainBlueColor
        self.finalImageTag.tintColor = mainOrangeColor
    }
    
    func buddyAdded(_ json:[JSON]) {
        addedBuddies = json;
        let count = json.count
        if(count ==  1) {
            self.friendsCount.setTitle("1 Friend", for: UIControlState())
            self.friendsCount.isHidden = false;
            self.friendsTag.tintColor = mainOrangeColor
        } else if(count > 1)  {
            self.friendsCount.setTitle("\(count) Friends", for: UIControlState())
            self.friendsCount.isHidden = false;
            self.friendsTag.tintColor = mainOrangeColor
        } else if (count == 0) {
            self.friendsCount.setTitle("0 Friend", for: UIControlState())
            self.friendsCount.isHidden = true;
            self.friendsTag.tintColor = mainBlueColor
        }
    }
    
    @IBAction func clearLocation(_ sender: Any) {
        self.locationHorizontalScroll.isHidden = false
        self.categoryView.isHidden = true
        self.editCategory.addTarget(self, action: #selector(self.selectAnotherCategory(_:)), for: .touchUpInside)
        self.addLocationButton.setTitle("Add Location", for: UIControlState())
        self.categoryLabel.text = "Label"
        self.locationTag.tintColor = mainBlueColor
        self.cancelLocationButton.isHidden = true
        self.currentLat = 0
        self.currentLong = 0
        self.currentCity = ""
        self.currentCountry = ""
    }
    
    func styleHorizontalButton(_ button: UIButton, buttonTitle: String) {
        button.backgroundColor = UIColor.clear
        button.titleLabel!.font = avenirFont
        button.setTitle(buttonTitle, for: UIControlState())
        button.setTitleColor(mainBlueColor, for: UIControlState())
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        locationHorizontalScroll.contentSize.width += button.frame.width + 10
    }
    
    
    func makeFAButton(_ faValue: String, button: UIButton) {
        let edit = String(format: "%C", faicon[faValue]!)
        button.setTitle(edit, for: .normal)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if thoughtsTextView.text == "Fill Me In..." {
            thoughtsTextView.text = ""
        }
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            thoughtsTextView.resignFirstResponder()
            
            if thoughtsTextView.text == "" {
                
                thoughtsTextView.text = "Fill Me In..."
                
            }
            return true
            
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let number = newText.characters.count
        self.countCharacters(number)
        return number <= 180
        
    }
    
    func countCharacters(_ number:Int) {
        thoughtsCharacterCount.text = String(180 - number)
        
        if(number != 0) {
            self.finalThoughtTag.tintColor = lightOrangeColor
        } else {
            self.finalThoughtTag.tintColor = mainBlueColor
        }
        
        if thoughtsCharacterCount.text == "-1" {
            thoughtsCharacterCount.text = "0"
        }
    }
    
    func resignThoughtsTexViewKeyboard() {
        thoughtsTextView.resignFirstResponder()
    }
    
    
    func getStylesOn(_ view: UIView) {
        view.layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        globalAddActivityNew = self;
        
        
        
        
        self.animation = "squeezeUp"
        self.duration = 1.5
        self.animate()
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddActivityNew", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        addLocationTapped();
        
        self.addLocationButton.addTarget(self, action: #selector(self.gotoSearchLocation(_:)), for: .touchUpInside)
        self.photosButton.addTarget(self, action: #selector(self.addPhotos(_:)), for: .touchUpInside)
        self.videosButton.addTarget(self, action: #selector(self.addVideos(_:)), for: .touchUpInside)
        self.thoughtsButton.addTarget(self, action: #selector(self.addThoughts(_:)), for: .touchUpInside)
        self.tagFriendButton.addTarget(self, action: #selector(self.tagMoreBuddies(_:)), for: .touchUpInside)
        self.postButton.addTarget(self, action: #selector(self.newPost(_:)), for: .touchUpInside)
        //        self.postButtonUp.addTarget(self, action: #selector(NewTLViewController.newPost(_:)), for: .touchUpInside)
        //        self.postCancelButton.addTarget(self, action: #selector(NewTLViewController.closeAdd(_:)), for: .touchUpInside)
    }
    
    func tagMoreBuddies(_ sender: UIButton) {
        self.resignThoughtsTexViewKeyboard()
        if(self.typeOfAddActivtiy != "EditActivity") {
            buddiesStatus = true
        } else {
            buddiesStatus = false
        }
        let next = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
        next.whichView = "AddActivity"
        print(addedBuddies);
        if addedBuddies != nil {
            next.addedFriends = addedBuddies
        }
        globalNavigationController?.setNavigationBarHidden(false, animated: true)
        globalNavigationController?.pushViewController(next, animated: true)
    }
    func addVideos(_ sender: UIButton) {
        let newTl = globalNavigationController.topViewController as! NewTLViewController;
        newTl.addVideos(sender);
    }


    
    func newPost(_ sender: UIButton) {
        
        switch(self.typeOfAddActivtiy) {
            case "AddPhotosVideos":
                let newTl = globalNavigationController.topViewController as! NewTLViewController;
                newTl.savePhotoVideo(sender);
            case "EditActivity":
                let newTl = globalNavigationController.topViewController as! NewTLViewController;
                newTl.editActivity(sender);
            default:
                let newTl = globalNavigationController.topViewController as! NewTLViewController;
                newTl.newPost(sender);   
        }
    }
    
    func closeAdd(_ sender: UIButton) {
        let newTl = globalNavigationController.topViewController as! NewTLViewController;
        newTl.closeAdd(sender);
    }
    
    func addThoughts(_ sender: UIButton) {
        self.thoughtsFinalView.isHidden = false
        self.thoughtsInitalView.isHidden = true
        addHeightToNewActivity(10.0)
        thoughtsTextView.becomeFirstResponder()
    }
    
    func addHeightToNewActivity(_ height: CGFloat) {
        self.frame.size.height = self.frame.height + height
        newScroll.contentSize.height = self.frame.height
        newScroll.bounces = false
        newScroll.showsVerticalScrollIndicator = false
        
    }
    
    func addLocationTapped() {
        
        if userLocation != nil {
            
            print("locations = \(userLocation.latitude) \(userLocation.longitude)")
            
            request.getLocationOTG(userLocation.latitude, long: userLocation.longitude, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    if (response.error != nil) {
                        print("error: \(response.error?.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        print(response["data"]);
                        self.locationArray = response["data"].array!;
                        self.getAllLocations();
                    }
                })
            })
        }
    }
    
    func hideLocation() {
        self.locationHorizontalScroll.isHidden = true
        self.categoryView.isHidden = false
        self.editCategory.addTarget(self, action: #selector(self.selectAnotherCategory(_:)), for: .touchUpInside)
    }
    
    func selectAnotherCategory(_ sender: UIButton) {
        let chooseCategory = storyboard?.instantiateViewController(withIdentifier: "editCategory") as! EditCategoryViewController
        chooseCategory.categoryTextView = self.categoryLabel;
        globalNavigationController?.setNavigationBarHidden(false, animated: true)
        globalNavigationController?.pushViewController(chooseCategory, animated: true)
    }
    
    
    func getAllLocations() {
        
        var locationCount = 5
        if locationArray.count < 5 {
            locationCount = locationArray.count - 1
        }
        if locationCount >= 0 {
            for i in 0 ... locationCount {
                let oneButton = UIButton(frame: CGRect(x: 10, y: 0, width: 200, height: self.locationHorizontalScroll.frame.height))
                self.horizontal.addSubview(oneButton)
                self.styleHorizontalButton(oneButton, buttonTitle: "\(locationArray[i]["name"].string!)")
                oneButton.layoutIfNeeded()
                oneButton.resizeToFitSubviews(self.locationHorizontalScroll.frame.height, finalHeight: self.locationHorizontalScroll.frame.height)
                oneButton.addTarget(self, action: #selector(self.selectLocation(_:)), for: .touchUpInside)
                self.buttonCollection.append(oneButton)
                
            }
        }
        let buttonSix = UIButton(frame: CGRect(x: 10, y: 0, width: 100, height: self.locationHorizontalScroll.frame.height))
        self.horizontal.addSubview(buttonSix)
        self.styleHorizontalButton(buttonSix, buttonTitle: "Search")
        self.buttonCollection.append(buttonSix)
        buttonSix.addTarget(self, action: #selector(self.gotoSearchLocation(_:)), for: .touchUpInside)
    }
    
    func selectLocation(_ sender: UIButton) {
        var id = ""
        for location in locationArray {
            if location["name"].string! == sender.titleLabel!.text! {
                id = location["place_id"].string!
            }
        }
        self.putLocationName(sender.titleLabel!.text!, placeId: id)
    }
    
    func putLocationName(_ selectedLocation: String, placeId: String!) {
        self.addLocationButton.setTitle(selectedLocation, for: UIControlState())
        self.locationTag.tintColor = lightOrangeColor
        self.cancelLocationButton.isHidden = false
        if(placeId != nil) {
            request.getPlaceId(placeId, completion: { response in
                DispatchQueue.main.async(execute: {
                    if response.error != nil { }
                    else if response["value"].bool! {
                        self.categoryLabel.text = response["data"].string!
                        self.currentCity = response["city"].string!
                        self.currentCountry = response["country"].string!
                        self.currentLat = response["lat"].float!
                        self.currentLong = response["long"].float!
                    }
                    else {
                        
                    }
                })
            })

        }
        
        self.hideLocation()
        
    }
    func gotoSearchLocation(_ sender: UIButton) {
        let searchVC = storyboard!.instantiateViewController(withIdentifier: "searchLocationsVC") as! SearchLocationTableViewController
        searchVC.places = self.locationArray
        searchVC.location = userLocation
        globalNavigationController?.setNavigationBarHidden(false, animated: true)
        globalNavigationController?.pushViewController(searchVC, animated: true)
    }
    
    func addPhotos(_ sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhotos = UIAlertAction(title: "Take Photos", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
           
            let configuration = Configuration() { builder in
                builder.configureCameraViewController( { cameraConf in
                        cameraConf.allowedRecordingModes = [.photo]
                })
            }

            let cameraViewController = CameraViewController(configuration:configuration)
//            let cameraViewController = CameraViewController()
            cameraViewController.cameraController?.recordingMode = .photo
            func abc(image:UIImage?,url:URL?) -> Void
            {
                let photoEffect = PhotoEffectThumbnailRenderer(inputImage: image!);
                if(cameraViewController.cameraController?.photoEffect != nil) {
                    photoEffect.generateThumbnails(for: [(cameraViewController.cameraController?.photoEffect)!], of: (image?.size)!, singleCompletion: { (image:UIImage, num:Int) in
                        DispatchQueue.main.async(execute: {
                            let imgA:[UIImage] = [image]
                            cameraViewController.dismiss(animated: true, completion: nil)
                            globalAddActivityNew.photosAdded(assets: imgA)
                        })
                    })
                } else {
                    let imgA:[UIImage] = [image!]
                    cameraViewController.dismiss(animated: true, completion: nil)
                    globalAddActivityNew.photosAdded(assets: imgA)
                }
                
            }
            cameraViewController.completionBlock = abc;
            globalNavigationController?.topViewController?.present(cameraViewController, animated: true, completion: nil)
            
        })
        let photoLibrary = UIAlertAction(title: "Photos Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let multipleImage = BSImagePickerViewController()
            globalNavigationController?.topViewController?.bs_presentImagePickerController(multipleImage, animated: true, select: { (asset: PHAsset) -> Void in
                print("Selected: \(asset)")
            }, deselect: { (asset: PHAsset) -> Void in
                print("Deselected: \(asset)")
            }, cancel: { (assets: [PHAsset]) -> Void in
                print("Cancel: \(assets)")
            }, finish: { (assets: [PHAsset]) -> Void in
                if sender.tag == 1 {
                    self.photosAddedMore = true
                }
                if !self.photosAddedMore {
                    self.photosGroupId += 1
                }
                var img11 = [UIImage]()
                DispatchQueue.main.async {
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    for n in 0...assets.count-1{
                        PHImageManager.default().requestImage(for: assets[n], targetSize: CGSize(width: assets[n].pixelWidth, height: assets[n].pixelHeight), contentMode: .aspectFit, options: options, resultHandler: {(result, info) in
                            img11.append(result!)
                        })
                    }
                    self.photosAdded(assets: img11)
                }
            }, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        optionMenu.addAction(takePhotos)
        optionMenu.addAction(photoLibrary)
        optionMenu.addAction(cancelAction)
        //        optionMenu.addAction(customeAction)
        
        globalNavigationController?.topViewController?.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func photosAdded(assets: [UIImage]) {
        for asset in assets {
            let postImg = PostImage();
            postImg.image = asset.resizeWith(width:800);
            imageArr.append(postImg);
        }
        let captionButton = UIButton()
        captionButton.setImage(imageArr[0].image, for: .normal)
        captionButton.tag = 0
        self.addCaption(captionButton)
        addPhotoToLayout();
    }
    
    func addPhotosAgain(_ sender: UIButton) {
        previouslyAddedPhotos = allAssets
        addPhotos(sender)
    }
    
    
    func addCaption(_ sender: UIButton) {
        let captionVC = storyboard?.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
        captionVC.imageArr = imageArr
        captionVC.addActivity = self
        
        captionVC.currentImageIndex = sender.tag
        globalNavigationController?.setNavigationBarHidden(false, animated: true)
        globalNavigationController!.pushViewController(captionVC, animated: true)
    }

    func addPhotoToLayout() {
        self.horizontalScrollForPhotos.removeAll()
        for i in 0 ..< imageArr.count {
            let photosButton = UIButton(frame: CGRect(x: 10, y: 0, width: 65, height: 65))
            photosButton.setImage(imageArr[i].image, for: .normal)
            photosButton.imageView?.contentMode = UIViewContentMode.scaleAspectFill
            photosButton.layer.cornerRadius = 5.0
            photosButton.tag = i
            photosButton.clipsToBounds = true
            photosButton.addTarget(self, action: #selector(self.addCaption(_:)), for: .touchUpInside)
            self.horizontalScrollForPhotos.addSubview(photosButton)
        }
        if(self.typeOfAddActivtiy != "EditActivity") {
            let addMorePhotosButton = UIButton(frame: CGRect(x: 10, y: 0, width: 65, height: 65))
            addMorePhotosButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            addMorePhotosButton.setImage(UIImage(named: "add_fa_icon"), for: .normal)
            addMorePhotosButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
            addMorePhotosButton.layer.cornerRadius = 5.0
            addMorePhotosButton.clipsToBounds = true
            addMorePhotosButton.addTarget(self, action: #selector(self.addPhotosAgain(_:)), for: .touchUpInside)
            addMorePhotosButton.tag = 1
            self.horizontalScrollForPhotos.addSubview(addMorePhotosButton)
        }
        
        self.horizontalScrollForPhotos.layoutSubviews()
        self.photoScroll.contentSize = CGSize(width: self.horizontalScrollForPhotos.frame.width, height: self.horizontalScrollForPhotos.frame.height)
        photosCount.text = "( " + String(imageArr.count) + " )";
        if(imageArr.count == 0) {
            self.photosIntialView.isHidden = false
            self.photosFinalView.isHidden = true
        } else {
            self.photosIntialView.isHidden = true
            self.photosFinalView.isHidden = false
        }
    }
}
