
import UIKit
import TAPageControl

var cardTitle: String!
var selectedOptions: [String] = []
let rightButton = UIButton()

class DisplayCardsViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    internal var isFromSettings:Bool? = false
    
    let titles = ["Your kind of a holiday", "You usually go", "Prefer to travel", "Your ideal holiday type"]
    let cardTitles = ["kindOfHoliday", "usuallyGo", "preferToTravel", "holidayType"]
    let checkBoxNumber = [6, 3, 8, 11]
    
    var pageControl = TAPageControl()    
    var dataIndex = 0
    var pageviewControllers = [UIViewController]()
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getDarkBackGroundBlur(self)
        
        pageControl = TAPageControl()
        pageControl.currentPage = dataIndex
        pageControl.numberOfPages = titles.count
        pageControl.contentMode = .center
        self.view.addSubview(pageControl)
        
        let originalPageControl: UIPageControl = UIPageControl.appearance(whenContainedInInstancesOf: [DisplayCardsViewController.self])
        originalPageControl.pageIndicatorTintColor = UIColor.clear
        originalPageControl.currentPageIndicatorTintColor = UIColor.clear
        
//        let myVC = viewControllerAtIndex(0) as! SignupCardsViewController
//        let viewControllers = [myVC]
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(DisplayCardsViewController.nextPage(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        for i in 0...3 {
            
            let myVC = storyboard?.instantiateViewController(withIdentifier: "SignupCardsViewController") as! SignupCardsViewController
            myVC.cardTitle = titles[i]
            myVC.pageIndex = i
            myVC.checkBoxes = CGFloat(checkBoxNumber[i])            
            pageviewControllers.append(myVC)
        }
        dataIndex = 0
        
        dataSource = self
        delegate = self
        cardTitle = cardTitles[dataIndex]
        travelConfig[cardTitle] = selectedOptions
        selectedOptions = []
        setViewControllers([pageviewControllers[dataIndex]], direction: .forward, animated: true, completion: nil)
//        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
        //        self.pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = NAVIGATION_BAR_CLEAR_COLOR
        self.navigationController?.navigationBar.isTranslucent = true
        pageControl.frame = CGRect(x: self.view.center.x, y: screenHeight - 15, width: 60, height: 30)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- Next Page
    
    func nextPage(_ sender: AnyObject) {
        
//        dataIndex = dataIndex + 1
//        
//        //        pageControl.currentPage = dataIndex
//        
//        //        viewControllerAtIndex(dataIndex)
//        
//        travelConfig[cardTitle] = selectedOptions
//        
//        selectedOptions = []
//        
//        if dataIndex < 4 || (isFromSettings == nil || isFromSettings == false){
//            let myVC = viewControllerAtIndex(dataIndex) as! SignupCardsViewController
//            setViewControllers([myVC], direction: .forward, animated: true, completion: nil)
//        }
//        
//        if dataIndex == 3 {
//            
//            rightButton.frame.size.width = 70.0
//            rightButton.setImage(nil, for: UIControlState())
//            rightButton.setTitle("Done", for: UIControlState())
//            rightButton.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 16)
//            
//        }
//            
//        else if dataIndex > 3 {
//            
//            finishQuestions(sender)
//        }
        
        travelConfig[cardTitle] = selectedOptions
        
        selectedOptions = []
        
        if dataIndex < 4 || (isFromSettings == nil || isFromSettings == false){
            dataIndex = dataIndex + 1
            if dataIndex < 4 {
                pageControl.currentPage = dataIndex
                cardTitle = cardTitles[dataIndex]
                self.setViewControllers([pageviewControllers[dataIndex]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }
        }
        
        if dataIndex == 3 {
            rightButton.frame.size.width = 70.0
            rightButton.setImage(nil, for: UIControlState())
            rightButton.setTitle("Done", for: UIControlState())
            rightButton.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 16)
        }
        else if dataIndex > 3 {
            
            finishQuestions(sender)
        }
    }
    
    func finishQuestions(_ sender: AnyObject) {
        
        dataIndex = 3
        
        if !(isFromSettings != nil && isFromSettings == true) {
            _ = viewControllerAtIndex(dataIndex)
        }        
        
        //        travelConfig["holidayType"]!.filter{
        //            !contains(travelConfig["preferToTravel"]!, $0)
        //        }
        //        print("travel config 1: \(travelConfig)")
        
        if travelConfig["preferToTravel"] != nil && travelConfig["holidayType"] != nil {
            
            for item in travelConfig["holidayType"]! {
                
                if travelConfig["preferToTravel"]!.contains(item) {
                    
                    print("contains \(item)")
                    
                    travelConfig["holidayType"] = travelConfig["holidayType"]!.filter{$0 != item}
                    
                }
                
            }
        }
        
        print("travel config: \(travelConfig)")
        
        request.addKindOfJourney(currentUser["_id"].string!, editFieldValue: travelConfig, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(String(describing: response.error?.localizedDescription))")
                }
                    
                else {
                    
                    if response["value"].bool! {
                        
                        print("response arrived!")
                        
                        currentUser = response["data"]
                        
                        if (self.isFromSettings != nil && self.isFromSettings == true) {
                            print("\n pop vc")
                            _ = self.navigationController?.popViewController(animated: true)
                        }                       
                        else {
                            let home = self.storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController                            
                            self.navigationController!.pushViewController(home, animated: true)
                        }
                        
                    }
                    else {
                        
                        print("response error: \(response["data"])")
                    }
                }
            })
        })
        
    }
    
    
    //MARK:- PageController Delgates
    /*
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
//        dataIndex = dataIndex - 1
        //        selectedOptions = []
        //        print("no problem in json")
        
        let vc = viewController as! SignupCardsViewController
        var index = vc.pageIndex  as Int
        if((index == 0) || (index == NSNotFound)) {
            
            return nil
        }
        
//        index = index - 1
        
        dataIndex = index
        
        //        pageControl.currentPage = index
        
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
//        dataIndex = dataIndex + 1
        
        travelConfig[cardTitle] = selectedOptions
        print("\(cardTitle): \(selectedOptions)")
        
        let vc = viewController as! SignupCardsViewController
        var index = vc.pageIndex  as Int
        if(index == NSNotFound) {
            
            return nil
        }
        
        index = index + 1
        
        if(index == titles.count) {
            
            return nil
        }
        
        dataIndex = index
        
        return viewControllerAtIndex(index)
        
    }
    */
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("before ......")
        let currentIndex = self.pageviewControllers.index(of: viewController)!
        self.dataIndex = currentIndex
        print(self.dataIndex)
        if currentIndex > 0{
            let previousIndex = abs((currentIndex - 1) % (self.pageviewControllers.count))
            travelConfig[cardTitle] = selectedOptions
            selectedOptions = []
            self.dataIndex = previousIndex            
            cardTitle = cardTitles[dataIndex]
            pageControl.currentPage = dataIndex
            return pageviewControllers[previousIndex]
        }else{
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("After.....")
        let currentIndex = self.pageviewControllers.index(of: viewController)!
        self.dataIndex = currentIndex
        print(self.dataIndex)        
        if currentIndex < 3{            
            let nextIndex = abs((currentIndex + 1) % (self.pageviewControllers.count))            
            travelConfig[cardTitle] = selectedOptions
            selectedOptions = []
            self.dataIndex = nextIndex
            cardTitle = cardTitles[dataIndex]
            if dataIndex == 3 {
                rightButton.frame.size.width = 70.0
                rightButton.setImage(nil, for: UIControlState())
                rightButton.setTitle("Done", for: UIControlState())
                rightButton.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 16)
            }
            else if dataIndex > 3 {
                finishQuestions(UIButton())
            }
            pageControl.currentPage = dataIndex
            return pageviewControllers[nextIndex]
            
        }else{
            return nil
        }
    }
    
    func viewControllerAtIndex(_ index: Int) -> UIViewController {        
        switch dataIndex {
        case 0:
            selectedOptions = []
            cardTitle = "kindOfHoliday"
        case 1:
            selectedOptions = []
            cardTitle = "usuallyGo"
        case 2:
            selectedOptions = []
            cardTitle = "preferToTravel"
        case 3:
            //            selectedOptions = []
            cardTitle = "holidayType"
        default:
            break
        }
        
        if((self.titles.count == 0) || (index >= self.titles.count)) {
            return SignupCardsViewController()
        }
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "SignupCardsViewController") as! SignupCardsViewController
        myVC.cardTitle = titles[index]
        myVC.pageIndex = index
        myVC.checkBoxes = CGFloat(checkBoxNumber[index]) 
        
        pageControl.currentPage = index
        return myVC
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return titles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return dataIndex
    }
    
}
