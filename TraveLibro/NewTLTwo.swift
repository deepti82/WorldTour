//
//  NewTLTwo.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/30/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import Foundation
import UIKit
import EventKitUI

import BSImagePicker
import Photos
import CoreLocation

extension NewTLViewController {
    
    func editPost(_ id: String) {
        
        for view in layout.subviews {
            
            if view.isKind(of: PhotosOTG.self) {
                
                let subview = view as! PhotosOTG
                
                if id == subview.optionsButton.titleLabel!.text! {
                    
                    print("inside removing subviews")
                    removeHeightFromLayout(subview.frame.height)
                    subview.removeFromSuperview()
                    
                }
                
            }
            
        }
        
        
    }
    
    func deleteFromLayout(_ id: String) {
        
        for view in layout.subviews {
            
            if view.isKind(of: PhotosOTG.self) {
                
                let subview = view as! PhotosOTG
                
                if  subview.optionsButton.titleLabel!.text! == id {
                    
                    print("inside delete subview")
                    removeHeightFromLayout(subview.frame.height)
                    subview.removeFromSuperview()
                    
                }
                
            }
            
        }
        
    }
    
    func buddyLeaves(_ post: JSON) {
        
        prevPosts.append(post)
        
//        if isInitialPost {
//            
//            layout = VerticalLayout(width: self.view.frame.width)
//            layout.frame.origin.y = 600
//            mainScroll.addSubview(layout)
//            isInitialPost = false
//            
//        }
        
        let buddyView = SayBye(frame: CGRect(x: 0, y: 10, width: 300, height: 250))
        buddyView.center = self.view.center
        buddyView.profileName.text = post["user"]["name"].string!
        buddyView.profileImageView.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(post["user"]["profilePicture"])")!))
        makeTLProfilePicture(buddyView.profileImageView)
        layout.addSubview(buddyView)
        addHeightToLayout(height: buddyView.frame.height)
        
    }
    
    func cityChanges(_ post: JSON) {
        
        print("in change city post")
        prevPosts.append(post)
        
        let changeCityView = ChangeCity(frame: CGRect(x: 0, y: 0, width: width - 120, height: 155))
        changeCityView.center.x = width/2
        changeCityView.cityButton.setTitle(post["location"].string!, for: .normal)
        layout.addSubview(changeCityView)
        addHeightToLayout(height: changeCityView.frame.height)
        
//        print("\(#line) \(post)")
        
        
    }
    
    func showReviewPopup(_ sender: UIButton) {
        
        let tapout = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.reviewTapOut(_:)))
        
        print("id: \(sender.title(for: .application))")
        
        request.getOneJourneyPost(id: sender.title(for: .application)!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.myReview = response["data"]["review"].array!
                    
                    self.backgroundReview = UIView(frame: self.view.frame)
                    self.backgroundReview.addGestureRecognizer(tapout)
                    self.backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                    self.view.addSubview(self.backgroundReview)
                    self.view.bringSubview(toFront: self.backgroundReview)
                   
                    let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
                    rating.center = self.backgroundReview.center
                    rating.layer.cornerRadius = 5
                    rating.ratingDisplay(self.myReview[0])
                    rating.postReview.setTitle("CLOSE", for: .normal)
                    rating.reviewTextView.isEditable = false
                    rating.starsStack.isUserInteractionEnabled = false
                    rating.clipsToBounds = true
                    rating.navController = self.navigationController!
                    rating.postReview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.reviewTapOut(_:))))
                    rating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
                    
                    self.backgroundReview.addSubview(rating)
                    
                    
                }
                else {
                    
                    print("response error")
                }
                
            })
            
        })
        
        print("completed review")
        
    }
    
    
    func addRatingPost(_ sender: UIButton) {
        
//        let backView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: width - 40, height: 280))
//        mainView.center.x = self.view.center.x
//        let ratingView = RatingAlert(frame: CGRect(x: 0, y: 0, width: 20, height: 200))
//        ratingView.center = mainView.center
//
//        backView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
//        backView.center.y = self.view.frame.size.height / 2
//
//        mainView.backgroundColor = UIColor.whiteColor()
//        //mainView.center = CGPointMake(backView.frame.size.width / 2, backView.frame.size.height / 2)
//        mainView.layer.cornerRadius = 5
//
//        mainView.addSubview(ratingView)
//        backView.addSubview(mainView)
//        self.view.addSubview(backView)
//        self.view.bringSubviewToFront(backView)
        
        print("post id: \(sender.titleLabel!.text)")
        
        let tapout = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.reviewTapOut(_:)))
        
        backgroundReview = UIView(frame: self.view.frame)
        backgroundReview.addGestureRecognizer(tapout)
        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.view.addSubview(backgroundReview)
        self.view.bringSubview(toFront: backgroundReview)
        
        let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
        rating.center = backgroundReview.center
        rating.layer.cornerRadius = 5
        rating.postReview.setTitle(sender.titleLabel!.text!, for: .application)
        rating.clipsToBounds = true
        rating.navController = self.navigationController!
