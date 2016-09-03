//
//  DisplayPagesOneViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 01/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var profilePic: String!

var kindOfJourney: [String] = []

class DisplayPagesOneViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var buttonsForView: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        let indicatorOne = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        indicatorOne.image = UIImage(named: "headerindicator1")
        self.navigationItem.titleView = indicatorOne
        
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
        
        request.getUser(currentUser["_id"].string!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
              
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    profilePic = response["data"]["profilePicture"].string!
                    print("image: \(profilePic)")
                    self.setImage()
                    
                }
                else {
                    
                    print("response error: \(response["error"])")
                }
                
            })
            
        })
        
        for button in buttonsForView {
            
            button.addTarget(self, action: #selector(DisplayPagesOneViewController.multipleSelect(_:)), forControlEvents: .TouchUpInside)
            
        }
        
        
//        let theScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        theScrollView.delaysContentTouches = false
//        self.view.addSubview(theScrollView)
        
//        checkBoxNumber = 6
//        
//        let cardView = TutorialCards(frame: CGRect(x: 25, y: 125, width: self.view.frame.width - 50, height: 6 * 125 - 75))
//        cardView.cardTitle.text = "Your kind of journey"
////        cardView.cardDescription.text = cardDescription
//        self.view.addSubview(cardView)
        
    }
    
//    func nextPage(sender: AnyObject) {
//        
//        let next = storyboard?.instantiateViewControllerWithIdentifier("displayTwo") as! DisplayPagesTwoViewController
//        self.navigationController?.pushViewController(next, animated: true)
//        
//    }
    
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
    
    func multipleSelect(sender: UIButton) {
        
        if sender.tag == 0 {
            
            sender.setBackgroundImage(UIImage(named: "halfgreenbox"), forState: .Normal)
            sender.tag = 1
            kindOfJourney.append(sender.titleLabel!.text!)
            
        }
        else {
            
            sender.setBackgroundImage(UIImage(named: "halfnhalfbgGray"), forState: .Normal)
            sender.tag = 0
            kindOfJourney = kindOfJourney.filter{ $0 != sender.titleLabel?.text}
            
        }
        
    }
    
    func nextPage(sender: AnyObject) {
        
        print("kind of journey: \(kindOfJourney)")
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("displayTwo") as! DisplayPagesTwoViewController
        self.navigationController?.pushViewController(next, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
