
import UIKit

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
//    @IBAction func cancelTapped(sender: AnyObject) {
//        
//        self.hidden = true
//        
//    }
    
    
    var eachButtonText = ""
    var buttonCollection: [UIButton] = []
    var horizontal: HorizontalLayout!
    var horizontalScrollForPhotos: HorizontalLayout!
    
//    var parent = NewTLViewController()
    
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
        
//        editCategoryPickerView.isHidden = true
//        editCategoryPVBar.isHidden = true
        
        locationHorizontalScroll.addSubview(horizontal)
        photoScroll.addSubview(horizontalScrollForPhotos)
        
//        photosFinalView.isHidden = true
//        videosFinalView.isHidden = true
//        thoughtsFinalView.isHidden = true
        
//        for photo in photosCollection {
//            
//            photo.layer.cornerRadius = 5.0
//            
//        }
        
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
        
        thoughtsTextView.text = ""
        
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
    
//    var dropdownCityOptions: [String] = ["one", "two", "three", "four", "five", "six"]
//    
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//        
//        return 1
//    }
//    
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        
//        return dropdownCityOptions.count
//    }
//    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        
//        return dropdownCityOptions[row]
//    }
    
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
    }

}
