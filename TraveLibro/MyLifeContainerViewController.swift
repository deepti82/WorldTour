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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        globalMyLifeContainerViewController = self;
        isEmptyProfile = false
        TheScrollView.delegate = self
        layout = VerticalLayout(width: self.view.frame.width);
        TheScrollView.addSubview(layout)
        loader.showOverlay(self.view)
        timeTag = TimestampTagViewOnScroll(frame: CGRect(x: 0, y: 100, width: screenWidth + 8, height: 40))
        timeTag.alpha = 0.8
        self.view.addSubview(timeTag)
        
        self.loadData("all", pageNumber: pageNumber)
    }
    
    func loadData(_ type:String,pageNumber:Int) {
        loader.hideOverlayView()
        var shouldChangeVal = true
        if(pageNumber == 1 && self.layout != nil) {
            self.layout.removeAll()
        }
        request.getMomentJourney(pageNumber: pageNumber, type: type,completion: {(request) in
            DispatchQueue.main.async(execute: {
                self.isLoading = false
                loader.hideOverlayView()
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
