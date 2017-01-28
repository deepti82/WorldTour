//
//  ListPhotosViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Spring

var globalListPhotosViewController:ListPhotosViewController!


class ListPhotosViewController: UIViewController {
    
    var layout: VerticalLayout!
    var journeyId = ""
    var scroll: UIScrollView!
    var photos: [JSON] = []
    var journeyCreationDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("..................")
        print(self.parent)
        getBackGround(self)
        getJourneyPhotos()
        globalListPhotosViewController = self
        
        layout = VerticalLayout(width: self.view.frame.width)
        
        let profileImage = UIImageView(frame: CGRect(x: 0, y: 85, width: 100, height: 100))
        profileImage.center.x = self.view.frame.width/2
        profileImage.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])")!))
        makeTLProfilePicture(profileImage)
        layout.addSubview(profileImage)
        
        scroll = UIScrollView(frame: self.view.frame)
        self.view.addSubview(scroll)
        scroll.addSubview(layout)
//        scroll.showsVerticalScrollIndicator = false
        
    }
    
    
    func getJourneyPhotos() {
        
        request.journeyTypeData(journeyId, type: "photos", userId: currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    if response["data"]["photos"] != nil {
                    self.photos = response["data"]["photos"].array!
//                    self.makeLayout()
                        for post in response["data"]["photos"].array! {
//                            self.feeds.arrayObject?.append(post)
                            let checkIn = TripPhotoLayout(width: self.view.frame.width)
                            checkIn.scrollView = self.scroll
                            checkIn.createProfileHeader(feed: post)
                            checkIn.tripListView = self
                            self.layout.addSubview(checkIn)
                            self.addHeightToLayout()
                            
                        }
                        
                        self.addHeightToLayout()
                    }
                    
                }
                else {
                    
                    print("response error")
                    
                }
                
            })
            
        })
        
    }
    
    func addHeightToLayout() {
        self.layout.layoutSubviews()
        self.scroll.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height + 60)
        
    }
    
    func addHeightToLayout(_ height: CGFloat) {
        
        layout.frame.size.height += height + 100
        
    }
    
    func addPhoto(_ count: Int, photo: JSON) {
        print("in photo........")
        print(photo)
        let photoList = PhotoList(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 410))
        photoList.videoIcon.isHidden = true
        photoList.commentCount.text = "\(photo["commentCount"]) Comments"
        photoList.likeCount.text = "\(photo["likeCount"]) Likes"
        photoList.mainImage.hnk_setImageFromURL(URL(string: "\(adminUrl)upload/readFile?file=\(photo["name"])&width=100")!)
        let days = getDate(journeyCreationDate, postDate: photo["createdAt"].string!)
        let attributedString = NSMutableAttributedString(string: "Day ", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
        let string = NSMutableAttributedString(string: " 0\(days + 1)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 24)!])
        attributedString.append(string)
        photoList.daysLabel.attributedText = attributedString
        photoList.mi = photo
        photoList.timeLabel.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "HH:mm", date: photo["createdAt"].string!)
        if photo["isDoneLike"] != nil {
            if photo["isDoneLike"].bool! {
                photoList.likeButton = SpringButton(type: .custom)
                let image = UIImage(named: "favorite-heart-button")
                photoList.likeButton.setImage(image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
                
            }
        }
        
        addHeightToLayout(photoList.frame.height)
        layout.addSubview(photoList)
        
    }
    
    func changeDateFormat(_ givenFormat: String, getFormat: String, date: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = getFormat
        dateFormatter.dateStyle = .medium
        let goodDate = dateFormatter.string(from: date!)
        return goodDate
        
    }
    
    func getDate(_ startDate: String, postDate: String) -> Int {
        
        let DFOne = DateFormatter()
        DFOne.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let start = DFOne.date(from: startDate)
        let post = DFOne.date(from: postDate)
        
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start!)
        let date2 = calendar.startOfDay(for: post!)
        
        let flags = NSCalendar.Unit.day
        let components = (calendar as NSCalendar).components(flags, from: date1, to: date2, options: [])
        print("days: \(components.day)")
        return components.day!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
