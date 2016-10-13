//
//  AddYourRatingViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddYourRatingViewController: UIViewController {
    
    var layout: VerticalLayout!
    var journeyId = ""
    var reviews: [JSON] = []
    
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
    
    func showRating() {
        
        for review in reviews {
            
            addRating(review)
            
        }
        
        
    }
    
    func addRating(post: JSON) {
        
        let rating = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
        rating.checkInTitle.text = "YOUR REVIEW OF \(post["city"].string!.uppercaseString)"
        rating.reviewDescription.text = post["review"].string!
        rating.date.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "dd-MM-yyyy", date: post["createdAt"].string!)
        rating.time.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "HH:mm a", date: post["createdAt"].string!)
        getStars(rating, stars: post["rating"].int!)
        addHeightToLayout(rating.frame.height)
        layout.addSubview(rating)
        
    }
    
    func getStars(view: Rating, stars: Int) {
        
        for i in 0 ..< stars {
            
            view.stars[i].image = UIImage(named: "star_check")
            
        }

    }
    
    func changeDateFormat(givenFormat: String, getFormat: String, date: String) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = getFormat
        dateFormatter.dateStyle = .ShortStyle
        let goodDate = dateFormatter.stringFromDate(date!)
        return goodDate
        
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
                    
                    self.reviews = response["data"].array!
                    self.showRating()
                    
                }
                else {
                    
                    print("response error")
                    
                }
                
            })
            
        })
        
    }

}
