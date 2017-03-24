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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        globalMyLifeContainerViewController = self;
        isEmptyProfile = false
        TheScrollView.delegate = self
        layout = VerticalLayout(width: self.view.frame.width);
        TheScrollView.addSubview(layout)
        timeTag = TimestampTagViewOnScroll(frame: CGRect(x: 0, y: 100, width: screenWidth + 8, height: 40))
        timeTag.alpha = 0.8
        self.view.addSubview(timeTag)
        
        self.loadData("all", pageNumber: pageNumber)
    }
    
    func showNoData(show:Bool, type:String) {
        if empty != nil {
            self.empty.removeFromSuperview()
        }
        if show {
            empty = EmptyScreenView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
            switch type {
            case "all":
                print("in moments all")
                empty.frame.size.height = 250.0
                empty.viewHeading.text = "Unwind​ B​y Rewinding"
                empty.viewBody.text = "Revisit and reminisce the days gone by through brilliant pictures and videos of your travel and local life."
                break
            case "travel-life":
                print("in moments tl")
                empty.frame.size.height = 350.0
                empty.viewHeading.text = "Travel Becomes A Reason To Take Pictures And Store Them"
                empty.viewBody.text = "Some memories are worth sharing, travel surely tops the list. Your travels will not only inspire you to explore more of the world, you may just move another soul or two!"
                break
            case "local-life":
                print("in moments ll")
                empty.frame.size.height = 275.0
                empty.viewHeading.text = "Suspended In Time"
                empty.viewBody.text = "Beautiful memories created through fabulous pictures and videos of those precious moments shared with family, friends and yourself."
                break
            default:
                break
            }
            self.view.addSubview(empty)
//            mainView.isHidden = true
        }
    }
    
    func loadData(_ type:String,pageNumber:Int) {
        loader.showOverlay(self.view)
        var shouldChangeVal = true
        if(pageNumber == 1 && self.layout != nil) {
            self.layout.removeAll()
        }
        if isViewed {
        request.getMomentJourney(pageNumber: pageNumber, type: type,completion: {(request) in
            DispatchQueue.main.async(execute: {
                loader.hideOverlayView()
                self.isViewed = false
                self.isLoading = false
                if request["data"] != nil && request["value"].boolValue {
                    print(request["data"])
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
                print("load data for page : \(pageNumber)")
                loadData("all", pageNumber: pageNumber)
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
