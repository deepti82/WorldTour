//
//  DisplayCardsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

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
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
//        rightButton.setTitle("Next", forState: .Normal)
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(DisplayCardsViewController.nextPage(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
//        rightButton.hidden = true
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        dataSource = self
        
        setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        
//        self.pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextPage(sender: AnyObject) {
        
        print("index: \(dataIndex)")
        dataIndex = dataIndex + 1
//        viewControllerAtIndex(dataIndex)
        let myVC = viewControllerAtIndex(dataIndex) as! SignupCardsViewController
        setViewControllers([myVC], direction: .Forward, animated: true, completion: nil)
        
        if dataIndex == 3 {
            
            rightButton.frame.size.width = 70.0
            rightButton.setImage(nil, forState: .Normal)
            rightButton.setTitle("Done", forState: .Normal)
            rightButton.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 16)
            
        }
        
        else if dataIndex > 3 {
            
            finishQuestions(sender)
        }
        
    }
    
    func finishQuestions(sender: AnyObject) {
        
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
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                }
                
                else {
                    
                    if response["value"] {
                        
                        print("response arrived!")
                        
                        let home = self.storyboard!.instantiateViewControllerWithIdentifier("Home") as! HomeViewController
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
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
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
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
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
    
    func viewControllerAtIndex(index: Int) -> UIViewController {
        
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
        
        let myVC = storyboard?.instantiateViewControllerWithIdentifier("SignupCardsViewController") as! SignupCardsViewController
        myVC.cardTitle = titles[index]
        myVC.pageIndex = index
        myVC.checkBoxes = CGFloat(checkBoxNumber[index])
        return myVC
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return titles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return 0
    }

}