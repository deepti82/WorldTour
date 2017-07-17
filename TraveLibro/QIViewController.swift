//
//  QIViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster
import iCarousel

var editValue = "";

class QIViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate  {
    var quick: QuickIteneraryOne!
    var selectedView = false
    var inx = 0
    var type = ""
    var editID:String!
    var editJson:JSON!
    var viewControllers1 = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Quick Itinerary"
        getDarkBackGround(self)
        self.delegate = self
        globalPostImage = []
        self.dataSource = self
        
        self.createNavigation()
        
        ToastView.appearance().backgroundColor = mainOrangeColor

        let quickOne: QuickIteneraryOne = (storyboard?.instantiateViewController(withIdentifier: "quickOne")) as! QuickIteneraryOne
        let quickTwo: QuickIteneraryTwo = (storyboard?.instantiateViewController(withIdentifier: "quickTwo")) as! QuickIteneraryTwo
        let quickThree: QuickIteneraryThree = (storyboard?.instantiateViewController(withIdentifier: "quickThree")) as! QuickIteneraryThree
        let quickFour: QuickIteneraryFour = (storyboard?.instantiateViewController(withIdentifier: "quickFour")) as! QuickIteneraryFour
        let quickFive: QuickIteneraryFive = (storyboard?.instantiateViewController(withIdentifier: "quickFive")) as! QuickIteneraryFive
        
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
        
        
        if(editID != nil) {
            editValue = editID;
            request.getItinerary(editID, completion: { (json) in
                DispatchQueue.main.async(execute: {
                    if(json["value"].boolValue) {
                        self.editJson = json["data"];
                        quickOne.tripTitle.text = self.editJson["name"].stringValue
                        quickOne.yearPickerView.text = self.editJson["year"].numberValue.stringValue
                        quickOne.durationTextField.text = self.editJson["duration"].numberValue.stringValue
                        quickOne.monthPickerView.text = self.editJson["month"].stringValue
                        quickTwo.itineraryTypes = self.editJson["itineraryType"]
                        quickItinery["countryVisited"] = self.editJson["countryVisited"]
                        quickItinery["status"] = self.editJson["status"]
                        for (n,country) in quickItinery["countryVisited"] {
                            quickItinery["countryVisited"][Int(n)!]["name"] = country["country"]["name"]
                            for (i,_) in country["cityVisited"] {
                                quickItinery["countryVisited"][Int(n)!]["cityVisited"][Int(i)!]["name"] = country["cityVisited"][Int(i)!]["city"]["name"]
                            }
                        }
                        quickFour.iniText = self.editJson["description"].stringValue
                        globalPostImage = []
                        print("\n Itinerary Data : \(self.editJson) \n");
                        for (_,photo) in self.editJson["photos"] {
                            let po = PostImage();
                            po.urlToData(photo["name"].stringValue, serverID: photo["_id"].stringValue)
                            quickFive.imageArr.append(po)
                            globalPostImage.append(po)
                        }
                    }
                })
            })
        }
        else {
            editValue = "";
        }
        
    }
    
    func changeView(changedIndex:Int, key:String) {
        print(changedIndex)
        inx = changedIndex
        self.setViewControllers([viewControllers1[inx]], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
        var mss = ""
        if key == "0duration" {
            mss = "Day's can not be 0."
        }else{
            mss = "Please enter \(key.capitalized)"
        }
        let tsrt = Toast(text: mss)
        tsrt.show()
        createNavigation()
        
    }
    
    
    func createNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
            rightButton.setTitle("Preview", for: .normal)
            rightButton.titleLabel?.font = UIFont(name: "avenirBold", size: 20)
            rightButton.addTarget(self, action: #selector(self.donePage(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: -5, y: 8, width: 80, height: 30)
            
        }else{
            rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
            rightButton.addTarget(self, action: #selector(self.nextPage(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        }
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        var check = true
        
        for (key, itm) in quickItinery {
            if(check){
                switch key {
                case "title", "month", "year", "duration":
                    if itm == "" {
                        self.changeView(changedIndex: 0, key: key)
                        check = false
                    } else if key == "duration" && itm == 0 {
                        self.changeView(changedIndex: 0, key: "0duration")
                        check = false
                    }
                    break
                case "countryVisited":
                    if itm.count == 0 {
                        self.changeView(changedIndex: 2, key: "country visited")
                        check = false
                    }
                    break
                default: break
                }
            }
        }
        if check {
            saveItinerary()
        }
    }
    
    func saveItinerary() {
        
        print(quickItinery)
        
//        request.postQuickitenary(title: quickItinery["title"].stringValue, year: quickItinery["year"].int!, month: quickItinery["month"].stringValue, duration:quickItinery["duration"].int!, description:quickItinery["description"].stringValue, itineraryType:quickItinery["itineraryType"], countryVisited:quickItinery["countryVisited"],  completion: {(response) in
//            DispatchQueue.main.async(execute: {
//                print(response)
//                if response.error != nil {
//                    
//                    print("error: \(response.error!.localizedDescription)")
//                    
//                }
//                else if response["value"].bool! {
//                    quickItinery = []
//                    let tstr = Toast(text: "Itenary saved successfully.")
//                    tstr.show()
//                    self.callBackViewC()
        
        let itineraryVC = storyboard?.instantiateViewController(withIdentifier: "previewQ") as! QuickItineraryPreviewViewController
        selectedQuickI = ""
        self.navigationController?.pushViewController(itineraryVC, animated: true)
        
//                    let next = self.storyboard?.instantiateViewController(withIdentifier: "previewQ") as! QuickItineraryPreviewViewController
//                    self.present(next, animated: true, completion: nil)
//                    print("nothing")
//                }
//                else {
//                    print("nothing")
//                    
//                }
//            })
//        })
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
        self.createNavigation()
        return viewControllers1.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {       
        return inx
    }
    
}
