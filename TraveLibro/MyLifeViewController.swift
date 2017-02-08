
import UIKit

var isEmptyProfile = false

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
    
    
    var radioValue: String!
    var firstTime = true
    var verticalLayout: VerticalLayout!
    let titleLabels = ["November 2015 (25)", "October 2015 (25)", "September 2015 (25)", "August 2015 (25)"]
    var whatTab = "Journeys"

    var whatEmptyTab = "Journeys"
    

    
    var radio:UIImageView!
    var radioTwo:UIImageView!
    var radioThree:UIImageView!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var arrowDownButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        let leftButton = UIButton()
        leftButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
        let arrow = String(format: "%C", faicon["arrow-down"]!)
        leftButton.setTitle(arrow, for: UIControlState())
        leftButton.addTarget(self, action: #selector(MyLifeViewController.exitMyLife(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
      
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        if currentUser != nil {
            
            profileName.text = currentUser["name"].string!
        }
        self.title = currentUser["name"].string!
        isEmptyProfile = true
        
        arrowDownButton.setTitle(arrow, for: UIControlState())
        arrowDownButton.addTarget(self, action: #selector(MyLifeViewController.exitMyLife(_:)), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(MyLifeViewController.exitMyLife(_:)))
        profileName.addGestureRecognizer(tap)
        
        
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        statusBar.layer.zPosition = -1
        statusBar.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
        self.view.addSubview(statusBar)
        
        
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
    
    func exitMyLife(_ sender: AnyObject ) {
        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            self.navigationController?.popViewController(animated: true)
            UIView.setAnimationTransition(.curlDown, for: self.navigationController!.view!, cache: false)
        })
        
        
    }
    

    
    func setDefaults() {
        whatEmptyTab = "Journeys"
        var start = 0;
        
        
        whatEmptyTab = "Journeys"
        reviewsButton.layer.zPosition = -1
        momentsButton.layer.zPosition = 1
        journeysButton.layer.zPosition = 3
        
        journeysContainerView.alpha = 1
        collectionContainer.alpha = 0
        tableContainer.alpha = 0
        
        
        radio.image = UIImage(named: "radio_checked_all")
        radioTwo.image = UIImage(named: "radio_for_button")
        radioThree.image = UIImage(named: "radio_for_button")
        
        
    }
    

    func showJourneys(_ sender: UIButton) {
        whatEmptyTab = "Journeys"
        var start = 0;
        
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
    
    func showMoments(_ sender: UIButton) {
        
        whatEmptyTab = "Moments"
        journeysButton.layer.zPosition = -1
        reviewsButton.layer.zPosition = 1
        momentsButton.layer.zPosition = 3
        
        journeysContainerView.alpha = 0
        collectionContainer.alpha = 1
        tableContainer.alpha = 0
        allRadioChecked(sender);
    }
    
    func showReviews(_ sender: UIButton) {
        
        whatEmptyTab = "Reviews"
        momentsButton.layer.zPosition = -1
        journeysButton.layer.zPosition = 1
        reviewsButton.layer.zPosition = 3
        
        journeysContainerView.alpha = 0
        collectionContainer.alpha = 0
        tableContainer.alpha = 1
        allRadioChecked(sender);
        
    }
    
    func showReviewsExtention(type:String) {
        
        if type == "travel-life" || type == "local-life" {
            
            journeysContainerView.alpha = 0
            collectionContainer.alpha = 1
            tableContainer.alpha = 0
            
        }else{
            
            journeysContainerView.alpha = 0
            collectionContainer.alpha = 0
            tableContainer.alpha = 1
        }
        
    }
    
//    var flag = false
    
    func allRadioChecked(_ sender: AnyObject?) {
        radio.image = UIImage(named: "radio_checked_all")
        radioTwo.image = UIImage(named: "radio_for_button")
        radioThree.image = UIImage(named: "radio_for_button")
        
        switch whatEmptyTab {
        case "Journeys": 
            globalMyLifeContainerViewController.loadData("all", pageNumber: 1);
        case "Moments":
            globalMyLifeMomentsViewController.page = 1
            globalMyLifeMomentsViewController.insideView = ""

            globalMyLifeMomentsViewController.loadMomentLife(pageno: 1, type: "all", token: "")
        case "Reviews":
            globalAccordionViewController.whichView = ""
            globalAccordionViewController.loadReview(pageno: 1, type: "all")
            showReviewsExtention(type:"all")

        default: break
            
        }
    }
    
    func travelLifeRadioChecked(_ sender: AnyObject?) {
        radio.image = UIImage(named: "radio_for_button")
        radioTwo.image = UIImage(named: "radio_checked_travel_life")
        radioThree.image = UIImage(named: "radio_for_button")
        
        switch whatEmptyTab {
        case "Journeys":
            globalMyLifeContainerViewController.loadData("travel-life", pageNumber: 1);
        case "Moments":
            globalMyLifeMomentsViewController.page = 1
            globalMyLifeMomentsViewController.insideView = ""
            globalMyLifeMomentsViewController.loadMomentLife(pageno: 1, type: "travel-life", token: "")
        case "Reviews":
            globalMyLifeMomentsViewController.page = 1
            globalMyLifeMomentsViewController.loadReview(pageno: 1, type: "review", review: "travel-life")
            showReviewsExtention(type:"travel-life")

        default: break
            
        }
    }
    
    func localLifeRadioChecked(_ sender: AnyObject?) {
        radio.image = UIImage(named: "radio_for_button")
        radioTwo.image = UIImage(named: "radio_for_button")
        radioThree.image = UIImage(named: "radio_checked_local_life")
        
        switch whatEmptyTab {
        case "Journeys":
            globalMyLifeContainerViewController.loadData("local-life", pageNumber: 1);
        case "Moments":
            globalMyLifeMomentsViewController.page = 1
            globalMyLifeMomentsViewController.insideView = ""

            globalMyLifeMomentsViewController.loadMomentLife(pageno: 1, type: "local-life", token: "")
        case "Reviews":
            globalMyLifeMomentsViewController.page = 1
            globalMyLifeMomentsViewController.loadReview(pageno: 1, type: "review", review: "local-life")
            showReviewsExtention(type:"local-life")

        default: break
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
}
