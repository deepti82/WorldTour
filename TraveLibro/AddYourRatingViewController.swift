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
        
        layout = VerticalLayout(width: self.view.frame.width)
        
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
        
        scroll.contentSize.height = layout.frame.height
        
        let orangeLine = drawLine(frame: CGRect(x: self.view.frame.width/2, y: 40, width: 10, height: layout.frame.height))
//        orangeLine.frame.origin.y = profileImage.frame.origin..y
        layout.addSubview(orangeLine)
        orangeLine.layer.zPosition = 0
        
        
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
        
        let rating = Rating(frame: CGRect(x: 0, y: 20, width: layout.frame.width, height: 225))
        rating.checkInTitle.text = "YOUR REVIEW OF \(post["city"].string!.uppercaseString)"
        rating.reviewDescription.text = post["review"].string!
        rating.date.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "dd-MM-yyyy", date: post["createdAt"].string!, isDate: true)
        rating.time.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "h:mm a", date: post["createdAt"].string!, isDate: false)
        rating.lines = rating.reviewDescription.text!.characters.count/55
        rating.textViewHeight = CGFloat(rating.lines) * 19.2
        
        if rating.reviewDescription.frame.height > rating.textViewHeight {
            
            let heightDifference = rating.reviewDescription.frame.height - rating.textViewHeight
            rating.frame.size.height -= heightDifference
            
            
        }
        else {
            
            let heightDifference = rating.textViewHeight - rating.reviewDescription.frame.height
            rating.frame.size.height += heightDifference
            
            
        }
        
        getStars(rating, stars: post["rating"].int!)
        addHeightToLayout(rating.frame.height)
        layout.addSubview(rating)
        
    }
    
    func getStars(view: Rating, stars: Int) {
        
        for i in 0 ..< stars {
            
            view.stars[i].image = UIImage(named: "star_check")
            
        }

    }
    
    func changeDateFormat(givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = getFormat
        
        if isDate {
            
            dateFormatter.dateStyle = .MediumStyle
            
        }
        
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
