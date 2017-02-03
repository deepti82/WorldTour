import UIKit
var globalMyLifeContainerViewController:MyLifeContainerViewController!
class MyLifeContainerViewController: UIViewController {
    
    @IBOutlet weak var TheScrollView: UIScrollView!
    
    var layout: VerticalLayout!
    var isInitalLoad = true
    var empty: EmptyScreenView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalMyLifeContainerViewController = self;
        isEmptyProfile = false
        
        layout = VerticalLayout(width: self.view.frame.width);
        TheScrollView.addSubview(layout)
        self.loadData("all", pageNumber: 1)
    }
    
    func loadData(_ type:String,pageNumber:Int) {
        if(pageNumber == 1 && self.layout != nil) {
            self.layout.removeAll()
        }
        request.getMomentJourney(pageNumber: pageNumber, type: type,completion: {(request) in
            DispatchQueue.main.async(execute: {
                if request["data"] != "" {
//                    for post in request["data"].array! {
//                        let checkIn = MyLifeActivityFeedsLayout(width: self.view.frame.width)
//                        checkIn.scrollView = self.TheScrollView
//                        checkIn.createProfileHeader(feed: post)
//                        checkIn.activityFeed = self
//                        self.layout.addSubview(checkIn)
//                    }
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
    
}
