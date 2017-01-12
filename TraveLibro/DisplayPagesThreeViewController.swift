//
//  DisplayPagesThreeViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 01/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit



class DisplayPagesThreeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)

//        let indicatorThree = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
////        indicatorThree.center.y = (self.navigationItem.titleView?.frame.height)!/2
//        indicatorThree.image = UIImage(named: "headerindicator3")
//        self.navigationItem.titleView = indicatorThree
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(DisplayPagesThreeViewController.nextPage(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        self.title = "\(fullCircle)    \(fullCircle)    \(fullCircle)     \(emptyCircle)"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : UIFont(name: "FontAwesome", size: 10)!]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self
            .popVC(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(DisplayPagesTwoViewController.nextPage(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(scroll)
        
        scroll.contentSize.height = 750
        
        let page = forDPThree(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 700))
        scroll.addSubview(page)
        
        for button in page.checkboxButtons {
            
            button.addTarget(self, action: #selector(DisplayPagesThreeViewController.multipleSelect(_:)), for: .touchUpInside)
            
        }
        
        if profilePic != nil {
            
            setImage(page)
        }
        
        
    }
    
    func setImage(_ sender: forDPThree) {
        
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
            preferToTravel.append(sender.titleLabel!.text!)
            
            if sender.titleLabel!.text! == "Blogger" {
                
                print("is a blogger")
                
            }
            
            else if sender.titleLabel!.text! == "Photographer" {
                
                print("is a photographer")
                
            }
        }
        else {
            
            sender.setBackgroundImage(UIImage(named: "halfnhalfbgGray"), for: UIControlState())
            sender.tag = 0
            preferToTravel = preferToTravel.filter{$0 != sender.titleLabel!.text!}
        }
        
    }
    
    func nextPage(_ sender: AnyObject) {
        
        print("prefer to travel: \(preferToTravel)")
        
//        let req = ["preferToTravel":preferToTravel]
//        
//        request.addKindOfJourney(currentUser["_id"].string!, editFieldValue: req, completion: {(responce) in
//            DispatchQueue.main.async(execute: {
//                if responce["value"] != true{
//                    self.alert(message: "Enable to save", title: "Prefer To Travel")
//                    
//                }
                let next = self.storyboard?.instantiateViewController(withIdentifier: "displayFour") as! DisplayPagesFourViewController
                self.navigationController?.pushViewController(next, animated: true)
                
//            })
//        })

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
