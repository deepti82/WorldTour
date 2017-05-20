
import UIKit

var isEmptyProfile = false
var globalMyLifeController: MyLifeViewController!
var globalMyLifeViewController:MyLifeViewController!
class MyLifeViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewZero: UIView!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var momentsButton: UIButton!
    @IBOutlet weak var journeysButton: UIButton!
    
    @IBOutlet weak var journeysWC: NSLayoutConstraint!
    @IBOutlet weak var momentsWC: NSLayoutConstraint!
    @IBOutlet weak var reviewsWC: NSLayoutConstraint!
    
    @IBOutlet weak var allRadio: UIButton!
    @IBOutlet weak var TLRadio: UIButton!
    @IBOutlet weak var LLRadio: UIButton!
    
    @IBOutlet weak var journeysContainerView: UIView!
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var tableContainer: UIView!
    
    var isFromFooter = false
    var mainFooter: FooterViewNew?
    
    var whichTab: String = ""
    var type = "on-the-go-journey"
    var journey: [JSON]!
    var displayData:String = ""
    var newScroll: UIScrollView!
    var backView:UIView!
    var addView: AddActivityNew!
    var journeyId = ""
    var radioValue: String!
    var firstTime = true
    
    var verticalLayout: VerticalLayout!
    let titleLabels = ["November 2015 (25)", "October 2015 (25)", "September 2015 (25)", "August 2015 (25)"]
    var whatTab = "Journeys"
    
    var whatEmptyTab = "Journeys"
    var currentIndex: Int!
    var feeds: JSON! = []
    var radio:UIImageView!
    var radioTwo:UIImageView!
    var radioThree:UIImageView!
    var loader = LoadingOverlay()
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var arrowDownButton: UIButton!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalMyLifeViewController = self
        getDarkBackGround(self)
        globalMyLifeController = self
        
//        if isFromFooter {
//            setNavigationBarItem()
//            
//            self.mainFooter = FooterViewNew(frame: CGRect.zero)
//            self.mainFooter.layer.zPosition = 5
//            self.view.addSubview(self.mainFooter)
//            
//            arrowDownButton.isHidden = true
//        }
//        else {
            let leftButton = UIButton()
            leftButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)        
            let arrow = String(format: "%C", faicon["arrow-down"]!)
            leftButton.setTitle(arrow, for: UIControlState())
            leftButton.addTarget(self, action: #selector(MyLifeViewController.exitMyLife(_:)), for: .touchUpInside)
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            self.customNavigationBar(left: leftButton, right: rightButton)
            
            arrowDownButton.setTitle(arrow, for: UIControlState())
            arrowDownButton.addTarget(self, action: #selector(MyLifeViewController.exitMyLife(_:)), for: .touchUpInside)
            arrowDownButton.isHidden = false
//        }
        
        if currentUser != nil {            
            profileName.text = selectedUser.isEmpty ? currentUser["name"].string! : selectedUser["name"].string!
        }
        
        if isFromFooter {
            self.title = currentUser["name"].stringValue
        }
        else {
            self.title = selectedUser.isEmpty ? currentUser["name"].string! : selectedUser["name"].string!
        }
        
        isEmptyProfile = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MyLifeViewController.exitMyLife(_:)))
        profileName.addGestureRecognizer(tap)
        
        
