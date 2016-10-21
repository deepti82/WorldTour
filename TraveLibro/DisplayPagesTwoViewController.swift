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
        
//        let indicatorTwo = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
//        indicatorTwo.image = UIImage(named: "headerindicator2")
//        self.navigationItem.titleView = indicatorTwo
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(DisplayPagesTwoViewController.nextPage(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        self.title = "\(fullCircle)    \(fullCircle)    \(emptyCircle)     \(emptyCircle)"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : UIFont(name: "FontAwesome", size: 10)!]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self
            .popVC(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(DisplayPagesTwoViewController.nextPage(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        for button in radioButtons {
            
            button.addTarget(self, action: #selector(DisplayPagesTwoViewController.singleSelect(_:)), for: .touchUpInside)
            
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
            let data = try? Data(contentsOf: URL(string: profilePic)!)
            
            if data != nil {
                
                print("some problem in data \(data)")
                //                uploadView.addButton.setImage(, forState: .Normal)
                profileImage.image = UIImage(data: data!)
                makeTLProfilePicture(profileImage)
            }
        }
            
        else {
            
            let getImageUrl = adminUrl + "upload/readFile?file=" + profilePic + "&width=100"
            
//            print("getImageUrl: \(getImageUrl)")
            
            let data = try? Data(contentsOf: URL(string: getImageUrl)!)
//            print("data: \(data)")
            
            if data != nil {
                
                //                uploadView.addButton.setImage(UIImage(data:data!), forState: .Normal)
                print("inside if statement \(profileImage.image)")
                profileImage.image = UIImage(data: data!)
                //                print("sideMenu.profilePicture.image: \(profileImage.image)")
                makeTLProfilePicture(profileImage)
            }
            
        }
    }
    
    func nextPage(_ sender: AnyObject) {
        
        print("you usually go: \(youUsuallyGo)")
        let next = self.storyboard?.instantiateViewController(withIdentifier: "displayThree") as! DisplayPagesThreeViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    var selected: UIButton!
    
    
    func singleSelect(_ sender: UIButton) {
        
//        var flag = 0
        
        for button in radioButtons {
            
            print("here 1")
            
            if selected != nil && selected == button {
                
                print("here 2")
                
                selected.setBackgroundImage(UIImage(named: "halfnhalfbgGray"), for: UIControlState())
//                flag = 1
                
            }
            
        }
        
        print("here 3")
        
        selected = sender
        selected.setBackgroundImage(UIImage(named: "halfgreenbox"), for: UIControlState())
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
