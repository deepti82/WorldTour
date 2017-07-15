

//
//  DisplayPagesFourViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 01/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit




class DisplayPagesFourViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)        

//        let indicatorFour = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
//        indicatorFour.image = UIImage(named: "headerindicator4")
//        self.navigationItem.titleView = indicatorFour
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setTitle("Done", for: UIControlState())
        rightButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 18)
//        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(DisplayPagesFourViewController.nextPage(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 15, y: 8, width: 70, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        self.title = "\(fullCircle)    \(fullCircle)    \(fullCircle)     \(fullCircle)"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : UIFont(name: "FontAwesome", size: 10)!]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self
            .popVC(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(DisplayPagesTwoViewController.nextPage(_:)))
//        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
//        self.view.addGestureRecognizer(swipeLeft)
        print("ypos : \(self.view.frame.origin.y)")
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(scroll)
        
        scroll.contentSize.height = 1050.0
        
        let page = forDpFour(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 950))        
        scroll.addSubview(page)
        
        for button in page.checkboxFourButtons {
            
            button.addTarget(self, action: #selector(DisplayPagesThreeViewController.multipleSelect(_:)), for: .touchUpInside)
        }
        
        if profilePic != nil {
            
            setImage(page)
            
        }
        
    }
    
    
    
    func setImage(_ sender: forDpFour) {
        
        let isUrl = verifyUrl(profilePic)
        print("isUrl: \(isUrl)")
        
        if isUrl {
            
            print("inside if statement")
            
            sender.profileImage.hnk_setImageFromURL(URL(string:profilePic)!)
            makeTLProfilePicture(sender.profileImage)
        }
            
        else {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + profilePic + "&width=100"
            sender.profileImage.hnk_setImageFromURL(URL(string:getImageUrl)!)
            makeTLProfilePicture(sender.profileImage)
            
        }
    }
    
    func multipleSelect(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            sender.setBackgroundImage(UIImage(named: "halfgreenbox"), for: UIControlState())
            sender.tag = 1
            yourIdeal.append(sender.titleLabel!.text!)
            
        }
        else {
            
            sender.setBackgroundImage(UIImage(named: "halfnhalfbgGray"), for: UIControlState())
            sender.tag = 0
            yourIdeal = yourIdeal.filter{ $0 != sender.titleLabel!.text!}
        }
        
    }
    
    func nextPage(_ sender: AnyObject) {
        
        print("your ideal holiday: \(yourIdeal)")
        
        
        let req = ["kindOfHoliday":kindOfJourney,"usuallyGo":[youUsuallyGo],"preferToTravel":preferToTravel,"holidayType":yourIdeal] as [String : Any]
        
        var popToVC : UIViewController!
        
        if kindOfJourney.isEmpty {
            for vc in (self.navigationController?.viewControllers)! {
                if vc.isKind(of: DisplayPagesOneViewController.self) {
                    popToVC = vc
                    break
                }
            }
        }
        else if youUsuallyGo == "" {
            for vc in (self.navigationController?.viewControllers)! {
                if vc.isKind(of: DisplayPagesTwoViewController.self) {
                    popToVC = vc
                    break
                }
            }
        }
        else if preferToTravel.isEmpty {
            for vc in (self.navigationController?.viewControllers)! {
                if vc.isKind(of: DisplayPagesThreeViewController.self) {
                    popToVC = vc
                    break
                }
            }
        }
        else if youUsuallyGo == "" {
            for vc in (self.navigationController?.viewControllers)! {
                if vc.isKind(of: DisplayPagesFourViewController.self) {
                    popToVC = vc
                    break
                }
            }
        }
        
        if kindOfJourney.isEmpty || youUsuallyGo == "" || preferToTravel.isEmpty || yourIdeal.isEmpty {            
            _ = self.navigationController?.popToViewController(popToVC, animated: true)
        }
        else {
            request.addCard(currentUser["_id"].string!, editFieldValue: req, completion: {(responce) in
                DispatchQueue.main.async(execute: {
                    if responce["value"] != true{
                        let errorAlert = UIAlertController(title: "Holiday Type", message: "Enable to save", preferredStyle: UIAlertControllerStyle.alert)
                        let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                            (result : UIAlertAction) -> Void in
                            //Cancel Action
                        }
                        errorAlert.addAction(DestructiveAction)
                        self.navigationController?.present(errorAlert, animated: true, completion: nil)
                    }
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "TLProfileView") as! TLProfileViewController
                    next.isAppStartedFromInitial = true
                    self.navigationController?.pushViewController(next, animated: true)
                })
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
