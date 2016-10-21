
import UIKit
import SwiftyJSON

var cardTitle: String!
var selectedOptions: [String] = []
let rightButton = UIButton()

class DisplayCardsViewController: UIPageViewController, UIPageViewControllerDataSource {

    let titles = ["Your kind of a holiday", "You usually go", "Prefer to travel", "Your ideal holiday type"]
    let checkBoxNumber = [6, 3, 8, 11]
    
    var travelConfig: [String: [String]] = [:]
    var dataIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDarkBackGroundBlur(self)
        
        let myVC = viewControllerAtIndex(0) as! SignupCardsViewController
        let viewControllers = [myVC]
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
//        rightButton.setTitle("Next", forState: .Normal)
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(DisplayCardsViewController.nextPage(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
//        rightButton.hidden = true
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        dataSource = self
        
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
//        self.pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextPage(_ sender: AnyObject) {
        
        print("index: \(dataIndex)")
        dataIndex = dataIndex + 1
//        viewControllerAtIndex(dataIndex)
        let myVC = viewControllerAtIndex(dataIndex) as! SignupCardsViewController
        setViewControllers([myVC], direction: .forward, animated: true, completion: nil)
        
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
        viewControllerAtIndex(dataIndex)
        travelConfig[cardTitle] = selectedOptions
        
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
                    
                    print("error: \(response.error?.localizedDescription)")
                }
                
                else {
                    
                    if response["value"] {
                        
                        print("response arrived!")
                        
                        let home = self.storyboard!.instantiateViewController(withIdentifier: "Home") as! HomeViewController
//                        self.slideMenuController()?.changeMainViewController(home, close: true)
//                        home.initialEntrance = true
                        self.navigationController!.pushViewController(home, animated: true)
                        
                    }
                    else {
                        
                        print("response error: \(response["data"])")
                    }
                }
            })
        })
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        dataIndex = dataIndex - 1
//        selectedOptions = []
//        print("no problem in json")
        
        let vc = viewController as! SignupCardsViewController
        var index = vc.pageIndex  as Int
        if((index == 0) || (index == NSNotFound)) {
            
            return nil
        }
        
        index = index - 1
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        travelConfig[cardTitle] = selectedOptions
        print("\(cardTitle): \(selectedOptions)")
//        dataIndex = dataIndex + 1
//        selectedOptions = []
        
        let vc = viewController as! SignupCardsViewController
        var index = vc.pageIndex  as Int
        if(index == NSNotFound) {
            
            return nil
        }
        
        index = index + 1
        
        if(index == titles.count) {
            
            return nil
        }
        
        return viewControllerAtIndex(index)
        
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
        return myVC
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return titles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }

}
