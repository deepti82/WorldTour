import UIKit
var globalMyLifeContainerViewController:MyLifeContainerViewController!
class MyLifeContainerViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var TheScrollView: UIScrollView!
    var layout: VerticalLayout!
    var isInitalLoad = true
    var empty: EmptyScreenView!
    var timeTag:TimestampTagViewOnScroll!
    var pageNumber = 1
    var hasNext: Bool = true
    var isLoading: Bool = false
    var isViewed:Bool = true
    var onTab:String = "all"
    var loader = LoadingOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        globalMyLifeContainerViewController = self;
        isEmptyProfile = false
        TheScrollView.delegate = self
        allData = []
        layout = VerticalLayout(width: self.view.frame.width);
        TheScrollView.addSubview(layout)
        timeTag = TimestampTagViewOnScroll(frame: CGRect(x: 0, y: 100, width: screenWidth + 8, height: 40))
        timeTag.alpha = 0.8
        self.view.addSubview(timeTag)
        
//        self.loadData("all", pageNumber: pageNumber)
    }
    
    func showNoData(show:Bool, type:String) {
        if empty != nil {
            self.empty.removeFromSuperview()
        }
        if show {
            empty = EmptyScreenView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
            switch type {
            case "all":
                empty.frame.size.height = 350.0
                empty.viewHeading.text = "Travel in a Time Machine"
                empty.viewBody.text = "Capture your journeys and activities whether local or global, creating a beautiful timeline and relive these treasured experiences of your past."
                break
            case "travel-life":
                empty.frame.size.height = 350.0
                empty.viewHeading.text = "On-the-Go Journeys"
                empty.viewBody.text = "Capture each moment of your journey via check-ins, pictures, videos, and thoughts live On-the-Go to create a stunning timeline with friends and family."
                break
            case "local-life":
                empty.frame.size.height = 275.0
                empty.viewHeading.text = "Life In The City"
                empty.viewBody.text = "Candid, fun moments with friends, happy family get-togethers, some precious ‘me-time’…share your love for your city and inspire others to do the same. Cherish your local life memories eternally."
                break
            default:
                break
            }
            self.view.addSubview(empty)
//            mainView.isHidden = true
        }
    }
    
    func loadData(_ type:String,pageNumber:Int) {
        onTab = type
        if pageNumber == 1 {
            hasNext = true
            loader.showOverlay(self.view)
            allData = []
        }
        var shouldChangeVal = true
        if(pageNumber == 1 && self.layout != nil) {
            self.layout.removeAll()
        }
        request.getMomentJourney(pageNumber: pageNumber, type: type, urlSlug: selectedUser["urlSlug"].stringValue, completion: {(request) in
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                self.isViewed = false
                self.isLoading = false
                if request["data"] != nil && request["value"].boolValue {
                    for post in request["data"].array! {
                        if(shouldChangeVal) {
                            self.timeTag.changeTime(feed: post)
                            shouldChangeVal = false
                        }
                        let checkIn = MyLifeActivityFeedsLayout(width: self.view.frame.width)
                        checkIn.scrollView = self.TheScrollView
                        checkIn.createProfileHeader(feed: post)
                        checkIn.activityFeed = self
                        self.layout.addSubview(checkIn)
                    }
                    if request["data"].array?.count == 0 {
                        self.hasNext = false
                    }
                    self.addHeightToLayout()
                    
                    
                    if self.layout.subviews.count == 0 {
                        self.showNoData(show: true, type: type)
                    }else{
//                        self.mainView.isHidden = false
                        self.showNoData(show: false, type: type)
                    }
                    
                }
            })
        })
    }
    
    func addHeightToLayout() {
        self.layout.layoutSubviews()
        self.TheScrollView.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height + 60)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
       
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            if hasNext && !isLoading {
                isLoading = true
                pageNumber += 1
                loadData(onTab, pageNumber: pageNumber)
            }
        }
        
        for postView in layout.subviews {
            if(postView is MyLifeActivityFeedsLayout) {
                let photosOtg = postView as! MyLifeActivityFeedsLayout
                if(photosOtg.videoContainer != nil) {
                    photosOtg.videoToPlay()
                }
            }
        }
        
        for postView in layout.subviews {
            if(postView is MyLifeActivityFeedsLayout) {
                let photosOtg = postView as! MyLifeActivityFeedsLayout
                
                let min = photosOtg.frame.origin.y - self.TheScrollView.contentOffset.y
                let max = min + photosOtg.frame.size.height
                
                if((min < 100) && (max > 140))
                {
                    self.timeTag.changeTime(feed: photosOtg.feeds)
                }
            }
        }
        
    }
}
