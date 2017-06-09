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
var photos = PhotosOTG()

extension NewTLViewController {
    
    func editPost(_ id: String) {
        
        for view in layout.subviews {
            
            if view.isKind(of: PhotosOTG.self) {
                
                let subview = view as! PhotosOTG
                
                if id == subview.optionsButton.titleLabel!.text! {
                    
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
                    
                    removeHeightFromLayout(subview.frame.height)
                    subview.removeFromSuperview()
                    
                }
                
            }
            
        }
        
    }
    
    
    func hideAddActivity() {
        editingPostLayout = nil
        isActivityHidden = true;
        addView.removeFromSuperview()
        backView.removeFromSuperview()
        self.setTopNavigation(text: "On The Go");
    }
    
    
    //MARK:- Show Add / Edit Activity
    
    func showAddActivity() {
        isActivityHidden = false;
        hideHeaderAndFooter(false)
        //Add Dard Blur Background
        var darkBlur: UIBlurEffect!
        var blurView: UIVisualEffectView!
        self.backView = UIView();
        self.backView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.view.addSubview(self.backView)
        
        darkBlur = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.backView.frame.height
        blurView.frame.size.width = self.backView.frame.width
        blurView.layer.zPosition = -1
        blurView.isUserInteractionEnabled = false
        self.backView.addSubview(blurView)
        
        self.newScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        self.backView.addSubview(self.newScroll)
        newScroll.bounces = false
        newScroll.bouncesZoom = false
        self.addView = AddActivityNew()
        self.addView.thoughtsTextView.delegate = self
        self.addView.buddyAdded(myJourney["buddies"].arrayValue)
        
        self.addView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.addView.newScroll = self.newScroll;
        self.newScroll.addSubview(self.addView)
        self.newScroll.contentSize.height = self.view.frame.height
        backView.addSubview(newScroll)
        
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.closeAdd(_:)), for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 35)
        
        rightButton.setTitle("Post", for: UIControlState())
        rightButton.titleLabel?.font = avenirBold
        rightButton.titleLabel!.font = UIFont (name: "Avenir-Roman", size: 17)
        rightButton.addTarget(self, action: #selector(self.newPost(_:) ), for: .touchUpInside)
        globalNavigationController.topViewController?.title = "Add Activity"
        globalNavigationController.topViewController?.customNavigationBar(left: leftButton, right: rightButton)
        addView.layer.zPosition = 10
        backView.layer.zPosition = 10
        newScroll.contentSize.height = self.view.frame.height
    }
    
    
    func showEditAddActivity(_ post:Post, onPostLayout:PhotosOTG2?) {
        
        if (onPostLayout != nil) {
            editingPostLayout = onPostLayout
        }
        
        isActivityHidden = false;
        hideHeaderAndFooter(false)
        var darkBlur: UIBlurEffect!
        var blurView: UIVisualEffectView!
        self.backView = UIView();
        self.backView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.view.addSubview(self.backView)        
        darkBlur = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.backView.frame.height
        blurView.frame.size.width = self.backView.frame.width
        blurView.layer.zPosition = -1
        blurView.isUserInteractionEnabled = false
        self.backView.addSubview(blurView)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: darkBlur)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        blurView.contentView.addSubview(vibrancyEffectView)
        
        
        self.newScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.backView.addSubview(self.newScroll)
        self.addView = AddActivityNew()
        self.addView.buddyAdded(myJourney["buddies"].arrayValue)
        self.addView.typeOfAddActivtiy = "AddPhotosVideos"
        self.addView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.addView.editPost = post
        self.addView.newScroll = self.newScroll;
        
        self.newScroll.contentSize.height = self.view.frame.height
        backView.addSubview(newScroll)
        
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.closeAdd(_:)), for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        
        rightButton.setTitle("Post", for: UIControlState())
        rightButton.titleLabel?.font = avenirBold
        rightButton.addTarget(self, action: #selector(self.savePhotoVideo(_:) ), for: .touchUpInside)
        globalNavigationController.topViewController?.title = "Add Photos/Videos"
        globalNavigationController.topViewController?.customNavigationBar(left: leftButton, right: rightButton)
        self.addView.layer.zPosition = 10
        
        backView.layer.zPosition = 10
        newScroll.contentSize.height = self.view.frame.height
        
        if(post.videoArr.count > 0) {
            let videoUrl = URL(string:post.videoArr[0].serverUrl)
            self.addView.addVideoToBlock(video: videoUrl)
        }
        
        self.addView.locationView.alpha = 0.1
        self.addView.locationView.isUserInteractionEnabled = false
        
        self.addView.locationView.alpha = 0.1
        self.addView.locationView.isUserInteractionEnabled = false
        
        self.addView.videosInitialView.alpha = 0.1
        self.addView.videosInitialView.isUserInteractionEnabled = false
        
        self.addView.thoughtsInitalView.alpha = 0.1
        self.addView.thoughtsInitalView.isUserInteractionEnabled = false
        
        self.addView.tagFriendsView.alpha = 1
        self.addView.tagFriendsView.isUserInteractionEnabled = true
        self.newScroll.addSubview(self.addView)
    }
    
    func showEditActivity(_ post:Post, onPostLayout:PhotosOTG2?) {
        if (onPostLayout != nil) {
            editingPostLayout = onPostLayout
        }
        
        isActivityHidden = false;
        hideHeaderAndFooter(false)
        var darkBlur: UIBlurEffect!
        var blurView: UIVisualEffectView!
        self.backView = UIView();
        self.backView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.view.addSubview(self.backView)        
        darkBlur = UIBlurEffect(style: .dark)
        blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = self.backView.frame.height
        blurView.frame.size.width = self.backView.frame.width
        blurView.layer.zPosition = -1
        blurView.isUserInteractionEnabled = false
        self.backView.addSubview(blurView)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: darkBlur)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        blurView.contentView.addSubview(vibrancyEffectView)
        
        self.newScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.backView.addSubview(self.newScroll)
        self.addView = AddActivityNew()
        self.addView.thoughtsTextView.delegate = globalNewTLViewController
        
        self.addView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
        self.addView.editPost = post
        self.addView.newScroll = self.newScroll;
        
        self.newScroll.contentSize.height = self.view.frame.height
        backView.addSubview(newScroll)
        
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.closeAdd(_:)), for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        
        rightButton.setTitle("Post", for: UIControlState())
        rightButton.titleLabel?.font = avenirBold
        rightButton.addTarget(self, action: #selector(self.editActivity(_:) ), for: .touchUpInside)
        globalNavigationController.topViewController?.title = "Edit Activity"
        globalNavigationController.topViewController?.customNavigationBar(left: leftButton, right: rightButton)
        self.addView.layer.zPosition = 10
        
        backView.layer.zPosition = 10
        newScroll.contentSize.height = self.view.frame.height
        
        self.addView.typeOfAddActivtiy = "EditActivity"
        if(post.imageArr.count > 0) {
            self.addView.imageArr = post.imageArr
            self.addView.addPhotoToLayout();
        }
        if(post.videoArr.count > 0) {
            let videoUrl = URL(string:post.videoArr[0].serverUrl)
            self.addView.addVideoToBlock(video: videoUrl)
            self.addView.videoCaption = post.videoArr[0].caption
        }
        
        if(post.post_thoughts != "") {
            self.addView.thoughtsTextView.text = post.post_thoughts
            self.addView.thoughtsFinalView.isHidden = false
            self.addView.thoughtsInitalView.isHidden = true
            self.addView.addHeightToNewActivity(10.0)
            self.addView.countCharacters(post.post_thoughts.characters.count)
        }
        
        if(post.post_location != "") {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                self.addView.putLocationName(post.post_location, placeId: nil)
                self.addView.categoryLabel.text = post.post_category
                self.addView.currentCity = post.post_city
                self.addView.currentCountry = post.post_country
                self.addView.currentLat = Float(post.post_latitude)
                self.addView.currentLong = Float(post.post_longitude)                
            })
        }
        self.addView.prevBuddies = post.jsonPost["buddies"].array!
        self.addView.buddyAdded(post.jsonPost["buddies"].array!)
        
        self.addView.photosIntialView.alpha = 0.1
        self.addView.photosIntialView.isUserInteractionEnabled = false
        
        self.addView.videosInitialView.alpha = 0.1
        self.addView.videosInitialView.isUserInteractionEnabled = false
        
        self.newScroll.addSubview(self.addView)
    }
    
    
    
    
    func buddyLeaves(_ post: JSON) {
        
        prevPosts.append(post)
        
        let buddyView = SayBye(frame: CGRect(x: 0, y: 10, width: 300, height: 247))
        buddyView.center.x = self.view.center.x
        buddyView.profileName.text = post["user"]["name"].string!
        DispatchQueue.main.async(execute: {
            buddyView.profileImageView.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(post["user"]["profilePicture"].stringValue)")!))
            HiBye(buddyView.profileImageView)
        })
        layout.addSubview(buddyView)
        addHeightToLayout(height: buddyView.frame.height)
        
    }
    
    func cityChanges(_ post: JSON) {
        
        prevPosts.append(post)
        if(post["location"].string != nil) {
            let changeCityView = ChangeCity(frame: CGRect(x: 0, y: 0, width: width - 120, height: 155))
            changeCityView.center.x = width/2
            changeCityView.cityButton.setTitle(post["location"].string!, for: .normal)
            changeCityView.dateLabel.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM,yyyy", date: post["UTCModified"].stringValue, isDate: true)
            changeCityView.timeLabel.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: post["UTCModified"].stringValue, isDate: false)
            layout.addSubview(changeCityView)
            addHeightToLayout(height: changeCityView.frame.height)
        }
    }
    
    func showReviewPopup(_ sender: UIButton) {
        
        let tapout = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.reviewTapOut(_:)))
        
        
        request.getOneJourneyPost(id: sender.title(for: .application)!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.myReview = response["data"]["review"].array!
                    
                    self.backgroundReview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height))
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
    }
    
    
    func addRatingPost(_ sender: UIButton) {
        print("two")
        if myJourney["user"]["_id"].stringValue == user.getExistingUser() {
            let tapout = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.reviewTapOut(_:)))
            
            backgroundReview = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height))
            backgroundReview.addGestureRecognizer(tapout)
            backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.view.addSubview(backgroundReview)
            self.view.bringSubview(toFront: backgroundReview)
            
            let rating = AddRating(frame: CGRect(x: 0, y: 0, width: width - 40, height: 335))
            rating.center = backgroundReview.center
            rating.layer.cornerRadius = 5
            rating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))

            rating.postReview.setTitle(sender.titleLabel!.text!, for: .application)
            rating.clipsToBounds = true
            rating.navController = self.navigationController!
            backgroundReview.addSubview(rating)
        }
        
    }
    
    func reviewTapOut(_ sender: UITapGestureRecognizer) {
        
        backgroundReview.removeFromSuperview()
        
    }
    
    func removeRatingButton(_ postId: String) {
        
        backgroundReview.removeFromSuperview()
        
        request.getOneJourneyPost(id: postId, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    
                    for subview in self.layout.subviews {
                        
                        if subview.tag == 10 {
                            
                            let view = subview as! RatingCheckIn
                            let viewIndex = self.layout.subviews.index(of: subview)
                            
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
        print("in ongoing journey \(isJourneyOngoing) ----- \(insideView)")
        
        if !isJourneyOngoing {
            height = self.view.frame.height/2
            addNewView = NewQuickItinerary(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            addNewView.layer.zPosition = 1000
            addNewView.profilePicture.contentMode = .scaleAspectFill
            addNewView.profilePicture.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=500")!)
            makeTLProfilePictureNew(addNewView.profilePicture)
            addNewView.profileName.text = currentUser["name"].string!
            self.view.addSubview(addNewView)
            addNewView.otgJourneyButton.addTarget(self, action: #selector(NewTLViewController.checkForLocation(_:)), for: .touchUpInside)
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
        
        for view in self.view.subviews {
            
            if view.isKind(of: UIScrollView.self) {
                
                for subview in view.subviews {
                    
                    if subview.isKind(of:startOTGView.self) {
                        let otg = subview as! startOTGView
                        let localDate = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: date, isDate: true)
                        let localTime = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: date, isDate: false)
                        otg.timestampDate.text = "\(localDate)     |     \(localTime)"
                        flag = 1
                    }
                }
            }
        }
        
        if flag == 0 {
            
            let localDate = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: date, isDate: true)
            let localTime = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: date, isDate: false)
            otgView.timestampDate.text = "\(localDate)     |     \(localTime)" //self.currentTime
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
        
        self.layout.removeAll()
        
        if isInitialPost {
            isInitialPost = false
        }
        if isJourneyOngoing {
            otgView = startOTGView(frame: CGRect(x: 0, y: 112, width: mainScroll.frame.width, height: 550))
            print("in on the go otg \(isSelfUser(otherUserID: currentUser["_id"].stringValue))")
            if myJourney != nil {
                if myJourney["user"]["_id"].stringValue != user.getExistingUser() {
                    otgView.optionsButton.isHidden = true
                }
            }else{
                otgView.optionsButton.isHidden = true

            }
            
            
            otgView.startJourneyButton.addTarget(self, action: #selector(NewTLViewController.startOTGJourney(_:)), for: .touchUpInside)
            otgView.selectCategoryButton.addTarget(self, action: #selector(NewTLViewController.journeyCategory(_:)), for: .touchUpInside)
            otgView.addBuddiesButton.addTarget(self, action: #selector(NewTLViewController.addBuddies(_:)), for: .touchUpInside)
            self.otgView.cityImage.hnk_setImageFromURL(URL(string: adminUrl + "upload/readFile?file=" + journey["startLocationPic"].stringValue)!)
            //                otgView.detectLocationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.detectLocationViewTap(_:))))
            //                otgView.detectLocationButton.addTarget(self, action: #selector(NewTLViewController.detectLocation(_:)), for: .touchUpInside)
            otgView.nameJourneyTF.returnKeyType = .done
            otgView.locationLabel.returnKeyType = .done
            otgView.locationLabel.delegate = self
            otgView.optionsButton.addTarget(self, action: #selector(NewTLViewController.optionsAction(_:)), for: .touchUpInside)
            otgView.clipsToBounds = true
            
            
            otgView.journeyName.isHidden = false
            otgView.journeyName.text = journey["name"].string!
            //self.title = journey["name"].string!
            self.title = "On The Go"
            otgView.startJourneyButton.isHidden = true
            otgView.detectLocationView.isHidden = true
            otgView.addBuddiesButton.isHidden = true
            otgView.selectCategoryButton.isHidden = true
            otgView.bonVoyageLabel.isHidden = false
            otgView.cityView.isHidden = false
            otgView.cityDetails.isHidden = false
            otgView.placeLabel.text = journey["startLocation"].string!
            otgView.journeyDetails.isHidden = false
            otgView.buddyStack.isHidden = false
            
            layout.addSubview(otgView)
            self.addHeightToLayout(height: 50.0)
            
            //            detectLocation(nil)
            
            journeyDateChanged(date: journey["startTime"].string!)
            
            let jc = journey["kindOfJourney"].array!
            journeyCategories = []
            for each in jc {
                
                journeyCategories.append(each.string!)
                
            }
            
            makeCoverPic(journey["startLocationPic"].stringValue)
            
            self.journeyId = journey["uniqueId"].string!
            showDetailsFn(isEdit: false)
            
            getJourneyBuddies(journey: journey)
            //            addedBuddies = journey["buddies"].array!
            countLabel = journey["buddies"].arrayValue.count
            showBuddies()
            
            self.otgView.journeyName.animation.makeY(125).animate(0.1)
            
            let allPosts = journey["post"].array!
            self.getAllPosts(allPosts)
            let p = Post()
            let offLinePost:[Post] = p.getAllPost(journey:journeyId);
            for sPost in offLinePost {
                self.addPostLayout(sPost)
            }
        }
        
        if !showDetails {
            self.view.addSubview(mainScroll)
            
            for view in self.view.subviews {
                
                if view.isKind(of: UIScrollView.self) {
                    
                    for subview in view.subviews {
                        
                        if subview.isKind(of: startOTGView.self) {
                            
                            view.removeFromSuperview()
                            
                        }
                        else if subview.isKind(of: drawLine.self) {
                            
                            subview.removeFromSuperview()
                            
                        }
                        
                    }
                    
                }
                
            }
        }
        
        self.view.bringSubview(toFront: toolbarView)
        self.view.bringSubview(toFront: addPostsButton)
        self.view.bringSubview(toFront: mainFooter)
        self.view.bringSubview(toFront: infoButton)
        if globalNewTLViewController?.fromOutSide == "" {
            self.scrollToBottom();

        }
        
    }
    
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: mainScroll.contentSize.height - mainScroll.bounds.size.height)
        mainScroll.setContentOffset(bottomOffset, animated: true)
    }
    
    
    func scrollToBottom1() {
        let bottomOffset = CGPoint(x: 0, y: mainScroll.contentSize.height - mainScroll.bounds.size.height - 150)
        mainScroll.setContentOffset(bottomOffset, animated: true)
    }

    
    func getJourneyBuddies(journey: JSON) {
        addedBuddies = journey["buddies"].array!
    }
    
    func getInfoCount() {
        
        self.showInfo(JSON("{}"))
        
        if (myJourney != nil) {
            
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
            
        }else{
            print("my journey")
        }
        
        
        
    }
    
    func showInfo(_ response: JSON) {
        
        
        // self.infoView.crollInoView.contentSize.height = 1000
        self.infoView.crollInoView.isScrollEnabled = true
        self.infoView.crollInoView.scrollsToTop = true
        
        self.infoView.summaryButton.addTarget(self, action: #selector(NewTLViewController.gotoSummaries(_:)), for: .touchUpInside)
        self.infoView.photosButton.tag = response["photos"].intValue
        self.infoView.photosButton.addTarget(self, action: #selector(NewTLViewController.gotoPhotos(_:)), for: .touchUpInside)
        self.infoView.videosButton.tag = response["videos"].intValue
        self.infoView.videosButton.addTarget(self, action: #selector(NewTLViewController.gotoVideos(_:)), for: .touchUpInside)
        self.infoView.reviewsButton.tag = response["review"].intValue
        self.infoView.reviewsButton.addTarget(self, action: #selector(NewTLViewController.gotoReviews(_:)), for: .touchUpInside)
        self.infoView.mustDoButton.addTarget(self, action: #selector(NewTLViewController.gotoMustDo(_:)), for: .touchUpInside)
        self.infoView.hotelsButton.addTarget(self, action: #selector(NewTLViewController.gotoHotels(_:)), for: .touchUpInside)
        self.infoView.restaurantsButton.addTarget(self, action: #selector(NewTLViewController.gotoRestaurants(_:)), for: .touchUpInside)
        self.infoView.itinerariesButton.addTarget(self, action: #selector(NewTLViewController.gotoItineraries(_:)), for: .touchUpInside)
        self.infoView.nearMeButton.addTarget(self, action: #selector(NewTLViewController.gotoNearMe(_:)), for: .touchUpInside)
        self.infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.closeInfo(_:))))
        
        if(response["videos"].number != nil) {
            
            self.infoView.videosCount.setTitle("\(response["videos"])", for: .normal)
            self.infoView.photosCount.setTitle("\(response["photos"])", for: .normal)
            self.infoView.ratingCount.setTitle("\(response["review"])", for: .normal)
            self.infoView.mustDoCount.setTitle("\(response["mustDo"])", for: .normal)
            self.infoView.hotelsCount.setTitle("\(response["hotel"])", for: .normal)
            self.infoView.restaurantCount.setTitle("\(response["restaurant"])", for: .normal)
            self.infoView.itinerariesCount.setTitle("\(response["itinerary"])", for: .normal)
            
            self.infoView.videosCount.alpha = 1
            self.infoView.photosCount.alpha = 1
            self.infoView.ratingCount.alpha = 1
            
        } else {
            self.infoView.videosCount.alpha = 0
            self.infoView.photosCount.alpha = 0
            self.infoView.ratingCount.alpha = 0
        }
        
        self.infoView.aboutLocationText.text = "About \(latestCity)"
        self.infoView.layer.opacity = 1.0
        self.infoView.isHidden = false
        self.view.addSubview(self.infoView)
        self.view.bringSubview(toFront: self.infoView)
        
        
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

