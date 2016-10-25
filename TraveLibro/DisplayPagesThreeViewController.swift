//
//  DisplayPagesThreeViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 01/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var preferToTravel: [String] = []

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
            let data = try? Data(contentsOf: URL(string: profilePic)!)
            
            if data != nil {
                
                print("some problem in data \(data)")
                //                uploadView.addButton.setImage(, forState: .Normal)
                sender.profileImage.image = UIImage(data: data!)
                makeTLProfilePicture(sender.profileImage)
            }
        }
            
        else {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + profilePic + "&width=100"
            
//            print("getImageUrl: \(getImageUrl)")
            
            let data = try? Data(contentsOf: URL(string: getImageUrl)!)
//            print("data: \(data)")
            
            if data != nil {
                
                //                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                print("inside if statement \(sender.profileImage.image)")
                sender.profileImage.image = UIImage(data: data!)
                //                print("sideMenu.profilePicture.image: \(profileImage.image)")
                makeTLProfilePicture(sender.profileImage)
            }
            
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
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "displayFour") as! DisplayPagesFourViewController
        self.navigationController?.pushViewController(next, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
