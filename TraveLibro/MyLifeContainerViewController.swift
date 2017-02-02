import UIKit
var globalMyLifeContainerViewController:MyLifeContainerViewController!
class MyLifeContainerViewController: UIViewController {
    
    @IBOutlet weak var TheScrollView: UIScrollView!
    
    var layout: VerticalLayout!
    var whichView = "All"
    var whichEmptyView = "Journeys-All"
    var isInitalLoad = true
    var empty: EmptyScreenView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalMyLifeContainerViewController = self;
        isEmptyProfile = false
        
        layout = VerticalLayout(width: self.view.frame.width);
        TheScrollView.addSubview(layout)
        
        if isEmptyProfile {
            if isInitalLoad {
                empty = EmptyScreenView(frame: CGRect(x: 0, y: 0, width: layout.frame.width, height: 250))
                self.addHeightToLayout()
                layout.addSubview(empty)
                isInitalLoad = false
            }
            switch whichEmptyView {
            case "Journeys-All":
                print("in journeys all")
                empty.frame.size.height = 275.0
                empty.viewHeading.text = "Travel in a Time Machine"
                empty.viewBody.text = "Capture your journeys and activities whether local or global, creating a beautiful timeline and relive these treasured experiences of your past."
            case "Journeys-TravelLife":
                print("in journeys tl")
                empty.frame.size.height = 350.0
                empty.viewHeading.text = "My Tales & Trails"
                let head = NSMutableAttributedString(string: "On-the-Go Journeys", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 16)!])
                let body: NSMutableAttributedString = NSMutableAttributedString(attributedString: head)
                let bodyOne = NSMutableAttributedString(string: "\n Capture each moment of your journey via check-ins, pictures, videos, and thoughts live On-the-Go to create a stunning timeline with friends and family. \n \n ", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!])
                let headTwo = NSMutableAttributedString(string: "Chronicling Past Travels ", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 16)!])
                let bodyTwo = NSMutableAttributedString(string: "\n Revisit the treasured moments of your past travels by creating a beautiful memoir of your trip.", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!])
                body.append(bodyOne)
                body.append(headTwo)
                body.append(bodyTwo)
                empty.viewBody.attributedText = body
            case "Journeys-LocalLife":
                print("in journeys ll")
                empty.frame.size.height = 325.0
                empty.viewHeading.text = "Life In The City"
                empty.viewBody.text = "Candid, fun moments with friends, happy family get-togethers, some precious ‘me-time’…share your love for your city and inspire others to do the same. Cherish your local life memories eternally."
            case "Moments–All":
                print("in moments all")
                empty.frame.size.height = 250.0
                empty.viewHeading.text = "Unwind​ B​y Rewinding"
                empty.viewBody.text = "Revisit and reminisce the days gone by through brilliant pictures and videos of your travel and local life."
            case "Moments-TravelLife":
                print("in moments tl")
                empty.frame.size.height = 350.0
                empty.viewHeading.text = "Travel Becomes A Reason To Take Pictures And Store Them"
                empty.viewBody.text = "Some memories are worth sharing, travel surely tops the list. Your travels will not only inspire you to explore more of the world, you may just move another soul or two!"
            case "Moments-LocalLife":
                print("in moments ll")
                empty.frame.size.height = 275.0
                empty.viewHeading.text = "Suspended In Time"
                empty.viewBody.text = "Beautiful memories created through fabulous pictures and videos of those precious moments shared with family, friends and yourself."
            case "Reviews-All":
                print("in reviews all")
                empty.frame.size.height = 275.0
                empty.viewHeading.text = "Relive Y​our Storyline"
                empty.viewBody.text = "Rate the places, restaurants, cuisines, theatres, parks, museums, and more, when you check-in. Jot down your thoughts and feelings about them."
            case "Reviews-TravelLife":
                print("in reviews tl")
                empty.frame.size.height = 285.0
                empty.viewHeading.text = "The World I​s Your Oyster"
                empty.viewBody.text = "A five star or a four star? What does that historical monument qualify for? Rate it and write a review. Help others with your rating and review."
            case "Reviews-LocalLife":
                print("in reviews ll")
                empty.frame.size.height = 285.0
                empty.viewHeading.text = "A Touch Of Your Daily Dose"
                empty.viewBody.text = "Now how about rating and writing a super review for that newly-opened restaurant in your town? Wherever you go, click on a star and pen down your experiences."
            default:
                print("in default")
                empty.frame.size.height = 250.0
                empty.viewHeading.text = "Unwind​ B​y Rewinding"
                empty.viewBody.text = "Revisit and reminisce the days gone by through brilliant pictures and videos of your travel and local life."
            }
        }
        
        else {
            
            switch whichView {
            case "All":
                request.getMomentJourney(pageNumber: 1, type: "all",completion: {(request) in
                    DispatchQueue.main.async(execute: {
                        if request["data"] != "" {
                            for post in request["data"].array! {
                                let checkIn = MyLifeActivityFeedsLayout(width: self.view.frame.width)
                                checkIn.scrollView = self.TheScrollView
                                checkIn.createProfileHeader(feed: post)
                                checkIn.activityFeed = self
                                self.layout.addSubview(checkIn)
                            }
                            self.addHeightToLayout()
                        }
                    })
                })
            case "TL":
                break
            case "LL":
                break
            default:
                break
            }
        }
        
    }
    
    func addHeightToLayout() {
        self.layout.layoutSubviews()
        self.TheScrollView.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height + 60)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
