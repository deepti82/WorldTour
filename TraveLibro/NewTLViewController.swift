//
//  NewTLViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 26/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import EventKitUI

import BSImagePicker
//import DKImagePickerController
import Photos
import CoreLocation
import ActiveLabel
//fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l < r
//  case (nil, _?):
//    return true
//  default:
//    return false
//  }
//}
//
//fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
//  switch (lhs, rhs) {
//  case let (l?, r?):
//    return l > r
//  default:
//    return rhs < lhs
//  }
//}


var isJourneyOngoing = false
var TLLoader = UIActivityIndicatorView()

class NewTLViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    var myJourney: JSON!
    var isJourney = false
    
    var height: CGFloat!
    var otgView = startOTGView()
    var showDetails = false
    var mainScroll = UIScrollView()
    var infoView: TripInfoOTG!
    var addPosts: AddPostsOTGView!
    var addNewView = NewQuickItinerary()
    
    var journeyName: String!
    var locationData = ""
    let locationManager = CLLocationManager()
//    var locValue:CLLocationCoordinate2D!
    var journeyCategories = [String] ()
    var currentTime: String!
    
    var journeyId: String!
    
    var addedBuddies: [JSON]!
    var addView: AddActivityNew!
    
    @IBOutlet weak var addPostsButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var toolbarView: UIView!
    
    @IBAction func addMoreBuddies(_ sender: AnyObject) {
        
        let getBuddies = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
        getBuddies.whichView = "TLMiddle"
        getBuddies.uniqueId = journeyId
        self.navigationController?.pushViewController(getBuddies, animated: true)
        
    }
    
    @IBAction func endJourneyTapped(_ sender: UIButton) {
        
//        getCurrentOTG()
        
//        dispatch_sync(dispatch_get_main_queue(), {
        
            self.getJourney()
//        })
        
        let end = storyboard!.instantiateViewController(withIdentifier: "endJourney") as! EndJourneyViewController
        end.journey = myJourney
        self.navigationController!.pushViewController(end, animated: true)
        
    }
    