//        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
//        statusBar.layer.zPosition = -1
//        statusBar.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
//        self.view.addSubview(statusBar)
        
        
        let frameWidth = self.view.frame.width - 25
        
        journeysWC.constant = frameWidth/3
        momentsWC.constant = frameWidth/3
        reviewsWC.constant = frameWidth/3
        
        reviewsButton.layer.zPosition = -1
        momentsButton.layer.zPosition = 1
        journeysButton.layer.zPosition = 3
        
        viewZero.layer.zPosition = 0
        viewOne.layer.zPosition = 2
        viewTwo.layer.zPosition = 4
        
        journeysButton.addTarget(self, action: #selector(MyLifeViewController.showJourneys(_:)), for: .touchUpInside)
        momentsButton.addTarget(self, action: #selector(MyLifeViewController.showMoments(_:)), for: .touchUpInside)
        reviewsButton.addTarget(self, action: #selector(MyLifeViewController.showReviews(_:)), for: .touchUpInside)
        
        viewBorder(viewZero)
        viewBorder(viewOne)
        viewBorder(viewTwo)
        
        buttonsView.clipsToBounds = true
        
        buttonShadow(journeysButton)
        buttonShadow(momentsButton)
        buttonShadow(reviewsButton)
        
        radio = UIImageView(frame: CGRect(x: -18, y: 2, width: 15, height: 15))
        radio.image = UIImage(named: "radio_for_button")
        radio.contentMode = .scaleAspectFit
        
        radioTwo = UIImageView(frame: CGRect(x: -18, y: 2, width: 15, height: 15))
        radioTwo.image = UIImage(named: "radio_for_button")
        radioTwo.contentMode = .scaleAspectFit
        
        radioThree = UIImageView(frame: CGRect(x: -18, y: 2, width: 15, height: 15))
        radioThree.image = UIImage(named: "radio_for_button")
        radioThree.contentMode = .scaleAspectFit
        
        allRadio.titleLabel?.addSubview(radio)
        TLRadio.titleLabel?.addSubview(radioTwo)
        LLRadio.titleLabel?.addSubview(radioThree)
        
        allRadio.addTarget(self, action: #selector(MyLifeViewController.allRadioChecked(_:)), for: .touchUpInside)
        TLRadio.addTarget(self, action: #selector(MyLifeViewController.travelLifeRadioChecked(_:)), for: .touchUpInside)
        LLRadio.addTarget(self, action: #selector(MyLifeViewController.localLifeRadioChecked(_:)), for: .touchUpInside)
        
        setDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if isFromFooter {
//            self.mainFooter.frame = CGRect(x: 0, y: self.view.frame.height - MAIN_FOOTER_HEIGHT, width: self.view.frame.width, height: MAIN_FOOTER_HEIGHT)
//            self.mainFooter.setHighlightStateForView(tag: 2, color: mainOrangeColor)
//            globalNavigationController = self.navigationController
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        if isFromFooter {
//        self.mainFooter.setFooterDefaultState()
        }
    }
    
    func showLoader() {
        loader.showOverlay(self.view)
    }
    
    func hideLoader() {
        loader.hideOverlayView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Actions
    
    func reloadContainerData() {
        globalMyLifeContainerViewController.loadData(type: globalMyLifeContainerViewController.onTab, fromVC: self)
    }
    
    func exitMyLife(_ sender: AnyObject ) {
        if !isFromFooter {
            _ = self.navigationController?.popViewController(animated: false)
        }
        else{
            leftViewController.profileTap(nil)
        }
    }
    
    func setDefaults() {
        
//        whatEmptyTab = "Journeys"
        
//        whatEmptyTab = "Journeys"
        reviewsButton.layer.zPosition = -1
        momentsButton.layer.zPosition = 1
        journeysButton.layer.zPosition = 3
        
        journeysContainerView.alpha = 1
        collectionContainer.alpha = 0
        tableContainer.alpha = 0
        
        
        radio.image = UIImage(named: "radio_checked_all")
        radioTwo.image = UIImage(named: "radio_for_button")
        radioThree.image = UIImage(named: "radio_for_button")
        
        switch whatEmptyTab {
        case "Journeys":
            showJourneys(nil)
        case "Moments":
            showMoments(nil)
        case "Reviews":
            showReviews(nil)
        default:
            showJourneys(nil)
        }
    }
    
    
    func showJourneys(_ sender: AnyObject?) {
        whatEmptyTab = "Journeys"
        
        // where to check review
        whatEmptyTab = "Journeys"
        reviewsButton.layer.zPosition = -1
        momentsButton.layer.zPosition = 1
        journeysButton.layer.zPosition = 3
        
        journeysContainerView.alpha = 1
        collectionContainer.alpha = 0
        tableContainer.alpha = 0
        allRadioChecked(sender);
    }
    
    func showMoments(_ sender: AnyObject?) {
        
        whatEmptyTab = "Moments"
        journeysButton.layer.zPosition = -1
        reviewsButton.layer.zPosition = 1
        momentsButton.layer.zPosition = 3
        
        journeysContainerView.alpha = 0
        collectionContainer.alpha = 1
        tableContainer.alpha = 0
        allRadioChecked(sender);
    }
    
    func showReviews(_ sender: AnyObject?) {
        
        whatEmptyTab = "Reviews"
        momentsButton.layer.zPosition = -1
        journeysButton.layer.zPosition = 1
        reviewsButton.layer.zPosition = 3
        
        journeysContainerView.alpha = 0
        collectionContainer.alpha = 0
        tableContainer.alpha = 1
        allRadioChecked(sender);
        
    }
    
    func showReviewsExtention(type:String, inside:Bool, params:String, id:String, name:String) {
        
        if inside {
            journeysContainerView.alpha = 0
            collectionContainer.alpha = 0
            tableContainer.alpha = 1
        }else{
            switch type {
            case "travel-life", "local-life":
                journeysContainerView.alpha = 0
                collectionContainer.alpha = 1
                tableContainer.alpha = 0
            case "all":
                journeysContainerView.alpha = 0
                collectionContainer.alpha = 0
                tableContainer.alpha = 1
            default:
                journeysContainerView.alpha = 0
                collectionContainer.alpha = 0
                tableContainer.alpha = 1
                if params == "country" {
                    globalAccordionViewController.country = id
                    globalAccordionViewController.countryName = name
                }else if params == "city" {
                    globalAccordionViewController.city = id
                    globalAccordionViewController.cityName = name
                }
                globalAccordionViewController.loadByLocation(location: params, id: id)
                
            }
            
        }
        
    }
    
    
    
    //    var flag = false
    
    func allRadioChecked(_ sender: AnyObject?) {
        radio.image = UIImage(named: "radio_checked_all")
        radioTwo.image = UIImage(named: "radio_for_button")
        radioThree.image = UIImage(named: "radio_for_button")
        switch whatEmptyTab {
        case "Journeys":
            globalMyLifeContainerViewController.isFromFooter = self.isFromFooter
            globalMyLifeContainerViewController.loadData(type: "all", fromVC: self)
        case "Moments":
            globalMyLifeMomentsViewController.page = 1
            globalMyLifeMomentsViewController.insideView = ""
            
            globalMyLifeMomentsViewController.loadMomentLife(pageno: 1, type: "all", token: "")
        case "Reviews":
            globalAccordionViewController.whichView = ""
            globalAccordionViewController.loadReview(pageno: 1, type: "all")
            showReviewsExtention(type:"all",inside: false, params: "", id: "", name: "")
            
        default: break
            
        }
    }
    
    func travelLifeRadioCheckExtention() {
        radio.image = UIImage(named: "radio_for_button")
        radioTwo.image = UIImage(named: "radio_checked_travel_life")
        radioThree.image = UIImage(named: "radio_for_button")
        switch whatEmptyTab {
        case "Journeys":
            globalMyLifeContainerViewController.loadData(type: "travel-life", fromVC: self)
        case "Moments":
            globalMyLifeMomentsViewController.page = 1
            globalMyLifeMomentsViewController.insideView = ""
            globalMyLifeMomentsViewController.loadMomentLife(pageno: 1, type: "travel-life", token: "")
        case "Reviews":
            globalMyLifeMomentsViewController.page = 1
            globalMyLifeMomentsViewController.insideView = ""
            globalMyLifeMomentsViewController.loadReview(pageno: 1, type: "review", review: "travel-life")
            showReviewsExtention(type:"travel-life", inside: false, params: "", id: "", name: "")
            
        default: break
            
        }
    }
    
    func localLifeRadioCheckExtention() {
        radio.image = UIImage(named: "radio_for_button")
        radioTwo.image = UIImage(named: "radio_for_button")
        radioThree.image = UIImage(named: "radio_checked_local_life")
        
        switch whatEmptyTab {
        case "Journeys":
            globalMyLifeContainerViewController.loadData(type: "local-life", fromVC: self)
        case "Moments":
            globalMyLifeMomentsViewController.page = 1
            globalMyLifeMomentsViewController.insideView = ""
            
            globalMyLifeMomentsViewController.loadMomentLife(pageno: 1, type: "local-life", token: "")
        case "Reviews":
            globalMyLifeMomentsViewController.page = 1
            globalMyLifeMomentsViewController.insideView = ""
            globalMyLifeMomentsViewController.loadReview(pageno: 1, type: "review", review: "local-life")
            showReviewsExtention(type:"local-life", inside: false, params: "", id: "", name: "")
            
        default: break
            
        }
    }
    
    func travelLifeRadioChecked(_ sender: AnyObject?) {
        ATL = "travel-life"
        travelLifeRadioCheckExtention()
        
    }
    
    func localLifeRadioChecked(_ sender: AnyObject?) {
        ATL = "local-life"
        localLifeRadioCheckExtention()
        
    }
    
    func viewBorder(_ sender: UIView) {
        
        sender.layer.shadowColor = UIColor.darkGray.cgColor
        sender.layer.shadowOpacity = 0.6
        sender.layer.shadowOffset = CGSize(width: 0, height: -1)
        sender.layer.shadowRadius = 5.0
        //        sender.clipsToBounds = true
        
    }
    
    func buttonShadow(_ sender: UIButton) {
        
        sender.layer.shadowColor = UIColor.darkGray.cgColor
        sender.layer.shadowOpacity = 0.4
        sender.layer.shadowOffset = CGSize(width: 1, height: 0)
        sender.layer.shadowRadius = 3.0
        
        sender.layer.cornerRadius = 5.0
        
    }
    
    
 // For Edit Activity
    
    
    func showEditActivity(_ postJson:JSON) {
        
        let post = Post();
        post.jsonToPost(postJson)
        
   
        var darkBlur: UIBlurEffect!
        var blurView: UIVisualEffectView!
        self.backView = UIView();
        self.backView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.view.addSubview(self.backView)
        darkBlur = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.backView.frame.height
        blurView.frame.size.width = self.backView.frame.width
        blurView.layer.zPosition = -1
        blurView.isUserInteractionEnabled = false
        self.backView.addSubview(blurView)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: darkBlur)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        blurView.contentView.addSubview(vibrancyEffectView)
        
        self.newScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height ))
        self.backView.addSubview(self.newScroll)
        self.addView = AddActivityNew()
        
        self.addView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.addView.editPost = post
        self.addView.newScroll = self.newScroll;
        
        self.newScroll.contentSize.height = self.view.frame.height
        self.newScroll.contentSize.width = 0
        backView.addSubview(newScroll)
        
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.closeAdd(_:)), for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        
        rightButton.setTitle("Post", for: UIControlState())
        rightButton.titleLabel?.font = avenirBold
        //        rightButton.addTarget(self, action: #selector(self.editActivity(_:) ), for: .touchUpInside)
        globalNavigationController.topViewController?.title = "Edit Activity"
        globalNavigationController.topViewController?.customNavigationBar(left: leftButton, right: rightButton)
        self.addView.layer.zPosition = 10
        
        backView.layer.zPosition = 10
        newScroll.contentSize.height = self.view.frame.height
        newScroll.contentSize.width = 0
        
        self.addView.typeOfAddActivtiy = "EditActivity"
        if(post.imageArr.count > 0) {
            self.addView.imageArr = post.imageArr
            self.addView.addPhotoToLayout();
        }
        if(post.videoArr.count > 0) {
            let videoUrl = URL(string:post.videoArr[0].serverUrl)
            self.addView.addVideoToBlock(video: videoUrl)
            self.addView.videoCaption = post.videoArr[0].caption
        }
        
        if(post.post_thoughts != "") {
            self.addView.thoughtsTextView.text = post.post_thoughts
            self.addView.thoughtsFinalView.isHidden = false
            self.addView.thoughtsInitalView.isHidden = true
            self.addView.addHeightToNewActivity(10.0)
            self.addView.countCharacters(post.post_thoughts.characters.count)
        }
        
        if(post.post_location != "") {
            self.addView.putLocationName(post.post_location, placeId: nil)
            self.addView.categoryLabel.text = post.post_category
            self.addView.currentCity = post.post_city
            self.addView.currentCountry = post.post_country
            self.addView.currentLat = Float(post.post_latitude)
            self.addView.currentLong = Float(post.post_longitude)
        }
        self.addView.prevBuddies = post.jsonPost["buddies"].array!
        self.addView.buddyAdded(post.jsonPost["buddies"].array!)
        
        self.newScroll.addSubview(self.addView)
    }
    
    func closeAdd(_ sender: UIButton) {
        hideAddActivity()
    }
    
    func hideAddActivity() {
        addView.removeFromSuperview()
        backView.removeFromSuperview()
        let leftButton = UIButton()
        leftButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
        let arrow = String(format: "%C", faicon["arrow-down"]!)
        leftButton.setTitle(arrow, for: UIControlState())
        leftButton.addTarget(self, action: #selector(MyLifeViewController.exitMyLife(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        self.customNavigationBar(left: leftButton, right: rightButton)
        self.title = currentUser["name"].string!
    }

    // Change date and Time
    var currentPhotoFooter:ActivityFeedFooterBasic!
    var currentPhotoFooter2:ActivityFeedFooterBasic!
    var inputview:UIView!
    var datePickerView:UIDatePicker!
    var dateSelected = ""
    var timeSelected = ""
    
    func changeDateAndTime(_ footer:ActivityFeedFooterBasic) {
        currentPhotoFooter = footer
        hideHeaderAndFooter(true)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        self.inputview = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 240, width: self.view.frame.size.width, height: 240))
        self.inputview.backgroundColor = UIColor.white
        self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.inputview.frame.size.width, height: 240))
        self.datePickerView.datePickerMode = UIDatePickerMode.dateAndTime                
        var showDate = dateFormatter.string(from: Date())        
        switch footer.postTop["type"].stringValue {
        case "on-the-go-journey":
            fallthrough
        case "ended-journey":
            fallthrough
        case "quick-itinerary":
            fallthrough
        case "detail-itinerary":
            showDate = footer.postTop["updatedAt"].stringValue
            break
            
        default:
            showDate = footer.postTop["UTCModified"].stringValue
        }        
        
        self.datePickerView.date = dateFormatter.date(from: showDate)!
        self.datePickerView.maximumDate = Date()
        
        self.backView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 280, width: self.view.frame.size.width, height: 40))
        self.backView.backgroundColor = UIColor(hex: "#272b49")
        self.inputview.addSubview(self.datePickerView) // add date picker to UIView
        
        let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 100, height: 40))
        doneButton.setTitle("Save", for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        cancelButton.setTitleColor(UIColor.white, for: UIControlState())
        self.inputview.addSubview(self.backView)
        self.backView.addSubview(doneButton) // add Button to UIView
        self.backView.addSubview(cancelButton) // add Cancel to UIView
        
        doneButton.addTarget(self, action: #selector(self.doneButton(_:)), for: .touchUpInside) // set button click event
        cancelButton.addTarget(self, action: #selector(self.cancelButton(_:)), for: .touchUpInside) // set button click event
        
        self.datePickerView.addTarget(self, action: #selector(NewTLViewController.handleDatePicker(_:)), for: .valueChanged)
        
        self.handleDatePicker(self.datePickerView) // Set the date on start.
        self.view.addSubview(self.backView)
        self.view.addSubview(self.inputview)
    }
    
    func changeDateAndTimeEndJourney(_ footer:ActivityFeedFooterBasic) {
        currentPhotoFooter2 = footer
        hideHeaderAndFooter(true)
        let dateFormatter = DateFormatter()
        print(footer.postTop);
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        self.inputview = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 264, width: self.view.frame.size.width, height: 240))
        self.inputview.backgroundColor = UIColor.white
        self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 10, width: self.inputview.frame.size.width, height: 200))
        self.datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        self.datePickerView.minimumDate = dateFormatter.date(from: footer.postTop["postLastTime"].stringValue)!
        self.datePickerView.date = dateFormatter.date(from: footer.postTop["endTime"].stringValue)!
        self.datePickerView.maximumDate = Date()
        self.backView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 304, width: self.view.frame.size.width, height: 40))
        self.backView.backgroundColor = UIColor(hex: "#272b49")
        self.inputview.addSubview(self.datePickerView) // add date picker to UIView
        let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 100, height: 40))
        doneButton.setTitle("Save", for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        cancelButton.setTitleColor(UIColor.white, for: UIControlState())
        self.inputview.addSubview(self.backView)
        self.backView.addSubview(doneButton) // add Button to UIView
        self.backView.addSubview(cancelButton) // add Cancel to UIView
        
        doneButton.addTarget(self, action: #selector(self.doneButtonJourney(_:)), for: .touchUpInside) // set button click event
        cancelButton.addTarget(self, action: #selector(self.cancelButton(_:)), for: .touchUpInside) // set button click event
        
        self.datePickerView.addTarget(self, action: #selector(NewTLViewController.handleDatePicker(_:)), for: .valueChanged)
        
        self.handleDatePicker(self.datePickerView) // Set the date on start.
        self.view.addSubview(self.backView)
        self.view.addSubview(self.inputview)
    }
    
    func cancelButton(_ sender: UIButton){
        self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
        self.backView.removeFromSuperview()
        hideHeaderAndFooter(false)
    }

    func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        dateSelected = dateFormatter.string(from: sender.date)
        timeSelected = timeFormatter.string(from: sender.date.toGlobalTime())
    }
    
    func doneButtonJourney(_ sender: UIButton){
        
        request.journeyChangeEndTime("\(dateSelected) \(timeSelected)", journeyId: currentPhotoFooter2.postTop["_id"].stringValue) { (response) in
            
        }
        self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
        self.backView.removeFromSuperview()
        hideHeaderAndFooter(false)
    }


    func doneButton(_ sender: UIButton){
        
        request.changeDateTimeLocal(currentPhotoFooter.postTop["_id"].stringValue, date: "\(dateSelected) \(timeSelected)", completion: {(response) in
            print(response)
            globalMyLifeContainerViewController.changeDateTag()
//            self.getJourney()
        })
        self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
        self.backView.removeFromSuperview()
        hideHeaderAndFooter(false)
    }

    
    // Add PhotosVideo
    
    func showEditAddActivity(_ postJson:JSON) {
        let post = Post();
        post.jsonToPost(postJson)
        print(postJson);
        var darkBlur: UIBlurEffect!
        var blurView: UIVisualEffectView!
        self.backView = UIView();
        self.backView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.view.addSubview(self.backView)
        self.backView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        darkBlur = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.backView.frame.height
        blurView.frame.size.width = self.backView.frame.width
        blurView.layer.zPosition = -1
        blurView.isUserInteractionEnabled = false
        self.backView.addSubview(blurView)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: darkBlur)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        blurView.contentView.addSubview(vibrancyEffectView)
        self.newScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height ))
        self.backView.addSubview(self.newScroll)
        self.addView = AddActivityNew()
        self.addView.buddyAdded(postJson["buddies"].arrayValue)
        
        self.addView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.addView.editPost = post
        self.addView.newScroll = self.newScroll;
        
        self.newScroll.contentSize.height = self.view.frame.height
        newScroll.contentSize.width = 0
        backView.addSubview(newScroll)
        
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.closeAdd(_:)), for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        
        rightButton.setTitle("Post", for: UIControlState())
        rightButton.titleLabel?.font = avenirBold
