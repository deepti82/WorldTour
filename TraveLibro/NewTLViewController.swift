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
import DKChainableAnimationKit

var isJourneyOngoing = false
var TLLoader = UIActivityIndicatorView()

class NewTLViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
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
    var journeyID: String!
    
    var addedBuddies: [JSON]!
    var addView: AddActivityNew!
    var backgroundReview = UIView()
    
    var addPostsButton: UIButton!
    var mainFooter: FooterViewNew!
    
    //@IBOutlet weak var addPostsButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var toolbarView: UIView!
    
    @IBAction func addMoreBuddies(_ sender: AnyObject) {
        
        let getBuddies = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
        getBuddies.whichView = "TLMiddle"
        getBuddies.uniqueId = journeyId
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(getBuddies, animated: true)
        
    }
    
    @IBAction func endJourneyTapped(_ sender: UIButton) {
        
//        getCurrentOTG()
        
//        dispatch_sync(dispatch_get_main_queue(), {
        
            self.getJourney()
//        })
        
        let end = storyboard!.instantiateViewController(withIdentifier: "endJourney") as! EndJourneyViewController
        end.journey = myJourney
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.pushViewController(end, animated: true)
        
    }
    
//    @IBOutlet weak var endJourney: UIButton!
    @IBAction func infoCircle(_ sender: AnyObject) {
        
        getInfoCount()
        
    }
    
    var newScroll: UIScrollView!
    let backView = UIView()
    
    //@IBAction func addPosts(_ sender: AnyObject) {
    func addPosts(_ sender: UIButton) {
        
//        addPosts = AddPostsOTGView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
//        addPosts.addPhotosButton.addTarget(self, action: #selector(NewTLViewController.addPhotosTL(_:)), forControlEvents: .TouchUpInside)
//        addPosts.addCheckInButton.addTarget(self, action: #selector(NewTLViewController.addCheckInTL(_:)), forControlEvents: .TouchUpInside)
//        addPosts.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.closeAdd(_:))))
//        self.view.addSubview(addPosts)
//        addPosts.animation.makeOpacity(1.0).animate(0.5)
//        getJourney()
        
        //let vc = storyboard?.instantiateViewController(withIdentifier: "createPost") as! CreatePostViewController
        //self.navigationController?.pushViewController(vc, animated: true)
        
        let postButton = UIButton()
        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.textColor = UIColor.white
        postButton.addTarget(self, action: #selector(self.newPost(_:)), for: .touchUpInside)
        postButton.titleLabel!.font = UIFont(name: "Avenir-Roman", size: 16)
        
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.textColor = UIColor.white
        //cancelButton.addTarget(self, action: nil, for: .touchUpInside)
        cancelButton.titleLabel!.font = UIFont(name: "Avenir-Roman", size: 16)
        
        
//        let leftButton = UIButton()
//        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
//        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
//        leftButton.frame = CGRectMake(-10, 0, 30, 30)

        //self.customNavigationBar(left: nil, right: nil)
        //self.customNavigationBar(left: nil, right: postButton)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        if Reachability.isConnectedToNetwork() {
        
        var flag = 0
        var darkBlur: UIBlurEffect!
        var blurView: UIVisualEffectView!
        
        backView.frame = self.view.frame
        
        for subview in self.view.subviews {
            
            if subview.tag == 8 {
                
                flag = 1
                backView.isHidden = false
                addView.isHidden = false
                newScroll.isHidden = false
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
        backView.layer.zPosition = 10
        backView.addSubview(newScroll)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60))
        toolbar.barTintColor = mainBlueColor
        toolbar.tintColor = UIColor.white
        
        var items = [UIBarButtonItem]()
        
//        var cancelButtonItem = UIBarButtonItem()
//        cancelButtonItem.setTitle("Cancel", for: .normal)
//        cancelButtonItem.titleLabel?.textColor = UIColor.white
//        //cancelButtonItem.addTarget(self, action: nil, for: .touchUpInside)
//        cancelButtonItem.titleLabel!.font = UIFont(name: "Avenir-Roman", size: 16)
//        
//        var postButtonItem = UIBarButtonItem()
//        postButtonItem.setTitle("Post", for: .normal)
//        postButtonItem.titleLabel?.textColor = UIColor.white
//        //postButtonItem.addTarget(self, action: nil, for: .touchUpInside)
//        postButtonItem.titleLabel!.font = UIFont(name: "Avenir-Roman", size: 16)
        
        items.append(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(NewTLViewController.closeAdd(_:))))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(NewTLViewController.newPost(_:))))
        toolbar.items = items
        backView.addSubview(toolbar)
        
        addView = AddActivityNew(frame: CGRect(x: 0, y: -20, width: self.view.frame.width, height: self.view.frame.height))
        addView.postCancelButton.isHidden = true
        addView.postButtonUp.isHidden = true
        print("add view: \(addView)")
        displayFriendsCount()
        addView.layer.zPosition = 10
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
        addView.postButtonUp.addTarget(self, action: #selector(NewTLViewController.newPost(_:)), for: .touchUpInside)
        addView.postCancelButton.addTarget(self, action: #selector(NewTLViewController.closeAdd(_:)), for: .touchUpInside)
        
//        let tapOut = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.closeAdd(_:)))
//        addView.addGestureRecognizer(tapOut)
        
    }
    
    func optionsAction(_ sender: UIButton) {
        let optionsController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        //optionsController.addAction(UIAlertAction(title: "Edit City", style: .default, handler: nil))
        optionsController.addAction(UIAlertAction(title: "Edit Category", style: .default, handler: { action -> Void in
            print("edit category clicked.")
            print(self.journeyId)
            let chooseCategory = self.storyboard?.instantiateViewController(withIdentifier: "kindOfJourneyVC") as! KindOfJourneyOTGViewController
            print(self.myJourney["kindOfJourney"])
            chooseCategory.selectedCategories = self.myJourney["kindOfJourney"]
            chooseCategory.journeyID = self.journeyID
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.pushViewController(chooseCategory, animated: true)
            
        }))
        optionsController.addAction(UIAlertAction(title: "Change Date & Time", style: .default, handler:
            { action -> Void in
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
                //let minDate = dateFormatter.date(from: "\(self.myJourney["startTime"])")!.toLocalTime()
                
                //Create the view
                self.inputview = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 240, width: self.view.frame.size.width, height: 240))
                self.inputview.backgroundColor = UIColor.white
                self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 40, width: self.inputview.frame.size.width, height: 200))
                self.datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
                //self.datePickerView.minimumDate = minDate
                self.datePickerView.maximumDate = Date()
                
                addTopBorder(mainBlueColor, view: self.datePickerView, borderWidth: 1)
                addTopBorder(mainBlueColor, view: self.inputview, borderWidth: 1)
                
                self.inputview.addSubview(self.datePickerView) // add date picker to UIView
                
                let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 100, height: 40))
                doneButton.setTitle("SAVE", for: UIControlState())
                doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
                doneButton.setTitleColor(mainBlueColor, for: UIControlState())
                doneButton.setTitle(sender.title(for: .application)!, for: .application)
                
                let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
                cancelButton.setTitle("CANCEL", for: UIControlState())
                cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
                cancelButton.setTitleColor(mainBlueColor, for: UIControlState())
                
                self.inputview.addSubview(doneButton) // add Button to UIView
                self.inputview.addSubview(cancelButton) // add Cancel to UIView
                
                doneButton.addTarget(self, action: #selector(NewTLViewController.doneButtonJourney(_:)), for: .touchUpInside) // set button click event
                cancelButton.addTarget(self, action: #selector(NewTLViewController.cancelButton(_:)), for: .touchUpInside) // set button click event
                
                //sender.inputView = inputView
                self.datePickerView.addTarget(self, action: #selector(NewTLViewController.handleDatePicker(_:)), for: .valueChanged)
                
                self.handleDatePicker(self.datePickerView) // Set the date on start.
                self.view.addSubview(self.inputview)
                
            }))
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
    var currentLat: Float!
    var currentLong: Float!
    
    func putLocationName(_ selectedLocation: String, placeId: String) {
        
        self.addView.addLocationButton.setTitle(selectedLocation, for: UIControlState())
        self.addView.locationTag.tintColor = lightOrangeColor
        request.getPlaceId(placeId, completion: { response in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    
                }
                else if response["value"].bool! {
                    
                    self.addView.categoryLabel.text = response["data"].string!
                    self.currentCity = response["city"].string!
                    self.currentCountry = response["country"].string!
                    self.currentLat = response["lat"].float!
                    self.currentLong = response["long"].float!
                    
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
            
            let thoughtsArray = thoughts.components(separatedBy: " ")
            var hashtags: [String] = []
            
            print("thoughts array is: \(thoughtsArray)")
            
            for eachString in thoughtsArray {
                if eachString.contains("#") {
                    hashtags.append(eachString)
                }
            }
            
            print("buddies: \(buddies)")
//            post.setPost(currentUser["_id"].string!, JourneyId: id, Type: "travelLife", Date: currentTime, Location: location, Category: addView.categoryLabel.text!, Latitude: "\(currentLat!)", Longitude: "\(currentLong!)", Country: currentCountry, City: currentCity, Status: thoughts)
            
            let latestPost = post.getRowCount()
            
            for eachBuddy in buddies {
                
                buddy.setBuddies("\(latestPost+1)", userId: eachBuddy["_id"].string!, userName: eachBuddy["name"].string!, userDp: eachBuddy["profilePicture"].string!, userEmail: eachBuddy["email"].string!)
                
            }
            
            var myLatitude = UserLocation()
            
            if currentLat != nil && currentLong != nil {
                myLatitude = UserLocation.init(latitude: currentLat, longitude: currentLong)
            }
            
            if Reachability.isConnectedToNetwork() {
                
                print("internet is connected post")
                request.postTravelLife(thoughts, location: location, locationCategory: locationCategory, latitude: "\(myLatitude.latitude)", longitude: "\(myLatitude.longitude)", photosArray: photos, videosArray: videos, buddies: buddies, userId: currentUser["_id"].string!, journeyId: id, userName: currentUser["name"].string!, city: currentCity, country: currentCountry, hashtags: hashtags, completion: {(response) in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if response.error != nil {
                            
                            print("error: \(response.error!.localizedDescription)")
                            
                        }
                        else if response["value"].bool! {
                            
                            print("response arrived new post!")
                            post.flushRows(Int64(latestPost))
//                            photo.flushRows(localId: String(latestPost))
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
        print("myuser")
        print(currentUser["_id"])
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
                    print("..........")
                    print(self.myJourney["_id"])
                    self.journeyID = self.myJourney["_id"].stringValue
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
        
    }
    
    func closeAdd(_ sender: UIButton) {
        
//        addView.animation.makeOpacity(0.0).animate(0.5)
        let postDb = Post()
        let postCount = postDb.getRowCount() + 1
        let photosDb = Photo()
        
//        photosDb.flushRows(localId: String(postCount))
        
        addView.categoryView.isHidden = true
        addView.categoryLabel.isHidden = false
        addView.locationHorizontalScroll.isHidden = false
        addView.isHidden = true
        newScroll.isHidden = true
        backView.isHidden = true
        
    }
    
    func gotoSummaries(_ sender: UIButton) {
        
        let summaryVC = storyboard?.instantiateViewController(withIdentifier: "summaryTLVC") as! CollectionViewController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(summaryVC, animated: true)
        summaryVC.journey = myJourney["_id"].string!
//        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.isHidden = true
        
        
    }
    
    func gotoPhotos(_ sender: UIButton) {
        
        let photoVC = storyboard?.instantiateViewController(withIdentifier: "photoGrid") as! TripSummaryPhotosViewController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(photoVC, animated: true)
        photoVC.whichView = "photo"
        photoVC.journey = myJourney["_id"].string!
        photoVC.creationDate = myJourney["startTime"].string!
//        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.isHidden = true
        
    }
    
    func gotoReviews (_ sender: UIButton) {
        
        let ratingVC = storyboard?.instantiateViewController(withIdentifier: "ratingTripSummary") as! AddYourRatingViewController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
                
                    print("thumbnail result: \(result!)")
                    print("thumbnail info: \(info)")
                    retimage = result!
                    
//                })
                
            })
            
//        })
        
        print(retimage)
        return retimage
    }
    
    func getAssetData(_ asset: PHAsset) -> Data {
        
        var retimage = Data()
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: options, resultHandler: {(result, info) in
            
            print("thumbnail result: \(result!)")
            print("thumbnail info: \(info)")
            retimage = UIImagePNGRepresentation(result!)!
        })
        
        print(retimage)
        return retimage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("image: \(image)")
        photosAdded(selectedImages: [image])
        
        let captionButton = UIButton()
        captionButton.setImage(image, for: .normal)
        addCaption(captionButton)
//        print("imageName: \(image.CIImage)")
        
//        let videoURL = info["UIImagePickerControllerReferenceURL"] as! URL
//        let video = info[UIImagePickerControllerLivePhoto] as! AVAsset
//        print("video: ", videoURL, video)
//        uploadVideo(videoURL, video: video)
//        picker.dismiss(animated: true, completion: nil)
    
    }
    
    func addCheckInTL(sender: UIButton) {
        
        let checkInVC = storyboard?.instantiateViewController(withIdentifier: "checkInSearch") as! CheckInSearchViewController
        checkInVC.whichView = "TL"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(checkInVC, animated: true)
        
    }
    
    var layout: VerticalLayout!
    var refreshControl = UIRefreshControl()
    var isInitialLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlue(self)
        
        mainScroll.delegate = self
        
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.gotoProfile(_:)), for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        //rightButton.setBackgroundImage(UIImage(named: "i_circle"), for: UIControlState())
        //rightButton.setImage(UIImage(named: "info_icon"), for: UIControlState())
        rightButton.setTitle("i", for: UIControlState())
        rightButton.layer.borderWidth = 1.5
        rightButton.layer.borderColor = UIColor.white.cgColor
        rightButton.layer.cornerRadius = rightButton.frame.width / 2
        rightButton.clipsToBounds = true
        rightButton.titleLabel?.font = avenirBold
        rightButton.addTarget(self, action: #selector(self.infoCircle(_:)), for: .touchUpInside)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        getJourney()
        
        self.title = "On The Go" //"\(currentUser["firstName"].string!)'s New On The Go"
        
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
        
        self.addPostsButton = UIButton(frame: CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - 120, width: 60, height: 60))
        self.addPostsButton.setImage(UIImage(named: "add_circle_opac"), for: .normal)
        self.addPostsButton.addTarget(self, action: #selector(NewTLViewController.addPosts(_:)), for: .touchUpInside)
        //addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(NewTLViewController.addPosts(_:))))
        self.addPostsButton.layer.zPosition = 5
        self.view.addSubview(self.addPostsButton)
        
        self.mainFooter = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 55, width: self.view.frame.width, height: 55))
        self.mainFooter.layer.zPosition = 5
        self.view.addSubview(self.mainFooter)
        
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
        
        mainScroll.delegate = self
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.toolbarView.animation.makeOpacity(0.0).animate(0.5)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.addPostsButton.frame.origin.y = self.view.frame.height + 10
                self.mainFooter.frame.origin.y = self.view.frame.height + 85
            }, completion: nil)
        }
        else{
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.toolbarView.animation.makeOpacity(1.0).animate(0.5)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.addPostsButton.frame.origin.y = self.view.frame.height - 120
                self.mainFooter.frame.origin.y = self.view.frame.height - 55
            }, completion: nil)
        }
    }
    
