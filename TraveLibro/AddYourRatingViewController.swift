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
    var reviews: [JSON] = []
    var orangeLine: drawLine!
    var scroll: UIScrollView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBackGround(self)
        
        layout = VerticalLayout(width: self.view.frame.width)
        
        scroll = UIScrollView(frame: self.view.frame)
        scroll.frame.origin.y = 100
        self.view.addSubview(scroll)
        scroll.showsVerticalScrollIndicator = false
        
        getReviews()
        
        let profileImage = UIImageView(frame: CGRect(x: 0, y: 85, width: 100, height: 100))
        profileImage.center.x = self.view.frame.width/2
        profileImage.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])")!))
        makeTLProfilePicture(profileImage)
        layout.addSubview(profileImage)
        
        print("layout height: \(layout.frame.height)")
        
        orangeLine = drawLine(frame: CGRect(x: profileImage.center.x, y: profileImage.center.y, width: 10, height: layout.frame.height))
        orangeLine.backgroundColor = UIColor.clear
        scroll.addSubview(orangeLine)
        scroll.addSubview(layout)
        
    }
    
    func addHeightToLayout(_ height: CGFloat) {
        
        layout.frame.size.height += height + 100
        orangeLine.frame.size.height += height + 100
        scroll.contentSize.height = layout.frame.height
        print("layout height: \(layout.frame.height)")
    }
    
    func showRating() {
        
        for review in reviews {
            
            addRating(post: review)
        }
        
        
    }
    
    func addRating(post: JSON) {
        
        let rating = Rating(frame: CGRect(x: 0, y: 20, width: layout.frame.width, height: 225))
        rating.checkInTitle.text = "Your Review Of \(post["city"].string!.capitalized)"
        rating.reviewDescription.text = post["review"].string!
        rating.date.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "dd-MM-yyyy", date: post["createdAt"].string!, isDate: true)
        rating.time.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "h:mm a", date: post["createdAt"].string!, isDate: false)
        rating.lines = rating.reviewDescription.text!.characters.count/55
        rating.textViewHeight = CGFloat(rating.lines) * 19.2
        
        if Float(rating.reviewDescription.frame.height) > Float(rating.textViewHeight) {
            
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
    
    func getStars(_ view: Rating, stars: Int) {
        
        for i in 0 ..< stars {
            
            view.stars[i].image = UIImage(named: "star_check")
            
        }

    }
    
    func changeDateFormat(_ givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = getFormat
        
        if isDate {
            
            dateFormatter.dateStyle = .medium
            
        }
        
        let goodDate = dateFormatter.string(from: date!)
        return goodDate
        
    }
    

    func getReviews() {
        
        request.journeyTypeData(journeyId, type: "reviews", userId: currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.reviews = response["data"]["reviews"].array!
                    self.showRating()
                    
                }
                else {
                    
                    print("response error")
                    
                }
                
            })
            
        })
        
    }

}
