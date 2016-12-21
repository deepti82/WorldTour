//
//  QIViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QIViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    
    var selectedView = false
    var inx = 0
    var viewControllers1 = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
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
        if selectedView {
            setViewControllers([quickThree], direction: .forward, animated: false, completion: nil)
            inx = 2
        }else{
            setViewControllers([quickOne], direction: .forward, animated: false, completion: nil)
            inx = 0
        }
        createNavigation()
        
    }
    
    
    func createNavigation() {
        let leftButton = UIButton()
        if inx == 0 {
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        }else{
            leftButton.addTarget(self, action: #selector(self.prevPage(_:)), for: .touchUpInside)
        }
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        //        leftButton.addTarget(self, action: #selector(self.prevPage(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        if inx == 4 {
            rightButton.setTitle("Done", for: .normal)
            rightButton.addTarget(self, action: #selector(self.donePage(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 0, y: 8, width: 45, height: 30)
        }else{
            rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
            rightButton.addTarget(self, action: #selector(self.nextPage(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        }
        
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
    }
    
    func prevPage(_ sender: UIButton) {
        if inx > 0 {
            inx = inx - 1
            self.setViewControllers([viewControllers1[inx]], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
            createNavigation()
        }
        
        
    }
    
    func nextPage(_ sender: UIButton) {
        if inx < 4 {
            inx = inx + 1
            self.setViewControllers([viewControllers1[inx]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            createNavigation()
        }
        
        
    }
    func donePage(_ sender: UIButton) {
        print("done")
        
        quickItinery["user"] = currentUser["_id"]
        quickItinery["status"] = false
        print(quickItinery)
        request.postQuickitenary(title: quickItinery["title"].stringValue, year: quickItinery["year"].int!, month: quickItinery["month"].stringValue, duration:quickItinery["duration"].int!, description:quickItinery["description"].stringValue, itineraryType:quickItinery["itineraryType"], countryVisited:quickItinery["countryVisited"],  completion: {(response) in
            DispatchQueue.main.async(execute: {
                print(response)
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    print("nothing")
                }
                else {
                    print("nothing")
                    
                }
            })
        })
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("before ......")
        let currentIndex = self.viewControllers1.index(of: viewController)!
        self.inx = currentIndex
        print(self.inx)
        self.createNavigation()
        if currentIndex > 0{
            
            let previousIndex = abs((currentIndex - 1) % (self.viewControllers1.count))
            
            return viewControllers1[previousIndex]
        }else{
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("After.....")
        let currentIndex = self.viewControllers1.index(of: viewController)!
        self.inx = currentIndex
        print(self.inx)
        self.createNavigation()
        if currentIndex < 4{
            
            let nextIndex = abs((currentIndex + 1) % (self.viewControllers1.count))
            
            return viewControllers1[nextIndex]
        }else{
            return nil
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return viewControllers1.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return inx
    }
    
}
