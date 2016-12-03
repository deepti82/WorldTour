//
//  DisplayPagesOneViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 01/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var profilePic: String!



let emptyCircle = String(format: "%C", faicon["emptyCircle"]!)
let fullCircle = String(format: "%C", faicon["fullCircle"]!)

class DisplayPagesOneViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var buttonsForView: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
//        let indicatorOne = UIImageView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
//        indicatorOne.image = UIImage(named: "indicatorOne")
//        self.navigationItem.titleView = indicatorOne
        
        
//        self.navigationItem.title.
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(DisplayPagesTwoViewController.nextPage(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        self.title = "\(fullCircle)    \(emptyCircle)    \(emptyCircle)     \(emptyCircle)"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : UIFont(name: "FontAwesome", size: 10)!]
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self
            .popVC(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(DisplayPagesTwoViewController.nextPage(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        request.getUser(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
              
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    for button in self.buttonsForView {
                        print(button.titleLabel?.text!)
                    }
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
            
            button.addTarget(self, action: #selector(DisplayPagesOneViewController.multipleSelect(_:)), for: .touchUpInside)
            
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
    
    func multipleSelect(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            sender.setBackgroundImage(UIImage(named: "halfgreenbox"), for: UIControlState())
            sender.tag = 1
            kindOfJourney.append(sender.titleLabel!.text!)
            
        }
        else {
            
            sender.setBackgroundImage(UIImage(named: "halfnhalfbgGray"), for: UIControlState())
            sender.tag = 0
            kindOfJourney = kindOfJourney.filter{ $0 != sender.titleLabel?.text}
            
        }
        
    }
    
    func nextPage(_ sender: AnyObject) {
        
//        let req = ["kindOfHoliday":kindOfJourney]
//        
//        request.addKindOfJourney(currentUser["_id"].string!, editFieldValue: req, completion: {(responce) in
//            DispatchQueue.main.async(execute: {
//                if responce["value"] != true{
//                    self.alert(message: "Enable to save Kind of holiday", title: "Kind of holiday")
//
//                }
                let next = self.storyboard?.instantiateViewController(withIdentifier: "displayTwo") as! DisplayPagesTwoViewController
                self.navigationController?.pushViewController(next, animated: true)

//            })
//        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