//    @IBOutlet weak var endJourney: UIButton!
    @IBAction func infoCircle(_ sender: AnyObject) {
        
        getInfoCount()
        
    }
    
    var newScroll: UIScrollView!
    let backView = UIView()
    
    @IBAction func addPosts(_ sender: AnyObject) {
        
//        addPosts = AddPostsOTGView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
//        addPosts.addPhotosButton.addTarget(self, action: #selector(NewTLViewController.addPhotosTL(_:)), forControlEvents: .TouchUpInside)
//        addPosts.addCheckInButton.addTarget(self, action: #selector(NewTLViewController.addCheckInTL(_:)), forControlEvents: .TouchUpInside)
//        addPosts.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.closeAdd(_:))))
//        self.view.addSubview(addPosts)
//        addPosts.animation.makeOpacity(1.0).animate(0.5)
//        getJourney()
        
        let postButton = UIButton()
        postButton.setTitle("Post", for: .normal)
        postButton.addTarget(self, action: #selector(self.newPost(_:)), for: .touchUpInside)
        postButton.titleLabel!.font = UIFont(name: "Avenir-Roman", size: 16)
        
//        let leftButton = UIButton()
//        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
//        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
//        leftButton.frame = CGRectMake(-10, 0, 30, 30)

        self.customNavigationBar(left: nil, right: nil)
        self.customNavigationBar(left: nil, right: postButton)
        
        
//        if Reachability.isConnectedToNetwork() {
        
        var flag = 0
        var darkBlur: UIBlurEffect!
        var blurView: UIVisualEffectView!
        
        backView.frame = self.view.frame
        
        for subview in self.view.subviews {
            
            if subview.tag == 8 {
                
                flag = 1
                
            }
            
        }
        
        if flag == 0 {
         
            self.view.addSubview(backView)
            darkBlur = UIBlurEffect(style: .dark)
            blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame.size.height = backView.frame.height
            blurView.frame.size.width = backView.frame.width
            blurView.layer.zPosition = -1
            blurView.isUserInteractionEnabled = false
            backView.addSubview(blurView)
        }
        
        print("in the add posts function")
        uploadedphotos = []
        newScroll = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
        backView.addSubview(newScroll)
        
        addView = AddActivityNew(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        print("add view: \(addView)")
        displayFriendsCount()
        newScroll.addSubview(addView)
        newScroll.contentSize.height = self.view.frame.height
        addLocationTapped(nil)
            
            
//        }
//        else {
//            
//            let alert = UIAlertController(title: "No Internet Connection Found!", message: "", preferredStyle: .Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            self.presentViewController(alert, animated: true, completion: nil)
//            
//        }
        
        addView.addLocationButton.addTarget(self, action: #selector(NewTLViewController.addLocationTapped(_:)), for: .touchUpInside)
        addView.photosButton.addTarget(self, action: #selector(NewTLViewController.addPhotos(_:)), for: .touchUpInside)
        addView.videosButton.addTarget(self, action: #selector(NewTLViewController.addVideos(_:)), for: .touchUpInside)
        addView.thoughtsButton.addTarget(self, action: #selector(NewTLViewController.addThoughts(_:)), for: .touchUpInside)
        addView.tagFriendButton.addTarget(self, action: #selector(NewTLViewController.tagMoreBuddies(_:)), for: .touchUpInside)
        addView.postButton.addTarget(self, action: #selector(NewTLViewController.newPost(_:)), for: .touchUpInside)
        addView.postCancelButton.addTarget(self, action: #selector(NewTLViewController.closeAdd(_:)), for: .touchUpInside)
        
//        let tapOut = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.closeAdd(_:)))
//        addView.addGestureRecognizer(tapOut)
        
    }
    
    func optionsAction(_ sender: UIButton) {
        let optionsController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        optionsController.addAction(UIAlertAction(title: "Edit City", style: .default, handler: nil))
        optionsController.addAction(UIAlertAction(title: "Edit Category", style: .default, handler: nil))
        optionsController.addAction(UIAlertAction(title: "Change Date & Time", style: .default, handler: nil))
        optionsController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(optionsController, animated: true, completion: nil)
    }
    
    func displayFriendsCount() {
        
        if addedBuddies != nil && addedBuddies.count > 0 {
            
            if addedBuddies.count == 1 {
                
                addView.friendsCount.setTitle("1 Friend", for: UIControlState())
                
            }
            else {
                
                addView.friendsCount.setTitle("\(addedBuddies.count) Friends", for: UIControlState())
            }
            
        }
        
    }
    
    func addHeightToNewActivity(_ height: CGFloat) {
        
        print("height: \(height), \(newScroll.contentSize.height)")
        addView.frame.size.height = addView.frame.height + height
        //addView.blurView.frame.size.height = addView.frame.height
        //addView.darkBlur = UIBlurEffect(style: .Dark)
        //addView.blurView = UIVisualEffectView(effect: addView.darkBlur)
        newScroll.contentSize.height = addView.frame.height
        newScroll.bounces = false
        newScroll.showsVerticalScrollIndicator = false
        
    }
    
    func tagMoreBuddies(_ sender: UIButton) {
        
        let next = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
        next.whichView = "TLTags"
        next.addedFriends = addedBuddies
//        addBuddies.uniqueId = journeyId
//        addBuddies.journeyName = otgView.journeyName.text!
        self.navigationController!.pushViewController(next, animated: true)
        
    }
    
    func getAllLocations() {
        
        print("all locations: \(locationArray)")
        
        var locationCount = 5
        
        if locationArray.count < 5 {
            
            locationCount = locationArray.count - 1
            
        }
        
        for i in 0 ..< locationCount {
            
            let oneButton = UIButton(frame: CGRect(x: 10, y: 0, width: 200, height: addView.locationHorizontalScroll.frame.height))
            addView.horizontal.addSubview(oneButton)
            addView.styleHorizontalButton(oneButton, buttonTitle: "\(locationArray[i]["name"].string!)")
            oneButton.layoutIfNeeded()
            oneButton.resizeToFitSubviews(addView.locationHorizontalScroll.frame.height, finalHeight: addView.locationHorizontalScroll.frame.height)
            oneButton.addTarget(self, action: #selector(NewTLViewController.selectLocation(_:)), for: .touchUpInside)
//            let stringSize = CGSizeFromString(locationArray[i]["name"].string!)
//            print("string size: \(stringSize)")
//            oneButton.frame.size.width = stringSize.width
            addView.buttonCollection.append(oneButton)
            
        }
        
        let buttonSix = UIButton(frame: CGRect(x: 10, y: 0, width: 100, height: addView.locationHorizontalScroll.frame.height))
        addView.horizontal.addSubview(buttonSix)
        addView.styleHorizontalButton(buttonSix, buttonTitle: "Search")
        addView.buttonCollection.append(buttonSix)
        buttonSix.addTarget(self, action: #selector(NewTLViewController.gotoSearchLocation(_:)), for: .touchUpInside)
        
    }
    
    func gotoSearchLocation(_ sender: UIButton) {
        
        let searchVC = self.storyboard!.instantiateViewController(withIdentifier: "searchLocationsVC") as! SearchLocationTableViewController
        searchVC.places = self.locationArray
        searchVC.location = userLocation
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func hideLocation() {
        
        addView.locationHorizontalScroll.isHidden = true
        addView.categoryView.isHidden = false
        addView.editCategory.addTarget(self, action: #selector(NewTLViewController.selectAnotherCategory(_:)), for: .touchUpInside)
        
    }
    
//    var pickerView = UIPickerView()
    
    func selectAnotherCategory(_ sender: UIButton) {
        
        print("select another category tapped")
        
        let chooseCategory = storyboard?.instantiateViewController(withIdentifier: "editCategory") as! EditCategoryViewController
        self.navigationController?.pushViewController(chooseCategory, animated: true)
        
//        addView.editCategoryPickerView.hidden = false
//        addView.editCategoryPVBar.hidden = false
        
//        pickerView = UIPickerView(frame: CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 200))
//        
//        let barView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 50))
//        pickerView.addSubview(barView)
//        
//        let left = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: barView.frame.height))
//        left.setTitle("Cancel", forState: .Normal)
//        left.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
//        left.addTarget(self, action: #selector(NewTLViewController.cancelPickerView(_:)), forControlEvents: .TouchUpInside)
//        barView.addSubview(left)
//        
//        let right = UIButton(frame: CGRect(x: barView.frame.width - 100, y: 0, width: 100, height: barView.frame.height))
//        right.setTitle("Done", forState: .Normal)
//        right.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 14)
//        right.addTarget(self, action: #selector(NewTLViewController.donePickerView(_:)), forControlEvents: .TouchUpInside)
//        barView.addSubview(right)
//        
//        self.view.addSubview(pickerView)
        
    }
    
//    func cancelPickerView(sender: UIButton) {
//        
//        print("picker view cancelled")
//        
//        pickerView.hidden = true
//        
//    }
//    
//    func donePickerView(sender: UIButton) {
//        
//        print("picker view done")
//        
//        pickerView.hidden = true
//        
//        
//    }
    
    
    func selectLocation(_ sender: UIButton) {
        
        var id = ""
        
        for location in locationArray {
            
            if location["name"].string! == sender.titleLabel!.text! {
                
                id = location["place_id"].string!
                
            }
            
        }
        
        putLocationName(sender.titleLabel!.text!, placeId: id)
        
    }
    
    var currentCity = ""
    var currentCountry = ""
    
    func putLocationName(_ selectedLocation: String, placeId: String) {
        
        self.addView.addLocationButton.setTitle(selectedLocation, for: UIControlState())
        self.addView.locationTag.tintColor = mainOrangeColor
        request.getPlaceId(placeId, completion: { response in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    
                }
                else if response["value"].bool! {
                    
                    self.addView.categoryLabel.text = response["data"].string!
                    self.currentCity = response["city"].string!
                    self.currentCountry = response["country"].string!
                    
                }
                else {
                    
                }
            })
        })
        
        hideLocation()
        
    }
    
    
    var uploadedVideos: [String] = []
    var journeyBuddies: [String] = []
    var isEdit = false
    
    func newPost(_ sender: UIButton) {
        
        print("photos new post \(uploadedphotos)")
        
        let post = Post()
        let buddy = Buddy()
        let photo = Photo()
        
        if !isEdit {
            
            var thoughts = ""
            var location = ""
            var locationCategory = ""
            var photos: [JSON] = []
            var videos: [String] = []
            var buddies: [JSON] = []
            var id = ""
            
            if addView.thoughtsTextView.text != nil && addView.thoughtsTextView.text != "" && addView.thoughtsTextView.text != "Fill Me In..." {
                
                thoughts = addView.thoughtsTextView.text
                print("thoughts: \(thoughts)")
                
            }
            if addView.addLocationButton.titleLabel!.text != nil && addView.addLocationButton.titleLabel!.text != "" && addView.addLocationButton.titleLabel!.text != "Add Location" {
                
                location = addView.addLocationButton.titleLabel!.text!
                print("location: \(location)")
                
            }
            if uploadedphotos.count > 0 {
                
                photos = uploadedphotos
                print("photos new post \(photos)")
                
            }
            if uploadedVideos.count > 0 {
                
                videos = uploadedVideos
                print("videos: \(videos)")
                
            }
            if addedBuddies.count > 0 {
                
//                for buddy in addedBuddies {
//                    
//                    buddies.append(buddy["_id"].string!)
//                    
//                }
                
                buddies = addedBuddies
                print("buddies: \(buddies)")
                
            }
            if journeyId != nil && journeyId != "" {
                
                id = journeyId
                print("id: \(id)")
                
            }
            
            if addView.categoryLabel.text != "Label" && addView.categoryLabel.text != "" {
                
                locationCategory = addView.categoryLabel.text!
                
            }
            
            addView.categoryView.isHidden = true
            addView.categoryLabel.isHidden = false
            addView.locationHorizontalScroll.isHidden = false
            addView.isHidden = true
            newScroll.isHidden = true
            backView.isHidden = true
            
            print("buddies: \(buddies)")
            post.setPost(currentUser["_id"].string!, JourneyId: id, Type: "travelLife", Date: currentTime, Location: location, Category: addView.categoryLabel.text!, Country: currentCountry, City: currentCity, Status: thoughts)
            
            let latestPost = post.getRowCount()
            
            for eachBuddy in buddies {
                
                buddy.setBuddies("\(latestPost+1)", userId: eachBuddy["_id"].string!, userName: eachBuddy["name"].string!, userDp: eachBuddy["profilePicture"].string!, userEmail: eachBuddy["email"].string!)
                
            }
            
            
            if Reachability.isConnectedToNetwork() {
                
                print("internet is connected post")
                request.postTravelLife(thoughts, location: location, locationCategory: locationCategory, photosArray: photos, videosArray: videos, buddies: buddies, userId: currentUser["_id"].string!, journeyId: id, userName: currentUser["name"].string!, city: currentCity, country: currentCountry, completion: {(response) in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if response.error != nil {
                            
                            print("error: \(response.error!.localizedDescription)")
                            
                        }
                        else if response["value"].bool! {
                            
                            print("response arrived new post!")
                            post.flushRows(Int64(latestPost))
                            photo.flushRows(String(latestPost))
                            buddy.flushRows(String(latestPost))
                            self.getJourney()
                            
                        }
                        else {
                            
                            let alert = UIAlertController(title: nil, message:
                                "response error!", preferredStyle: .alert)
                            
                            self.present(alert, animated: false, completion: nil)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                                {action in
                                    alert.dismiss(animated: true, completion: nil)
                            }))
                            print("response error!")
                            
                        }
                        
                    })
                })
                
            } else {
//                let alertController = UIAlertController(title: "No Internet", message: "There is no internet, please try later.", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
//                present(alertController, animated: false, completion: nil)
            }
        
        }
            
        else {
            
            var location = ""
            var thoughts = ""
            var locationCategory = ""
            
            if addView.addLocationButton.titleLabel!.text! != "Add Location" {
                
                location = addView.addLocationButton.titleLabel!.text!
                
            }
            
            if addView.categoryLabel.text != nil && addView.categoryLabel.text != "Label" {
                
                locationCategory = addView.categoryLabel.text!
                
            }
            
            if addView.thoughtsTextView.text != nil && addView.thoughtsTextView.text != "" && addView.thoughtsTextView.text != "Fill me in" {
                
                thoughts = addView.thoughtsTextView.text
                print("\(#line) \(addView.thoughtsTextView.text)")
                
            }
            
            request.editPost(editPostId, location: location, categoryLocation: locationCategory, thoughts: thoughts, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                        
                    else if response["value"].bool! {
                        
                        print("edited response")
                        self.addView.categoryView.isHidden = true
                        self.addView.categoryLabel.isHidden = false
                        self.addView.locationHorizontalScroll.isHidden = false
                        self.addView.isHidden = true
                        self.newScroll.isHidden = true
                        self.backView.isHidden = true
                        self.getJourney()
                        
                    }
                        
                    else {
                        
                        
                        
                        
                    }

                })
                
            })
            
        }
        
    }
    
    var prevPosts: [JSON] = []
    var initialPost = true
    
    
    func getJourney() {
        
        request.getJourney(currentUser["_id"].string!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.detectLocation(nil)
                    
                    self.latestCity = response["data"]["startLocation"].string!
                    
                    if self.isRefreshing {
                        
                        self.refreshControl.endRefreshing()
                        self.isRefreshing = false
                    }
                    
                    print("response get journey \(response["data"]["post"].array!)")
                    isJourneyOngoing = true
                    self.myJourney = response["data"]
                    if self.isInitialLoad {
                        
                        self.isInitialLoad = false
                        self.showJourneyOngoing(journey: response["data"])
                        
                    }
                    else {
                        
                        let allPosts = response["data"]["post"].array!
                        self.getAllPosts(allPosts)
                        
                    }
                    
                }
                else if response["error"]["message"] == "No ongoing journey found" {
                    
                    print("inside no ongoing journey")
                    isJourneyOngoing = false
                    self.showJourneyOngoing(journey: JSON(""))
                    
                }
                else {
                 
                    print("response error!")
                    
                }
            })
            
        })
        
    }
    
    func getAllPosts(_ posts: [JSON]) {
        
        for post in posts {
            
            if post["type"].string! == "join" {
                
                if !self.prevPosts.contains(post) {
                    
                    self.BuddyJoinInLayout(post)
                    
                }
                
            }
                
            else if post["type"].string! == "left" {
                
                if !self.prevPosts.contains(post) {
                    
                    self.buddyLeaves(post)
                    
                }
                
            }
                
            else if post["type"].string! == "cityChange" {
                
                if !self.prevPosts.contains(post) {
                    
                    self.cityChanges(post)
                    
                }
                
            }
                
            else if !self.prevPosts.contains(post) {
                
                print("my post id: \(post["_id"])")
                
                self.configurePost(post)
                
            }
            
        }
        
    }
    
    func closeInfo(_ sender: UITapGestureRecognizer) {
        
        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.isHidden = true
//        
        
    }
    
    func closeAdd(_ sender: UIButton) {
        
//        addView.animation.makeOpacity(0.0).animate(0.5)
        let postDb = Post()
        let postCount = postDb.getRowCount() + 1
        let photosDb = Photo()
        
        photosDb.flushRows(String(postCount))
        
        addView.categoryView.isHidden = true
        addView.categoryLabel.isHidden = false
        addView.locationHorizontalScroll.isHidden = false
        addView.isHidden = true
        newScroll.isHidden = true
        backView.isHidden = true
        
    }
    
    func gotoSummaries(_ sender: UIButton) {
        
        let summaryVC = storyboard?.instantiateViewController(withIdentifier: "summaryTLVC") as! CollectionViewController
        self.navigationController?.pushViewController(summaryVC, animated: true)
        summaryVC.journey = myJourney["_id"].string!
//        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.isHidden = true
        
        
    }
    
    func gotoPhotos(_ sender: UIButton) {
        
        let photoVC = storyboard?.instantiateViewController(withIdentifier: "photoGrid") as! TripSummaryPhotosViewController
        self.navigationController?.pushViewController(photoVC, animated: true)
        photoVC.whichView = "photo"
        photoVC.journey = myJourney["_id"].string!
        photoVC.creationDate = myJourney["startTime"].string!
//        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.isHidden = true
        
    }
    
    func gotoReviews (_ sender: UIButton) {
        
        let ratingVC = storyboard?.instantiateViewController(withIdentifier: "ratingTripSummary") as! AddYourRatingViewController
        self.navigationController?.pushViewController(ratingVC, animated: true)
        ratingVC.journeyId = myJourney["_id"].string!
//        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.isHidden = true
        
    }
    
    func writeImageToFile(_ path: String, completeBlock: (_ success: Bool) -> Void) {
        
//        request.uploadPhotos(NSURL(fileURLWithPath: path), completion: {(response) in
//
//            print("response: \(response)")
//            completeBlock(success: true)
//
//        })
        
    }
    
    let imagePicker = UIImagePickerController()
    var uploadedphotos: [JSON] = []
    
