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
            
            self.view.addSubview(mainScroll)
            mainScroll.addSubview(otgView)
            
        }
        
        self.view.bringSubviewToFront(toolbarView)
        self.view.bringSubviewToFront(addPostsButton)
        self.view.bringSubviewToFront(infoButton)
        
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

