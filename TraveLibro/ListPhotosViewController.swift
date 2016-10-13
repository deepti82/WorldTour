//
//  ListPhotosViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListPhotosViewController: UIViewController {
    
    var layout: VerticalLayout!
    var journeyId = ""
    var scroll: UIScrollView!
    var photos: [JSON] = []
    var journeyCreationDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBackGround(self)
        
        getJourneyPhotos()
        
        layout = VerticalLayout(width: self.view.frame.width - 40)
        
        let profileImage = UIImageView(frame: CGRect(x: 0, y: 85, width: 100, height: 100))
        profileImage.center.x = self.view.frame.width/2
        profileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])")!)!)
        makeTLProfilePicture(profileImage)
        layout.addSubview(profileImage)
        
        scroll = UIScrollView(frame: self.view.frame)
        self.view.addSubview(scroll)
        scroll.showsVerticalScrollIndicator = false
        
//        let ratingOne = Rating(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 225))
//        addHeightToLayout(ratingOne.frame.height)
//        layout.addSubview(ratingOne)
//        
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
        
    }
    
    func makeLayout() {
        
        for i in 0 ..< photos.count {
            
            addPhoto(i, photo: photos[i])
            
        }
        
        scroll.contentSize.height = layout.frame.height
        scroll.addSubview(layout)
        
    }
    
    func getJourneyPhotos() {
        
        request.journeyTypeData(journeyId, type: "photos", userId: currentUser["_id"].string!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    self.photos = response["data"].array!
                    self.makeLayout()
                    
                }
                else {
                    
                    print("response error")
                    
                }
                
            })
            
        })
        
    }
    
    func addHeightToLayout(height: CGFloat) {
        
        layout.frame.size.height += height + 100
        
    }
    
    func addPhoto(count: Int, photo: JSON) {
        
        let photoList = PhotoList(frame: CGRect(x: 20, y: 20, width: layout.frame.width, height: 425))
        photoList.videoIcon.hidden = true
        photoList.commentCount.text = "\(photo["commentCount"]) Comments"
        photoList.likeCount.text = "\(photo["likeCount"]) Likes"
        photoList.mainImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(photo["name"])")!)!)
        let days = getDate(journeyCreationDate, postDate: photo["createdAt"].string!)
        let attributedString = NSMutableAttributedString(string: "Day ", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
        let string = NSMutableAttributedString(string: " 0\(days + 1)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 24)!])
        attributedString.appendAttributedString(string)
        photoList.daysLabel.attributedText = attributedString
        photoList.timeLabel.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "HH:mm", date: photo["createdAt"].string!)
        if photo["isDoneLike"] {
            
            photoList.likeButton.setImage(UIImage(named: "favorite-heart-button"), forState: .Normal)
        }
        addHeightToLayout(photoList.frame.height)
        layout.addSubview(photoList)
        
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
    
    func getDate(startDate: String, postDate: String) -> Int {
        
        let DFOne = NSDateFormatter()
        DFOne.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let start = DFOne.dateFromString(startDate)
        let post = DFOne.dateFromString(postDate)
        
        let calendar = NSCalendar.currentCalendar()
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDayForDate(start!)
        let date2 = calendar.startOfDayForDate(post!)
        
        let flags = NSCalendarUnit.Day
        let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
        print("days: \(components.day)")
        return components.day
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