//        rating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
//        rating.postReview.addTarget(self, action: #selector(NewTLViewController.postReview(_:)), forControlEvents: .TouchUpInside)
        backgroundReview.addSubview(rating)
        
        
    }
    
    func reviewTapOut(_ sender: UITapGestureRecognizer) {
        
        backgroundReview.removeFromSuperview()
        
    }
    
    func removeRatingButton(_ postId: String) {
        
//        print("layout: \(layout.subviews)")
        backgroundReview.removeFromSuperview()
        
        request.getOneJourneyPost(id: postId, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    print("self is: \(self.layout)")
                    
                    for subview in self.layout.subviews {
                        
                        if subview.tag == 10 {
                            
                            let view = subview as! RatingCheckIn
                            let viewIndex = self.layout.subviews.index(of: subview)
                            print("index: \(viewIndex)")
                            print("remove rating \(view.rateCheckInButton.title(for: .application))")
                            if view.rateCheckInButton.title(for: .application)! == postId {
                                
                                self.removeHeightFromLayout(view.frame.height)
                                view.removeFromSuperview()
                                self.showReviewButton(post: response["data"], isIndex: true, index: viewIndex)
                            }
                            
                            
                        }
                        
                    }
                    
                }
                else {
                    
                    print("response error")
                }
                
            })
            
        })
        
    }
    
    func showJourneyOngoing(journey: JSON) {
        
        if !isJourneyOngoing {
            
            print("no journey ongoing")
            height = self.view.frame.height/2
            addNewView = NewQuickItinerary(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            addNewView.layer.zPosition = 1000
            addNewView.profilePicture.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!))
            makeTLProfilePicture(addNewView.profilePicture)
            addNewView.profileName.text = currentUser["name"].string!
            self.view.addSubview(addNewView)
            
            addNewView.otgJourneyButton.addTarget(self, action: #selector(NewTLViewController.newOtg(_:)), for: .touchUpInside)
            addNewView.itineraryButton.addTarget(self, action: #selector(NewTLViewController.newItinerary(_:)), for: .touchUpInside)
            addNewView.closeButton.addTarget(self, action: #selector(NewTLViewController.closeView(_:)), for: .touchUpInside)
            
        }
        else {
            
            height = 0
            getScrollView(height, journey: journey)
            
        }
        
    }
    
    func journeyDateChanged(date: String) {
        
        var flag = 0
        print("date is: \(date)")
        
        for view in self.view.subviews {
            
            if view.isKind(of: UIScrollView.self) {
                
                for subview in view.subviews {
                    
                    if subview.isKind(of:startOTGView.self) {
                        
                        print("inside here")
                        let otg = subview as! startOTGView
                        let localDate = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: date, isDate: true)
                        let localTime = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: date, isDate: false)
                        otg.timestampDate.text = "\(localDate), \(localTime)"
                        flag = 1
                    }
                }
            }
        }
        
        if flag == 0 {
            
            let localDate = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: date, isDate: true)
            let localTime = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: date, isDate: false)
            otgView.timestampDate.text = "\(localDate), \(localTime)" //self.currentTime
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
    
    func getScrollView(_ height: CGFloat, journey: JSON) {
        
        mainScroll = UIScrollView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height))
        mainScroll.showsVerticalScrollIndicator = false
        mainScroll.showsHorizontalScrollIndicator = false
        refreshControl.addTarget(self, action: #selector(NewTLViewController.refresh(_:)), for: .valueChanged)
        let attributes = [NSForegroundColorAttributeName: UIColor.white]
        let attributedTitle = NSAttributedString(string: "Pull To Refresh", attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = lightOrangeColor
        mainScroll.delegate = self
        mainScroll.contentSize.height = self.view.frame.height
        mainScroll.addSubview(refreshControl)
        
        if isInitialPost {
            
            layout = VerticalLayout(width: self.view.frame.width)
            layout.frame.origin.y = 560
            mainScroll.addSubview(self.layout)
            isInitialPost = false
            
        }
        
        otgView = startOTGView(frame: CGRect(x: 0, y: 0, width: mainScroll.frame.width, height: 600))
        otgView.startJourneyButton.addTarget(self, action: #selector(NewTLViewController.startOTGJourney(_:)), for: .touchUpInside)
        otgView.selectCategoryButton.addTarget(self, action: #selector(NewTLViewController.journeyCategory(_:)), for: .touchUpInside)
        otgView.addBuddiesButton.addTarget(self, action: #selector(NewTLViewController.addBuddies(_:)), for: .touchUpInside)
        //        otgView.detectLocationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.detectLocationViewTap(_:))))
        otgView.detectLocationButton.addTarget(self, action: #selector(NewTLViewController.detectLocation(_:)), for: .touchUpInside)
        otgView.nameJourneyTF.returnKeyType = .done
        otgView.nameJourneyTF.delegate = self
        otgView.locationLabel.returnKeyType = .done
        otgView.locationLabel.delegate = self
        otgView.optionsButton.setTitle(journey["_id"].string, for: .application)
        otgView.optionsButton.addTarget(self, action: #selector(NewTLViewController.optionsAction(_:)), for: .touchUpInside)
        otgView.clipsToBounds = true
        
        if !isJourneyOngoing {
            
            mainScroll.animation.makeFrame(CGRect(x: 0, y: mainScroll.frame.origin.y - height, width: mainScroll.frame.width, height: mainScroll.frame.height)).animate(0.3)
            
        }
        else {
            
            mainScroll.frame.origin.y = height
            otgView.journeyName.isHidden = false
            otgView.journeyName.text = journey["name"].string!
            //self.title = journey["name"].string!
            self.title = "On The Go"
            otgView.startJourneyButton.isHidden = true
            otgView.detectLocationView.isHidden = true
            otgView.addBuddiesButton.isHidden = true
            otgView.selectCategoryButton.isHidden = true
            otgView.bonVoyageLabel.isHidden = true
            otgView.cityView.isHidden = false
            otgView.cityDetails.isHidden = false
            otgView.placeLabel.text = journey["startLocation"].string!
            otgView.journeyDetails.isHidden = false
            otgView.buddyStack.isHidden = false
            
            detectLocation(nil)
            
            journeyDateChanged(date: journey["startTime"].string!)
            
            let jc = journey["kindOfJourney"].array!
            
            for each in jc {
                
                journeyCategories.append(each.string!)
                
            }
            
            makeCoverPic("\(journey["startLocationPic"])")
            
            self.journeyId = journey["uniqueId"].string!
            showDetailsFn()
            
            addedBuddies = journey["buddies"].array!
            countLabel = journey["buddies"].array!.count
            showBuddies()
            
            let allPosts = journey["post"].array!
            self.getAllPosts(allPosts)
            
        }
        
        if !showDetails {
            
            print("in no show details \(self.view.subviews) \(mainScroll.subviews)")
            
            self.view.addSubview(mainScroll)
            
            for view in self.view.subviews {
                
                if view.isKind(of: UIScrollView.self) {
                    
                    for subview in view.subviews {
                        
                        if subview.isKind(of: startOTGView.self) {
                            
                            print("in duplication one")
                            view.removeFromSuperview()
                            
                        }
                        else if subview.isKind(of: drawLine.self) {
                            
                            subview.removeFromSuperview()
                            
                        }
                        
                    }
                    
                }
                
            }
            
            mainScroll.addSubview(otgView)
            
        }
        
        self.view.bringSubview(toFront: toolbarView)
        self.view.bringSubview(toFront: addPostsButton)
        self.view.bringSubview(toFront: infoButton)
        
    }
    
    func getInfoCount() {
        
        request.infoCount(myJourney["_id"].string!, city: latestCity, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.showInfo(response["data"])
                }
                else {
                    
                    print("response error")
                }
                
            })
            
        })
        
    }
    
    func showInfo(_ response: JSON) {
        
        print("response of count: \(response)")
        var flag = 0
        var myInfo: TripInfoOTG!
        
        for subview in self.view.subviews {
            
            if subview.isKind(of: TripInfoOTG.self) {
                
                flag = 1
                myInfo = subview as! TripInfoOTG
                
            }
            
        }
        
        if flag == 0 {
            
            print("no subview")
            self.infoView = TripInfoOTG(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height))
            self.infoView.summaryButton.addTarget(self, action: #selector(NewTLViewController.gotoSummaries(_:)), for: .touchUpInside)
            self.infoView.photosButton.addTarget(self, action: #selector(NewTLViewController.gotoPhotos(_:)), for: .touchUpInside)
            self.infoView.videosButton.addTarget(self, action: #selector(NewTLViewController.gotoPhotos(_:)), for: .touchUpInside)
            self.infoView.reviewsButton.addTarget(self, action: #selector(NewTLViewController.gotoReviews(_:)), for: .touchUpInside)
            self.infoView.mustDoButton.addTarget(self, action: #selector(NewTLViewController.gotoMustDo(_:)), for: .touchUpInside)
            self.infoView.hotelsButton.addTarget(self, action: #selector(NewTLViewController.gotoHotels(_:)), for: .touchUpInside)
            self.infoView.restaurantsButton.addTarget(self, action: #selector(NewTLViewController.gotoRestaurants(_:)), for: .touchUpInside)
            self.infoView.itinerariesButton.addTarget(self, action: #selector(NewTLViewController.gotoItineraries(_:)), for: .touchUpInside)
            self.infoView.nearMeButton.addTarget(self, action: #selector(NewTLViewController.gotoNearMe(_:)), for: .touchUpInside)
            self.infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.closeInfo(_:))))
            self.infoView.videosCount.setTitle("\(response["videos"])", for: UIControlState())
            self.infoView.photosCount.setTitle("\(response["photos"])", for: UIControlState())
            self.infoView.ratingCount.setTitle("\(response["review"])", for: UIControlState())
            self.infoView.mustDoCount.setTitle("\(response["mustDo"])", for: UIControlState())
            self.infoView.hotelsCount.setTitle("\(response["hotel"])", for: UIControlState())
            self.infoView.restaurantCount.setTitle("\(response["restaurant"])", for: UIControlState())
            self.infoView.itinerariesCount.setTitle("\(response["itinerary"])", for: UIControlState())
            self.infoView.aboutLocationText.text = "About \(latestCity)"
            self.infoView.layer.opacity = 1.0
            self.view.addSubview(self.infoView)
            self.view.bringSubview(toFront: self.infoView)
            
        }
        else {
            
            print("yes subview")
            myInfo.videosCount.setTitle("\(response["videos"])", for: UIControlState())
            myInfo.photosCount.setTitle("\(response["photos"])", for: UIControlState())
            myInfo.ratingCount.setTitle("\(response["review"])", for: UIControlState())
            myInfo.mustDoCount.setTitle("\(response["mustDo"])", for: UIControlState())
            myInfo.hotelsCount.setTitle("\(response["hotel"])", for: UIControlState())
            myInfo.isHidden = false
            myInfo.layer.opacity = 1.0
            
        }
        
    }
    
    func gotoMustDo(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "eachCityPagerStripVC") as! EachCityPagerViewController
        vc.city = latestCity
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func gotoHotels(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "eachCityPagerStripVC") as! EachCityPagerViewController
        vc.city = latestCity
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func gotoRestaurants(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "eachCityPagerStripVC") as! EachCityPagerViewController
        vc.city = latestCity
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func gotoItineraries(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "eachCityPagerStripVC") as! EachCityPagerViewController
        vc.city = latestCity
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func gotoNearMe(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "nearMeVC") as! NearMeViewController
        vc.city = latestCity
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func uploadVideo(_ url: URL, video: AVAsset) {
        
        print("format: \(url.lastPathComponent)")
        
//        let exportFilePath = "file://" + NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("\(url.lastPathComponent)")
//        let video =
        
//        request.uploadPhotos(url, completion: {(response) in
//            
//            if response.error != nil {
//                
//                print("response: \(response.error?.localizedDescription)")
//                
//            }
//            else if response["value"].bool! {
//                
//                print("response arrived")
//                
//            }
//            else {
//                
//                print("response error")
//            }
//            
//        })
        
    }
    
}

