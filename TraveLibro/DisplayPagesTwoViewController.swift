//
//  DisplayPagesTwoViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 01/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var youUsuallyGo: String!

class DisplayPagesTwoViewController: UIViewController {

    @IBOutlet var radioButtons: [UIButton]!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        let indicatorTwo = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        indicatorTwo.image = UIImage(named: "headerindicator2")
        self.navigationItem.titleView = indicatorTwo
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(DisplayPagesTwoViewController.nextPage(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self
            .popVC(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(DisplayPagesTwoViewController.nextPage(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        for button in radioButtons {
            
            button.addTarget(self, action: #selector(DisplayPagesTwoViewController.singleSelect(_:)), forControlEvents: .TouchUpInside)
            
        }
        
        if profilePic != nil {
            
            setImage()
            
        }
        
        
    }
    
    func setImage() {
        
        let isUrl = verifyUrl(profilePic)
        print("isUrl: \(isUrl)")
        
        if isUrl {
            
            print("inside if statement")
            let data = NSData(contentsOfURL: NSURL(string: profilePic)!)
            
            if data != nil {
                
                print("some problem in data \(data)")
                //                uploadView.addButton.setImage(, forState: .Normal)
                profileImage.image = UIImage(data: data!)
                makeTLProfilePicture(profileImage)
            }
        }
            
        else {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + profilePic + "&width=100"
            
            print("getImageUrl: \(getImageUrl)")
            
            let data = NSData(contentsOfURL: NSURL(string: getImageUrl)!)
            print("data: \(data)")
            
            if data != nil {
                
                //                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                print("inside if statement \(profileImage.image)")
                profileImage.image = UIImage(data: data!)
                //                print("sideMenu.profilePicture.image: \(profileImage.image)")
                makeTLProfilePicture(profileImage)
            }
            
        }
    }
    
    func nextPage(sender: AnyObject) {
        
        print("you usually go: \(youUsuallyGo)")
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("displayThree") as! DisplayPagesThreeViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    var selected: UIButton!
    
    
    func singleSelect(sender: UIButton) {
        
//        var flag = 0
        
        for button in radioButtons {
            
            print("here 1")
            
            if selected != nil && selected == button {
                
                print("here 2")
                
                selected.setBackgroundImage(UIImage(named: "halfnhalfbgGray"), forState: .Normal)
//                flag = 1
                
            }
            
        }
        
        print("here 3")
        
        selected = sender
        selected.setBackgroundImage(UIImage(named: "halfgreenbox"), forState: .Normal)
        youUsuallyGo = selected.titleLabel?.text
        
//        if flag == 1 {
//          
//            
//            
//        }
//        
//        else {
//            
//            
//        }
        
        
//        if sender.tag == 0 {
//            
//            sender.setBackgroundImage(UIImage(named: ""), forState: .Normal)
//            sender.tag = 1
//            
//        }
//        else {
//            
//            sender.setBackgroundImage(UIImage(named: ""), forState: .Normal)
//            sender.tag = 0
//            
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
