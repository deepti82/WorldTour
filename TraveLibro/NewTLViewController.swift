import UIKit
import EventKitUI
import BSImagePicker
import Dollar
import Cent
import Photos
import CoreLocation
import DKChainableAnimationKit
import imglyKit
import AVKit
import AVFoundation
import Haneke

var isJourneyOngoing = false
var TLLoader = UIActivityIndicatorView()

var userLocation: CLLocationCoordinate2D!
var globalNavigationController:UINavigationController!

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
    
    var journeyCategories = [String] ()
    var currentTime: String!
    
    var journeyId: String!
    var journeyID: String!
    
    var addedBuddies: [JSON] = []
    var addView: AddActivityNew!
    var backgroundReview = UIView()
    
    var addPostsButton: UIButton!
    var mainFooter: FooterViewNew!
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
        self.getJourney()
        let end = storyboard!.instantiateViewController(withIdentifier: "endJourney") as! EndJourneyViewController
        end.journey = myJourney
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.pushViewController(end, animated: true)
    }
    

    @IBAction func infoCircle(_ sender: AnyObject) {
        getInfoCount()
    }
    
    
    
    var newScroll: UIScrollView!
    var backView:UIView!
    
    func addPosts(_ sender: UIButton) {
        
        
        showAddActivity(view: self.view)
        getJourneyBuddies(journey: myJourney)
        
        
    }
    
    func optionsAction(_ sender: UIButton) {
        let optionsController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
    
        optionsController.addAction(UIAlertAction(title: "Edit Category", style: .default, handler: { action -> Void in
            let chooseCategory = self.storyboard?.instantiateViewController(withIdentifier: "kindOfJourneyVC") as! KindOfJourneyOTGViewController
            //            print(self.myJourney["kindOfJourney"])
            
            if self.journeyCategories.count > 0 {
                
                chooseCategory.selectedCategories = JSON(self.journeyCategories)
            }
            else {
                chooseCategory.selectedCategories = self.myJourney["kindOfJourney"]
            }
            chooseCategory.journeyID = self.journeyID
            chooseCategory.isEdit = true
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.pushViewController(chooseCategory, animated: true)
            
        }))
        optionsController.addAction(UIAlertAction(title: "Change Date & Time", style: .default, handler:
            { action -> Void in
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
                self.inputview = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 240, width: self.view.frame.size.width, height: 240))
                self.inputview.backgroundColor = UIColor.white
                self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 40, width: self.inputview.frame.size.width, height: 200))
                self.datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
                self.datePickerView.maximumDate = Date()
                
                addTopBorder(mainBlueColor, view: self.datePickerView, borderWidth: 1)
                addTopBorder(mainBlueColor, view: self.inputview, borderWidth: 1)
                
                self.inputview.addSubview(self.datePickerView) // add date picker to UIView
                
                let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 100, height: 40))
                doneButton.setTitle("SAVE", for: .normal)
                doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
                doneButton.setTitleColor(mainBlueColor, for: .normal)
                doneButton.setTitle(sender.title(for: .application)!, for: .application)
                
                let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
                cancelButton.setTitle("CANCEL", for: .normal)
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
        
        if (addedBuddies.count > 0) {
            
            if addedBuddies.count == 1 {
                addView.friendsCount.setTitle("1 Friend", for: UIControlState())
            }
            else {
                addView.friendsCount.setTitle("\(addedBuddies.count) Friends", for: UIControlState())
            }
            
        }
        
    }
    
    
    
    func tagMoreBuddies(_ sender: UIButton) {
        
        addView.resignThoughtsTexViewKeyboard()
        //        let isTextView = textFieldShouldReturn(otgView.locationLabel)
        let next = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
        next.whichView = "TLTags"
        
        if addedBuddies != nil {
            
            next.addedFriends = addedBuddies
        }
        //        addBuddies.uniqueId = journeyId
        //        addBuddies.journeyName = otgView.journeyName.text!
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.pushViewController(next, animated: true)
        
    }
    
    
    
    //    var pickerView = UIPickerView()
    
    
    var currentCity = ""
    var currentCountry = ""
    var currentLat: Float!
    var currentLong: Float!
    
    
    
    
    var uploadedVideos: [String] = []
    var journeyBuddies: [String] = []
    var isEdit = false
    
    func newPost(_ sender: UIButton) {
        
        print("on post clicked")
        print(photosToBeUploaded)
        print(tempAssets);
        
        for photoToBeUploaded in photosToBeUploaded {
            tempAssets.append(URL(string: photoToBeUploaded.url)!)
            localDbPhotoIds.append(Int(photoToBeUploaded.localId))
        }
        
        if tempAssets.count > 0 {
            print("PRIRIRIIR");
            uploadMultiplePhotos(tempAssets, localIds: localDbPhotoIds)
        }
            
        else {
            print("PRIRIRIIR 2222");
            postPartTwo()
        }
        
        hideAddActivity()
        
        self.addView.postButton.isHidden = true
    }
    
    var prevPosts: [JSON] = []
    var initialPost = true
    
    func storeOfflinePost(id: String, time: String, loc: String, locCategory: String, lat: String, long: String, thoughts: String, buddies: [JSON]) {
        
        let post = Post()
        let buddy = Buddy()
        let photo = Photo()
        
        post.setPost(currentUser["_id"].string!, JourneyId: id, Type: "travelLife", Date: time, Location: loc, Category: locCategory, Latitude: lat, Longitude: long, Country: currentCountry, City: currentCity, Status: thoughts)
        let postId = post.getRowCount()
        
        for eachBuddy in buddies {
            
            buddy.setBuddies("\(postId+1)", userId: eachBuddy["_id"].string!, userName: eachBuddy["name"].string!, userDp: eachBuddy["profilePicture"].string!, userEmail: eachBuddy["email"].string!)
        }
        
        var allPhotos: [JSON] = []
        
        
        for eachPhoto in photosToBeUploaded {
            
            allPhotos.append(["name": eachPhoto.serverId, "caption": eachPhoto.caption])
            
            var imageData = Data()
            
            do {
                
                imageData = try Data(contentsOf: URL(string: eachPhoto.url)!)
            } catch _ {
                
            }
            
            photo.setPhotos(name: eachPhoto.serverId, data: imageData, caption: eachPhoto.caption, groupId: Int64(postId))
        }
        
        var offlineJson: JSON = ["user": currentUser["_id"], "thoughts": thoughts, "date":currentTime, "buddies": buddies, "journey": myJourney["uniqueId"], "type": JSON(stringLiteral: "travel-life"), "photos": allPhotos, "username": currentUser["name"], "country": currentCountry, "city": currentCity]
        offlineJson["checkIn"]["location"] = JSON(loc)
        offlineJson["check"]["long"] = JSON(long)
        offlineJson["check"]["lat"] = JSON(lat)
        offlineJson["check"]["category"] = JSON(locCategory)
        
    
        showOfflinePost(post: offlineJson, postId: postId)
        
    }
    
    func showOfflinePost(post: JSON, postId: Int) {
        var thoughts = String()
        var postTitle = ""
        var photos: [JSON] = []
        
        if post["thoughts"] != nil && post["thoughts"].string != "" {
            
            thoughts = post["thoughts"].string!
        }
        
        let buddyAnd = " and"
        let buddyWith = "— with "
        
        switch post["buddies"].array!.count {
            
        case 1:
            
            thoughts.append(buddyWith)
            let buddyName = "\(post["buddies"][0]["name"])"
            thoughts.append(buddyName)
        case 2:
            //            print("buddies if statement")
            thoughts.append(buddyWith)
            let buddyName = post["buddies"][0]["name"].string!
            thoughts.append(buddyName)
            thoughts.append(buddyAnd)
            let buddyCount = " 1 other"
            thoughts.append(buddyCount)
            postTitle += " and 1 other"
        case 0:
            //            print("buddies if statement")
            break
        default:
            //            print("buddies if statement")
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
            
            //            print("checkin location if statement")
            let buddyAt = " at"
            let buddyLocation = " \(post["checkIn"]["location"])"
            thoughts.append(buddyAt)
            thoughts.append(buddyLocation)
            postTitle += " at \(post["checkIn"]["location"])"
            latestCity = post["checkIn"]["city"].string!
            
        }
        
        var checkIn = PhotosOTG()
        checkIn = PhotosOTG(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: setHeight(view: checkIn, thoughts: thoughts, photos: post["photos"].array!.count)))
        checkIn.clipsToBounds = true
        checkIn.commentButton.addTarget(self, action: #selector(NewTLViewController.sendComments(_:)), for: .touchUpInside)
        checkIn.optionsButton.addTarget(self, action: #selector(NewTLViewController.chooseOptions(_:)), for: .touchUpInside)
        
        //        print("is edit: \(isEdit), postid: \(post["_id"].string!)")
        
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
            checkIn.mainPhoto.hnk_setImageFromURL(NSURL(string: "\(adminUrl)upload/readFile?file=\(post["photos"][0]["name"].string!)&width=500") as! URL)
            checkIn.mainPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.openSinglePhoto(_:))))
            checkIn.mainPhoto.tag = 0
            
            let likeMainPhoto = UITapGestureRecognizer(target: self, action: #selector(PhotosOTG.sendLikes(_:)))
            likeMainPhoto.numberOfTapsRequired = 2
            checkIn.mainPhoto.addGestureRecognizer(likeMainPhoto)
            checkIn.mainPhoto.isUserInteractionEnabled = true
            //            print("photobar count: \(photos.count)")
            
            var count = 4
            if photos.count < 5 {
                
                count = photos.count - 1
                //                print("in the if statement \(count)")
                
            }
            
            for i in 0 ..< count {
                

                checkIn.otherPhotosStack[i].hnk_setImageFromURL(URL(string:photosToBeUploaded[i + 1].url)!)
                checkIn.otherPhotosStack[i].isHidden = false
                checkIn.otherPhotosStack[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.openSinglePhoto(_:))))
                checkIn.otherPhotosStack[i].tag = i + 1

                checkIn.otherPhotosStack[i].isUserInteractionEnabled = true
                
            }
            
        }
            
        else if post["photos"] != nil && post["photos"].array!.count == 0 && post["checkIn"]["location"] == "" {
            
            checkIn.mainPhoto.isHidden = false
            checkIn.photosStack.isHidden = true
//            checkIn.photosHC.constant = 0.0
            checkIn.frame.size.height = 250.0
            
        }
        
        checkIn.tag = 11
        layout.addSubview(checkIn)
        layout.layoutIfNeeded()
        
        addHeightToLayout(height: checkIn.frame.height + 50.0)
     
        
    }
    
    func postPartTwo() {
        
        if !isEdit {
            
            var thoughts = ""
            var location = ""
            var locationCategory = ""
            var photos: [JSON] = []
            var videos: [String] = []
            var buddies: [JSON] = []
            var id = ""
            var myLatitude = UserLocation(latitude: "", longitude: "")
            if addView.thoughtsTextView.text != nil && addView.thoughtsTextView.text != "" && addView.thoughtsTextView.text != "Fill Me In..." {
                thoughts = addView.thoughtsTextView.text
            }
            if addView.addLocationButton.titleLabel!.text != nil && addView.addLocationButton.titleLabel!.text != "" && addView.addLocationButton.titleLabel!.text != "Add Location" {
                
                location = addView.addLocationButton.titleLabel!.text!
                //                print("location: \(location)")
                
                if currentLat != nil && currentLong != nil {
                    myLatitude = UserLocation(latitude: "\(currentLat!)", longitude: "\(currentLong!)")
                }
                
                if addView.categoryLabel.text != "Label" && addView.categoryLabel.text != "" {
                    locationCategory = addView.categoryLabel.text!
                }
            }
            else {
                currentCity = ""
                currentCountry = ""
            }
            
            if photosToBeUploaded.count > 0 {
                
                for eachPhoto in photosToBeUploaded {
                    
                    //                    print("photos caption: \(eachPhoto.caption)")
                    photos.append(["name": eachPhoto.serverId, "caption": eachPhoto.caption])
                }
                
            }
            if uploadedVideos.count > 0 {
                
                videos = uploadedVideos
                //                print("videos: \(videos)")
                
            }
            if addedBuddies.count > 0 {
                
                buddies = addedBuddies
                //                print("buddies: \(buddies)")
                
            }
            if journeyId != nil && journeyId != "" {
                
                id = journeyId
                //                print("id: \(id)")
                
            }
            
            let thoughtsArray = thoughts.components(separatedBy: " ")
            var hashtags: [String] = []
            
            //            print("thoughts array is: \(thoughtsArray)")
            
            for eachString in thoughtsArray {
                if eachString.contains("#") {
                    hashtags.append(eachString)
                }
            }
            
            let dateFormatterTwo = DateFormatter()
            dateFormatterTwo.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            self.currentTime = dateFormatterTwo.string(from: Date())
            //            print("time: \(currentTime)")
            
            storeOfflinePost(id: id, time: currentTime, loc: location, locCategory: locationCategory, lat: "\(myLatitude.latitude)", long: "\(myLatitude.longitude)", thoughts: thoughts, buddies: buddies)
            
            if Reachability.isConnectedToNetwork() {
                
                //                print("internet is connected post")
                request.postTravelLife(thoughts, location: location, locationCategory: locationCategory, latitude: "\(myLatitude.latitude)", longitude: "\(myLatitude.longitude)", photosArray: photos, videosArray: videos, buddies: buddies, userId: currentUser["_id"].string!, journeyId: id, userName: currentUser["name"].string!, city: currentCity, country: currentCountry, hashtags: hashtags, date: currentTime, completion: {(response) in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if response.error != nil {
                            
                            //                            print("error: \(response.error!.localizedDescription)")
                            
                        }
                        else if response["value"].bool! {
                            
                            //                            print("response arrived new post!")
                            self.addActivityToOriginalState()
                            var isRemoved = false
                            if self.layout.viewWithTag(11) != nil && !isRemoved {
                                
                                let subview = self.layout.viewWithTag(11)
                                subview!.removeFromSuperview()
                                //                                print("subviews: \(subview)")
                                //                                print("removed")
                                isRemoved = true
                            }
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
                            //                            print("response error!")
                            
                        }
                        
                    })
                })
                
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
                //                print("\(#line) \(addView.thoughtsTextView.text)")
                
            }
            
            request.editPost(editPostId, location: location, categoryLocation: locationCategory, thoughts: thoughts, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        //                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                        
                    else if response["value"].bool! {
                        
                        //                        print("edited response")
                        self.addView.categoryView.isHidden = true
                        self.addView.categoryLabel.isHidden = true
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
                    
                    //                    print("response get journey \(response["data"]["post"].array!)")
                    
                    isJourneyOngoing = true
                    self.myJourney = response["data"]
                    //                    print("..........")
                    //                    print(self.myJourney["_id"])
                    self.journeyID = self.myJourney["_id"].stringValue
                    if self.isInitialLoad {
                        //                        print("i im isInitialLoad")
                        self.isInitialLoad = false
                        self.showJourneyOngoing(journey: response["data"])
                        
                    }
                    else {
                        //                        print("i im not in isInitialLoad")
                        let allPosts = response["data"]["post"].array!
                        self.getAllPosts(allPosts)
                        
                    }
                    
                }
                else {
                    
                    //                    print("response error!")
                    
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
                
                //                print("my post id: \(post["_id"])")
                
                self.configurePost(post)
                
            }
            
        }
        
    }
    
    func closeInfo(_ sender: UITapGestureRecognizer) {
        
        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.isHidden = true
        
    }
    
    func closeAdd(_ sender: UIButton) {
        let postDb = Post()
        let postCount = postDb.getRowCount() + 1
        let photosDb = Photo()
        hideAddActivity()
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
        infoView.isHidden = true
        
    }
    
    func writeImageToFile(_ path: String, completeBlock: (_ success: Bool) -> Void) {

    }
    
    let imagePicker = UIImagePickerController()
    var uploadedphotos: [JSON] = []

    
    func getAssetThumbnail(_ asset: PHAsset) -> UIImage {
        
        var retimage = UIImage()
        DispatchQueue.main.async {
            
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: options, resultHandler: {(result, info) in
                retimage = result!
                
            })
        }
        //        print(retimage)
        return retimage
    }
    
    func getAssetData(_ asset: PHAsset) -> Data {
        
        var retimage = Data()
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: options, resultHandler: {(result, info) in
            
            retimage = UIImageJPEGRepresentation(result!, 0.35)!
        })
    
        return retimage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //        print("image: \(image)")
        
        photosAdded(selectedImages: [image])
        
        
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
    
    func setTopNavigation(text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.gotoProfile(_:)), for: .touchUpInside)
        
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        rightButton.setTitle("i", for: UIControlState())
        rightButton.layer.borderWidth = 1.5
        rightButton.layer.borderColor = UIColor.white.cgColor
        rightButton.layer.cornerRadius = rightButton.frame.width / 2
        rightButton.clipsToBounds = true
        rightButton.titleLabel?.font = avenirBold
        rightButton.addTarget(self, action: #selector(self.infoCircle(_:)), for: .touchUpInside)
        self.title = text
        self.customNavigationBar(left: leftButton, right: rightButton)
        globalNavigationController  = self.navigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGroundBlue(self)
        mainScroll.delegate = self
        setTopNavigation(text: "On The Go");
        getJourney()
        
        TLLoader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        TLLoader.center = self.view.center
        
        imagePicker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewTLViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewTLViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        otgView.clipsToBounds = true
        mainScroll.clipsToBounds = true
        
        self.addPostsButton = UIButton(frame: CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - 120, width: 60, height: 60))
        self.addPostsButton.setImage(UIImage(named: "add_circle_opac"), for: .normal)
        self.addPostsButton.addTarget(self, action: #selector(NewTLViewController.addPosts(_:)), for: .touchUpInside)
        
        self.addPostsButton.layer.zPosition = 5
        self.view.addSubview(self.addPostsButton)
        
        self.mainFooter = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 55, width: self.view.frame.width, height: 55))
        self.mainFooter.layer.zPosition = 5
        self.view.addSubview(self.mainFooter)
        
        infoButton.isHidden = true
        addPostsButton.isHidden = true
        
        self.view.bringSubview(toFront: infoButton)
        self.view.bringSubview(toFront: addPostsButton)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        
    }
    
    var isRefreshing = false
    
    func refresh(_ sender: AnyObject) {
        
        //        print("in refresh")
        isRefreshing = true
        getJourney()
        
        
    }
    
    var isInitialPost = true
    var otherCommentId = ""
    var latestCity = ""
    
    func showPost(_ whichPost: String, post: JSON) {

        var thoughts = String()
        var postTitle = ""
        var photos: [JSON] = []
        //        let tags = ActiveLabel()
        
        if post["thoughts"] != nil && post["thoughts"].string != "" {
            
            //            print("thoughtts if statement")
            thoughts = post["thoughts"].string!
        }
        
        let buddyAnd = " and"
        let buddyWith = "— with "
        
        switch post["buddies"].array!.count {
            
        case 1:
            thoughts.append(buddyWith)
            let buddyName = "\(post["buddies"][0]["name"])"
            thoughts.append(buddyName)
        //            postTitle += "— with \(post["buddies"][0]["name"])"
        case 2:
            thoughts.append(buddyWith)
            let buddyName = post["buddies"][0]["name"].string!
            thoughts.append(buddyName)
            thoughts.append(buddyAnd)
            let buddyCount = " 1 other"
            thoughts.append(buddyCount)
            postTitle += " and 1 other"
        case 0:
            break
        default:
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
            
            let buddyAt = " at"
            let buddyLocation = " \(post["checkIn"]["location"])"
            thoughts.append(buddyAt)
            thoughts.append(buddyLocation)
            postTitle += " at \(post["checkIn"]["location"])"
            latestCity = post["checkIn"]["city"].string!
            
        }
        
        self.editPost(post["_id"].string!)
        var checkIn = PhotosOTG()
        checkIn = PhotosOTG(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: setHeight(view: checkIn, thoughts: thoughts, photos: post["photos"].array!.count)))
        checkIn.likeButton.setTitle(post["uniqueId"].string!, for: .normal)
        checkIn.likeViewLabel.text = "\(post["like"].array!.count) Likes"
        checkIn.commentCount.text = "\(post["comment"].array!.count) Comments"
        checkIn.commentButton.setTitle(post["uniqueId"].string!, for: .normal)
        checkIn.commentButton.setTitle(post["_id"].string!, for: .application)
        otherCommentId = post["_id"].string!
        currentPost = post
        
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
            checkIn.mainPhoto.hnk_setImageFromURL(NSURL(string: "\(adminUrl)upload/readFile?file=\(post["photos"][0]["name"].string!)&width=500") as! URL)
            checkIn.mainPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.openSinglePhoto(_:))))
            checkIn.mainPhoto.tag = 0
            checkIn.mainPhoto.accessibilityLabel = post["_id"].string!
            
            let likeMainPhoto = UITapGestureRecognizer(target: self, action: #selector(PhotosOTG.sendLikes(_:)))
            likeMainPhoto.numberOfTapsRequired = 2
            checkIn.mainPhoto.addGestureRecognizer(likeMainPhoto)
            checkIn.mainPhoto.isUserInteractionEnabled = true
            
            var count = 4
            if photos.count < 5 {
                
                count = photos.count - 1
                
            }
            
            for i in 0 ..< count {
                
                let imgg = photos[i + 1]["name"]
                checkIn.otherPhotosStack[i].hnk_setImageFromURL(NSURL(string:"\(adminUrl)upload/readFile?file=\(imgg)&width=250") as! URL)
                checkIn.otherPhotosStack[i].isHidden = false
                checkIn.otherPhotosStack[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.openSinglePhoto(_:))))
                checkIn.otherPhotosStack[i].tag = i + 1
                checkIn.otherPhotosStack[i].accessibilityLabel = post["_id"].string!
                checkIn.otherPhotosStack[i].isUserInteractionEnabled = true
                
            }
            
        }
            
        else if post["photos"].array!.count == 0 && post["videos"].array!.count == 0 && post["checkIn"]["location"] != "" {
            
            checkIn.mainPhoto.isHidden = false
            checkIn.photosStack.isHidden = true
//            checkIn.photosHC.constant = 0.0
            //            checkIn.frame.size.height = 250.0
            
        }
        
        //checkIn.frame.size.height = setHeight(view: checkIn, thoughts: checkIn.photosTitle.text!, photos: post["photos"].array!.count)
        layout.addSubview(checkIn)
        //setHeight(checkIn, height: checkInHeight)
        addHeightToLayout(height: checkIn.frame.height + 50.0)
        
        switch whichPost {
        case "CheckIn":
            checkIn.whatPostIcon.setImage(UIImage(named: "location_icon"), for: .normal)
            
            if post["photos"].array!.count < checkIn.otherPhotosStack.count {
                
                
                let difference = checkIn.otherPhotosStack.count - post["photos"].array!.count
                
                for i in 0 ..< difference {
                    
                    
                    let index = checkIn.otherPhotosStack.count - i - 1
                    checkIn.otherPhotosStack[index].isHidden = true
                    
                }
                
            }
            
            if post["photos"].array!.count == 0 && post["videos"].array!.count == 0 {
                
                checkIn.mainPhoto.isHidden = false
                checkIn.photosStack.isHidden = true
//                checkIn.photosHC.constant = 300.0
                
                if post["showMap"].boolValue && post["showMap"] != nil {
                    
                    // CHECKIN MAP IMAGE
                    if ( post["checkIn"]["lat"].string != nil && post["checkIn"]["lat"] != "" ) && post["checkIn"]["long"].string != nil {
                        
                        let getKey = post["imageUrl"].string?.components(separatedBy: "=")
                        print("getting key: \(getKey)")
                        mapKey = getKey!.last!
                        
                        let imageString = "https://maps.googleapis.com/maps/api/staticmap?zoom=12&size=800x600&maptype=roadmap&markers=color:red|\(post["checkIn"]["lat"].string!),\(post["checkIn"]["long"].string!)&key=\(mapKey)"
                        var mapurl = URL(string: imageString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                        if mapurl == nil {
                            mapurl = URL(string: "")
                        }
                        checkIn.mainPhoto.hnk_setImageFromURL(mapurl!)
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
        let bottomOffset = CGPoint(x: 0, y: mainScroll.contentSize.height - mainScroll.bounds.size.height)
        mainScroll.setContentOffset(bottomOffset, animated: true)
    }
    
    func openSinglePhoto(_ sender: AnyObject) {
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
        buddy.profileImage.hnk_setImageFromURL(NSURL(string:"\(adminUrl)upload/readFile?file=\(post["user"]["profilePicture"])&width=250") as! URL)
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
            
            
            request.getOneJourneyPost(id: sender.titleLabel!.text!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    print("\(response["value"].bool!)")
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        
                        
                        //                        var flag = 0
                        //                        var darkBlur: UIBlurEffect!
                        //                        var blurView: UIVisualEffectView!
                        
                        self.backView.frame = self.view.frame
                        self.backView.tag = 8
                        
                        self.showAddActivity(view: self.view)
                        
                        self.addView.postButton.setTitle("Edit", for: .normal)
                        self.editPostId = sender.titleLabel!.text!
                        
                        
                        if response["data"]["checkIn"]["location"] != "" && response["data"]["checkIn"]["location"] != nil {
                            
                            self.addView.addLocationButton.setTitle(response["data"]["checkIn"]["location"].string!, for: .normal)
                            self.addView.categoryView.isHidden = false
                            self.addView.categoryLabel.isHidden = false
                            self.addView.locationHorizontalScroll.isHidden = true
                            self.addView.locationTag.tintColor = UIColor(red: 252, green: 80, blue: 71, alpha: 1)
                        }
                            
                        else {
                            
                            self.addView.addLocationButton.setTitle("Add Location", for: .normal)
                            self.addView.categoryView.isHidden = true
                            self.addView.locationHorizontalScroll.isHidden = false
                            self.addView.categoryLabel.isHidden = true
                            
                        }
                        
                        
                        if response["data"]["photos"] != nil && response["data"]["photos"].array!.count > 0 {
                            
                            self.addView.photosFinalView.isHidden = false
                            
                            for photo in response["data"]["photos"].array! {
                                
                                do {
                                    
                                    let image = try UIImage(data: Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(photo["name"])&width=250")!))
                                    self.addPhotoToLayout(photo: image!)
                                } catch _ {
                                    
                                }
                            }
                            
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
                            self.addView.thoughtsTextView.text = response["data"]["thoughts"].string!
                            self.addView.thoughtsInitalView.isHidden = true
                            
                        }
                            
                        else {
                            
                            self.addView.thoughtsFinalView.isHidden = true
                            self.addView.thoughtsInitalView.isHidden = false
                            
                        }
                        
                        
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
            doneButton.setTitleColor(mainBlueColor, for: .normal)
            doneButton.setTitle(sender.title(for: .application), for: .application)
            
            let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            cancelButton.setTitle("CANCEL", for: .normal)
            cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            cancelButton.setTitleColor(mainBlueColor, for: .normal)
            
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
            
            request.deletePost(self.currentPost["_id"].string!, uniqueId: self.myJourney["uniqueId"].string!, user: self.currentPost["user"]["_id"].string!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        
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
        
        myImage.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(imageValue)&width=250")!))
        
        
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
        otgView.bonVoyageLabel.animation.easeIn.makeOpacity(1.0).thenAfter(0.3).animate(0.3)
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
    
    //    var keyboardHidden = false
    
     var viewHeight = 0
    
    func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = CGFloat(viewHeight)
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            

//            if !keyboardHidden {
            if self.view.frame.origin.y == 0{
               self.view.frame.origin.y -= keyboardSize.height
//                keyboardHidden = true
//            }
            }
        }
        
    }
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += keyboardSize.height
            }
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        otgView.locationLabel.resignFirstResponder()
        //        addView.thoughtsTextView.resignFirstResponder()
        self.title = "On The Go" //otgView.nameJourneyTF.text
        
        if textField == otgView.nameJourneyTF {
            
            otgView.nameJourneyTF.isHidden = true
            otgView.nameJourneyView.isHidden = true
            otgView.journeyName.isHidden = false
            otgView.journeyName.text = otgView.nameJourneyTF.text
            journeyName = otgView.nameJourneyTF.text
            otgView.nameJourneyTF.resignFirstResponder()
            
            height = 100
            mainScroll.animation.makeY(mainScroll.frame.origin.y - height).thenAfter(0.3).animate(0.3)
            //        otgView.animation.makeY(mainScroll.frame.origin.y - height).animate(0.5)
            otgView.detectLocationView.layer.opacity = 0.0
            otgView.detectLocationView.isHidden = false
            otgView.detectLocationView.animation.makeOpacity(1.0).thenAfter(0.3).animate(0.3)
            
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
        //imageCache = nil
    }
    
    func startOTGJourney(_ sender: UIButton) {
        
        sender.animation.makeHeight(0.0).animate(0.3)
        sender.isHidden = true
        otgView.nameJourneyView.layer.opacity = 0.0
        otgView.nameJourneyView.isHidden = false
        otgView.nameJourneyView.animation.makeOpacity(1.0).makeHeight(otgView.nameJourneyView.frame.height).animate(0.5)
        otgView.bonVoyageLabel.animation.makeOpacity(0.0).animate(0.10)
        
        
        
    }
    
    func journeyCategory(_ sender: UIButton) {
        
        let categoryVC = storyboard?.instantiateViewController(withIdentifier: "kindOfJourneyVC") as! KindOfJourneyOTGViewController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(categoryVC, animated: true)
        //        showDetailsFn()
        
    }
    
    func showDetailsFn(isEdit: Bool) {
        
        if !isJourneyOngoing {
            
            let journeyName = otgView.nameJourneyTF.text!
            height = 40.0
            mainScroll.animation.thenAfter(0.5).makeY(mainScroll.frame.origin.y - height).animate(0.5)
            
            
            request.addNewOTG(journeyName, userId: currentUser["_id"].string!, startLocation: locationData, kindOfJourney: journeyCategories, timestamp: currentTime, lp: locationPic, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error?.localizedDescription)")
                    }
                        
                    else if response["value"].bool! {
                        
                        self.journeyId = response["data"]["uniqueId"].string!
                        isJourneyOngoing = true
                        //                        self.getJourney()
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
        
        var kindOfJourneyStack: [String] = []
        
        for i in 0 ..< journeyCategories.count {
            switch journeyCategories[i] {
            case "adventure":
                print("1")
                kindOfJourneyStack.append("adventure")
            case "backpacking":
                print("2")
                kindOfJourneyStack.append("backpacking")
            case "business":
                print("3")
                kindOfJourneyStack.append("business_new")
            case "religious":
                print("4")
                kindOfJourneyStack.append("religious")
            case "romance":
                print("5")
                kindOfJourneyStack.append("romance")
            case "budget":
                print("6")
                kindOfJourneyStack.append("luxury")
            case "luxury":
                print("7")
                kindOfJourneyStack.append("luxury_new")
            case "family":
                print("8")
                kindOfJourneyStack.append("family")
            case "friends":
                print("9")
                kindOfJourneyStack.append("friends")
            case "solo":
                print("10")
                kindOfJourneyStack.append("solo")
            case "betterhalf":
                print("11")
                kindOfJourneyStack.append("partner")
            case "colleague":
                print("12")
                kindOfJourneyStack.append("colleague")
            default:
                break
            }
        }
        
        if journeyCategories.count == 1 {
            
            otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
            otgView.journeyCategoryOne.isHidden = false
            otgView.journeyCategoryTwo.isHidden = true
            otgView.journeyCategoryThree.isHidden = true
            
        }
            
        else if journeyCategories.count == 2 {
            
            otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
            otgView.journeyCategoryOne.isHidden = false
            otgView.journeyCategoryTwo.image = UIImage(named: kindOfJourneyStack[1])
            otgView.journeyCategoryTwo.isHidden = false
            otgView.journeyCategoryThree.isHidden = true
            
        }
            
        else {
            
            otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
            otgView.journeyCategoryOne.isHidden = false
            otgView.journeyCategoryTwo.image = UIImage(named: kindOfJourneyStack[1])
            otgView.journeyCategoryTwo.isHidden = false
            otgView.journeyCategoryThree.isHidden = false
//            print("indexprob\(kindOfJourneyStack[3])")
//            otgView.journeyCategoryThree.image = UIImage(named: kindOfJourneyStack[2])
           
            
        }
        
        if !isEdit {
            
            otgView.selectCategoryButton.isHidden = true
            otgView.journeyDetails.isHidden = false
            otgView.buddyStack.isHidden = true
            otgView.addBuddiesButton.isHidden = false
        }
        
    }
    
    var countLabel: Int!
    var dpOne: String!
    var dpTwo: String!
    var dpThree: String!
    
    
    func addBuddies(_ sender: UIButton) {
        let addBuddiesVC = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
        addBuddiesVC.whichView = "TL"
        
        if journeyId != nil {
            
            addBuddiesVC.uniqueId = journeyId
            addBuddiesVC.journeyName = otgView.journeyName.text!
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController!.pushViewController(addBuddiesVC, animated: true)
        }
        else {
            addBuddies(sender)
        }
        
    }
    
    
    func showBuddies() {
        print("added buddies: \(addedBuddies)")
        
        for i in 0 ..< addedBuddies.count {
            
            let imageUrl = addedBuddies[i]["profilePicture"].string!
            
            let isUrl = verifyUrl(imageUrl)
            
            if isUrl && imageUrl != "" {
                
                let data = try? Data(contentsOf: URL(string: imageUrl)!)
                
                if data != nil  && imageUrl != "" {
                    
                    otgView.buddyStackPictures[i].image = UIImage(data: data!)
                    makeTLProfilePicture(otgView.buddyStackPictures[i])
                    
                }
            }
                
            else if imageUrl != "" {
                
                let getImageUrl = adminUrl + "upload/readFile?file=" + imageUrl + "&width=250"
                let data = try? Data(contentsOf: URL(string: getImageUrl)!)
                if data != nil && i <= 2 {
                    otgView.buddyStackPictures[i].image = UIImage(data: data!)
                    makeTLProfilePicture(otgView.buddyStackPictures[i])
                }
            }
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
        

        otgView.buddyStack.isHidden = false
        otgView.addBuddiesButton.isHidden = true
        infoButton.isHidden = true
        addPostsButton.isHidden = false
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
        
        
    }
    
    var places: [JSON]!
    var coverImage: String!
    
    func makeCoverPic(_ imageString: String) {
        var  getImageUrl = adminUrl + "upload/readFile?file=\(imageString)&width=250"
        
        if imageString.range(of:"https://") != nil{
            getImageUrl = imageString;
        }
        do {
            let url1 = URL(string:getImageUrl);
            try self.otgView.cityImage.hnk_setImageFromURL(url1!)
        }
        catch _ {
            
        }
        
    }
    
    var locationPic: String!
    var locationName: String = ""
    var locationLat: String = ""
    var locationLong: String = ""
    
    var whichButton = "OTGLocation"
    var locationArray: [JSON] = []
    var initialLocationLoad = true
    
    func addLocationTapped(_ sender: UIButton?) {
        
        if userLocation != nil {
            
            print("locations = \(userLocation.latitude) \(userLocation.longitude)")
            
            request.getLocationOTG(userLocation.latitude, long: userLocation.longitude, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if (response.error != nil) {
                        
                        print("error: \(response.error?.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        print(response["data"]);
                        self.locationArray = response["data"].array!
//                        self.getAllLocations()
                    }
                })
            })
        }
    }
    
    
    var photosCount: Int = 0
    var previouslyAddedPhotos: [URL]!
    var allAssets: [URL] = []
    
    func addPhotos(_ sender: AnyObject) {

        
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Take Photos", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .camera
            if sender.tag == 1 {
                
                self.photosAddedMore = true
            }
            self.present(self.imagePicker, animated: true, completion: nil)
        })

        let saveAction = UIAlertAction(title: "Photos Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let multipleImage = BSImagePickerViewController()
            multipleImage.maxNumberOfSelections = self.selectPhotosCount
            
            self.bs_presentImagePickerController(multipleImage, animated: true,
                                                 select: { (asset: PHAsset) -> Void in
                                                    
                                                    print("Selected: \(asset)")
                                                    
            }, deselect: { (asset: PHAsset) -> Void in
                
                print("Deselected: \(asset)")
                
            }, cancel: { (assets: [PHAsset]) -> Void in
                
                print("Cancel: \(assets)")
                
            }, finish: { (assets: [PHAsset]) -> Void in
                
                
                if sender.tag == 1 {
                    
                    self.photosAddedMore = true
                    
                }
                
                if !self.photosAddedMore {
                    self.photosGroupId += 1
                }
                var img11 = [UIImage]()
                
                DispatchQueue.main.async {
                    
                    let options = PHImageRequestOptions()
                    options.isSynchronous = true
                    for n in 0...assets.count-1{
                        PHImageManager.default().requestImage(for: assets[n], targetSize: CGSize(width: assets[n].pixelWidth, height: assets[n].pixelHeight), contentMode: .aspectFit, options: options, resultHandler: {(result, info) in
                            
                            img11.append(result!)
                            
                            
                        })
                    }
                    self.photosAdded(assets: img11)
                }
                
                
            }, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        //        optionMenu.addAction(customeAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    var photosAddedMore = false
    var photosGroupId = 0
    var photosToBeUploaded: [PhotoUpload] = []
    
    func photosAdded(assets: [UIImage]) {
        
        
        self.addView.photosIntialView.isHidden = true
        self.addView.photosFinalView.isHidden = false
        
        for subview in self.addView.horizontalScrollForPhotos.subviews {
            
            if subview.tag == 1 {
                
                self.removeWidthToPhotoLayout(subview.frame.width + 10.0)
                subview.removeFromSuperview()
                
            }
            
        }
        
        var allImages: [UIImage] = []
        var index = 0
        
        for asset in assets {
            
            if  !photosAddedMore {
                
                index = assets.index(of: asset)!
            }
            
            
            allImages.append(asset)
            //            let photoData = getAssetData(asset)
            let exportFileUrl = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/image\(index).jpg"
            
            //            DispatchQueue.main.async(execute: {
            
            do {
                let image = asset
                
                if let data = UIImageJPEGRepresentation(image, 0.35) {
                    try data.write(to: URL(string: exportFileUrl)!)
                }
                
                self.allAssets.append(NSURL(string: exportFileUrl)! as URL)
                self.photosToBeUploaded.append(PhotoUpload(localId: Int64(index), caption: "", serverId: "", url: exportFileUrl))
            } catch let error as NSError {
                
                print("error creating file: \(error.localizedDescription)")
                
            }
            //            })
            
            addPhotoToLayout(photo: asset)
            //            photo.setPhotos(name: nil, data: photoData, caption: nil, groupId: Int64(photosGroupId))
        }
        
        allImageIds = photo.getPhotosIdsOfPost(photosGroup: Int64(photosGroupId))
        let captionButton = UIButton()
        captionButton.setImage(allImages[0], for: .normal)
        captionButton.tag = 2
        addCaption(captionButton)
        
        //        DispatchQueue.main.sync(execute: {
        
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
        
        //        })
        
    }
    
    func addPhotoToLayout(photo: UIImage) {
        
        //        DispatchQueue.main.sync {
        
        let photosButton = UIButton(frame: CGRect(x: 10, y: 0, width: 65, height: 65))
        photosButton.setImage(photo, for: .normal)
        photosButton.layer.cornerRadius = 5.0
        photosButton.clipsToBounds = true
        photosButton.addTarget(self, action: #selector(NewTLViewController.addCaption(_:)), for: .touchUpInside)
        self.addWidthToPhotoLayout(photosButton.frame.width)
        self.addView.horizontalScrollForPhotos.addSubview(photosButton)
        
        //        }
    }
    
    func photosAdded(selectedImages: [UIImage]) {
        
        self.addView.photosIntialView.isHidden = true
        self.addView.photosFinalView.isHidden = false
        self.addView.photosCount.text = "\(self.allAssets.count)"
        
        for subview in self.addView.horizontalScrollForPhotos.subviews {
            
            if subview.tag == 1 {
                
                self.removeWidthToPhotoLayout(subview.frame.width + 10.0)
                subview.removeFromSuperview()
                photosAddedMore = true
            }
            
        }
        
        var allImages: [UIImage] = []
        var index = 0
        
        for each in selectedImages {
            
            if  !photosAddedMore {
                
                index = selectedImages.index(of: each)!
            }
                
            else {
                index += self.addView.horizontalScrollForPhotos.subviews.count
            }
            
            
            allImages.append(each)
            let exportFileUrl = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/image\(index).jpg"
            
            self.allAssets.append(NSURL(string: exportFileUrl)! as URL)
            self.photosToBeUploaded.append(PhotoUpload(localId: Int64(index), caption: "", serverId: "", url: exportFileUrl))
            
            DispatchQueue.main.async(execute: {
                
                do {
                    
                    if let data = UIImageJPEGRepresentation(each, 0.35) {
                        try data.write(to: URL(string: exportFileUrl)!)
                    }
                } catch let error as NSError {
                    
                    print("error creating file: \(error.localizedDescription)")
                    
                }
            })
            
            addPhotoToLayout(photo: each)
            let photoData: Data = UIImageJPEGRepresentation(each, 0.35)!
            photo.setPhotos(name: nil, data: photoData, caption: nil, groupId: Int64(photosGroupId))
        }
        
        allImageIds = photo.getPhotosIdsOfPost(photosGroup: Int64(photosGroupId))
        let captionButton = UIButton()
        captionButton.setImage(allImages[0], for: .normal)
        captionButton.tag = 2
        addCaption(captionButton)
        
        DispatchQueue.main.async(execute: {
            
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
    
    func addWidthToPhotoLayout(_ width: CGFloat) {
        
        addView.horizontalScrollForPhotos.frame.size.width = addView.horizontalScrollForPhotos.frame.size.width + width + 25.0
        addView.photoScroll.contentSize.width = addView.photoScroll.contentSize.width + width + 25.0
        
    }
    
    func removeWidthToPhotoLayout(_ width: CGFloat) {
        
        addView.horizontalScrollForPhotos.frame.size.width = addView.horizontalScrollForPhotos.frame.size.width - width - 25.0
        addView.photoScroll.contentSize.width = addView.photoScroll.contentSize.width - width - 25.0
        
    }
    
    func addCaption(_ sender: UIButton) {
        
        var allPhotos: [UIButton] = []
        
        let captionVC = self.storyboard!.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
        captionVC.imagesArray = addView.horizontalScrollForPhotos.subviews
        self.addView.photosCount.text = "\(self.addView.horizontalScrollForPhotos.subviews.count - 1)"
        
        for subview in addView.horizontalScrollForPhotos.subviews {
            
            if subview.tag != 1 {
                
                let view = subview as! UIButton
                allPhotos.append(view)
                
            }
            
        }
        
        
        //        DispatchQueue.main.async(execute: {
        
        captionVC.currentImage = sender.currentImage!
        
        if sender.tag == 2 {
            
            captionVC.currentSender = allPhotos[0]
        }
        else {
            
            captionVC.currentSender = sender
        }
        //        captionVC.index = captionVC.getIndex()
        
        captionVC.allImages = allPhotos
        captionVC.allPhotos = self.photosToBeUploaded
        captionVC.getPhotoIds(groupId: Int64(self.photosGroupId))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        //End Loader
        self.navigationController!.pushViewController(captionVC, animated: true)
        
        //        })
        
    }
    
    var tempAssets: [URL] = []
    var allImageIds: [Int] = []
    var localDbPhotoIds: [Int] = []
    
    //    var uploadedPhotos: [String] = []
    
    func uploadMultiplePhotos(_ assets: [URL], localIds: [Int]) {
        
        var photosCount = 0
        let photoDB = Photo()
        
        request.uploadPhotos(tempAssets[0], localDbId: localIds[0], completion: {(response) in
            
            if response.error != nil {
                
                print("error: \(response.error!.localizedDescription)")
                
            }
            else if response["value"].bool! {
                
                photoDB.insertName(response["localId"].string!, Name: response["data"][0].string!)
                //                            self.allImageIds.append(response["data"][0].string!)
                self.uploadedphotos.append(["name": response["data"][0].string!, "caption": ""])
                
                for (index, eachPhoto) in self.photosToBeUploaded.enumerated() {
                    
                    if eachPhoto.localId == Int64(response["localId"].string!) {
                        self.photosToBeUploaded[index].serverId = response["data"][0].string!
                    }
                    
                }
                
                
                if self.tempAssets.count > 1 {
                    
                    self.tempAssets.removeFirst()
                    self.localDbPhotoIds.removeFirst()
                    self.uploadMultiplePhotos(self.tempAssets, localIds: self.localDbPhotoIds)
                    
                }
                else if self.tempAssets.count == 1 {
                    
                    self.tempAssets = []
                    self.addView.postButton.isHidden = false
                    self.postPartTwo()
                    
                }
                else {
                    print("no temp assets")
                }
                
                
            }
            else {
                
                print("response error!")
                self.uploadMultiplePhotos(self.tempAssets, localIds: self.localDbPhotoIds)
                
            }
            
        })
        
    }
    
    var allrows: [String] = []
   
    
    
    func addPhotosAgain(_ sender: UIButton) {
        
        previouslyAddedPhotos = allAssets
        addPhotos(sender)
        
    }
    
    func completionVideoBlock(result:UIImage?,img:URL?){
        DispatchQueue.main.async(execute: {
            
            self.dismiss(animated: true, completion:nil)
            let player = AVPlayer(url: img!)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.present(playerController, animated: true) {
                player.play()
            }
        })
        

    }
    
    func addVideos(_ sender: UIButton) {
        
        addView.videosInitialView.isHidden = false
        addView.videosFinalView.isHidden = true
//        addHeightToNewActivity(5.0)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        let deleteAction = UIAlertAction(title: "Take Video", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let configuration = Configuration() { builder in
                builder.backgroundColor = UIColor.clear
                builder.configureCameraViewController(){ cameraConf in
                    cameraConf.allowedRecordingModes = [.video]
                    cameraConf.maximumVideoLength = 6
                }
                
                builder.configureToolStackController(){toolSck in
                    toolSck.mainToolbarBackgroundColor = UIColor.white
                    toolSck.secondaryToolbarBackgroundColor = UIColor.white
                    toolSck.useNavigationControllerForNavigationButtons = true
                    toolSck.useNavigationControllerForTitles = true
                }
                
            }
            let cameraViewController = CameraViewController(configuration:configuration)
            cameraViewController.completionBlock = self.completionVideoBlock
            self.present(cameraViewController, animated: true, completion: nil)
        })
        
  
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        //        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
        
        
    }
    
    
    
    func checkForEditedImages(editedImagesArray: [Dictionary<Int,UIImage>]) {
        
        
        let subviewCount = addView.horizontalScrollForPhotos.subviews.count - 2
        
        
        for subview in addView.horizontalScrollForPhotos.subviews {
            
            if subview.tag != 1 {
                
                let eachImage = subview as! UIButton
                let index = addView.horizontalScrollForPhotos.subviews.index(of: subview)!
                
                
                DispatchQueue.main.async(execute: {
                    
                    //                    for editImage in editedImagesArray {
                    
                    if eachImage.currentImage != editedImagesArray[index][index] && index < subviewCount {
                        
                        eachImage.setImage(editedImagesArray[index][index], for: .normal)
                        
                        let exportFileUrl = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/image\(index).jpg"
                        
                        
                        DispatchQueue.main.async(execute: {
                            
                            //                                if editedImage[index] != nil {
                            
                            do {
                                
                                if let data = UIImageJPEGRepresentation(editedImagesArray[index][index]!, 0.35) {
                                    try data.write(to: URL(string: exportFileUrl)!, options: .atomic)
                                }
                            } catch let error as NSError {
                                
                                print("error creating file: \(error.localizedDescription)")
                                
                            }
                            
                            //                                }
                            
                        })
                        
                    }
                    
                    
                    //                    }
                    
                })
                
            }
            
        }
        
        print("for loop over")
        
    }
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if manager.location?.coordinate != nil {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            userLocation = locValue
            var coverImage: String!
            
            if !isJourneyOngoing {
                
                request.getLocation(locValue.latitude, long: locValue.longitude, completion: { (response) in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if (response.error != nil) {
                            
                            print("error: \(response.error?.localizedDescription)")
                            
                        }
                            
                        else if response["value"].bool! {
                            
                            self.locationData = response["data"]["name"].string!
                            self.otgView.locationLabel.text = response["data"]["name"].string!
                            self.locationPic = response["data"]["image"].string!
                            self.locationName = self.locationData
                            self.locationLat = String(locValue.latitude)
                            self.locationLong = String(locValue.longitude)
                            
                            
                            let dateFormatterTwo = DateFormatter()
                            dateFormatterTwo.dateFormat = "dd-MM-yyyy HH:mm"
                            self.currentTime = dateFormatterTwo.string(from: Date())
                            
                            self.otgView.detectLocationView.animation.makeOpacity(0.0).animate(0.5)
                            self.otgView.detectLocationView.isHidden = true
                            self.otgView.placeLabel.text = self.locationData
                            self.otgView.timestampDate.text = self.currentTime
                            self.otgView.cityImage.hnk_setImageFromURL(URL(string: self.locationPic)!)
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