//    func addPhotosTL(sender: UIButton) {
//        
//        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
//        
//        let deleteAction = UIAlertAction(title: "Take Photos", style: .Default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            
//            self.imagePicker.allowsEditing = true
//            self.imagePicker.sourceType = .Camera
////            imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
//            self.presentViewController(self.imagePicker, animated: true, completion: nil)
//            
//        })
//        let saveAction = UIAlertAction(title: "Photos Library", style: .Default, handler: {
//            (alert: UIAlertAction!) -> Void in
//            
//            let multipleImage = BSImagePickerViewController()
//            multipleImage.maxNumberOfSelections = 200
//            
//            self.bs_presentImagePickerController(multipleImage, animated: true,
//                select: { (asset:PHAsset) -> Void in
////                    print("Selected: \(asset)")
//                }, deselect: { (asset: PHAsset) -> Void in
////                    print("Deselected: \(asset)")
//                }, cancel: { (assets: [PHAsset]) -> Void in
////                    print("Cancel: \(assets)")
//                }, finish: { (assets: [PHAsset]) -> Void in
//                    
//                    print("Finish: \(assets)")
//                    
//                    for asset in assets {
//                        
//                        let exportFilePath = "file://" + NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/image.jpg")
//                        
//                        do {
//                            
//                            //            try filemanager.removeItemAtPath("asset.jpg")
//                            
//                            //            try filemanager.createFileAtPath("image.jpg", contents: NSData(), attributes: nil)
//                            let image = self.getAssetThumbnail(asset)
//                            try UIImageJPEGRepresentation(image, 1.0)!.writeToURL(NSURL(string: exportFilePath)!, atomically: false)
//                            print("file created")
//                            request.uploadPhotos(NSURL(string: exportFilePath)!, completion: {(response) in
//                                
//                                print("response upload photos")
//
//                            })
//                        } catch let error as NSError {
//                            
//                            print("error creating file: \(error.localizedDescription)")
//                            
//                        }
//                        
////                        PHImageManager.defaultManager().requestImageDataForAsset(image, options: nil) {
////                            imageData,dataUTI,orientation,info in
////                            let imageURL = info!["PHImageFileURLKey"] as! NSURL
////                            print("imageURL: \(imageURL)")
////                            
////                            request.uploadPhotos(NSURL(string: exportFilePath)!, completion: {(response) in
////                                
////                                print("response arrived!")
////                                
////                            })
////                            
////                        }
//                        
//                    }
//                    
//                    
//                    
//                }, completion: nil)
//            
////            let pickerController = DKImagePickerController()
//            
////            pickerController.didSelectAssets = {(assets: [DKAsset]) in
////                
////                print("didSelectAssets")
////                print(assets)
////                
////                
//////                for image in assets {
////////                    var info: [NSObject : AnyObject]
////////                    let tempImage = info[image] as! UIImage
//////                    
////////                    print("partial path: \(resourcePath)")
//////                    if let resourcePath = NSBundle.mainBundle().resourcePath {
////////                        print("partial path: \(resourcePath)")
////////                        let imgName = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
////////                        print("name: \(imgName)")
//////                        
////////                        let imagename = "IMG_kdslkglkd_dngslgldnsgls_001.jpg"
////////                        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
////////                        let destinationPath = String(documentsPath) + "/" + imagename
//////////                        UIImageJPEGRepresentation(image,1.0)!.writeToFile(destinationPath, atomically: true)
////////                        
////////                        print(destinationPath);
//////                        let imageData: NSData = UIImagePNGRepresentation(image)
//////                        self.writeImageToFile(, completeBlock: {(response) in
//////                            
//////                            print("response: \(response)")
//////                            
//////                        })
////////                        let path = resourcePath + "/" + imgName
////////                        print("path: \(path)")
//////                        
//////                    }
//////                    
//////                }
////                
////            }
//            
////            self.presentViewController(multipleImage, animated: true) {}
//        })
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
//            (alert: UIAlertAction!) -> Void in
//            print("Cancelled")
//        })
//        
//        
//        optionMenu.addAction(deleteAction)
//        optionMenu.addAction(saveAction)
//        optionMenu.addAction(cancelAction)
//        
//        self.presentViewController(optionMenu, animated: true, completion: nil)
//        
//        
//    }
    
    func getAssetThumbnail(_ asset: PHAsset) -> UIImage {
        
        var retimage = UIImage()
        print(retimage)
        
//        dispatch_async(dispatch_get_main_queue(), {
        
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: options, resultHandler: {(result, info) in
                
//                dispatch_async(dispatch_get_main_queue(), {
                
                    print("thumbnail result: \(result)")
                    print("thumbnail info: \(info)")
                    retimage = result!
                    
//                })
                
            })
            
//        })
        
        print(retimage)
        return retimage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
