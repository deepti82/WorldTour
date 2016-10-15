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
import SwiftyJSON
import BSImagePicker
import Photos
import CoreLocation
import ActiveLabel

extension NewTLViewController {
    
    func editPost(id: String) {
        
        for view in layout.subviews {
            
            if view.isKindOfClass(PhotosOTG) {
                
                let subview = view as! PhotosOTG
                
                if id == subview.optionsButton.titleLabel!.text! {
                    
                    print("inside removing subviews")
                    removeHeightFromLayout(subview.frame.height)
                    subview.removeFromSuperview()
                    
                }
                
            }
            
        }
        
        
    }
    
    func deleteFromLayout(id: String) {
        
        for view in layout.subviews {
            
            if view.isKindOfClass(PhotosOTG) {
                
                let subview = view as! PhotosOTG
                
                if  subview.optionsButton.titleLabel!.text! == id {
                    
                    print("inside delete subview")
                    removeHeightFromLayout(subview.frame.height)
                    subview.removeFromSuperview()
                    
                }
                
                
            }
            
            
        }
        
        
    }
    
    func buddyLeaves(post: JSON) {
        
        prevPosts.append(post)
        
        if isInitialPost {
            
            layout = VerticalLayout(width: self.view.frame.width)
            layout.frame.origin.y = 600
            mainScroll.addSubview(layout)
            isInitialPost = false
            
        }
        
        let buddyView = BuddyLeaves(frame: CGRect(x: 0, y: 10, width: 300, height: 215))
        buddyView.profileName.text = post["user"]["name"].string!
        buddyView.profilePicture.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(post["user"]["profilePicture"])")!)!)
        makeTLProfilePicture(buddyView.profilePicture)
        layout.addSubview(buddyView)
        addHeightToLayout(buddyView.frame.height)
        
    }
    
    func cityChanges(post: JSON) {
        
        print("in change city post")
        prevPosts.append(post)
        
        if isInitialPost {
            layout = VerticalLayout(width: self.view.frame.width)
            layout.frame.origin.y = 600
            mainScroll.addSubview(layout)
            isInitialPost = false
        }
        
        let changeCityView = ChangeCity(frame: CGRect(x: 0, y: 50, width: width - 120, height: 100))
        changeCityView.center.x = width / 2
        changeCityView.cityButton.setTitle(post["location"].string!, forState: .Normal)
        layout.addSubview(changeCityView)
        addHeightToLayout(changeCityView.frame.height)
        
        print("\(#line) \(post)")
        
        
    }
    
    func showReviewPopup(sender: UIButton) {
        
        let tapout = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.reviewTapOut(_:)))
        
        let lastCount = myReview.count - 1
        
        let background = UIView(frame: self.view.frame)
        background.addGestureRecognizer(tapout)
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.view.addSubview(background)
        self.view.bringSubviewToFront(background)
        
        let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 315))
        rating.center = background.center
        rating.layer.cornerRadius = 5
        rating.ratingDisplay(myReview[lastCount])
//        rating.postReview.setTitle(sender.titleLabel!.text!, forState: .Application)
        rating.postReview.setTitle("CLOSE", forState: .Normal)
        rating.reviewTextView.editable = false
        rating.starsStack.userInteractionEnabled = false
//        rating.starCount.
        
        background.addSubview(rating)
        
        
    }
    
    func addRatingPost(sender: UIButton) {
        
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
        
        let background = UIView(frame: self.view.frame)
        background.addGestureRecognizer(tapout)
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.view.addSubview(background)
        self.view.bringSubviewToFront(background)
        
        let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 315))
        rating.center = background.center
        rating.layer.cornerRadius = 5
        rating.postReview.setTitle(sender.titleLabel!.text!, forState: .Application)
