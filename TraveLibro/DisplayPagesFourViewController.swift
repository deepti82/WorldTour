

//
//  DisplayPagesFourViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 01/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


var yourIdeal: [String] = []

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
        
        var json: JSON!
        
        json["kindOfJourney"] = JSON(kindOfJourney)
        json["youUsuallyGo"] = JSON(youUsuallyGo)
        json["preferToTravel"] = JSON(preferToTravel)
        json["yourIdeal"] = JSON(yourIdeal)
        
        print("json: \(json)")
        
//        request.editUser(currentUser["_id"].string!, editField: "", editFieldValue: "", completion: {(response) in
//            
//            if response.error != nil {
//                
//                print("error: \(response.error?.localizedDescription)")
//                
//            }
//            
//            else if response["value"].bool! {
//                
//                print("response arrived!")
//                
//            }
//            
//            else {
//                
//                print("response error: \(response["error"])")
//                
//            }
//        })
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
//        self.slideMenuController()?.changeMainViewController(next, close: true)
        self.navigationController?.pushViewController(next, animated: true)
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
