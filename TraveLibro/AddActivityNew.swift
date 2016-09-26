
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
    
    @IBOutlet weak var photosCount: UILabel!
    @IBOutlet weak var videosCount: UILabel!
    
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var locationTag: UIImageView!
    
    @IBOutlet weak var photosButton: UIButton!
    
    @IBOutlet var photosCollection: [UIImageView]!
    
    @IBOutlet weak var friendsCount: UIButton!
    
    @IBOutlet weak var thoughtsTextView: UITextView!
    @IBOutlet weak var thoughtsCharacterCount: UILabel!
    
    @IBOutlet weak var postButton: UIButton!
    
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
    
    var eachButtonText = ""
    var buttonCollection: [UIButton] = []
    var horizontal: HorizontalLayout!
//    var parent = NewTLViewController()
    
    var darkBlur: UIBlurEffect!
    var blurView: UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        darkBlur = UIBlurEffect(style: .Dark)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.frame.height
        blurView.frame.size.width = self.frame.width
        blurView.layer.zPosition = -1
        blurView.userInteractionEnabled = false
        self.addSubview(blurView)
        
        makeFAButton("fbSquare", button: facebookShare)
        makeFAButton("whatsapp", button: whatsappShare)
        makeFAButton("googleSquare", button: googleShare)
        makeFAButton("twitterSquare", button: twitterShare)
        makeFAButton("whatsapp", button: moreOptions)
        makeFAButton("edit", button: editCategory)
        
        horizontal = HorizontalLayout(height: locationHorizontalScroll.frame.height)
        
        editCategoryPickerView.hidden = true
        editCategoryPVBar.hidden = true
//        editCategoryPickerView.delegate = self
        
//        for i in 0 ..< 5 {
//            
//            let oneButton = UIButton(frame: CGRect(x: 10, y: 0, width: 100, height: locationHorizontalScroll.frame.height))
//            horizontal.addSubview(oneButton)
//            styleHorizontalButton(oneButton, buttonTitle: eachButtonText)
//            buttonCollection.append(oneButton)
//            
//        }
        
//        let buttonOne = UIButton(frame: CGRect(x: 10, y: 0, width: 100, height: locationHorizontalScroll.frame.height))
//        horizontal.addSubview(buttonOne)
//        styleHorizontalButton(buttonOne, buttonTitle: "buttonOne")
//       
//        
//        let buttonTwo = UIButton(frame: CGRect(x: 10, y: 0, width: 100, height: locationHorizontalScroll.frame.height))
//        horizontal.addSubview(buttonTwo)
//        styleHorizontalButton(buttonTwo, buttonTitle: "buttonTwo")
//        
//        let buttonThree = UIButton(frame: CGRect(x: 10, y: 0, width: 100, height: locationHorizontalScroll.frame.height))
//        horizontal.addSubview(buttonThree)
//        styleHorizontalButton(buttonThree, buttonTitle: "buttonOne")
//        
//        let buttonFour = UIButton(frame: CGRect(x: 10, y: 0, width: 100, height: locationHorizontalScroll.frame.height))
//        horizontal.addSubview(buttonFour)
//        styleHorizontalButton(buttonFour, buttonTitle: "buttonFour")
//        
//        let buttonFive = UIButton(frame: CGRect(x: 10, y: 0, width: 100, height: locationHorizontalScroll.frame.height))
//        horizontal.addSubview(buttonFive)
//        styleHorizontalButton(buttonFive, buttonTitle: "buttonFive")
        
        
        locationHorizontalScroll.addSubview(horizontal)
        
        photosFinalView.hidden = true
        videosFinalView.hidden = true
        thoughtsFinalView.hidden = true
        
        for photo in photosCollection {
            
            photo.layer.cornerRadius = 5.0
            
        }
        
        getStylesOn(locationView)
        getStylesOn(photosIntialView)
        getStylesOn(photosFinalView)
        getStylesOn(videosInitialView)
        getStylesOn(videosFinalView)
        getStylesOn(thoughtsInitalView)
        getStylesOn(thoughtsFinalView)
        getStylesOn(tagFriendsView)
        
        thoughtsTextView.delegate = self
        thoughtsTextView.returnKeyType = .Done
        
        postButton.layer.cornerRadius = 5.0
        postButton.layer.borderColor = UIColor.whiteColor().CGColor
        postButton.layer.borderWidth = 1.0
        
    }
    
    func styleHorizontalButton(button: UIButton, buttonTitle: String) {
        
//        print("inside the style horizontal button")
        button.backgroundColor = UIColor.clearColor()
        button.titleLabel!.font = avenirFont
        button.setTitle(buttonTitle, forState: .Normal)
        button.setTitleColor(mainBlueColor, forState: .Normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.darkGrayColor().CGColor
        button.layer.borderWidth = 1.0
        locationHorizontalScroll.contentSize.width += button.frame.width + 10
        
    }
    
    
    func makeFAButton(faValue: String, button: UIButton) {
        
        let edit = String(format: "%C", faicon[faValue]!)
        button.setTitle(edit, forState: .Normal)
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        thoughtsTextView.text = ""
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            thoughtsTextView.resignFirstResponder()
            
            if thoughtsTextView.text == "" {
                
                thoughtsTextView.text = "Fill Me In..."
                
            }
            return true
            
        }
        
        let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
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
    
    func getStylesOn(view: UIView) {
        
        view.layer.cornerRadius = 5.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddActivityNew", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}
