//
//  NewTLViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 26/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import EventKitUI
import SwiftyJSON
import BSImagePicker
//import DKImagePickerController
import Photos
import CoreLocation
import ActiveLabel

var isJourneyOngoing = false
var TLLoader = UIActivityIndicatorView()

class NewTLViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    var myJourney: JSON!
    var isJourney = false
    
    var height: CGFloat!
    var otgView: startOTGView!
    var showDetails = false
    var mainScroll: UIScrollView!
    var infoView: TripInfoOTG!
    var addPosts: AddPostsOTGView!
    var addNewView: NewQuickItinerary!
    
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
    
    @IBAction func addMoreBuddies(sender: AnyObject) {
        
        let getBuddies = storyboard?.instantiateViewControllerWithIdentifier("addBuddies") as! AddBuddiesViewController
        getBuddies.whichView = "TLMiddle"
        getBuddies.uniqueId = journeyId
        self.navigationController?.pushViewController(getBuddies, animated: true)
        
    }
    
    @IBAction func endJourneyTapped(sender: AnyObject) {
        
        getCurrentOTG()
        
        request.endJourney(myJourney["_id"].string!, uniqueId: myJourney["uniqueId"].string!, user: currentUser["_id"].string!, userName: currentUser["name"].string!, buddies: addedBuddies, completion: {(response) in
            if response.error != nil {
                
                print("error: \(response.error!.localizedDescription)")
                
            }
            else if response["value"] {
                
                print("response arrived!")
                
            }
            else {
                
                print("response error")
            }
        })
        
        
    }