//        rightButton.addTarget(self, action: #selector(self.savePhotoVideo(_:) ), for: .touchUpInside)
        globalNavigationController.topViewController?.title = "Add Photos/Videos"
        globalNavigationController.topViewController?.customNavigationBar(left: leftButton, right: rightButton)
        self.addView.layer.zPosition = 10
        
        backView.layer.zPosition = 10
        newScroll.contentSize.height = self.view.frame.height
        newScroll.contentSize.width = 0
        
        if(post.videoArr.count > 0) {
            let videoUrl = URL(string:post.videoArr[0].serverUrl)
            self.addView.addVideoToBlock(video: videoUrl)
        }
        
        self.addView.locationView.alpha = 0.1
        self.addView.locationView.isUserInteractionEnabled = false
        
        self.addView.locationView.alpha = 0.1
        self.addView.locationView.isUserInteractionEnabled = false
        
        self.addView.thoughtsInitalView.alpha = 0.1
        self.addView.thoughtsInitalView.isUserInteractionEnabled = false
        
        self.addView.tagFriendsView.alpha = 1
        self.addView.tagFriendsView.isUserInteractionEnabled = true
        self.addView.typeOfAddActivtiy = "AddPhotosVideos"
        self.newScroll.addSubview(self.addView)
    }
    
    func hideHeaderAndFooter(_ isShow:Bool) {
        if isFromFooter {
            if(isShow) {
                self.mainFooter?.frame.origin.y = self.view.frame.height + MAIN_FOOTER_HEIGHT
            } else {
                self.mainFooter?.frame.origin.y = self.view.frame.height - MAIN_FOOTER_HEIGHT
            }
        }
    }
}
