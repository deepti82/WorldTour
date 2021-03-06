//
//  EndJourneyViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/8/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class EndJourneyViewController: UIViewController {

    @IBOutlet weak var endJourneyTitle: UILabel!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var userDp: UIImageView!
    @IBOutlet weak var journeyCoverPic: UIImageView!
    @IBOutlet weak var buddyStack: UIStackView!
    @IBOutlet weak var categoryStack: UIStackView!
    
    @IBOutlet weak var buddyCount: UILabel!
    @IBOutlet var categoryImages: [UIImageView]!
    @IBOutlet var buddiesImages: [UIImageView]!
    var journeyImages: [String] = []
    var journey: JSON!
    
    @IBAction func changePicture(sender: AnyObject) {
        
        if journeyImages.count > 0 {
            
            let selectImage = storyboard?.instantiateViewControllerWithIdentifier("multipleCollectionVC") as! MyLifeMomentsViewController
            selectImage.whichView = "SelectCover"
            selectImage.images = journeyImages
            self.navigationController?.pushViewController(selectImage, animated: true)
            
        }
        else {
            
            print("No pictures found")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(-10, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setTitle("Done", forState: .Normal)
        rightButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        rightButton.addTarget(self, action: #selector(EndJourneyViewController.doneEndJourney(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(10, 0, 70, 30)
        self.customNavigationBar(leftButton, right: rightButton)
        
//        calendarIcon.text = String(format: "%C", args: faicon["calendar"])
//        clockIcon.text = String(format: "%C", arguments: faicon["clock"])
        
        getAllImages()
        
        userDp.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])")!)!)
        makeTLProfilePicture(userDp)
        endJourneyTitle.text = "\(currentUser["name"]) has ended the \(journey["name"]) Journey"
        
        let buddies = journey["buddies"].array!
        let categories = journey["kindOfJourney"].array!
        
        if buddies.count >= 3 {
            
            buddiesImages[0].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!)!)
            makeTLProfilePicture(buddiesImages[0])
            buddiesImages[1].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(buddies[1]["profilePicture"])")!)!)
            makeTLProfilePicture(buddiesImages[1])
            buddyCount.text = "+\(buddies.count - 2)"
            
        }
        else if buddies.count == 2 {
            
            buddiesImages[0].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!)!)
            makeTLProfilePicture(buddiesImages[0])
            buddiesImages[1].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(buddies[1]["profilePicture"])")!)!)
            makeTLProfilePicture(buddiesImages[1])
            buddyCount.hidden = true
            
        }
        else if buddies.count == 1 {
            
            buddiesImages[0].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!)!)
            makeTLProfilePicture(buddiesImages[0])
            buddiesImages[1].hidden = true
            buddyCount.hidden = true
            
        }
        else {
            
            buddyStack.hidden = true
            
        }
        
        if categories.count >= 3 {
            
            categoryImages[0].image = UIImage(named: "\(categories[0])")
            categoryImages[1].image = UIImage(named: "\(categories[1])")
            categoryImages[2].image = UIImage(named: "\(categories[2])")
            
        }
        else if journey["kindOfJourney"].array!.count == 2 {
            
            categoryImages[0].image = UIImage(named: "\(categories[0])")
            categoryImages[1].image = UIImage(named: "\(categories[1])")
            categoryImages[2].hidden = true
            
        }
        else if journey["kindOfJourney"].array!.count == 1 {
            
            categoryImages[0].image = UIImage(named: "\(categories[0])")
            categoryImages[1].hidden = true
            categoryImages[2].hidden = true
            
        }
        else {
            
            categoryStack.hidden = true
            
        }
        
        
    }
    
    func getAllImages() {
        
        print("in get all images: \(journey)")
        request.getJourneyPhotos(currentUser["_id"].string!, completion: {(response) in
            
            if response.error != nil {
                
                print("error: \(response.error?.localizedDescription)")
            }
            else if response["value"] {
                
                for image in response["data"].array! {
                    
                    self.journeyImages.append(image.string!)
                    
                }
                if response["data"].array!.count > 0 {
                    
                    self.randomImage()
                }
                else {
                    
                   self.makeCoverPicture(self.journey["startLocationPic"].string!)
                    
                }
                
            }
            else {
                
                print("response error!")
            }
            
        })
        
    }
    
    var coverImage = ""
    
    func randomImage() {
        
        let randomIndex = Int(arc4random_uniform(UInt32(journeyImages.count)))
        print(journeyImages[randomIndex])
        self.coverImage = self.journeyImages[randomIndex]
        makeCoverPicture(self.journeyImages[randomIndex])
        
    }
    
    func makeCoverPicture (image: String) {
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.journeyCoverPic.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(image)")!)!)
            
        })
        
    }
    
    func doneEndJourney(sender: UIButton) {
        
        request.endJourney(journey["_id"].string!, uniqueId: journey["uniqueId"].string!, user: currentUser["_id"].string!, userName: currentUser["name"].string!, buddies: journey["buddies"].array!, photo: coverImage, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    print("response arrived!")
                    self.goBack()
                    
                }
                else {
                    
                    print("response error")
                }
                
            })
            
        })
        
        
    }
    
    func goBack() {
            
        print("\(self.navigationController!.viewControllers)")
        let allvcs = self.navigationController!.viewControllers
        for vc in allvcs {
            
            if vc.isKindOfClass(ProfileViewController) {
                
                self.navigationController!.popToViewController(vc, animated: true)
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
