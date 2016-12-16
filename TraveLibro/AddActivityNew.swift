
import UIKit

var globalAddActivityNew:AddActivityNew!

class AddActivityNew: UIView, UITextViewDelegate {

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
        globalAddActivityNew = self;
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
        
    }
    
    func styleHorizontalButton(_ button: UIButton, buttonTitle: String) {
        
//        print("inside the style horizontal button")
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
        thoughtsCharacterCount.text = String(180 - number)
        
        if thoughtsCharacterCount.text == "-1" {
            
            thoughtsCharacterCount.text = "0"
        }
        
        return number <= 180
        
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
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddActivityNew", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        addLocationTapped();
        
        
        self.addLocationButton.addTarget(self, action: #selector(self.gotoSearchLocation(_:)), for: .touchUpInside)
        self.photosButton.addTarget(self, action: #selector(NewTLViewController.addPhotos(_:)), for: .touchUpInside)
        self.videosButton.addTarget(self, action: #selector(NewTLViewController.addVideos(_:)), for: .touchUpInside)
        self.thoughtsButton.addTarget(self, action: #selector(NewTLViewController.addThoughts(_:)), for: .touchUpInside)
        self.tagFriendButton.addTarget(self, action: #selector(NewTLViewController.tagMoreBuddies(_:)), for: .touchUpInside)
        self.postButton.addTarget(self, action: #selector(NewTLViewController.newPost(_:)), for: .touchUpInside)
        self.postButtonUp.addTarget(self, action: #selector(NewTLViewController.newPost(_:)), for: .touchUpInside)
        self.postCancelButton.addTarget(self, action: #selector(NewTLViewController.closeAdd(_:)), for: .touchUpInside)
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
    
    func putLocationName(_ selectedLocation: String, placeId: String) {
        
        self.addLocationButton.setTitle(selectedLocation, for: UIControlState())
        self.locationTag.tintColor = lightOrangeColor
        request.getPlaceId(placeId, completion: { response in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    
                }
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
        
//        hideLocation()
        
    }
    func gotoSearchLocation(_ sender: UIButton) {
        
        let searchVC = storyboard!.instantiateViewController(withIdentifier: "searchLocationsVC") as! SearchLocationTableViewController
        searchVC.places = self.locationArray
        searchVC.location = userLocation
        globalNavigationController?.setNavigationBarHidden(false, animated: true)
        globalNavigationController?.pushViewController(searchVC, animated: true)
    }


}
