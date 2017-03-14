//
//  AddYourRatingViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddYourRatingViewController: UIViewController {
    let border = CALayer()
    var rating = Rating()
    var layout: VerticalLayout!
    var journeyId = ""
    var reviews: [JSON] = []
    var orangeLine: drawLine!
    var scroll: UIScrollView! = nil
    var loader = LoadingOverlay()
    override func viewDidLoad() {
        super.viewDidLoad()
//        getBackGround(self)
        getDarkBackGround(self)
        createNavigation()
        layout = VerticalLayout(width: self.view.frame.width)
        
        scroll = UIScrollView(frame: self.view.frame)
        scroll.frame.origin.y = 0
        self.view.addSubview(scroll)
        scroll.showsVerticalScrollIndicator = false
        
        getReviews()
        
//        let profileImage = UIImageView(frame: CGRect(x: 0, y: 85, width: 100, height: 100))
//        profileImage.center.x = self.view.frame.width/2
//        profileImage.image = UIImage(named: "logo-default")
//        profileImage.hnk_setImageFromURL(getImageURL(currentUser["profilePicture"].stringValue, width: 100))
//        makeTLProfilePicture(profileImage)
//        layout.addSubview(profileImage)
        
        print("layout height: \(layout.frame.height)")
        
//        orangeLine = drawLine(frame: CGRect(x: self.view.frame.width/2, y: 0, width: 20, height: 20))
//        orangeLine.backgroundColor = UIColor.clear
//        scroll.addSubview(orangeLine)
        scroll.addSubview(layout)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("navigationBar")
        navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         navigationController?.navigationBar.isTranslucent = true
    }
    
    func createNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func addHeightToLayout(_ height: CGFloat) {
        
        layout.frame.size.height += height + 100
//        orangeLine.frame.size.height += height + 100
        scroll.contentSize.height = layout.frame.height
        print("layout height: \(layout.frame.height)")
    }
    
    func showRating() {
        
        for review in reviews {
            
            addRating(post: review)
        }
        
        
    }
    
    func addRating(post: JSON) {
        print("One post ..............")
        print(post)
        let rating = Rating(frame: CGRect(x: 0, y: 0, width: layout.frame.width, height: 165))
        
        if post["city"] != nil {
            rating.checkInTitle.text = "\(post["city"].string!.capitalized)"
        }else{
            rating.checkInTitle.text = ""
        }
        rating.reviewDescription.text = post["review"].string!
        rating.date.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "dd-MM-yyyy", date: post["createdAt"].string!, isDate: true)
        rating.time.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "h:mm a", date: post["createdAt"].string!, isDate: false)
        rating.lines = rating.reviewDescription.text!.characters.count/55
        rating.textViewHeight = CGFloat(rating.lines) * 19.2
        
        if Float(rating.reviewDescription.frame.height) > Float(rating.textViewHeight) {
            
            let heightDifference = rating.reviewDescription.frame.height - rating.textViewHeight
            rating.frame.size.height -= heightDifference
//            let width = CGFloat(2)
            
            
//            border.frame = CGRect(x: 0, y: rating.frame.size.height - width, width:  rating.frame.size.width, height: rating.frame.size.height)
//            border.borderColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
//            border.borderWidth = width
//            rating.layer.addSublayer(border)
//            rating.layer.masksToBounds = true
        }
        else {
            
            let heightDifference = rating.textViewHeight - rating.reviewDescription.frame.height 
            rating.frame.size.height += heightDifference
//            border.frame = CGRect(x: 0, y: rating.frame.size.height - width, width:  rating.frame.size.width, height: rating.frame.size.height)
//            border.borderColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
//            border.borderWidth = width
//            rating.layer.addSublayer(border)
//            rating.layer.masksToBounds = true

        }
        print(post["rating"].intValue)
        getStars(rating, stars: post["rating"].intValue)

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
