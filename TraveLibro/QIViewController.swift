//
//  QIViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QIViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    
//    let variousViews = ["One", "Two", "Three", "Four", "Five"]
//    var quickTwo: QuickIteneraryTwo!
//    var quickOne: QuickIteneraryOne!
     var viewControllers1 = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDarkBackGround(self)
//        one.durationTextField.delegate = self
        
        
        //let myVC = viewControllerAtIndex(0) as! QuickItinerariesViewController
        //let viewControllers = [myVC]
       
       
        let leftButton = UIButton()
        self.delegate = self
        self.dataSource = self
        
        let quickOne: UIViewController = (storyboard?.instantiateViewController(withIdentifier: "quickOne"))!
        let quickTwo: UIViewController! = (storyboard?.instantiateViewController(withIdentifier: "quickTwo"))!
        let quickThree: UIViewController = (storyboard?.instantiateViewController(withIdentifier: "quickThree"))!
        let quickFour: UIViewController! = (storyboard?.instantiateViewController(withIdentifier: "quickFour"))!
        let quickFive: UIViewController! = (storyboard?.instantiateViewController(withIdentifier: "quickFive"))!
        viewControllers1.append(quickOne)
        viewControllers1.append(quickTwo)
        viewControllers1.append(quickThree)
        viewControllers1.append(quickFour)
        viewControllers1.append(quickFive)
        setViewControllers([quickOne], direction: .forward, animated: false, completion: nil)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
//        rightButton.addTarget(self, action: #selector(), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        
        
//        one.durationTextField.delegate = self
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
//        switch <#value#> {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
        
        let currentIndex = viewControllers1.index(of: viewController)!
        let previousIndex = abs((currentIndex - 1) % (viewControllers1.count))
        return viewControllers1[previousIndex]
    }
        

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let currentIndex = viewControllers1.index(of: viewController)!
        let nextIndex = abs((currentIndex + 1) % (viewControllers1.count))
        return viewControllers1[nextIndex]
    }
    
    
//    func viewControllerAtIndex(_ index: Int) -> UIViewController {
//        
//        print("index: \(index)")
//        
//        if((viewControllers?.count == 0) || (index >= (viewControllers?.count)!)) {
//            
//            return QuickItinerariesViewController()
//        }
//        
//       var quickIntinerary: UIViewController!
//        
//        switch index {
//        case 0:
//            return quickOne
//        case 1:
//            return quickTwo
//        default:
//            break
//        }
//        return quickIntinerary
////        let myVC = storyboard?.instantiateViewController(withIdentifier: "quickItinerary") as! QuickItinerariesViewController
////        myVC.whichView = variousViews[index]
////        myVC.pageIndex = index
////        return myVC
//    }
//    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return viewControllers1.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
    }

}