//    @IBOutlet weak var endJourney: UIButton!
    @IBAction func infoCircle(sender: AnyObject) {
        
        infoView = TripInfoOTG(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
        infoView.summaryButton.addTarget(self, action: #selector(NewTLViewController.gotoSummaries(_:)), forControlEvents: .TouchUpInside)
        infoView.photosButton.addTarget(self, action: #selector(NewTLViewController.gotoPhotos(_:)), forControlEvents: .TouchUpInside)
        infoView.videosButton.addTarget(self, action: #selector(NewTLViewController.gotoPhotos(_:)), forControlEvents: .TouchUpInside)
        infoView.reviewsButton.addTarget(self, action: #selector(NewTLViewController.gotoReviews(_:)), forControlEvents: .TouchUpInside)
        infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.closeInfo(_:))))
        self.view.addSubview(infoView)
        infoView.animation.makeOpacity(1.0).animate(0.5)
        
    }
    
    var newScroll: UIScrollView!
    
    @IBAction func addPosts(sender: AnyObject) {
        
//        addPosts = AddPostsOTGView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
//        addPosts.addPhotosButton.addTarget(self, action: #selector(NewTLViewController.addPhotosTL(_:)), forControlEvents: .TouchUpInside)
//        addPosts.addCheckInButton.addTarget(self, action: #selector(NewTLViewController.addCheckInTL(_:)), forControlEvents: .TouchUpInside)
//        addPosts.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.closeAdd(_:))))
//        self.view.addSubview(addPosts)
//        addPosts.animation.makeOpacity(1.0).animate(0.5)
//        getJourney()
        
//        let postButton = UIButton()
//        postButton.setTitle("Post", forState: .Normal)
//        postButton.addTarget(self, action: #selector(self.newPost(_:)), forControlEvents: .TouchUpInside)
//        postButton.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 16)
//        
//        let leftButton = UIButton()
//        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
//        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
//        leftButton.frame = CGRectMake(-10, 0, 30, 30)
//        
//        self.customNavigationBar(leftButton, right: postButton)
        
        print("in the add posts function")
        uploadedphotos = []
        newScroll = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
        self.view.addSubview(newScroll)
        
        addView = AddActivityNew(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        print("add view: \(addView)")
        displayFriendsCount()
        newScroll.addSubview(addView)
        newScroll.contentSize.height = self.view.frame.height
        addLocationTapped(nil)
        
        
//        let tapOut = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.closeAdd(_:)))
//        addView.addGestureRecognizer(tapOut)
        
        addView.addLocationButton.addTarget(self, action: #selector(NewTLViewController.addLocationTapped(_:)), forControlEvents: .TouchUpInside)
        addView.photosButton.addTarget(self, action: #selector(NewTLViewController.addPhotos(_:)), forControlEvents: .TouchUpInside)
        addView.thoughtsButton.addTarget(self, action: #selector(NewTLViewController.addThoughts(_:)), forControlEvents: .TouchUpInside)
        addView.tagFriendButton.addTarget(self, action: #selector(NewTLViewController.tagMoreBuddies(_:)), forControlEvents: .TouchUpInside)
        addView.postButton.addTarget(self, action: #selector(NewTLViewController.newPost(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    func displayFriendsCount() {
        
        if addedBuddies != nil && addedBuddies.count > 0 {
            
            if addedBuddies.count == 1 {
                
                addView.friendsCount.setTitle("1 Friend", forState: .Normal)
                
            }
            else {
                
                addView.friendsCount.setTitle("\(addedBuddies.count) Friends", forState: .Normal)
            }
            
        }
        
    }
    
    func addHeightToNewActivity(height: CGFloat) {
        
        print("height: \(height), \(newScroll.contentSize.height)")
        addView.frame.size.height = addView.frame.height + height
        addView.blurView.frame.size.height = addView.frame.height
        addView.darkBlur = UIBlurEffect(style: .Dark)
        addView.blurView = UIVisualEffectView(effect: addView.darkBlur)
        newScroll.contentSize.height = addView.frame.height
        newScroll.bounces = false
        newScroll.showsVerticalScrollIndicator = false
        
    }
    
    func tagMoreBuddies(sender: UIButton) {
        
        let next = storyboard?.instantiateViewControllerWithIdentifier("addBuddies") as! AddBuddiesViewController
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
            addView.styleHorizontalButton(oneButton, buttonTitle: locationArray[i]["name"].string!)
            oneButton.layoutIfNeeded()
            oneButton.addTarget(self, action: #selector(NewTLViewController.selectLocation(_:)), forControlEvents: .TouchUpInside)
//            let stringSize = CGSizeFromString(locationArray[i]["name"].string!)
//            print("string size: \(stringSize)")
//            oneButton.frame.size.width = stringSize.width
            addView.buttonCollection.append(oneButton)
            
        }
        
        let buttonSix = UIButton(frame: CGRect(x: 10, y: 0, width: 100, height: addView.locationHorizontalScroll.frame.height))
        addView.horizontal.addSubview(buttonSix)
        addView.styleHorizontalButton(buttonSix, buttonTitle: "Search")
        addView.buttonCollection.append(buttonSix)
        buttonSix.addTarget(self, action: #selector(NewTLViewController.gotoSearchLocation(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    func gotoSearchLocation(sender: UIButton) {
        
        let searchVC = self.storyboard!.instantiateViewControllerWithIdentifier("searchLocationsVC") as! SearchLocationTableViewController
        searchVC.places = self.locationArray
        searchVC.location = userLocation
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    func hideLocation() {
        
        addView.locationHorizontalScroll.hidden = true
        addView.categoryView.hidden = false
        addView.editCategory.addTarget(self, action: #selector(NewTLViewController.selectAnotherCategory(_:)), forControlEvents: .TouchUpInside)
        
    }
    
//    var pickerView = UIPickerView()
    
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
    
    func selectAnotherCategory(sender: UIButton) {
        
        print("select another category tapped")
        
        let chooseCategory = storyboard?.instantiateViewControllerWithIdentifier("editCategory") as! EditCategoryViewController
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
    
    
    func selectLocation(sender: UIButton) {
        
        var id = ""
        
        for location in locationArray {
            
            if location["name"].string! == sender.titleLabel!.text! {
                
                id = location["place_id"].string!
                
            }
            
        }
        
        putLocationName(sender.titleLabel!.text!, placeId: id)
        
    }
    
    func putLocationName(selectedLocation: String, placeId: String) {
        
        self.addView.addLocationButton.setTitle(selectedLocation, forState: .Normal)
        self.addView.locationTag.tintColor = mainOrangeColor
        request.getPlaceId(placeId, completion: { response in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    
                }
                else if response["value"] {
                    
                    self.addView.categoryLabel.text = response["data"].string!
                    
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
    
    func newPost(sender: UIButton) {
        
        if !isEdit {
            
            var thoughts = ""
            var location = ""
            var locationCategory = ""
            var photos: [String] = []
            var videos: [String] = []
            var buddies: [String] = []
            var id = ""
            
            if addView.thoughtsTextView.text != nil && addView.thoughtsTextView.text != "" {
                
                thoughts = addView.thoughtsTextView.text
                print("thoughts: \(thoughts)")
                
            }
            if addView.addLocationButton.titleLabel!.text != nil && addView.addLocationButton.titleLabel!.text != "" {
                
                location = addView.addLocationButton.titleLabel!.text!
                print("location: \(location)")
                
            }
            if uploadedphotos.count > 0 {
                
                photos = uploadedphotos
                print("photos \(photos)")
                
            }
            if uploadedVideos.count > 0 {
                
                videos = uploadedVideos
                print("videos: \(videos)")
                
            }
            if addedBuddies.count > 0 {
                
                for buddy in addedBuddies {
                    
                    buddies.append(buddy["_id"].string!)
                    
                }
                
                print("buddies: \(buddies)")
                
            }
            if journeyId != nil && journeyId != "" {
                
                id = journeyId
                print("id: \(id)")
                
            }
            
            addView.locationHorizontalScroll.hidden = false
            addView.categoryView.hidden = false
            addView.hidden = true
            newScroll.hidden = true
            request.postTravelLife(thoughts, location: location, locationCategory: locationCategory, photosArray: photos, videosArray: videos, buddies: buddies, userId: currentUser["_id"].string!, journeyId: id, completion: {(response) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"] {
                        
                        print("response arrived new post!")
                        self.getJourney()
                        
                    }
                    else {
                        
                        let alert = UIAlertController(title: nil, message:
                            "response error!", preferredStyle: .Alert)
                        
                        self.presentViewController(alert, animated: false, completion: nil)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:
                            {action in
                                alert.dismissViewControllerAnimated(true, completion: nil)
                        }))
                        print("response error!")
                        
                    }
                    
                })
            })
            
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
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                        
                    else if response["value"] {
                        
                        print("edited response")
                        self.addView.hidden = true
                        self.newScroll.hidden = true
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
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    print("response get journey \(response["data"]["post"].array!)")
//                    let allPosts = response["data"]["post"].array!
                    for post in response["data"]["post"].array! {
                        
                        if post["type"].string! == "join" {
                            
                            self.BuddyJoinInLayout(post)
                            
                        }
                        
                        else if !self.prevPosts.contains(post) {
                        
                            print("my post id: \(post["_id"])")
                        
                            self.configurePost(post)
                            
                        }
                        
                    }
                    
//                    if self.initialPost {
//                        
//                        print("initial post")
//                        
//                        self.prevPosts = allPosts
//                        self.initialPost = false
//                        
//                        for post in allPosts {
//
//                            self.configurePost(post)
//                            
//                        }
//                        
//                    }
//                    
//                    else {
//                        
//                        print("not initial post")
//                        
//                        
//                        
//                    }
                    
                }
                else {
                 
                    print("response error!")
                    
                }
            })
            
        })
        
    }
    
    func closeInfo(sender: UITapGestureRecognizer) {
        
        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.hidden = true
        
    }
    
    func closeAdd(sender: UITapGestureRecognizer) {
        
        addView.animation.makeOpacity(0.0).animate(0.5)
        addView.hidden = true
        newScroll.hidden = true
        
    }
    
    func gotoSummaries(sender: UIButton) {
        
        let summaryVC = storyboard?.instantiateViewControllerWithIdentifier("summaryTLVC") as! CollectionViewController
        self.navigationController?.pushViewController(summaryVC, animated: true)
        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.hidden = true
        
        
    }
    
    func gotoPhotos(sender: UIButton) {
        
        let photoVC = storyboard?.instantiateViewControllerWithIdentifier("photoGrid") as! TripSummaryPhotosViewController
        self.navigationController?.pushViewController(photoVC, animated: true)
        photoVC.whichView = "photo"
        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.hidden = true
        
    }
    
    func gotoReviews (sender: UIButton) {
        
        let ratingVC = storyboard?.instantiateViewControllerWithIdentifier("ratingTripSummary") as! AddYourRatingViewController
        self.navigationController?.pushViewController(ratingVC, animated: true)
        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.hidden = true
        
    }
    
    func writeImageToFile(path: String, completeBlock: (success: Bool) -> Void) {
        
//        request.uploadPhotos(NSURL(fileURLWithPath: path), completion: {(response) in
//
//            print("response: \(response)")
//            completeBlock(success: true)
//
//        })
        
    }
    
    let imagePicker = UIImagePickerController()
    var uploadedphotos: [String] = []
    
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
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        
        var retimage = UIImage()
        print(retimage)
        
//        dispatch_async(dispatch_get_main_queue(), {
        
            let options = PHImageRequestOptions()
            options.synchronous = true
            
            PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .AspectFit, options: options, resultHandler: {(result, info) in
                
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        print("image: \(image)")
        print("imageName: \(image.CIImage)")
    
    }
    
    func addCheckInTL(sender: UIButton) {
        
        let checkInVC = storyboard?.instantiateViewControllerWithIdentifier("checkInSearch") as! CheckInSearchViewController
        checkInVC.whichView = "TL"
        self.navigationController?.pushViewController(checkInVC, animated: true)
        
    }
    
    var layout: VerticalLayout!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(-10, 0, 30, 30)
        self.customNavigationBar(leftButton, right: nil)
        
        self.title = "\(currentUser["firstName"].string!)'s New On The Go"
        
        height = self.view.frame.height/2
        
        TLLoader = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        TLLoader.center = self.view.center
//        TLLoader.s
        
        imagePicker.delegate = self
        
        let darkBlur = UIBlurEffect(style: .Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame.size.height = toolbarView.frame.height
        blurView.frame.size.width = toolbarView.frame.width
        blurView.layer.zPosition = -1
        blurView.userInteractionEnabled = false
        toolbarView.addSubview(blurView)
        
        mainScroll = UIScrollView(frame: CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height))
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
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
        
        otgView.locationLabel.returnKeyType = .Done
        otgView.locationLabel.delegate = self
        
        mainScroll.animation.makeFrame(CGRect(x: 0, y: mainScroll.frame.origin.y - height, width: mainScroll.frame.width, height: mainScroll.frame.height)).animate(0.3)
        line.animation.makeFrame(CGRect(x: self.view.frame.size.width/2, y: 17.5, width: line.frame.width, height: line.frame.height)).animate(0.3)
        
        if !showDetails {
            
            self.view.addSubview(mainScroll)
            mainScroll.addSubview(otgView)
            
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewTLViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewTLViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        otgView.nameJourneyTF.returnKeyType = .Done
        otgView.nameJourneyTF.delegate = self
        
        otgView.clipsToBounds = true
        mainScroll.clipsToBounds = true
        
        infoButton.hidden = true
        addPostsButton.hidden = true
        
        self.view.bringSubviewToFront(infoButton)
        self.view.bringSubviewToFront(addPostsButton)
        
        if !isJourney {
            
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
        
//        addView.editCategoryPickerView.delegate = self
//        pickerView.delegate = self
        
//        otgView.locationLabel.inputView = pickerView
        otgView.locationLabel.addTarget(self, action: #selector(NewTLViewController.showDropdown(_:)), forControlEvents: .EditingChanged)
        mainScroll.contentSize.height = self.view.frame.height
        
        self.view.bringSubviewToFront(toolbarView)
        
        self.view.addSubview(TLLoader)
        
    }
    
    func gotoProfile(sender: UIButton) {
        
        let viewControllers = self.navigationController!.viewControllers
        
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
    
    func refresh(sender: UIRefreshControl) {
        
        print("in refresh")
        getJourney()
        
        
    }
    
    var isInitialPost = true
    var otherCommentId = ""
    
    func showPost(whichPost: String, post: JSON) {
        
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
        
        if isInitialPost {
            
            layout = VerticalLayout(width: self.view.frame.width)
            layout.frame.origin.y = 600
            mainScroll.addSubview(layout)
            isInitialPost = false
            
        }
        
        var thoughts = ""
        var photos: [JSON] = []
//        let tags = ActiveLabel()
        
        if post["thoughts"] != nil && post["thoughts"].string != "" {
            
            thoughts = "\(post["thoughts"]) — with \(post["buddies"][0]["name"])"
            
            if post["buddies"].array!.count > 0 {
                
                thoughts = thoughts + " and \(post["buddies"].array!.count - 1) other(s)"
                
            }
            
            if post["checkIn"]["location"] != nil && post["checkIn"]["location"] != "" {
                
                thoughts = thoughts + " at \(post["checkIn"]["location"])"
                
            }
            
            
        }
        
//        57ed03d67f46c62d59af8836
        
        for view in layout.subviews {
            
            if view.isKindOfClass(PhotosOTG) {
                
                let subview = view as! PhotosOTG
                print("edit id: \(deletePostId), post id: \(post["_id"].string!)")
                
                if isEdit && editPostId == subview.optionsButton.titleLabel!.text! {
                    
                    print("inside removing subviews")
                    removeHeightFromLayout(subview.frame.height)
                    subview.removeFromSuperview()
                    isEdit = false
                    
                }
                
            }
            
        }
        
        let checkIn = PhotosOTG(frame: CGRect(x: 0, y: 30, width: self.view.frame.width, height: 550))
        checkIn.likeButton.setTitle(post["uniqueId"].string!, forState: .Normal)
        checkIn.commentButton.setTitle(post["uniqueId"].string!, forState: .Normal)
        otherCommentId = post["_id"].string!
        currentPost = post
        checkIn.optionsButton.setTitle(post["_id"].string!, forState: .Normal)
        checkIn.likeButton.addTarget(self, action: #selector(NewTLViewController.sendLikes(_:)), forControlEvents: .TouchUpInside)
        checkIn.commentButton.addTarget(self, action: #selector(NewTLViewController.sendComments(_:)), forControlEvents: .TouchUpInside)
        checkIn.optionsButton.addTarget(self, action: #selector(NewTLViewController.chooseOptions(_:)), forControlEvents: .TouchUpInside)
        
//        if !isDelete {
        
            layout.addSubview(checkIn)
            print("layout views: \(layout.subviews.count)")
            addHeightToLayout(checkIn.frame.height + 50.0)
            
//        }
        
        print("is edit: \(isEdit), postid: \(post["_id"].string!)")
        
        checkIn.photosTitle.text = thoughts
        for image in checkIn.otherPhotosStack {
            
            image.hidden = true
            
        }
        
        if post["photos"] != nil && post["photos"].array?.count > 0 {
            
            photos = post["photos"].array!
            checkIn.mainPhoto.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(post["photos"][0]["name"].string!)&width=500")!)!)
            print("photobar count: \(photos.count)")
            
            var count = 4
            if photos.count < 5 {
                
                count = photos.count - 1
                print("in the if statement \(count)")
                
            }
            
            for i in 0 ..< count {
                
                print("in the for loop \(post["photos"][i + 1]["name"])")
                checkIn.otherPhotosStack[i].image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(photos[i + 1]["name"])&width=500")!)!)
                checkIn.otherPhotosStack[i].hidden = false
                
            }
            
        }
        
        else {
            
            checkIn.mainPhoto.hidden = true
            checkIn.photosStack.hidden = true
            checkIn.frame.size.height = 350.0
            
        }
        
        switch whichPost {
        case "CheckIn":
            checkIn.whatPostIcon.setImage(UIImage(named: "location_icon"), forState: .Normal)
//            checkIn.postDp.hidden = true

//            if post["photos"].array!.count < checkIn.otherPhotosStack.count {
//                
//                print("in photo comparison")
//                
//                let difference = checkIn.otherPhotosStack.count - post["photos"].array!.count
//                
//                for i in 0 ..< difference {
//                    
//                    print("in difference for loop")
//                    
//                    let index = checkIn.otherPhotosStack.count - i - 1
//                    checkIn.otherPhotosStack[index].hidden = true
//                    
//                }
//                
//                
//            }
            
        case "Photos":
            checkIn.whatPostIcon.setImage(UIImage(named: "camera_icon"), forState: .Normal)
        case "Videos":
            checkIn.whatPostIcon.setImage(UIImage(named: "video"), forState: .Normal)
        case "Thoughts":
            checkIn.whatPostIcon.setImage(UIImage(named: "pen_icon"), forState: .Normal)
        default:
            break
        }
        
        
//        mainScroll.contentSize.height = 10000
        
        
        
    }
    
    func BuddyJoinInLayout(post: JSON) {
        
        let buddy = BuddyOTG(frame: CGRect(x: 0, y: 20, width: 245, height: 300))
        buddy.center.x = self.view.center.x
        buddy.profileImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(post["user"]["profilePicture"])&width=500")!)!)
        buddy.joinJourneytext.text = "\(post["user"]["name"]) has joined this journey"
        makeTLProfilePicture(buddy.profileImage)
        layout.addSubview(buddy)
        addHeightToLayout(buddy.frame.height)
        
    }
    
    var selectPhotosCount = 11
    var editPostId = ""
    var currentPost: JSON = []
    var isDelete = false
    var deletePostId = ""
    
    func chooseOptions(sender: UIButton) {
        
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
            
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let EditCheckIn: UIAlertAction = UIAlertAction(title: "Edit Post", style: .Default)
        {action -> Void in
            
            self.isEdit = true
            
            request.getOneJourneyPost(sender.titleLabel!.text!, completion: {(response) in
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    self.newScroll.hidden = false
                    self.addView.hidden = false
                    self.addView.postButton.setTitle("Edit", forState: .Normal)
                    self.editPostId = sender.titleLabel!.text!
//                    self.addView.postButton.addTarget(self, action: #selector(NewTLViewController.editPost(_:)), forControlEvents: .TouchUpInside)
                    
                    if response["data"]["checkIn"]["location"] != "" {
                        
                        self.addView.addLocationButton.setTitle(response["data"]["checkIn"]["location"].string!, forState: .Normal)
                        self.addView.categoryView.hidden = true
                        self.addView.categoryLabel.hidden = false
                        
                    }
                    
                    else {
                        
                        self.addView.addLocationButton.setTitle("Add Location", forState: .Normal)
                        self.addView.categoryView.hidden = false
                        self.addView.categoryLabel.hidden = true
                        
                    }
                    
                    if response["data"]["photos"] != nil && response["data"]["photos"].array?.count > 0 {
                        
                        self.addView.photosFinalView.hidden = false
                        self.addView.photosIntialView.hidden = true
                        
                    }
                    
                    else {
                        
                        self.addView.photosFinalView.hidden = true
                        self.addView.photosIntialView.hidden = false
                        
                    }
                    
                    if response["data"]["videos"] != nil && response["data"]["videos"].array?.count > 0 {
                        
                        self.addView.videosFinalView.hidden = false
                        self.addView.videosInitialView.hidden = true
                        
                    }
                    
                    else {
                        
                        self.addView.videosFinalView.hidden = true
                        self.addView.videosInitialView.hidden = false
                        
                    }
                    
                    if response["data"]["thoughts"] != nil && response["data"]["thoughts"].string != "" {
                        
                        self.addView.thoughtsFinalView.hidden = false
                        self.addView.thoughtsInitalView.hidden = true
                        
                    }
                    
                    else {
                        
                        self.addView.thoughtsFinalView.hidden = true
                        self.addView.thoughtsInitalView.hidden = false
                        
                    }
                    
                    if response["data"]["buddies"] != nil && response["data"]["buddies"].array!.count > 0 {
                        
                        self.addView.friendsCount.setTitle("\(response["data"]["buddies"].array!.count) Friend(s)", forState: .Normal)
                        
                    }
                    
                    else {
                        
                       self.addView.friendsCount.setTitle("0 Friends", forState: .Normal)
                        
                    }
                    
                    
                }
                else {
                    
                    print("response error")
                    
                }
                
            })
            
            print("inside edit check in \(self.addView), \(self.newScroll.hidden)")
            
        }
        actionSheetControllerIOS8.addAction(EditCheckIn)
        
        let EditDnt: UIAlertAction = UIAlertAction(title: "Change Date & Time", style: .Default)
        { action -> Void in
            
            print("inside change date and time")
            
        }
        actionSheetControllerIOS8.addAction(EditDnt)
        
        let DeletePost: UIAlertAction = UIAlertAction(title: "Delete Post", style: .Default)
        { action -> Void in
            
            print("inside delete post \(self.currentPost)")
            request.deletePost(self.currentPost["_id"].string!, uniqueId: self.currentPost["uniqueId"].string!, user: self.currentPost["user"]["_id"].string!, completion: {(response) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"] {
                        
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
        
        let share: UIAlertAction = UIAlertAction(title: "Copy Share URL", style: .Default)
        { action -> Void in
            
            print("inside copy share")
            
        }
        actionSheetControllerIOS8.addAction(share)
        self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)
        
    }
    
    func editPost(sender: UIButton) {
        
    }
    
    func sendLikes(sender: UIButton) {
        
        print("like button tapped \(sender.titleLabel!.text)")
        
        var hasLiked = false
        
        if sender.tag == 1 {
            
            hasLiked = true
            sender.tag = 0
            
        }
        else {
            
            sender.tag = 1
        }
        
        print("send likes: \(sender.tag) \(hasLiked)")
        
        request.likePost(sender.titleLabel!.text!, userId: currentUser["_id"].string!, userName: currentUser["name"].string!, unlike: hasLiked, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    if sender.tag == 1 {
                     
                        sender.setImage(UIImage(named: "favorite-heart-button"), forState: .Normal)
                        
                    }
                    else {
                        
                        sender.setImage(UIImage(named: "like_empty_icon"), forState: .Normal)
                        
                    }
                    
                }
                else {
                    
                }
                
            })
            
        })
        
    }
    
    func sendComments(sender: UIButton) {
        
        print("comment button tapped")
        let comment = storyboard?.instantiateViewControllerWithIdentifier("CommentsVC") as! CommentsViewController
        comment.postId = sender.titleLabel!.text!
        comment.otherId = otherCommentId
        self.navigationController?.pushViewController(comment, animated: true)
        
    }
    
    
    func addHeightToLayout(height: CGFloat) {
        
        layout.frame.size.height = layout.frame.size.height + height
        mainScroll.contentSize.height = mainScroll.contentSize.height + height
        
    }
    
    func removeHeightFromLayout(height: CGFloat) {
        
        layout.frame.size.height = layout.frame.size.height - height
        mainScroll.contentSize.height = mainScroll.contentSize.height - height
        
    }
    
    func configurePost(post: JSON) {
        
        prevPosts.append(post)
        
        if post["checkIn"] != nil &&  post["checkIn"].string != "" {
            
            showPost("CheckIn", post: post)
        }
        else if post["photos"] != nil && post["photos"].array?.count > 0 {
            
            showPost("Photos", post: post)
            
        }
        else if post["videos"] != nil && post["videos"].array?.count > 0 {
            
            showPost("Videos", post: post)
        }
        else if post["thoughts"] != nil &&  post["thoughts"].string != "" {
            
            showPost("Thoughts", post: post)
            
        }
        
    }
    
    func getImage(myImage: UIImageView, imageValue: String) {
        
        myImage.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(imageValue)&width=500")!)!)
        
        
    }
    
    func showDropdown(sender: UITextField) {
        
        request.searchCity(otgView.locationLabel.text!, completion: {(response) in
            
            if response.error != nil {
                
                print("error: \(response.error!.localizedDescription)")
                
            }
            else if response["value"] {
                
                
                
            }
            else {
                
            }
            
        })
    }
    
    
    func newOtg(sender: UIButton) {
        
        addNewView.animation.makeOpacity(0.0).animate(0.5)
        addNewView.hidden = true
        
    }
    
    func newItinerary(sender: UIButton) {
        
        let itineraryVC = storyboard?.instantiateViewControllerWithIdentifier("qiPVC") as! QIViewController
        self.navigationController?.pushViewController(itineraryVC, animated: true)
        
    }
    
    func closeView(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
//        otgView.locationLabel.resignFirstResponder()
//        addView.thoughtsTextView.resignFirstResponder()
        print("\(otgView.nameJourneyTF.text)")
        print("\(self.title)")
        self.title = otgView.nameJourneyTF.text
        print("text field: \(textField)")
        
        if textField == otgView.nameJourneyTF {
            
            otgView.nameJourneyTF.hidden = true
            otgView.nameJourneyView.hidden = true
            otgView.journeyName.hidden = false
            otgView.journeyName.text = otgView.nameJourneyTF.text
            journeyName = otgView.nameJourneyTF.text
            
            height = 100.0
            mainScroll.animation.thenAfter(0.5).makeY(mainScroll.frame.origin.y - height).animate(0.5)
    //        otgView.animation.makeY(mainScroll.frame.origin.y - height).animate(0.5)
            otgView.detectLocationView.layer.opacity = 0.0
            otgView.detectLocationView.hidden = false
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
    
    func startOTGJourney(sender: UIButton) {
        
        sender.animation.makeHeight(0.0).animate(0.3)
        sender.hidden = true
        otgView.nameJourneyView.layer.opacity = 0.0
        otgView.nameJourneyView.hidden = false
        otgView.nameJourneyView.animation.makeOpacity(1.0).makeHeight(otgView.nameJourneyView.frame.height).animate(0.5)
        otgView.bonVoyageLabel.animation.makeScale(2.0).makeOpacity(0.0).animate(0.5)
        
    }

    func journeyCategory(sender: UIButton) {
        
        print("inside journey category button")
        let categoryVC = storyboard?.instantiateViewControllerWithIdentifier("kindOfJourneyVC") as! KindOfJourneyOTGViewController
        self.navigationController?.pushViewController(categoryVC, animated: true)
//        showDetailsFn()
        
    }
    
    func showDetailsFn() {
        
        let journeyName = otgView.nameJourneyTF.text!
        
        print("show details function")
        
        request.addNewOTG(journeyName, userId: currentUser["_id"].string!, startLocation: locationData, kindOfJourney: journeyCategories, timestamp: currentTime, lp: locationPic, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                }
                    
                else if response["value"] {
                    
                    print("response of add posts")
                    self.journeyId = response["data"]["uniqueId"].string!
                    print("unique id: \(self.journeyId)")
                }
                
                else {
                    
                    let alert = UIAlertController(title: nil, message:
                        "response error!", preferredStyle: .Alert)
                    
                    self.presentViewController(alert, animated: false, completion: nil)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:
                        {action in
                            alert.dismissViewControllerAnimated(true, completion: nil)
                    }))
                }
            })
        })
        
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
            case "better half":
                kindOfJourneyStack.append("partner")
            case "colleague":
                kindOfJourneyStack.append("colleague")
            default:
                break
            }
            
        }
        
        if journeyCategories.count == 1 {
            
            otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
            otgView.journeyCategoryTwo.hidden = true
            otgView.journeyCategoryThree.hidden = true
            
        }
        
        else if journeyCategories.count == 2 {
            
            otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
            otgView.journeyCategoryTwo.image = UIImage(named: kindOfJourneyStack[1])
            otgView.journeyCategoryThree.hidden = true
            
        }
        
        else {
            
            otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
            otgView.journeyCategoryTwo.image = UIImage(named: kindOfJourneyStack[1])
            otgView.journeyCategoryThree.image = UIImage(named: kindOfJourneyStack[2])
            
        }
        
//        print("here 2")
        
        otgView.selectCategoryButton.hidden = true
        otgView.journeyDetails.hidden = false
        otgView.buddyStack.hidden = true
        otgView.addBuddiesButton.hidden = false
        
    }
    
    var countLabel: Int!
    var dpOne: String!
    var dpTwo: String!
    var dpThree: String!
    
    
    func addBuddies(sender: UIButton) {
        
//        print("here 3")
        
        let addBuddies = storyboard?.instantiateViewControllerWithIdentifier("addBuddies") as! AddBuddiesViewController
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
    
    func showBuddiesPost() {
        
        let buddyInTheMiddle = BuddyOTG(frame: CGRect(x: 0, y: 0, width: 300, height: 250))
        buddyInTheMiddle
        
    }
    
    func getCurrentOTG() {
        
        print("in otg")
        
        request.getOTGJourney(currentUser["_id"].string!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                    
                else if response["value"] {
                    
                    self.myJourney = response["data"]
                    
                }
                    
                else {
                    
                    print("response: \(response)")
                    
                }
                
                
            })
        })
        
    }
    
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
                let data = NSData(contentsOfURL: NSURL(string: imageUrl)!)
                
                if data != nil  && imageUrl != "" {
                    
                    otgView.buddyStackPictures[i].image = UIImage(data: data!)
                    makeTLProfilePicture(otgView.buddyStackPictures[i])
                    
                }
            }
                
            else if imageUrl != "" {
                
                let getImageUrl = adminUrl + "upload/readFile?file=" + imageUrl + "&width=100"
                let data = NSData(contentsOfURL: NSURL(string: getImageUrl)!)
                if data != nil && i <= 2 {
                    
                    otgView.buddyStackPictures[i].image = UIImage(data: data!)
                    otgView.buddyStackPictures[i].image = UIImage(data: data!)
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
        
        otgView.buddyStack.hidden = false
        otgView.addBuddiesButton.hidden = true
        infoButton.hidden = false
        addPostsButton.hidden = false
        toolbarView.hidden = false
        
    }
    
    func detectLocationViewTap(sender: UITapGestureRecognizer) {
        
        self.detectLocation(sender)
        
    }
    
    func detectLocation(sender: AnyObject) {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        print("location: \(locationManager)")
        
    }
    
    var places: [JSON]!
    var coverImage: String!
    
    func makeCoverPic(imageString: String) {
        
        print("image name: \(imageString)")
        let getImageUrl = adminUrl + "upload/readFile?file=" + imageString + "&width=500"
        print("image url: \(getImageUrl)")
        let data = NSData(contentsOfURL: NSURL(string: getImageUrl)!)
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
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
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
                    
                    let dateFormatterTwo = NSDateFormatter()
                    dateFormatterTwo.dateFormat = "dd-MM-yyyy HH:mm"
                    self.currentTime = dateFormatterTwo.stringFromDate(NSDate())
                    print("time: \(self.currentTime)")
                    
                    self.otgView.detectLocationView.animation.makeOpacity(0.0).animate(0.5)
                    self.otgView.detectLocationView.hidden = true
                    self.otgView.placeLabel.text = self.locationData
                    self.otgView.timestampDate.text = self.currentTime
                    //                    self.otgView.timestampTime.text =
                    self.otgView.cityView.layer.opacity = 0.0
                    self.otgView.cityView.hidden = false
                    self.otgView.cityView.animation.makeOpacity(1.0).animate(0.5)
                    self.otgView.journeyDetails.hidden = true
                    self.otgView.selectCategoryButton.hidden = false
                    self.height = 250.0
                    self.mainScroll.animation.makeY(60.0).animate(0.7)
                    self.otgView.animation.makeY(0.0).animate(0.7)
                    
//                }
                
            })
            
        })
    }
    
    var whichButton = "OTGLocation"
    var locationArray: [JSON] = []
    var initialLocationLoad = true
    
    func addLocationTapped(sender: UIButton?) {
        
        print("add location")
        whichButton = "AddActivity"
        print("locations = \(userLocation.latitude) \(userLocation.longitude)")
        request.getLocationOTG(userLocation.latitude, long: userLocation.longitude, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if (response.error != nil) {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                    
                else if response["value"] {
                    
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
    var previouslyAddedPhotos: [PHAsset]!
    
    func addPhotos(sender: AnyObject) {
        
//        addView.photosIntialView.hidden = true
//        addView.photosFinalView.hidden = false
        
//        addView.postButton.enabled = true
        
        print("add new photos")
        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Take Photos", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .Camera
            //            imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        let saveAction = UIAlertAction(title: "Photos Library", style: .Default, handler: {
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
                    
                    if self.previouslyAddedPhotos != nil {
                        
                        myAssets += self.previouslyAddedPhotos
                        print("my assets: \(myAssets)")
//                        for each in self.previouslyAddedPhotos {
//                            
//                           .append(each)
//                        }
                        
                    }
                    
                    
                    var index = 0
                    self.addView.postButton.hidden = true
                    print("Finish: \(self.addView.postButton.hidden)")
                    
                    let layerAbove = UIView(frame: CGRect(x: 0, y: 0, width: self.addView.photosCollection[0].frame.width, height: self.addView.photosCollection[0].frame.height))
                    layerAbove.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
                    let addButton = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
                    addButton.center = CGPointMake(layerAbove.frame.width/2, layerAbove.frame.height/2)
                    addButton.image = UIImage(named: "add_fa_icon")
                    layerAbove.addSubview(addButton)
                    layerAbove.clipsToBounds = true
                    
                    let addTap = UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.addPhotosAgain(_:)))
                    addTap.delegate = self
//                    self.bringSubviewToFront(layerAbove)
                    layerAbove.addGestureRecognizer(addTap)
                    
                    if assets.count < 4 {
                        
                        let difference = 4 - assets.count
                        
                        for i in 0 ..< difference {
                            
                            let index = self.addView.photosCollection.count - i - 1
                            self.addView.photosCollection[index].hidden = true
                            
                        }
                        
                    }
                    
                    var assetArray: [NSURL] = []
                    
                    for asset in assets {
                        
                        let image = self.getAssetThumbnail(asset)
                        let temp: Bool!
                        
                        print("got uiimage: \(image)")
                        
                        let exportFilePath = "file://" + NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/image\(index).jpg")
                        
                        do {
                            
                            print("export file: \(NSURL(string: exportFilePath)!), \(image), \(image.scale)")
                            let tempImage = UIImageJPEGRepresentation(image, 0.87)
//                            print("temp Image: \(tempImage)")
                            
                            if tempImage == nil {
                                
                                UIGraphicsBeginImageContext(image.size)
                                image.drawInRect(CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
                                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                                UIGraphicsEndImageContext()
                                let newTemp = UIImageJPEGRepresentation(newImage, 0.87)
//                                print("new: \(newTemp)")
                                temp = try newTemp!.writeToURL(NSURL(string: exportFilePath)!, atomically: false)
                                self.addView.photosCollection[index].image = UIImage(data: newTemp!)
                            }
                            
                            else {
                                
                               temp = try tempImage!.writeToURL(NSURL(string: exportFilePath)!, atomically: false)
                                
                                if index <= self.addView.photosCollection.count - 1 {
                                
                                    self.addView.photosCollection[index].image = UIImage(data: tempImage!)
                                    self.addView.photosCollection[index].layer.cornerRadius = 5.0
                                    
                                }
                                
                            }
                            print("temp: \(temp)")
                            print("file created")
                            
                            if index < 2 {
                                
                                assetArray.append(NSURL(string: exportFilePath)!)
                                
                            }
                            
                            self.addView.photosIntialView.hidden = true
//                            self.addView.photosIntialView.userInteractionEnabled = false
                            self.addView.photosFinalView.hidden = false
                            self.addHeightToNewActivity(5.0)
                            self.addView.photosCount.text = "(\(assets.count))"
                            
                            if assets.count < 4 {
                                
                                self.addView.photosCollection[index].addSubview(layerAbove)
                                
                            }
                            
                            else {
                                
                               self.addView.photosCollection[3].addSubview(layerAbove)
                                
                            }
                            
                            index = index + 1
                            
                        } catch let error as NSError {
                            
                            print("error creating file: \(error.localizedDescription)")
                            
                        }
                        
                        self.uploadMultiplePhotos(assetArray)
                        
                    }
                    
                    
                    
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
//                            else if response["value"] {
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
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    func uploadMultiplePhotos(assets: [NSURL]) {
        
        var tempAssets = assets
        
        for asset in assets {
            
            //                        uploadArray.append("blah")
            
            
            request.uploadPhotos(asset, completion: {(response) in
                
                dispatch_sync(dispatch_get_main_queue(), {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"] {
                        
                        if self.photosCount >= assets.count {
                            
                            self.photosCount = 0
                            //                                    self.addView.postButton.hidden = false
                            
                        }
                        
                        self.photosCount += 1
                        print("response upload photos \(asset)")
                        self.uploadedphotos.append(response["data"][0].string!)
                        
                        if asset == assets.last {
                            
                            print("assert number: \(asset)")
                            print("out of upload for loop")
                            self.addView.postButton.hidden = false
                            
                        }
                        
                        if tempAssets.count > 1 {
                         
                            tempAssets.removeAtIndex(assets.indexOf(asset)!)
                            
                        }
                        else {
                            
                            tempAssets = []
                            
                        }
                        
                        
                    }
                    else {
                        
                        print("response error!")
                        self.uploadMultiplePhotos(tempAssets)
//                        request.uploadPhotos(asset, completion: {(response) in})
                        //                                    self.addView.postButton.hidden = false
                        
                    }
                    
                })
                
            })
            
        }
        
    }
    
    func addPhotosAgain(sender: UITapGestureRecognizer) {
        
        print("photos again")
        
    }
    
    func addThoughts(sender: UIButton) {
        
        addView.thoughtsFinalView.hidden = false
        addView.thoughtsInitalView.hidden = true
        addHeightToNewActivity(10.0)
        
    }
    
    
    var userLocation: CLLocationCoordinate2D!
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("in updated locations")
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        userLocation = locValue
        var coverImage: String!
        
        if self.whichButton == "AddActivity" {
            
            
        }
        else {
            
            request.getLocation(locValue.latitude, long: locValue.longitude, completion: { (response) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if (response.error != nil) {
                        
                        print("error: \(response.error?.localizedDescription)")
                        
                    }
                        
                    else if response["value"] {
                        
                        //                    print("response: \(response)")
                        
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
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Error while updating location " + error.localizedDescription)
        
    }
}