//        print("image: \(image)")
//        print("imageName: \(image.CIImage)")
        
        let videoURL = info["UIImagePickerControllerReferenceURL"] as! URL
        let video = info[UIImagePickerControllerLivePhoto] as! AVAsset
        print("video: ", videoURL, video)
        uploadVideo(videoURL, video: video)
        picker.dismiss(animated: true, completion: nil)
    
    }
    
    func addCheckInTL(sender: UIButton) {
        
        let checkInVC = storyboard?.instantiateViewController(withIdentifier: "checkInSearch") as! CheckInSearchViewController
        checkInVC.whichView = "TL"
        self.navigationController?.pushViewController(checkInVC, animated: true)
        
    }
    
    var layout: VerticalLayout!
    var refreshControl = UIRefreshControl()
    var isInitialLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.gotoProfile(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "info_icon"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(self.infoCircle(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 10, height: 20)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        getJourney()
        
        self.title = "\(currentUser["firstName"].string!)'s New On The Go"
        
        TLLoader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        TLLoader.center = self.view.center
        
        imagePicker.delegate = self
        
//        let darkBlur = UIBlurEffect(style: .dark)
//        let blurView = UIVisualEffectView(effect: darkBlur)
//        blurView.frame = toolbarView.frame
//        blurView.tag = 10
//        blurView.layer.zPosition = -1
//        blurView.isUserInteractionEnabled = false
//        blurView.clipsToBounds = true
//        toolbarView.addSubview(blurView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewTLViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewTLViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        otgView.clipsToBounds = true
        mainScroll.clipsToBounds = true
        
        infoButton.isHidden = true
        addPostsButton.isHidden = true
        
        self.view.bringSubview(toFront: infoButton)
        self.view.bringSubview(toFront: addPostsButton)
        
//        addView.editCategoryPickerView.delegate = self
//        pickerView.delegate = self
        
//        otgView.locationLabel.inputView = pickerView
        otgView.locationLabel.addTarget(self, action: #selector(NewTLViewController.showDropdown(_:)), for: .editingChanged)
        
        self.view.bringSubview(toFront: toolbarView)
        
        self.view.addSubview(TLLoader)
        
    }
    
    func gotoProfile(_ sender: UIButton) {
        
        if isJourneyOngoing {
            
            let profile = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
            self.navigationController!.pushViewController(profile, animated: false)
            
        }
        else {
            
            self.popVC(sender)
            
        }
        
        
//        let viewControllers = self.navigationController!.viewControllers
        
//        for vc in viewControllers {
//            
//            if vc.isKindOfClass(ProfileViewController) {
//                
//                self.navigationController!.showViewController(vc, sender: nil)
//                
//            }
//            
//        }
        
    }
    
    var isRefreshing = false
    
    func refresh(_ sender: AnyObject) {
        
        print("in refresh")
        isRefreshing = true
        getJourney()
        
        
    }
    
    var isInitialPost = true
    var otherCommentId = ""
    var latestCity = ""
    
    func showPost(_ whichPost: String, post: JSON) {
        
        print("previous posts: \(prevPosts.count)")
        print("current post: \(post)")

//        var isEditId = ""
//
//        for prevPost in prevPosts {
//            
//            if prevPost["_id"].string! == post["_id"].string! {
//                
//                print("is in the edit id")
//                isEditId = prevPost["_id"].string!
//                
//            }
//            
//        }
        
        var thoughts = NSMutableAttributedString()
        var postTitle = ""
        var photos: [JSON] = []
//        let tags = ActiveLabel()
        
        if post["thoughts"] != nil && post["thoughts"].string != "" {
            
            print("thoughtts if statement")
            
            thoughts = NSMutableAttributedString(string: "\(post["thoughts"]) ", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
            postTitle = "\(post["thoughts"]) "
            
        }
        
        let buddyAnd = NSAttributedString(string: " and", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
        let buddyWith = NSAttributedString(string: "— with ", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
        
        switch post["buddies"].array!.count {
        
        case 1:
            print("buddies if statement")
            thoughts.append(buddyWith)
            let buddyName = NSAttributedString(string: "\(post["buddies"][0]["name"])", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
            thoughts.append(buddyName)
//            postTitle += "— with \(post["buddies"][0]["name"])"
        case 2:
            print("buddies if statement")
            thoughts.append(buddyWith)
            let buddyName = NSAttributedString(string: "\(post["buddies"][0]["name"])", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
            thoughts.append(buddyName)
            thoughts.append(buddyAnd)
            let buddyCount = NSAttributedString(string: " 1 other", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
            thoughts.append(buddyCount)
            postTitle += " and 1 other"
        case 0:
            print("buddies if statement")
            break
        default:
            print("buddies if statement")
            let buddyCount = NSAttributedString(string: " \(post["buddies"].array!.count - 1)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
            let buddyOthers = NSAttributedString(string: " others", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
            thoughts.append(buddyWith)
            let buddyName = NSAttributedString(string: "\(post["buddies"][0]["name"])", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
            thoughts.append(buddyName)
            thoughts.append(buddyAnd)
            thoughts.append(buddyCount)
            thoughts.append(buddyOthers)
            postTitle += " and \(post["buddies"].array!.count - 1) others"
        }
        
        if post["checkIn"]["location"] != nil && post["checkIn"]["location"] != "" {
            
            print("checkin location if statement")
            let buddyAt = NSAttributedString(string: " at", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
            let buddyLocation = NSAttributedString(string: " \(post["checkIn"]["location"])", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
            thoughts.append(buddyAt)
            thoughts.append(buddyLocation)
            postTitle += " at \(post["checkIn"]["location"])"
            latestCity = post["checkIn"]["city"].string!
            
        }
        
//        dispatch_sync(dispatch_get_main_queue(), {
        
          self.editPost(post["_id"].string!)
            
//        })
        
        let checkIn = PhotosOTG(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 600))
        checkIn.likeButton.setTitle(post["uniqueId"].string!, for: .normal)
        checkIn.likeViewLabel.text = "0 Likes"
        checkIn.commentCount.text = "\(post["comment"].array!.count) Comments"
        checkIn.commentButton.setTitle(post["uniqueId"].string!, for: .normal)
        otherCommentId = post["_id"].string!
        currentPost = post
        checkIn.optionsButton.setTitle(post["_id"].string!, for: .normal)
        checkIn.optionsButton.setTitle(post["uniqueId"].string!, for: .application)
        checkIn.dateLabel.text = changeDate(givenFormat: "yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "dd-MM-yyyy", date: post["UTCModified"].string!, isDate: true) + "  | "
        checkIn.timeLabel.text = changeDate(givenFormat: "yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "h:mm a", date: post["UTCModified"].string!, isDate: false)
        
        checkIn.commentButton.addTarget(self, action: #selector(NewTLViewController.sendComments(_:)), for: .touchUpInside)
        checkIn.optionsButton.addTarget(self, action: #selector(NewTLViewController.chooseOptions(_:)), for: .touchUpInside)
        
        print("is edit: \(isEdit), postid: \(post["_id"].string!)")
        
//        print("\(#line) \(NSAttributedString(attributedString: thoughts))")
        checkIn.photosTitle.attributedText = thoughts
//        checkIn.photosTitle.text = postTitle

        for image in checkIn.otherPhotosStack {
            
            image.isHidden = true
            
        }
        
        if post["photos"] != nil && post["photos"].array!.count > 0 {
            
            photos = post["photos"].array!
            checkIn.mainPhoto.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(post["photos"][0]["name"].string!)&width=500")!))
            print("photobar count: \(photos.count)")
            
            var count = 4
            if photos.count < 5 {
                
                count = photos.count - 1
                print("in the if statement \(count)")
                
            }
            
            for i in 0 ..< count {
                
                print("in the for loop \(post["photos"][i + 1]["name"])")
                checkIn.otherPhotosStack[i].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(photos[i + 1]["name"])&width=500")!))
                checkIn.otherPhotosStack[i].isHidden = false
                
            }
            
        }
        
        else if post["photos"].array!.count == 0 && post["videos"].array!.count == 0 {
            
            checkIn.mainPhoto.isHidden = true
            checkIn.photosStack.isHidden = true
            checkIn.photosHC.constant = 0.0
//            checkIn.frame.size.height = 250.0
            
        }
        
//        checkIn.frame.size.height = setHeight(view: checkIn, thoughts: checkIn.photosTitle.text!, photos: post["photos"].array!.count)
        layout.addSubview(checkIn)
        print("layout views: \(checkIn.frame.size.height)")
        addHeightToLayout(height: checkIn.frame.height + 50.0)
        
        switch whichPost {
        case "CheckIn":
            checkIn.whatPostIcon.setImage(UIImage(named: "location_icon"), for: .normal)

            if post["photos"].array!.count < checkIn.otherPhotosStack.count {
                
                print("in photo comparison")
                
                let difference = checkIn.otherPhotosStack.count - post["photos"].array!.count
                
                for i in 0 ..< difference {
                    
                    print("in difference for loop")
                    
                    let index = checkIn.otherPhotosStack.count - i - 1
                    checkIn.otherPhotosStack[index].isHidden = true
                    
                }
                
            }
            
            if post["checkIn"]["location"] != nil && post["checkIn"]["location"] != "" {
                
                if post["review"].array!.count > 0 {
                    
                    let allReviews = post["review"].array!
                    let lastReviewCount = post["review"].array!.count - 1
                    
                    for subview in layout.subviews {
                        
                        if subview.isKind(of: RatingCheckIn.self) {
                            
                            let myView = subview as! RatingCheckIn
                            if myView.rateCheckInButton.currentTitle! == post["_id"].string! {
                                
                                subview.removeFromSuperview()
                                removeHeightFromLayout(subview.frame.height)
                                
                            }
                            
                        }
                        
                    }
                    
                    let rateButton = ShowRating(frame: CGRect(x: 0, y: 0, width: width, height: 150))
                    myReview = post["review"].array!
                    rateButton.showRating(Int(allReviews[lastReviewCount]["rating"].string!)!)
                    rateButton.rating.addTarget(self, action: #selector(NewTLViewController.showReviewPopup(_:)), for: .touchUpInside)
                    rateButton.rating.setTitle(post["_id"].string!, for: .application)
                    rateButton.tag = Int(allReviews[lastReviewCount]["rating"].string!)!
                    layout.addSubview(rateButton)
                    addHeightToLayout(height: rateButton.frame.height + 20.0)
                    
                }
                
                else {
            
                    let rateButton = RatingCheckIn(frame: CGRect(x: 0, y: 0, width: width, height: 150))
                    rateButton.rateCheckInLabel.text = "Rate \(post["checkIn"]["location"])?"
                    rateButton.rateCheckInButton.addTarget(self, action: #selector(NewTLViewController.addRatingPost(_:)), for: .touchUpInside)
                    rateButton.rateCheckInButton.setTitle(post["_id"].string!, for: .normal)
                    layout.addSubview(rateButton)
                    addHeightToLayout(height: rateButton.frame.height + 20.0)
                    
                }
            
            }
            
        case "Photos":
            checkIn.whatPostIcon.setImage(UIImage(named: "camera_icon"), for: .normal)
        case "Videos":
            checkIn.whatPostIcon.setImage(UIImage(named: "video"), for: .normal)
        case "Thoughts":
            checkIn.whatPostIcon.setImage(UIImage(named: "pen_icon"), for: .normal)
            checkIn.mainPhoto.removeFromSuperview()
            checkIn.photosStack.removeFromSuperview()
        default:
            break
        }
        
    }
    
    var myReview: [JSON] = []
    
    func setHeight(view: UIView, thoughts: String, photos: Int) -> CGFloat {
        
        var lines = 0
        var textHeight: CGFloat = 0.0
        let myView = view as! PhotosOTG
        
        lines = thoughts.characters.count/35
        textHeight = CGFloat(lines) * 19.5
        
        if myView.photosTitle.frame.height > textHeight {
            
            myView.photosTitle.frame.size.height -= textHeight
            
        }
        else {
            
            myView.photosTitle.frame.size.height += textHeight
            
        }
        
        if photos == 1 {
            
            myView.frame.size.height -= myView.photosStack.frame.height
            
        }
        else if photos == 0 {
            
            myView.frame.size.height -= myView.photosStack.frame.height
            myView.frame.size.height -= myView.mainPhoto.frame.height
            
        }
        
        return myView.frame.height
        
    }
    
    func changeDate(givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        
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
    
    func BuddyJoinInLayout(_ post: JSON) {
        
        prevPosts.append(post)
        
        let buddy = BuddyOTG(frame: CGRect(x: 0, y: 0, width: 245, height: 260))
        buddy.center.x = self.view.center.x
        buddy.profileImage.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(post["user"]["profilePicture"])&width=500")!))
        buddy.joinJourneytext.text = "\(post["user"]["name"]) has joined this journey"
        makeTLProfilePicture(buddy.profileImage)
        layout.addSubview(buddy)
        addHeightToLayout(height: buddy.frame.height + 20.0)
        
    }
    
    var selectPhotosCount = 11
    var editPostId = ""
    var currentPost: JSON = []
    var isDelete = false
    var deletePostId = ""
    var datePickerView: UIDatePicker!
    var dateSelected = ""
    var timeSelected = ""
    var inputview: UIView!
    
    func chooseOptions(_ sender: UIButton) {
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            
            
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let EditCheckIn: UIAlertAction = UIAlertAction(title: "Edit Post", style: .default)
        {action -> Void in
            
            self.isEdit = true
            
            request.getOneJourneyPost(sender.titleLabel!.text!, completion: {(response) in
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.newScroll.isHidden = false
                    self.backView.isHidden = false
                    self.addView.isHidden = false
                    self.addView.postButton.setTitle("Edit", for: UIControlState())
                    self.editPostId = sender.titleLabel!.text!
//                    self.addView.postButton.addTarget(self, action: #selector(NewTLViewController.editPost(_:)), forControlEvents: .TouchUpInside)
                    
                    if response["data"]["checkIn"]["location"] != "" {
                        
                        self.addView.addLocationButton.setTitle(response["data"]["checkIn"]["location"].string!, for: UIControlState())
                        self.addView.categoryView.isHidden = true
                        self.addView.categoryLabel.isHidden = false
                        self.addView.locationHorizontalScroll.isHidden = false
                        
                    }
                    
                    else {
                        
                        self.addView.addLocationButton.setTitle("Add Location", for: UIControlState())
                        self.addView.categoryView.isHidden = false
                        self.addView.categoryLabel.isHidden = true
                        
                    }
                    
                    if response["data"]["photos"] != nil && response["data"]["photos"].array!.count > 0 {
                        
                        self.addView.photosFinalView.isHidden = false
                        self.addView.photosIntialView.isHidden = true
                        
                    }
                    
                    else {
                        
                        self.addView.photosFinalView.isHidden = true
                        self.addView.photosIntialView.isHidden = false
                        
                    }
                    
                    if response["data"]["videos"] != nil && response["data"]["videos"].array!.count > 0 {
                        
                        self.addView.videosFinalView.isHidden = false
                        self.addView.videosInitialView.isHidden = true
                        
                    }
                    
                    else {
                        
                        self.addView.videosFinalView.isHidden = true
                        self.addView.videosInitialView.isHidden = false
                        
                    }
                    
                    if response["data"]["thoughts"] != nil && response["data"]["thoughts"].string != "" {
                        
                        self.addView.thoughtsFinalView.isHidden = false
                        self.addView.thoughtsInitalView.isHidden = true
                        
                    }
                    
                    else {
                        
                        self.addView.thoughtsFinalView.isHidden = true
                        self.addView.thoughtsInitalView.isHidden = false
                        
                    }
                    
                    if response["data"]["buddies"] != nil && response["data"]["buddies"].array!.count > 0 {
                        
                        self.addView.friendsCount.setTitle("\(response["data"]["buddies"].array!.count) Friend(s)", for: UIControlState())
                        
                    }
                    
                    else {
                        
                       self.addView.friendsCount.setTitle("0 Friends", for: UIControlState())
                        
                    }
                    
                    
                }
                else {
                    
                    print("response error")
                    
                }
                
            })
            
            print("inside edit check in \(self.addView), \(self.newScroll.isHidden)")
            
        }
        actionSheetControllerIOS8.addAction(EditCheckIn)
        
        let EditDnt: UIAlertAction = UIAlertAction(title: "Change Date & Time", style: .default)
        { action -> Void in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            let minDate = dateFormatter.date(from: "\(self.myJourney["startTime"])")!.toLocalTime()
            
            //Create the view
            self.inputview = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 240, width: self.view.frame.size.width, height: 240))
            self.inputview.backgroundColor = UIColor.white
            self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 40, width: self.inputview.frame.size.width, height: 200))
            self.datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
            self.datePickerView.minimumDate = minDate
            self.datePickerView.maximumDate = Date()
            
            addTopBorder(mainBlueColor, view: self.datePickerView, borderWidth: 1)
            addTopBorder(mainBlueColor, view: self.inputview, borderWidth: 1)
            
            self.inputview.addSubview(self.datePickerView) // add date picker to UIView
            
            let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 100, height: 40))
            doneButton.setTitle("SAVE", for: UIControlState())
            doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            doneButton.setTitleColor(mainBlueColor, for: UIControlState())
            doneButton.setTitle(sender.title(for: .application), for: .application)
            
            self.inputview.addSubview(doneButton) // add Button to UIView
            
            doneButton.addTarget(self, action: #selector(NewTLViewController.doneButton(_:)), for: .touchUpInside) // set button click event
            
            //sender.inputView = inputView
            self.datePickerView.addTarget(self, action: #selector(NewTLViewController.handleDatePicker(_:)), for: .valueChanged)
            
            self.handleDatePicker(self.datePickerView) // Set the date on start.
            self.view.addSubview(self.inputview)
            
        }
        
        actionSheetControllerIOS8.addAction(EditDnt)
        
        let DeletePost: UIAlertAction = UIAlertAction(title: "Delete Post", style: .default)
        { action -> Void in
            
            print("inside delete post \(self.currentPost)")
            request.deletePost(self.currentPost["_id"].string!, uniqueId: self.currentPost["uniqueId"].string!, user: self.currentPost["user"]["_id"].string!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        
                        print("post deleted successfully \(self.currentPost["_id"].string!)")
                        self.isDelete = true
                        self.deletePostId = self.currentPost["_id"].string!
                        self.deleteFromLayout(self.currentPost["_id"].string!)
                        
                    }
                    else {
                        
                        print("response error")
                        
                    }
                    
                    
                })
                
            })
            
        }
        actionSheetControllerIOS8.addAction(DeletePost)
        
        let share: UIAlertAction = UIAlertAction(title: "Copy Share URL", style: .default)
        { action -> Void in
            
            print("inside copy share")
            
        }
        actionSheetControllerIOS8.addAction(share)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    func handleDatePicker(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        dateSelected = dateFormatter.string(from: sender.date)
        timeSelected = timeFormatter.string(from: sender.date)
        print(timeSelected)
    }
    
    func doneButton(_ sender: UIButton){
        request.changeDateTime(sender.title(for: .application)!, date: "\(dateSelected) \(timeSelected)", completion: {(response) in
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                } else if response["value"].bool! {
                    print("edited date time response")
                    print("\(response)")
                } else {
                    
                }
                
            })
            
        })
        
        self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
    }
    
    func sendComments(_ sender: UIButton) {
        
        print("comment button tapped")
        let comment = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
        comment.postId = sender.titleLabel!.text!
        comment.otherId = otherCommentId
        self.navigationController?.pushViewController(comment, animated: true)
        
    }
    
    
    func addHeightToLayout(height: CGFloat) {
        
        layout.frame.size.height = layout.frame.size.height + height
        mainScroll.contentSize.height = mainScroll.contentSize.height + height
        
    }
    
    func removeHeightFromLayout(_ height: CGFloat) {
        
        layout.frame.size.height = layout.frame.size.height - height
        mainScroll.contentSize.height = mainScroll.contentSize.height - height
        
    }
    
    func configurePost(_ post: JSON) {
        
        prevPosts.append(post)
        
        if post["checkIn"]["location"] != nil &&  post["checkIn"].string != "" {
            
            showPost("CheckIn", post: post)
        }
        else if post["photos"] != nil && post["photos"].array!.count > 0 {
            
            showPost("Photos", post: post)
            
        }
        else if post["videos"] != nil && post["videos"].array!.count > 0 {
            
            showPost("Videos", post: post)
        }
        else if post["thoughts"] != nil &&  post["thoughts"].string != "" {
            
            showPost("Thoughts", post: post)
            
        }
        
    }
    
    func getImage(_ myImage: UIImageView, imageValue: String) {
        
        myImage.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(imageValue)&width=500")!))
        
        
    }
    
    func showDropdown(_ sender: UITextField) {
        
        request.searchCity(otgView.locationLabel.text!, completion: {(response) in
            
            if response.error != nil {
                
                print("error: \(response.error!.localizedDescription)")
                
            }
            else if response["value"].bool! {
                
                
                
            }
            else {
                
            }
            
        })
    }
    
    
    func newOtg(_ sender: UIButton) {
        
        print("start new on the go")
        addNewView.animation.makeOpacity(0.0).animate(0.5)
        addNewView.isHidden = true
        getScrollView(height, journey: JSON(""))
        
    }
    
    func newItinerary(_ sender: UIButton) {
        
        let itineraryVC = storyboard?.instantiateViewController(withIdentifier: "qiPVC") as! QIViewController
        self.navigationController?.pushViewController(itineraryVC, animated: true)
        
    }
    
    func closeView(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
//        otgView.locationLabel.resignFirstResponder()
//        addView.thoughtsTextView.resignFirstResponder()
        print("\(otgView.nameJourneyTF.text)")
        print("\(self.title)")
        self.title = otgView.nameJourneyTF.text
        print("text field: \(textField)")
        
        if textField == otgView.nameJourneyTF {
            
            otgView.nameJourneyTF.isHidden = true
            otgView.nameJourneyView.isHidden = true
            otgView.journeyName.isHidden = false
            otgView.journeyName.text = otgView.nameJourneyTF.text
            journeyName = otgView.nameJourneyTF.text
            
            height = 100.0
            mainScroll.animation.thenAfter(0.5).makeY(mainScroll.frame.origin.y - height).animate(0.5)
    //        otgView.animation.makeY(mainScroll.frame.origin.y - height).animate(0.5)
            otgView.detectLocationView.layer.opacity = 0.0
            otgView.detectLocationView.isHidden = false
            otgView.detectLocationView.animation.thenAfter(0.5).makeOpacity(1.0).animate(0.5)
            
        }
        
//        else if textField == otgView.locationLabel {
//            
//            locationData = otgView.locationLabel.text
//            getCoverPic()
//            
//        }
        
        return false
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startOTGJourney(_ sender: UIButton) {
        
        sender.animation.makeHeight(0.0).animate(0.3)
        sender.isHidden = true
        otgView.nameJourneyView.layer.opacity = 0.0
        otgView.nameJourneyView.isHidden = false
        otgView.nameJourneyView.animation.makeOpacity(1.0).makeHeight(otgView.nameJourneyView.frame.height).animate(0.5)
        otgView.bonVoyageLabel.animation.makeScale(2.0).makeOpacity(0.0).animate(0.5)
        
    }

    func journeyCategory(_ sender: UIButton) {
        
        print("inside journey category button")
        let categoryVC = storyboard?.instantiateViewController(withIdentifier: "kindOfJourneyVC") as! KindOfJourneyOTGViewController
        self.navigationController?.pushViewController(categoryVC, animated: true)
//        showDetailsFn()
        
    }
    
    func showDetailsFn() {
        
        if !isJourneyOngoing {
            
            let journeyName = otgView.nameJourneyTF.text!
            
            print("show details function")
            
            request.addNewOTG(journeyName, userId: currentUser["_id"].string!, startLocation: locationData, kindOfJourney: journeyCategories, timestamp: currentTime, lp: locationPic, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error?.localizedDescription)")
                    }
                        
                    else if response["value"].bool! {
                        
                        print("response of add posts")
                        self.journeyId = response["data"]["uniqueId"].string!
                        isJourneyOngoing = true
                        print("unique id: \(self.journeyId)")
                    }
                        
                    else {
                        
                        let alert = UIAlertController(title: nil, message:
                            "response error!", preferredStyle: .alert)
                        
                        self.present(alert, animated: false, completion: nil)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                            {action in
                                alert.dismiss(animated: true, completion: nil)
                        }))
                        
                    }
                    
                })
                
            })
            
        }
        
//        print("here 1")
        var kindOfJourneyStack: [String] = []
        
        for i in 0 ..< journeyCategories.count {
            
            switch journeyCategories[i] {
            case "adventure":
                kindOfJourneyStack.append("adventure")
            case "backpacking":
                kindOfJourneyStack.append("backpacking")
            case "business":
                kindOfJourneyStack.append("business_new")
            case "religious":
                kindOfJourneyStack.append("religious")
            case "romance":
                kindOfJourneyStack.append("romance")
            case "budget":
                kindOfJourneyStack.append("luxury")
            case "luxury":
                kindOfJourneyStack.append("luxury_new")
            case "family":
                kindOfJourneyStack.append("family")
            case "friends":
                kindOfJourneyStack.append("friends")
            case "solo":
                kindOfJourneyStack.append("solo")
            case "betterhalf":
                kindOfJourneyStack.append("partner")
            case "colleague":
                kindOfJourneyStack.append("colleague")
            default:
                break
            }
            
        }
        
        if journeyCategories.count == 1 {
            
            otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
            otgView.journeyCategoryTwo.isHidden = true
            otgView.journeyCategoryThree.isHidden = true
            
        }
        
        else if journeyCategories.count == 2 {
            
            otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
            otgView.journeyCategoryTwo.image = UIImage(named: kindOfJourneyStack[1])
            otgView.journeyCategoryThree.isHidden = true
            
        }
        
        else {
            
            otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
            otgView.journeyCategoryTwo.image = UIImage(named: kindOfJourneyStack[1])
            otgView.journeyCategoryThree.image = UIImage(named: kindOfJourneyStack[2])
            
        }
        
//        print("here 2")
        
        otgView.selectCategoryButton.isHidden = true
        otgView.journeyDetails.isHidden = false
        otgView.buddyStack.isHidden = true
        otgView.addBuddiesButton.isHidden = false
        
    }
    
    var countLabel: Int!
    var dpOne: String!
    var dpTwo: String!
    var dpThree: String!
    
    
    func addBuddies(_ sender: UIButton) {
        
//        print("here 3")
        
        let addBuddies = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
        addBuddies.whichView = "TL"
        addBuddies.uniqueId = journeyId
        addBuddies.journeyName = otgView.journeyName.text!
        print("add buddies: \(addBuddies)")
        print("navigation: \(self.navigationController)")
        self.navigationController!.pushViewController(addBuddies, animated: true)
//        showBuddies()
//        mainScroll.layer.zPosition = -1
//
        
    }
    
//    func getCurrentOTG() {
//        
//        print("in otg")
//        
//        request.getOTGJourney(currentUser["_id"].string!, completion: {(response) in
//            
//            dispatch_async(dispatch_get_main_queue(), {
//                
//                if response.error != nil {
//                    
//                    print("error: \(response.error?.localizedDescription)")
//                    
//                }
//                    
//                else if response["value"].bool! {
//                    
//                    self.myJourney = response["data"]
//                    
//                }
//                    
//                else {
//                    
//                    print("response: \(response)")
//                    
//                }
//                
//                
//            })
//        })
//        
//    }
    
    func showBuddies() {
        
//        dispatch_async(dispatch_get_main_queue(), {
//            
//            self.getCurrentOTG()
//            
//        })
        
//        var buddies: [JSON]! = []
//        
//        if myJourney != nil {
//            
//            print("In show buddies \(myJourney["buddies"])")
//            buddies = myJourney["buddies"].array!
//            countLabel = buddies.count
//            
//        }
        
        print("added buddies: \(addedBuddies)")

        for i in 0 ..< addedBuddies.count {
            
            let imageUrl = addedBuddies[i]["profilePicture"].string!
            
            let isUrl = verifyUrl(imageUrl)
            
            if isUrl && imageUrl != "" {
                
                print("inside if statement")
                let data = try? Data(contentsOf: URL(string: imageUrl)!)
                
                if data != nil  && imageUrl != "" {
                    
                    otgView.buddyStackPictures[i].image = UIImage(data: data!)
                    makeTLProfilePicture(otgView.buddyStackPictures[i])
                    
                }
            }
                
            else if imageUrl != "" {
                
                let getImageUrl = adminUrl + "upload/readFile?file=" + imageUrl + "&width=100"
                let data = try? Data(contentsOf: URL(string: getImageUrl)!)
                if data != nil && i <= 2 {
                    
                    otgView.buddyStackPictures[i].image = UIImage(data: data!)
//                    otgView.buddyStackPictures[i].image = UIImage(data: data!)
                    makeTLProfilePicture(otgView.buddyStackPictures[i])
                    
                }
                
            }
            
//            let imageData = NSData(contentsOfURL: NSURL(string: imageUrl)!)
//            
//            if imageData != nil {
//
//                otgView.buddyStackPictures[i].image = UIImage(data:imageData!)
//            }
            
            
//            if imageData != nil  && i == 0 {
//                
//                otgView.dpFriendOne.image =
//            }
//                
//            else if imageData != nil  && i == 1 {
//                
//                otgView.dpFriendTwo.image = UIImage(data:imageData!)
//            }
//                
//            else if imageData != nil  && i == 2 {
//                
//                otgView.dpFriendThree.image = UIImage(data:imageData!)
//            }
            
        }
        
        switch countLabel {
        case 0:
            otgView.dpFriendOne.removeFromSuperview()
            otgView.dpFriendTwo.removeFromSuperview()
            otgView.dpFriendThree.removeFromSuperview()
            otgView.journeyBuddiesCount.removeFromSuperview()
            break
        case 1:
            otgView.dpFriendTwo.removeFromSuperview()
            otgView.dpFriendThree.removeFromSuperview()
            otgView.journeyBuddiesCount.removeFromSuperview()
            break
        case 2:
            otgView.dpFriendThree.removeFromSuperview()
            otgView.journeyBuddiesCount.removeFromSuperview()
            break
        case 3:
            otgView.journeyBuddiesCount.removeFromSuperview()
            break
        default:
            let remainingCount = countLabel - 3
            otgView.journeyBuddiesCount.text = "+\(remainingCount)"
            break
        }
        
//        if countLabel > 3 {
//            
//            
//            
//            
//            
//        }
//        else if countLabel == 3 {
//            
//            
//            
//            
//        }
//        else if countLabel == 1 {
//            
//            
//            
//        }
//        else if countLabel == 2 {
//            
//            
//        }
//        else if countLabel == 0 {
//            
//            
//            
//            
//        }
        
//        otgView.dpFriendOne.image = UIImage(named: "")
//        otgView.dpFriendTwo.image = UIImage(named: "")
//        otgView.dpFriendThree.image = UIImage(named: "")
        
        otgView.buddyStack.isHidden = false
        otgView.addBuddiesButton.isHidden = true
        infoButton.isHidden = true
        addPostsButton.isHidden = false
        
//        for view in self.view.subviews {
//            
//            for subview in view.subviews {
//                
//                if subview.isKind(of: UIVisualEffectView.self) && subview.tag != 10 {
//                    
//                    view.removeFromSuperview()
//                    
//                }
//                
//            }
//            
//            
//        }
        
        otgView.lineThree.isHidden = false
        toolbarView.isHidden = false
        
    }
    
    func detectLocationViewTap(_ sender: UITapGestureRecognizer) {
        
        self.detectLocation(sender)
        
    }
    
    func detectLocation(_ sender: AnyObject?) {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        print("location: \(locationManager)")
        
    }
    
    var places: [JSON]!
    var coverImage: String!
    
    func makeCoverPic(_ imageString: String) {
        
        print("image name: \(imageString)")
        let getImageUrl = adminUrl + "upload/readFile?file=" + imageString + "&width=500"
        print("image url: \(getImageUrl)")
        let data = try? Data(contentsOf: URL(string: getImageUrl)!)
        print("image data: \(data)")
        if data != nil {
            
            self.otgView.cityImage.image = UIImage(data: data!)
            
        }
    }
    
    var locationPic: String!
    
    func getCoverPic() {
        
        var temp: [String] = []
        
        for place in places {
            
            temp.append(place.string!)
        }
        
        request.getJourneyCoverPic(temp, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.locationPic = response["data"].string!
                    self.makeCoverPic(response["data"].string!)
                    
                }
                else {
                    
                    
                }
                
//                if self.locationData != nil {
                
                    //                    let dateFormatterOne = NSDateFormatter()
                    ////                    dateFormatter.dateFormat = "YYYY-MM-DD"
                    //
                    //
                    //                    dateFormatterOne.dateStyle = .LongStyle
                    //                    let currentDate = dateFormatterOne.stringFromDate(NSDate())
                    //                    print("date: \(currentDate)")
                
                if !isJourneyOngoing {
                    
                    let dateFormatterTwo = DateFormatter()
                    dateFormatterTwo.dateFormat = "dd-MM-yyyy HH:mm"
                    self.currentTime = dateFormatterTwo.string(from: Date())
                    print("time: \(self.currentTime)")
                    
                    self.otgView.detectLocationView.animation.makeOpacity(0.0).animate(0.5)
                    self.otgView.detectLocationView.isHidden = true
                    self.otgView.placeLabel.text = self.locationData
                    self.otgView.timestampDate.text = self.currentTime
                    //                    self.otgView.timestampTime.text =
                    self.otgView.cityView.layer.opacity = 0.0
                    self.otgView.cityView.isHidden = false
                    self.otgView.cityView.animation.makeOpacity(1.0).animate(0.5)
                    self.otgView.journeyDetails.isHidden = true
                    self.otgView.selectCategoryButton.isHidden = false
                    self.height = 250.0
                    self.mainScroll.animation.makeY(60.0).animate(0.7)
                    self.otgView.animation.makeY(0.0).animate(0.7)
                    
                    
                }
                
//                }
                
            })
            
        })
    }
    
    var whichButton = "OTGLocation"
    var locationArray: [JSON] = []
    var initialLocationLoad = true
    
    func addLocationTapped(_ sender: UIButton?) {
        
        print("add location")
        
        print("locations = \(userLocation.latitude) \(userLocation.longitude)")
        request.getLocationOTG(userLocation.latitude, long: userLocation.longitude, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if (response.error != nil) {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                    
                else if response["value"].bool! {
                    
                    self.locationArray = response["data"].array!
                    
                    if self.initialLocationLoad {
                        
                        self.getAllLocations()
                        self.initialLocationLoad = false
                        
                    }
                    
                    if sender != nil {
                        
                        self.gotoSearchLocation(sender!)
                        
                    }
                    
                }
                    
                else {
                    
                }
                
                
            })
            
            
        })
        
    }
    
    var photosCount: Int = 0
    var previouslyAddedPhotos: [URL]!
    var allAssets: [URL] = []
    
    func addPhotos(_ sender: AnyObject) {
        
//        let captionTap = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.addCaption(_:)))
//        captionTap.delegate = self
        
//        addView.photosIntialView.hidden = true
//        addView.photosFinalView.hidden = false
        
//        addView.postButton.enabled = true
        
        print("add new photos \(photosCount)")
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Take Photos", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
//            self.imagePicker.allowsEditing = true
//            self.imagePicker.sourceType = .Camera
//            //            imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
//            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            let multipleImage = BSImagePickerViewController()
            multipleImage.maxNumberOfSelections = self.selectPhotosCount
            multipleImage.takePhotos = true
            
        })
        let saveAction = UIAlertAction(title: "Photos Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let multipleImage = BSImagePickerViewController()
            multipleImage.maxNumberOfSelections = self.selectPhotosCount
            
            self.bs_presentImagePickerController(multipleImage, animated: true,
                select: { (asset:PHAsset) -> Void in
                    //                    print("Selected: \(asset)")
                }, deselect: { (asset: PHAsset) -> Void in
                    //                    print("Deselected: \(asset)")
                }, cancel: { (assets: [PHAsset]) -> Void in
                    //                    print("Cancel: \(assets)")
                }, finish: { (assets: [PHAsset]) -> Void in
                    
                    var myAssets = assets
                    
                    self.addView.photosIntialView.isHidden = true
                    self.addView.photosFinalView.isHidden = false
                    self.addView.photosCount.text = "\(self.allAssets.count)"
                    self.selectPhotosCount = self.selectPhotosCount - self.allAssets.count
                    self.addView.horizontalScrollForPhotos.isUserInteractionEnabled = true
                    
                    for subview in self.addView.horizontalScrollForPhotos.subviews {
                        
                        if subview.tag == 1 {
                            
                            self.removeWidthToPhotoLayout(subview.frame.width + 10.0)
                            subview.removeFromSuperview()
                            
                        }
                        
                    }
                    
                    
                    var index = 0
                    
                    
                    if Reachability.isConnectedToNetwork() {
                        self.addView.postButton.isHidden = true
                    }
                    print("Finish: \(self.addView.postButton.isHidden)")
                    
                    var assetArray: [URL] = []
                    
                    if self.previouslyAddedPhotos != nil {
                        
                        assetArray = self.previouslyAddedPhotos
                        
                    }
                    
                    for asset in assets {
                        
                        let image = self.getAssetThumbnail(asset)
                        let temp: Bool!
                        let assetIndex = assets.index(of: asset)
                        
                        print("got uiimage: \(image)")
                        
                        let exportFilePath = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/image\(assetIndex!).jpg"
                        assetArray.append(URL(string: exportFilePath)!)
                        
                        let visibleImage = UIButton(frame: CGRect(x: 10, y: 0, width: 65, height: 65))
                        visibleImage.tag = 1
                        visibleImage.addTarget(self, action: #selector(NewTLViewController.addCaption(_:)), for: .touchUpInside)
                        self.addWidthToPhotoLayout(visibleImage.frame.width + 10.0)
                        self.addView.horizontalScrollForPhotos.addSubview(visibleImage)
                        
//                        dispatch_sync(dispatch_get_main_queue(),  {
                        
                            do {
                                
//                                print("export file: \(NSURL(string: exportFilePath)!), \(image), \(image.scale)")
                                let tempImage = UIImageJPEGRepresentation(image, 0.87)
                                //                            print("temp Image: \(tempImage)")
                                
                                if tempImage == nil {
                                    
                                    UIGraphicsBeginImageContext(image.size)
                                    image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
                                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                                    UIGraphicsEndImageContext()
                                    let newTemp = UIImageJPEGRepresentation(newImage!, 0.50)
//                                    temp = try newTemp!.write(to: URL(string: exportFilePath)!, options: [])
                                    visibleImage.setImage(UIImage(data: newTemp!), for: UIControlState())
                                    
                                }
                                    
                                else {
                                    
//                                    temp = try tempImage!.write(to: URL(string: exportFilePath)!, options: [])
                                    
                                    if index <= self.addView.photosCollection.count - 1 {
                                        
                                        visibleImage.setImage(UIImage(data: tempImage!), for: UIControlState())
                                        
                                    }
                                    
                                }
//                                print("temp: \(temp)")
                                print("file created")
                                visibleImage.layer.cornerRadius = 5.0
                                visibleImage.clipsToBounds = true
                                
                                self.addView.photosIntialView.isHidden = true
                                self.addView.photosFinalView.isHidden = false
                                self.addHeightToNewActivity(self.addView.photosFinalView.frame.height - self.addView.photosIntialView.frame.height)
                                self.addView.photosCount.text = "(\(assets.count))"
                                
//                                if assets.count < 4 {
//                                    
//                                    //                                self.addView.photosCollection[assetIndex!].addSubview(layerAbove)
//                                    //                                self.addView.photosCollection[assetIndex!].userInteractionEnabled = false
//                                    
//                                }
//                                    
//                                else {
//                                    
//                                    //                                self.addView.photosCollection[3].addSubview(layerAbove)
//                                    //                                self.addView.photosCollection[3].userInteractionEnabled = false
//                                    
//                                }
                                
                                index = index + 1
                                
                            } catch let error as NSError {
                                
                                print("error creating file: \(error.localizedDescription)")
                                
                            }
                            
//                        })
                        
                        print("asset array: \(assetArray)")
                        self.tempAssets = assetArray
                        self.allAssets += assetArray
                        
                        if self.previouslyAddedPhotos == nil {
                            
                            self.uploadedphotos = []
                        }
                        
                    }
                    
                    let addMorePhotosButton = UIButton(frame: CGRect(x: 10, y: 0, width: 65, height: 65))
                    addMorePhotosButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                    addMorePhotosButton.setImage(UIImage(named: "add_fa_icon"), for: UIControlState())
                    addMorePhotosButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
                    addMorePhotosButton.layer.cornerRadius = 5.0
                    addMorePhotosButton.clipsToBounds = true
                    addMorePhotosButton.addTarget(self, action: #selector(NewTLViewController.addPhotosAgain(_:)), for: .touchUpInside)
                    addMorePhotosButton.tag = 2
                    self.addWidthToPhotoLayout(addMorePhotosButton.frame.width)
                    self.addView.horizontalScrollForPhotos.addSubview(addMorePhotosButton)
//                    self.addView.horizontalScrollForPhotos.
                    self.storePhotos(assetArray)
                    
                    
//                                        let addButton = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//                                        addButton.center = CGPointMake(layerAbove.frame.width/2, layerAbove.frame.height/2)
////                                        addButton.image =
//                                        layerAbove.addSubview(addButton)
//                                        layerAbove.clipsToBounds = true
                    
//                    var uploadArray: [String] = []
                    
                    
                    
//                    request.uploadPhotosMultiple(assetArray, completion: {(response) in
//                        
//                        dispatch_sync(dispatch_get_main_queue(), {
//
//                            if response.error != nil {
//
//                                print("error: \(response.error!.localizedDescription)")
//
//                            }
//                            else if response["value"].bool! {
//
////                                if self.photosCount >= assets.count {
////
////                                    self.photosCount = 0
////                                    //                                    self.addView.postButton.hidden = false
////
////                                }
////
////                                self.photosCount += 1
////                                print("response upload photos \(asset)")
////                                self.uploadedphotos.append(response["data"][0].string!)
////
////                                if asset == assetArray.last {
////
////                                    print("assert number: \(asset)")
//
//                                    print("out of upload for loop")
//                                    self.addView.postButton.hidden = false
//                                    
////                                }
//                                
//                            }
//                            else {
//                                
//                                print("response error!")
//                                self.addView.postButton.hidden = false
//                                
//                            }
//                            
//                        })
//                        
//                    })
                    
                    
                    
                }, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func addWidthToPhotoLayout(_ width: CGFloat) {
        
        addView.horizontalScrollForPhotos.frame.size.width = addView.horizontalScrollForPhotos.frame.size.width + width
        addView.photoScroll.contentSize.width = addView.photoScroll.contentSize.width + width
        
    }
    
    func removeWidthToPhotoLayout(_ width: CGFloat) {
        
        addView.horizontalScrollForPhotos.frame.size.width = addView.horizontalScrollForPhotos.frame.size.width - width
        addView.photoScroll.contentSize.width = addView.photoScroll.contentSize.width - width
        
    }
    
    func addCaption(_ sender: UIButton) {
        
        print("add new captions")
        
//        if !addView.postButton.hidden {
        
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = addView.horizontalScrollForPhotos.subviews
            print("sender image: \(sender.currentImage), \(sender), \(addView.horizontalScrollForPhotos.subviews), \(allImageIds)")
            captionVC.currentImage = sender.currentImage!
            captionVC.currentSender = sender
            captionVC.imageIds = allrows
            captionVC.allIds = allImageIds
            self.navigationController!.pushViewController(captionVC, animated: true)
            
//        }
//        else {
//            
//            let alert = UIAlertController(title: nil, message:
//                "photos not uploaded yet!", preferredStyle: .Alert)
//            self.presentViewController(alert, animated: false, completion: nil)
//            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:
//                {action in
//                    self.dismissViewControllerAnimated(false, completion: nil)
//            }))
//            
//        }
        
        
    }
    
    var tempAssets: [URL] = []
    var allImageIds: [String] = []
    var localDbPhotoIds: [Int64] = []
    
//    var uploadedPhotos: [String] = []
    
    func uploadMultiplePhotos(_ assets: [URL], localIds: [Int64]) {
        
        var photosCount = 0
        let photoDB = Photo()
        
                request.uploadPhotos(tempAssets[0], localDbId: localIds[0], completion: {(response) in
                        
                        if response.error != nil {
                            
                            print("error: \(response.error!.localizedDescription)")
                            
                        }
                        else if response["value"].bool! {
                            
                            photoDB.insertName(response["localId"].string!, Name: response["data"][0].string!)
                            self.allImageIds.append(response["data"][0].string!)
                            self.uploadedphotos.append(["name": response["data"][0].string!, "caption": ""])
                            print("assets: \(self.tempAssets)")
                            if self.tempAssets.count > 1 {
                                
                                print("greater than one")
                                self.tempAssets.removeFirst()
                                self.localDbPhotoIds.removeFirst()
                                self.uploadMultiplePhotos(self.tempAssets, localIds: self.localDbPhotoIds)
                                
                            }
                            else if self.tempAssets.count == 1 {
                                
                                print("done")
                                self.tempAssets = []
                                self.addView.postButton.isHidden = false
                                
                            }
                            
                            
                        }
                        else {
                            
                            print("response error!")
                            self.uploadMultiplePhotos(self.tempAssets, localIds: self.localDbPhotoIds)
                            
                        }
                    
                })
        
    }
    
    var allrows: [String] = []
    func storePhotos(_ photoArray: [URL]) {
        
        allrows = []
        let postDb = Post()
        let photos = Photo()
        let postCount = postDb.getRowCount()
        
        for photo in photoArray {
            
            print("photos array: \(photo)")
            let data = try? Data(contentsOf: photo)
            
//            DispatchQueue.main.sync(execute: {
              photos.setPhotos("\(postCount + 1)", Name: nil, Data: data!, Caption: nil)
//            })
            
        }
        
        allrows = photos.getPhotosOfPost("\(postCount + 1)")
        print("allrows: \(allrows)")
        var localids: [Int64] = []
        for eachRow in allrows {
            
            localids.append(Int64(eachRow)!)
            
        }
        
        localDbPhotoIds = localids
        
        if Reachability.isConnectedToNetwork() {
            print("internet is connected")
            uploadMultiplePhotos(photoArray, localIds: localids)
        }
        
    }
    
    
    func addPhotosAgain(_ sender: UIButton) {
        
        previouslyAddedPhotos = allAssets
        print("photos again")
        addPhotos(sender)
        
    }
    
    func addVideos(_ sender: UIButton) {
        
        addView.videosInitialView.isHidden = false
        addView.videosFinalView.isHidden = true
        addHeightToNewActivity(5.0)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Take Video", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
//            self.imagePicker.allowsEditing = true
//            self.imagePicker.sourceType = .Camera
//            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        let saveAction = UIAlertAction(title: "Album", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
//            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = ["public.movie"]
            self.present(self.imagePicker, animated: true, completion: nil)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    func addThoughts(_ sender: UIButton) {
        
        addView.thoughtsFinalView.isHidden = false
        addView.thoughtsInitalView.isHidden = true
        addHeightToNewActivity(10.0)
        
    }
    
    
    var userLocation: CLLocationCoordinate2D!
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("in updated locations")
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        userLocation = locValue
        var coverImage: String!
        
//        if self.whichButton == "AddActivity" {
//            
//            
//        }
        if !isJourneyOngoing {
            
            request.getLocation(locValue.latitude, long: locValue.longitude, completion: { (response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if (response.error != nil) {
                        
                        print("error: \(response.error?.localizedDescription)")
                        
                    }
                        
                    else if response["value"].bool! {
                        
                        self.places = response["data"]["placeId"].array!
                        self.locationData = response["data"]["name"].string!
                        self.otgView.locationLabel.text = response["data"]["name"].string!
                        print("location: \(self.locationData)")
                        self.getCoverPic()
                        
                    }
                    else {
                        
                        print("response error!")
                    }
                    
                })
            })
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error while updating location " + error.localizedDescription)
        
    }
}
