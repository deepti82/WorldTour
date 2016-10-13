//
//  AddYourRatingViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddYourRatingViewController: UIViewController {
    
    var layout: VerticalLayout!
    var journeyId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBackGround(self)
        
        layout = VerticalLayout(width: self.view.frame.width - 40)
        
        let scroll = UIScrollView(frame: self.view.frame)
        self.view.addSubview(scroll)
        scroll.showsVerticalScrollIndicator = false
        scroll.addSubview(layout)
        
        getReviews()
        
        let profileImage = UIImageView(frame: CGRect(x: 0, y: 85, width: 100, height: 100))
        profileImage.center.x = self.view.frame.width/2
        profileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])")!)!)
        makeTLProfilePicture(profileImage)
        layout.addSubview(profileImage)
        
        for i in 0 ..< 6 {
            
            addRating()
            
        }
        
//        let ratingTwo = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingTwo.frame.height)
//        layout.addSubview(ratingTwo)
//        
//        let ratingThree = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingThree.frame.height)
//        layout.addSubview(ratingThree)
//        
//        let ratingFour = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingFour.frame.height)
//        layout.addSubview(ratingFour)
//        
//        let ratingFive = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingFive.frame.height)
//        layout.addSubview(ratingFive)
//        
//        let ratingSix = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingSix.frame.height)
//        layout.addSubview(ratingSix)
        
        scroll.contentSize.height = layout.frame.height
    }
    
    func addHeightToLayout(height: CGFloat) {
        
        layout.frame.size.height += height + 100
        
    }
    
    func addRating() {
        
        let ratingOne = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
        addHeightToLayout(ratingOne.frame.height)
        layout.addSubview(ratingOne)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getReviews() {
        
        request.journeyTypeData(journeyId, type: "reviews", userId: currentUser["_id"].string!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    
                    
                }
                else {
                    
                    print("response error")
                    
                }
                
            })
            
        })
        
    }

}