//    var hideStatusBar = false
//    
//    func didSwipe() {
//        hideStatusBar = true
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        navigationController?.hidesBarsOnSwipe = true
//        navigationController?.hidesBarsOnTap = false
        
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(NewTLViewController.didSwipe))
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(NewTLViewController.didSwipe))
//        swipeUp.direction = UISwipeGestureRecognizerDirection.up
//        swipeDown.direction = UISwipeGestureRecognizerDirection.down
//        self.view.addGestureRecognizer(swipeUp)
//        self.view.addGestureRecognizer(swipeDown)
//        isRefreshing = true
//        viewDidLoad()

    }
    
    func gotoProfile(_ sender: UIButton) {
        
        if isJourneyOngoing {
            
            let profile = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
            self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        var thoughts = String()
        var postTitle = ""
        var photos: [JSON] = []
//        let tags = ActiveLabel()
        
        if post["thoughts"] != nil && post["thoughts"].string != "" {
            
            print("thoughtts if statement")
            thoughts = post["thoughts"].string!
        }
        
        let buddyAnd = " and"
        let buddyWith = "— with "
        
        switch post["buddies"].array!.count {
        
        case 1:
            print("buddies if statement")
            thoughts.append(buddyWith)
            let buddyName = "\(post["buddies"][0]["name"])"
            thoughts.append(buddyName)
//            postTitle += "— with \(post["buddies"][0]["name"])"
        case 2:
            print("buddies if statement")
            thoughts.append(buddyWith)
            let buddyName = post["buddies"][0]["name"].string!
            thoughts.append(buddyName)
            thoughts.append(buddyAnd)
            let buddyCount = " 1 other"
            thoughts.append(buddyCount)
            postTitle += " and 1 other"
        case 0:
            print("buddies if statement")
            break
        default:
            print("buddies if statement")
            let buddyCount = " \(post["buddies"].array!.count - 1)"
            let buddyOthers = " others"
            thoughts.append(buddyWith)
            let buddyName = "\(post["buddies"][0]["name"])"
            thoughts.append(buddyName)
            thoughts.append(buddyAnd)
            thoughts.append(buddyCount)
            thoughts.append(buddyOthers)
            postTitle += " and \(post["buddies"].array!.count - 1) others"
        }
        
        if post["checkIn"]["location"] != nil && post["checkIn"]["location"] != "" {
            
            print("checkin location if statement")
            let buddyAt = " at"
            let buddyLocation = " \(post["checkIn"]["location"])"
            thoughts.append(buddyAt)
            thoughts.append(buddyLocation)
            postTitle += " at \(post["checkIn"]["location"])"
            latestCity = post["checkIn"]["city"].string!
            
        }
        
//        dispatch_sync(dispatch_get_main_queue(), {
        
          self.editPost(post["_id"].string!)
            
//        })
        var checkIn = PhotosOTG()
        checkIn = PhotosOTG(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: setHeight(view: checkIn, thoughts: thoughts, photos: post["photos"].array!.count)))
        checkIn.likeButton.setTitle(post["uniqueId"].string!, for: .normal)
        checkIn.likeViewLabel.text = "\(post["like"].array!.count) Likes"
        checkIn.commentCount.text = "\(post["comment"].array!.count) Comments"
        checkIn.commentButton.setTitle(post["uniqueId"].string!, for: .normal)
        checkIn.commentButton.setTitle(post["_id"].string!, for: .application)
        otherCommentId = post["_id"].string!
        currentPost = post
        print("post: \(post)")
        
        if post["like"].array!.contains(JSON(user.getExistingUser())) {
            checkIn.likeButton.setImage(UIImage(named: "favorite-heart-button"), for: UIControlState())
        }
        
        checkIn.optionsButton.setTitle(post["_id"].string!, for: .normal)
        checkIn.optionsButton.setTitle(post["uniqueId"].string!, for: .application)
        checkIn.dateLabel.text = changeDate(givenFormat: "yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "dd-MM-yyyy", date: post["UTCModified"].string!, isDate: true) //+ "  | "
        checkIn.timeLabel.text = changeDate(givenFormat: "yyyy-MM-dd'T'HH:mm:ss.SSZ", getFormat: "h:mm a", date: post["UTCModified"].string!, isDate: false)
        checkIn.clipsToBounds = true
        checkIn.commentButton.addTarget(self, action: #selector(NewTLViewController.sendComments(_:)), for: .touchUpInside)
        checkIn.optionsButton.addTarget(self, action: #selector(NewTLViewController.chooseOptions(_:)), for: .touchUpInside)
        
        print("is edit: \(isEdit), postid: \(post["_id"].string!)")
        
//        print("\(#line) \(NSAttributedString(attributedString: thoughts))")
//        checkIn.photosTitle.text =
        checkIn.photosTitle.enabledTypes = [.hashtag, .url]
        checkIn.photosTitle.customize {label in
            label.text = thoughts
            label.hashtagColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1)
            label.mentionColor = UIColor(red: 238.0/255, green: 85.0/255, blue: 96.0/255, alpha: 1)
            label.URLColor = UIColor(red: 85.0/255, green: 238.0/255, blue: 151.0/255, alpha: 1)
            label.handleMentionTap {
                
                let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Mention", message: $0, preferredStyle: .alert)
                let cancelActionButton: UIAlertAction = UIAlertAction(title: "OK", style: .default) {action -> Void in}
                actionSheetControllerIOS8.addAction(cancelActionButton)
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
            label.handleHashtagTap {
                
                let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Hashtag", message: $0, preferredStyle: .alert)
                let cancelActionButton: UIAlertAction = UIAlertAction(title: "OK", style: .default) {action -> Void in}
                actionSheetControllerIOS8.addAction(cancelActionButton)
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
            label.handleURLTap { let actionSheetControllerIOS8: UIAlertController =
                
                UIAlertController(title: "Url", message: "\($0)", preferredStyle: .alert)
                let cancelActionButton: UIAlertAction = UIAlertAction(title: "OK", style: .default) {action -> Void in}
                actionSheetControllerIOS8.addAction(cancelActionButton)
                self.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
        }

        for image in checkIn.otherPhotosStack {
            
            image.isHidden = true
            
        }
        
        if post["photos"] != nil && post["photos"].array!.count > 0 {
            
            photos = post["photos"].array!
            checkIn.mainPhoto.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(post["photos"][0]["name"].string!)&width=500")!))
            checkIn.mainPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.openSinglePhoto(_:))))
            checkIn.mainPhoto.tag = 0
            checkIn.mainPhoto.accessibilityLabel = post["_id"].string!
            
            let likeMainPhoto = UITapGestureRecognizer(target: self, action: #selector(PhotosOTG.sendLikes(_:)))
            likeMainPhoto.numberOfTapsRequired = 2
            checkIn.mainPhoto.addGestureRecognizer(likeMainPhoto)
            checkIn.mainPhoto.isUserInteractionEnabled = true
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
                checkIn.otherPhotosStack[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.openSinglePhoto(_:))))
                checkIn.otherPhotosStack[i].tag = i + 1
                checkIn.otherPhotosStack[i].accessibilityLabel = post["_id"].string!
                
                checkIn.otherPhotosStack[i].isUserInteractionEnabled = true
                
            }
            
        }
        
        else if post["photos"].array!.count == 0 && post["videos"].array!.count == 0 {
            
            checkIn.mainPhoto.isHidden = false
            checkIn.photosStack.isHidden = true
            checkIn.photosHC.constant = 0.0
//            checkIn.frame.size.height = 250.0
            
        }
        
        //checkIn.frame.size.height = setHeight(view: checkIn, thoughts: checkIn.photosTitle.text!, photos: post["photos"].array!.count)
        layout.addSubview(checkIn)
        //setHeight(checkIn, height: checkInHeight)
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
            
            if post["photos"].array!.count == 0 && post["videos"].array!.count == 0 {
                
                checkIn.mainPhoto.isHidden = false
                checkIn.photosStack.isHidden = true
                checkIn.photosHC.constant = 300.0
                
                if post["showMap"].boolValue && post["showMap"] != nil {
                    print("map shown")
                    
                    // CHECKIN MAP IMAGE
                    if post["checkIn"]["lat"].string != nil && post["checkIn"]["long"].string != nil {
                        
                        let imageString = "https://maps.googleapis.com/maps/api/staticmap?zoom=12&size=800x600&maptype=roadmap&markers=color:red|\(post["checkIn"]["lat"].string!),\(post["checkIn"]["long"].string!)&key=\(mapKey)"
                        print("\(imageString)")
                        var mapurl = URL(string: imageString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                        if mapurl == nil {
                            mapurl = URL(string: "")
                        }
                        DispatchQueue.main.async(execute: {
                            do {
                                let data = try Data(contentsOf: mapurl!)
//                                print("image data: \(data)")
                                checkIn.mainPhoto.image = UIImage(data: data)
                            } catch _ {
                                print("Unable to set map image")
                            }
                        })
                    }
                } else {
                    print("map not shown")
                }
                
            }
            
            if post["checkIn"]["location"] != nil && post["checkIn"]["location"] != "" {
                
                if post["review"].array!.count > 0 {
                    
                    for subview in layout.subviews {
                        
                        if subview.isKind(of: RatingCheckIn.self) {
                            
                            let myView = subview as! RatingCheckIn
                            if myView.rateCheckInButton.currentTitle! == post["_id"].string! {
                                
                                subview.removeFromSuperview()
                                removeHeightFromLayout(subview.frame.height)
                                
                            }
                            
                        }
                        
                    }
                    
                    showReviewButton(post: post, isIndex: false, index: nil)
                    
                }
                
                else {
            
                    let rateButton = RatingCheckIn(frame: CGRect(x: 0, y: 0, width: width, height: 150))
                    rateButton.rateCheckInLabel.text = "Rate \(post["checkIn"]["location"])?"
                    rateButton.rateCheckInButton.addTarget(self, action: #selector(NewTLViewController.addRatingPost(_:)), for: .touchUpInside)
                    rateButton.rateCheckInButton.setTitle(post["_id"].string!, for: .normal)
                    layout.addSubview(rateButton)
                    addHeightToLayout(height: rateButton.frame.height + 20.0)
                    rateButton.tag = 10
                    
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
    
    func openSinglePhoto(_ sender: AnyObject) {
        print("single photo: \(sender)")
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.mainImage?.image = sender.image
        singlePhotoController.index = sender.view.tag
        singlePhotoController.postId = sender.view.accessibilityLabel
        self.present(singlePhotoController, animated: true, completion: nil)
    }
    
    func showReviewButton(post: JSON, isIndex: Bool, index: Int?) {
        
        let allReviews = post["review"].array!
        let lastReviewCount = post["review"].array!.count - 1
        let rateButton = ShowRating(frame: CGRect(x: 0, y: 0, width: width, height: 150))
//        myReview = post["review"].array!
        rateButton.showRating(ratingCount: Int(allReviews[0]["rating"].string!)! - 1)
        rateButton.rating.addTarget(self, action: #selector(NewTLViewController.showReviewPopup(_:)), for: .touchUpInside)
        rateButton.rating.setTitle(post["_id"].string!, for: .application)
        rateButton.tag = Int(allReviews[lastReviewCount]["rating"].string!)!
        
        if isIndex {
            
            layout.insertSubview(rateButton, at: index!)
        }
        else {
            
            layout.addSubview(rateButton)
        }
        addHeightToLayout(height: rateButton.frame.height + 20.0)
        
    }
    
    
    
    var myReview: [JSON] = []
    
    func setHeight(view: UIView, thoughts: String, photos: Int) -> CGFloat {
        
        var lines = 0
        var textHeight: CGFloat = 0.0
        let myView = view as! PhotosOTG
        var totalHeight = 185
        
        lines = thoughts.characters.count / 34
        if lines % 34 > 0 || lines == 0 {
            lines += 1
        }
        textHeight = CGFloat(lines) * 19.5
        totalHeight += lines * 20
        
        if myView.photosTitle.frame.height > textHeight {
            
            myView.photosTitle.frame.size.height -= textHeight
            
        }
        else {
            
            myView.photosTitle.frame.size.height += textHeight
            
        }
        
        if photos > 1 {
            
            totalHeight += 360
            
        } else if photos == 1 {
            
            myView.frame.size.height -= myView.photosStack.frame.height
            totalHeight += 300
        }
        else if photos == 0 {
            
            myView.frame.size.height -= myView.photosStack.frame.height
            myView.frame.size.height -= myView.mainPhoto.frame.height
            totalHeight += 300 // CHECKIN MAP IMAGE
            
        }
        
        print("total height: \(totalHeight)")
        
        //return myView.frame.height
        return CGFloat(totalHeight)
        
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
            
//            self.isEdit = true
            
            print("edit response function \(sender.titleLabel!.text!)")
            
            request.getOneJourneyPost(id: sender.titleLabel!.text!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    print("\(response["value"].bool!)")
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        
                        print("edit response function one")
                        
                        var flag = 0
                        var darkBlur: UIBlurEffect!
                        var blurView: UIVisualEffectView!
                        
                        self.backView.frame = self.view.frame
                        self.backView.tag = 8
                        
                        if self.view.viewWithTag(8) != nil {
                            
                            self.newScroll.isHidden = false
                            self.backView.isHidden = false
                            self.addView.isHidden = false
                            
                            
                        }
                        
                        else {
                            
                            self.view.addSubview(self.backView)
                            darkBlur = UIBlurEffect(style: .dark)
                            blurView = UIVisualEffectView(effect: darkBlur)
                            blurView.frame.size.height = self.backView.frame.height
                            blurView.frame.size.width = self.backView.frame.width
                            blurView.layer.zPosition = -1
                            blurView.isUserInteractionEnabled = false
                            self.backView.addSubview(blurView)
                            self.newScroll = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
                            self.backView.addSubview(self.newScroll)
                            self.addView = AddActivityNew(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                            print("add view: \(self.addView)")
                            self.displayFriendsCount()
                            self.newScroll.addSubview(self.addView)
                            self.newScroll.contentSize.height = self.view.frame.height
                            self.addLocationTapped(nil)
                        }
                        
                        
                        self.addView.postButton.setTitle("Edit", for: .normal)
                        self.editPostId = sender.titleLabel!.text!
                        
                        print("edit response function two")
                        
                        if response["data"]["checkIn"]["location"] != "" {
                            
                            self.addView.addLocationButton.setTitle(response["data"]["checkIn"]["location"].string!, for: .normal)
                            self.addView.categoryView.isHidden = false
                            self.addView.categoryLabel.isHidden = false
                            self.addView.locationHorizontalScroll.isHidden = true
                            self.addView.locationTag.tintColor = UIColor(red: 252, green: 80, blue: 71, alpha: 1)
                        }
                            
                        else {
                            
                            self.addView.addLocationButton.setTitle("Add Location", for: .normal)
                            self.addView.categoryView.isHidden = false
                            self.addView.categoryLabel.isHidden = true
                            
                        }
                        
                        print("edit response function one")
                        
                        if response["data"]["photos"] != nil && response["data"]["photos"].array!.count > 0 {
                            
                            self.addView.photosFinalView.isHidden = false
                            self.addView.photosIntialView.isHidden = true
                            
                        }
                            
                        else {
                            
                            self.addView.photosFinalView.isHidden = true
                            self.addView.photosIntialView.isHidden = false
                            
                        }
                        
                        print("edit response function one")
                        
                        if response["data"]["videos"] != nil && response["data"]["videos"].array!.count > 0 {
                            
                            self.addView.videosFinalView.isHidden = false
                            self.addView.videosInitialView.isHidden = true
                            
                        }
                            
                        else {
                            
                            self.addView.videosFinalView.isHidden = true
                            self.addView.videosInitialView.isHidden = false
                            
                        }
                        
                        print("edit response function one")
                        
                        if response["data"]["thoughts"] != nil && response["data"]["thoughts"].string != "" {
                            
                            self.addView.thoughtsFinalView.isHidden = false
                            self.addView.thoughtsInitalView.isHidden = true
                            
                        }
                            
                        else {
                            
                            self.addView.thoughtsFinalView.isHidden = true
                            self.addView.thoughtsInitalView.isHidden = false
                            
                        }
                        
                        print("edit response function one")
                        
                        if response["data"]["buddies"] != nil && response["data"]["buddies"].array!.count == 1{
                            
                            self.addView.friendsCount.setTitle("\(response["data"]["buddies"].array!.count) Friend", for: .normal)
                            self.addView.friendsTag.tintColor = UIColor(red: 252, green: 80, blue: 71, alpha: 1)
                            
                        }
                            
                        else if response["data"]["buddies"] != nil && response["data"]["buddies"].array!.count > 1 {
                            
                            self.addView.friendsCount.setTitle("\(response["data"]["buddies"].array!.count) Friends", for: .normal)
                            self.addView.friendsTag.tintColor = UIColor(red: 252, green: 80, blue: 71, alpha: 1)
                            
                        }
                        
                        else {
                            
                            self.addView.friendsCount.setTitle("0 Friends", for: .normal)
                            
                        }
                        
                        print("edit response function one")
                        
                        
                    }
                    else {
                        
                        print("response error")
                        
                    }
                })
                
            })
            
            //print("inside edit check in \(self.addView), \(self.newScroll.isHidden)")
            
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
            doneButton.setTitle("SAVE", for: .normal)
            doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            doneButton.setTitleColor(mainBlueColor, for: UIControlState())
            doneButton.setTitle(sender.title(for: .application), for: .application)
            
            let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            cancelButton.setTitle("CANCEL", for: UIControlState())
            cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            cancelButton.setTitleColor(mainBlueColor, for: UIControlState())
            
            self.inputview.addSubview(doneButton) // add Button to UIView
            self.inputview.addSubview(cancelButton) // add Cancel to UIView
            
            doneButton.addTarget(self, action: #selector(NewTLViewController.doneButton(_:)), for: .touchUpInside) // set button click event
            cancelButton.addTarget(self, action: #selector(NewTLViewController.cancelButton(_:)), for: .touchUpInside) // set button click event
            
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
        timeSelected = timeFormatter.string(from: sender.date.toGlobalTime())
//        print(timeSelected)
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
    
    func doneButtonJourney(_ sender: UIButton){
        request.changeDateTimeJourney(sender.title(for: .application)!, date: "\(dateSelected) \(timeSelected)", completion: {(response) in
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                } else if response["value"].bool! {
                    
                    print("edited date time response")
                    self.journeyDateChanged(date: "\(self.dateSelected)T\(self.timeSelected).000Z")
                } else {
                    
                }
                
            })
            
        })
        
        self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
    }
    
    func cancelButton(_ sender: UIButton){
        self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
    }
    
    func sendComments(_ sender: UIButton) {
        
        print("comment button tapped")
        let comment = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
        comment.postId = sender.titleLabel!.text!
        comment.otherId = sender.title(for: .application)!
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(itineraryVC, animated: true)
        
    }
    
    func closeView(_ sender: UIButton) {
        
        self.navigationController!.popViewController(animated: true)
        
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
        self.title = "On The Go" //otgView.nameJourneyTF.text
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        if let mapurl = URL(string: getImageUrl) {
            do {
                DispatchQueue.main.async(execute: {
                    let data = try! Data(contentsOf: mapurl)
                    print("image data: \(data)")
                    self.otgView.cityImage.image = UIImage(data: data)
                })
            } catch _ {
                print("Unable to set map image")
            }
        }
        
//        } else {
//            print("no image data found")
//        }
        
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    var locationPic: String!
    var locationName: String = ""
    var locationLat: String = ""
    var locationLong: String = ""
    
    func getCoverPic() {
        
        var temp: [String] = []
        
        for place in places {
            
            temp.append(place.string!)
        }
        
        request.getJourneyCoverPic(locationName, lat: locationLat, long: locationLong, completion: {(response) in
            
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
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        let customeAction = UIAlertAction(title: "Photo Editor", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let imgLyKit = storyboard.instantiateViewController(withIdentifier: "ImgLyKit") as! ImgLyKitViewController
            self.present(imgLyKit, animated: true, completion: nil)
            
        })
        let saveAction = UIAlertAction(title: "Photos Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let multipleImage = BSImagePickerViewController()
            multipleImage.maxNumberOfSelections = self.selectPhotosCount
            
            self.bs_presentImagePickerController(multipleImage, animated: true,
                select: { (asset:PHAsset) -> Void in
                    
                    print("Selected: \(asset)")
                    
                }, deselect: { (asset: PHAsset) -> Void in
                    
                    print("Deselected: \(asset)")
                    
                }, cancel: { (assets: [PHAsset]) -> Void in
                    
                    print("Cancel: \(assets)")
                    
                }, finish: { (assets: [PHAsset]) -> Void in
                    
                    //**************************** MIDHET'S CODE ******************************
                    
                    if sender.tag == 1 {
                        
                        self.photosAddedMore = true
                        
                    }
                    
                    if !self.photosAddedMore {
                        self.photosGroupId += 1
                    }
                    
                    self.photosAdded(assets: assets)
                    
//                    var index = 0
//                    
//                    
//                    if Reachability.isConnectedToNetwork() {
//                        
//                    }
//                    print("Finish: \(self.addView.postButton.isHidden)")
//                    
//                    var assetArray: [URL] = []
//                    
//                    if self.previouslyAddedPhotos != nil {
//                        
//                        assetArray = self.previouslyAddedPhotos
//                        
//                    }
                    
                    
                }, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        optionMenu.addAction(customeAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    var photosAddedMore = false
    var photosGroupId = 0
    
    func photosAdded(assets: [PHAsset]) {
        
        self.addView.photosIntialView.isHidden = true
        self.addView.photosFinalView.isHidden = false
//        self.addView.photosCount.text = "\(self.allAssets.count)"
//        self.selectPhotosCount = self.selectPhotosCount - self.allAssets.count
//        self.addView.horizontalScrollForPhotos.isUserInteractionEnabled = true
        
        for subview in self.addView.horizontalScrollForPhotos.subviews {
            
            if subview.tag == 1 {
                
                self.removeWidthToPhotoLayout(subview.frame.width + 10.0)
                subview.removeFromSuperview()
                
            }
            
        }
        
        self.addView.postButton.isEnabled = false
        
        var allImages: [UIImage] = []
        
        for asset in assets {
            
            allImages.append(getAssetThumbnail(asset))
            addPhotoToLayout(photo: getAssetThumbnail(asset))
            let photoData = getAssetData(asset)
            photo.setPhotos(name: nil, data: photoData, caption: nil, groupId: Int64(photosGroupId))
        }
        
        allImageIds = photo.getPhotosIdsOfPost(photosGroup: Int64(photosGroupId))
        let captionButton = UIButton()
        captionButton.setImage(allImages[0], for: .normal)
        addCaption(captionButton)
        
        DispatchQueue.main.sync(execute: {
            
            let addMorePhotosButton = UIButton(frame: CGRect(x: 10, y: 0, width: 65, height: 65))
            addMorePhotosButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            addMorePhotosButton.setImage(UIImage(named: "add_fa_icon"), for: .normal)
            addMorePhotosButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
            addMorePhotosButton.layer.cornerRadius = 5.0
            addMorePhotosButton.clipsToBounds = true
            addMorePhotosButton.addTarget(self, action: #selector(NewTLViewController.addPhotosAgain(_:)), for: .touchUpInside)
            addMorePhotosButton.tag = 1
            self.addWidthToPhotoLayout(addMorePhotosButton.frame.width)
            self.addView.horizontalScrollForPhotos.addSubview(addMorePhotosButton)
            
        })
        
    }
    
    func addPhotoToLayout(photo: UIImage) {
        
        let photosButton = UIButton(frame: CGRect(x: 10, y: 0, width: 65, height: 65))
        photosButton.setImage(photo, for: .normal)
        photosButton.layer.cornerRadius = 5.0
        photosButton.clipsToBounds = true
        photosButton.addTarget(self, action: #selector(NewTLViewController.addPhotosAgain(_:)), for: .touchUpInside)
        self.addWidthToPhotoLayout(photosButton.frame.width)
        self.addView.horizontalScrollForPhotos.addSubview(photosButton)
    }
    
    func photosAdded(selectedImages: [UIImage]) {
        
        self.addView.photosIntialView.isHidden = true
        self.addView.photosFinalView.isHidden = false
        self.addView.photosCount.text = "\(self.allAssets.count)"
        
        for each in selectedImages {
            
            let visibleImage = UIButton(frame: CGRect(x: 10, y: 0, width: 65, height: 65))
            visibleImage.tag = 1
            visibleImage.addTarget(self, action: #selector(NewTLViewController.addCaption(_:)), for: .touchUpInside)
            visibleImage.setImage(each, for: .normal)
            self.addWidthToPhotoLayout(visibleImage.frame.width + 10.0)
            self.addView.horizontalScrollForPhotos.addSubview(visibleImage)
            
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
        
        var allPhotos: [UIButton] = []
        
            let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
            captionVC.imagesArray = addView.horizontalScrollForPhotos.subviews
        
        for subview in addView.horizontalScrollForPhotos.subviews {
            
            if subview.tag != 1 {
                
                let view = subview as! UIButton
                allPhotos.append(view)
                
            }
            
        }
        
            print("sender image: \(sender.currentImage), \(sender), \(addView.horizontalScrollForPhotos.subviews), \(allImageIds) \(allPhotos)")
        
        DispatchQueue.main.sync(execute: {
        
            captionVC.currentImage = sender.currentImage!
            captionVC.currentSender = sender
            captionVC.allImages = allPhotos
            captionVC.allIds = self.allImageIds
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController!.pushViewController(captionVC, animated: true)
            
        })
        
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
            if let data = try? Data(contentsOf: photo) {
                DispatchQueue.main.sync(execute: {
                    photos.setPhotos(name: nil, data: data, caption: nil, groupId: Int64(photosGroupId))
                })
            } else {
                print("\(#line) no data found from photos")
            }
            
        }
        
        allrows = photos.getPhotosIdsOfPost(photosGroup: Int64(photosGroupId))
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
        if manager.location?.coordinate != nil {
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
                        self.locationName = self.locationData
                        self.locationLat = String(locValue.latitude)
                        self.locationLong = String(locValue.longitude)
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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error while updating location " + error.localizedDescription)
        
    }
}

struct UserLocation {
    var latitude: Float = 0
    var longitude: Float = 0
}