//        rating.postReview.addTarget(self, action: #selector(NewTLViewController.postReview(_:)), forControlEvents: .TouchUpInside)
        background.addSubview(rating)
        
        
    }
    
    func reviewTapOut(sender: UITapGestureRecognizer) {
        
        sender.view!.removeFromSuperview()
        
    }
    
    func removeRatingButton(postId: String) {
        
//        print("layout: \(layout.subviews)")
        
//        for subview in layout.subviews {
//            
//            if subview.isKindOfClass(AddRating) {
//                
//                let view = subview as! AddRating
//                if view.postReview.titleForState(.Application)! == postId {
//                    
//                    removeHeightFromLayout(view.frame.height)
//                    view.removeFromSuperview()
//                    
//                }
//                
//                
//            }
//            
//        }
        
    }
    
    func showJourneyOngoing(journey: JSON) {
        
//        LoadingOverlay.shared.showOverlay(self.view)
        
        if !isJourneyOngoing {
            
            print("no journey ongoing")
            height = self.view.frame.height/2
            addNewView = NewQuickItinerary(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            addNewView.layer.zPosition = 1000
            addNewView.profilePicture.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!)!)
            makeTLProfilePicture(addNewView.profilePicture)
            addNewView.profileName.text = currentUser["name"].string!
            self.view.addSubview(addNewView)
            
            addNewView.otgJourneyButton.addTarget(self, action: #selector(NewTLViewController.newOtg(_:)), forControlEvents: .TouchUpInside)
            addNewView.itineraryButton.addTarget(self, action: #selector(NewTLViewController.newItinerary(_:)), forControlEvents: .TouchUpInside)
            addNewView.closeButton.addTarget(self, action: #selector(NewTLViewController.closeView(_:)), forControlEvents: .TouchUpInside)
            
        }
        else {
            
            height = 70
            getScrollView(height, journey: journey)
            
        }
        
//        LoadingOverlay.shared.hideOverlayView()
        
    }
    
    func getScrollView(height: CGFloat, journey: JSON) {
        
        mainScroll = UIScrollView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height))
        mainScroll.showsVerticalScrollIndicator = false
        mainScroll.showsHorizontalScrollIndicator = false
        refreshControl.addTarget(self, action: #selector(NewTLViewController.refresh(_:)), forControlEvents: .ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        //        mainScroll.addSubview(refreshControl)
        mainScroll.contentSize.height = self.view.frame.height
        mainScroll.addSubview(refreshControl)
        
        let line = drawLine(frame: CGRect(x: self.view.frame.size.width/2, y: 17.5, width: 10, height: mainScroll.frame.height))
        line.backgroundColor = UIColor.clearColor()
        mainScroll.addSubview(line)
        
        otgView = startOTGView(frame: CGRect(x: 0, y: 0, width: mainScroll.frame.width, height: 600))
        otgView.startJourneyButton.addTarget(self, action: #selector(NewTLViewController.startOTGJourney(_:)), forControlEvents: .TouchUpInside)
        otgView.selectCategoryButton.addTarget(self, action: #selector(NewTLViewController.journeyCategory(_:)), forControlEvents: .TouchUpInside)
        otgView.addBuddiesButton.addTarget(self, action: #selector(NewTLViewController.addBuddies(_:)), forControlEvents: .TouchUpInside)
        //        otgView.detectLocationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.detectLocationViewTap(_:))))
        otgView.detectLocationButton.addTarget(self, action: #selector(NewTLViewController.detectLocation(_:)), forControlEvents: .TouchUpInside)
        otgView.nameJourneyTF.returnKeyType = .Done
        otgView.nameJourneyTF.delegate = self
        otgView.locationLabel.returnKeyType = .Done
        otgView.locationLabel.delegate = self
        
        if !isJourneyOngoing {
            
            mainScroll.animation.makeFrame(CGRect(x: 0, y: mainScroll.frame.origin.y - height, width: mainScroll.frame.width, height: mainScroll.frame.height)).animate(0.3)
            line.animation.makeFrame(CGRect(x: self.view.frame.size.width/2, y: 17.5, width: line.frame.width, height: line.frame.height)).animate(0.3)
            
        }
        else {
            
            mainScroll.frame.origin.y = height
            otgView.journeyName.hidden = false
            otgView.journeyName.text = journey["name"].string!
            self.title = journey["name"].string!
            otgView.startJourneyButton.hidden = true
            otgView.detectLocationView.hidden = true
            otgView.addBuddiesButton.hidden = true
            otgView.selectCategoryButton.hidden = true
            otgView.bonVoyageLabel.hidden = true
            otgView.cityView.hidden = false
            otgView.cityDetails.hidden = false
            otgView.placeLabel.text = journey["startLocation"].string!
            otgView.journeyDetails.hidden = false
            otgView.buddyStack.hidden = false
            
            detectLocation(nil)
            
            let dateFormatterTwo = NSDateFormatter()
            dateFormatterTwo.dateFormat = "dd-MM-yyyy HH:mm"
            self.currentTime = dateFormatterTwo.stringFromDate(NSDate())
            print("time: \(self.currentTime)")
            self.otgView.timestampDate.text = self.currentTime
            
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
                
                if view.isKindOfClass(UIScrollView) {
                    
                    for subview in view.subviews {
                        
                        if subview.isKindOfClass(startOTGView) {
                            
                            print("in duplication one")
                            view.removeFromSuperview()
                            
                        }
//                        else if subview.isKindOfClass(drawLine) {
//                            
//                            subview.removeFromSuperview()
//                            
//                        }
                        
                    }
                    
                }
                
            }
            
            mainScroll.addSubview(otgView)
            
        }
        
        self.view.bringSubviewToFront(toolbarView)
        self.view.bringSubviewToFront(addPostsButton)
        self.view.bringSubviewToFront(infoButton)
        
    }
    
    func getInfoCount() {
        
        request.infoCount(myJourney["_id"].string!, city: latestCity, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    self.showInfo(response["data"])
                }
                else {
                    
                    print("response error")
                }
                
            })
            
        })
        
    }
    
    func showInfo(response: JSON) {
        
        print("response of count: \(response)")
        var flag = 0
        var myInfo: TripInfoOTG!
        
        for subview in self.view.subviews {
            
            if subview.isKindOfClass(TripInfoOTG) {
                
                flag = 1
                myInfo = subview as! TripInfoOTG
                
            }
            
        }
        
        if flag == 0 {
            
            print("no subview")
            self.infoView = TripInfoOTG(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
            self.infoView.summaryButton.addTarget(self, action: #selector(NewTLViewController.gotoSummaries(_:)), forControlEvents: .TouchUpInside)
            self.infoView.photosButton.addTarget(self, action: #selector(NewTLViewController.gotoPhotos(_:)), forControlEvents: .TouchUpInside)
            self.infoView.videosButton.addTarget(self, action: #selector(NewTLViewController.gotoPhotos(_:)), forControlEvents: .TouchUpInside)
            self.infoView.reviewsButton.addTarget(self, action: #selector(NewTLViewController.gotoReviews(_:)), forControlEvents: .TouchUpInside)
            self.infoView.mustDoButton.addTarget(self, action: #selector(NewTLViewController.gotoMustDo(_:)), forControlEvents: .TouchUpInside)
            self.infoView.hotelsButton.addTarget(self, action: #selector(NewTLViewController.gotoHotels(_:)), forControlEvents: .TouchUpInside)
            self.infoView.restaurantsButton.addTarget(self, action: #selector(NewTLViewController.gotoRestaurants(_:)), forControlEvents: .TouchUpInside)
            self.infoView.itinerariesButton.addTarget(self, action: #selector(NewTLViewController.gotoItineraries(_:)), forControlEvents: .TouchUpInside)
            self.infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.closeInfo(_:))))
            self.infoView.videosCount.setTitle("\(response["videos"])", forState: .Normal)
            self.infoView.photosCount.setTitle("\(response["photos"])", forState: .Normal)
            self.infoView.ratingCount.setTitle("\(response["review"])", forState: .Normal)
            self.infoView.mustDoCount.setTitle("\(response["mustDo"])", forState: .Normal)
            self.infoView.hotelsCount.setTitle("\(response["hotel"])", forState: .Normal)
            self.infoView.restaurantCount.setTitle("\(response["restaurant"])", forState: .Normal)
            self.infoView.itinerariesCount.setTitle("\(response["itinerary"])", forState: .Normal)
            self.infoView.layer.opacity = 1.0
            self.view.addSubview(self.infoView)
            self.view.bringSubviewToFront(self.infoView)
            
        }
        else {
            
            print("yes subview")
            myInfo.videosCount.setTitle("\(response["videos"])", forState: .Normal)
            myInfo.photosCount.setTitle("\(response["photos"])", forState: .Normal)
            myInfo.ratingCount.setTitle("\(response["review"])", forState: .Normal)
            myInfo.mustDoCount.setTitle("\(response["mustDo"])", forState: .Normal)
            myInfo.hotelsCount.setTitle("\(response["hotel"])", forState: .Normal)
            myInfo.hidden = false
            myInfo.layer.opacity = 1.0
            
        }
        
    }
    
    func gotoMustDo(sender: UIButton) {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("eachCityPagerStripVC") as! EachCityPagerViewController
        vc.city = latestCity
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func gotoHotels(sender: UIButton) {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("eachCityPagerStripVC") as! EachCityPagerViewController
        vc.city = latestCity
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func gotoRestaurants(sender: UIButton) {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("eachCityPagerStripVC") as! EachCityPagerViewController
        vc.city = latestCity
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func gotoItineraries(sender: UIButton) {
        
        let vc = storyboard?.instantiateViewControllerWithIdentifier("eachCityPagerStripVC") as! EachCityPagerViewController
        vc.city = latestCity
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func uploadVideo(url: NSURL, video: AVAsset) {
        
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
//            else if response["value"] {
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

