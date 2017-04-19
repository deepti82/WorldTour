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
import Toaster
import Spring

var isJourneyOngoing = false
var TLLoader = UIActivityIndicatorView()
var userLocation: CLLocationCoordinate2D!
var globalNewTLViewController:NewTLViewController!


class NewTLViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    var myJourney: JSON!
    var isJourney = false
    var imageView1: UIImageView!
    var isActivityHidden = true;
    var height: CGFloat!
    var otgView:startOTGView!
    var showDetails = false
    var journeyStart = false
    var infoView: TripInfoOTG!
    var addPosts: AddPostsOTGView!
    var addNewView = NewQuickItinerary()
    var buttons1 = Buttons2()
    var changeText = AddBuddiesViewController()
    var endJourneyView: EndJourneyMyLife!
    var textFieldYPos = CGFloat(0)
    var difference = CGFloat(0)
    var loader = LoadingOverlay()
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var toolbarView: UIView!
    @IBOutlet weak var hideVisual: UIVisualEffectView!
    @IBOutlet weak var hideToolBar: UIStackView!
    @IBOutlet weak var mainScroll: UIScrollView!
    var journeyName: String!
    var locationData = ""
    var locationManager : CLLocationManager?
    var locationPic = ""
    var journeyCategories = [String] ()
    var currentTime: String!
    
    var journeyId: String!
    var journeyID: String!
    
    var addedBuddies: [JSON] = []
    var addView: AddActivityNew!
    var backgroundReview = UIView()
    var buttons = NearMeOptionButton()
    var addPostsButton: UIButton!
    var mainFooter: FooterViewNew!
    var layout: VerticalLayout!
    var refreshControl = UIRefreshControl()
    var isInitialLoad = true
    var fromOutSide = ""
    var fromType = ""
    let userm = User()

    
    @IBAction func addMoreBuddies(_ sender: AnyObject) {
        buddiesStatus = false;
        let getBuddies = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
        getBuddies.addedFriends = myJourney["buddies"].arrayValue
        getBuddies.whichView = "NewTLMiddle"
        getBuddies.uniqueId = journeyId
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(getBuddies, animated: true)
    }
    
    
    @IBAction func endJourneyTapped(_ sender: UIButton) {
        let end = storyboard!.instantiateViewController(withIdentifier: "endJourney") as! EndJourneyViewController
        end.journeyId = myJourney["_id"].stringValue
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController!.pushViewController(end, animated: true)
    }
    
    
    @IBAction func infoCircle(_ sender: AnyObject) {
        getInfoCount()
    }
    
    
    
    var newScroll: UIScrollView!
    var backView:UIView!
    var backView1: UIView!
    
    func addPosts(_ sender: UIButton) {
        showAddActivity()
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
                self.inputview = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 220, width: self.view.frame.size.width, height: 240))
                self.inputview.backgroundColor = UIColor.white
               
                self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.inputview.frame.size.width, height: 200))
                self.datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
                self.datePickerView.maximumDate = Date()
                
                self.backView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 260, width: self.view.frame.size.width, height: 40))
                self.backView.backgroundColor = UIColor(hex: "#272b49")               
                self.inputview.addSubview(self.datePickerView) // add date picker to UIView
                
                let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 100, height: 40))
                doneButton.setTitle("Save", for: .normal)
                doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
                doneButton.setTitleColor(UIColor.white, for: .normal)
                //                doneButton.setTitle(sender.title(for: .application)!, for: .application)
                
                let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
                cancelButton.setTitle("Cancel", for: .normal)
                cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
                cancelButton.setTitleColor(UIColor.white, for: UIControlState())
                self.inputview.addSubview(self.backView)
                self.backView.addSubview(doneButton) // add Button to UIView
                self.backView.addSubview(cancelButton) // add Cancel to UIView
                
               if self.addPostsButton.tag == 1 {
                    self.addPostsButton.backgroundColor  = UIColor.black
                }
                
                doneButton.addTarget(self, action: #selector(NewTLViewController.doneButtonJourney(_:)), for: .touchUpInside) // set button click event
                cancelButton.addTarget(self, action: #selector(NewTLViewController.cancelButton(_:)), for: .touchUpInside) // set button click event
                
                self.hideHeaderAndFooter(true)
                //sender.inputView = inputView
                self.datePickerView.addTarget(self, action: #selector(NewTLViewController.handleDatePicker(_:)), for: .valueChanged)
                
                self.handleDatePicker(self.datePickerView) // Set the date on start.
                self.view.addSubview(self.backView)
                self.view.addSubview(self.inputview)
                
        }))
        optionsController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        showPopover(optionsController: optionsController, sender: sender, vc: self)
//        if let popover = optionsController.popoverPresentationController{
//            popover.sourceView = sender
//            popover.sourceRect = sender.bounds
//        }
//        self.present(optionsController, animated: true, completion: nil)
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
    
    
    
    func savePhotoVideo (_ sender: UIButton) {
        let post = PostEditPhotosVideos()
        post.saveAddPhotosVideos(uniqueId: self.addView.editPost.post_uniqueId, imageArr: self.addView.imageArr,buddy:JSON(self.addView.addedBuddies).rawString()!)
        hideAddActivity()
        
        let i = PostImage()
        i.uploadPhotos()
        self.addView.postButton.isHidden = true
    }
    
    func editActivity(_ sender: UIButton) {
        
        
        hideAddActivity()
        var lat = ""
        if self.addView.currentLat != nil && self.addView.currentLat != 0.0 {
            lat = String(self.addView.currentLat!)
            if(lat == "0.0") {
                lat = ""
            }
        }
        var lng = ""
        if self.addView.currentLong != nil && self.addView.currentLong != 0.0 {
            lng = String(self.addView.currentLong!)
            if(lng == "0.0") {
                lng = ""
            }
        }
        var category = ""
        if self.addView.categoryLabel.text! != nil {
            category = self.addView.categoryLabel.text!
            if(category == "Label") {
                category = ""
            }
        }
        
        var location = ""
        if self.addView.addLocationButton.titleLabel?.text! != nil {
            location = (self.addView.addLocationButton.titleLabel?.text)!
            if(location == "Add Location") {
                location = ""
                
                }
        }
        
        var thoughts = ""
        if self.addView.thoughtsTextView.text! != nil {
            thoughts = self.addView.thoughtsTextView.text!
            if(thoughts == "Fill Me In...") {
                thoughts = ""
            }
        }
        
        if(self.addView.imageArr.count > 0 || self.addView.videoURL != nil  || thoughts.characters.count > 0 || location.characters.count > 0) {
            var params:JSON = ["type":"editPost"];
            params["_id"] = JSON(self.addView.editPost.post_ids)
            params["user"] = JSON(self.addView.editPost.post_userId)
            params["uniqueId"] = JSON(self.addView.editPost.post_uniqueId)
            params["journeyUniqueId"] = JSON(self.myJourney["uniqueId"].stringValue)
            params["username"] = JSON(currentUser["name"].stringValue)
            params["thoughts"] = JSON(thoughts)
            let checkIn:JSON = [
                "location": location,
                "lat": lat,
                "long": lng,
                "city": self.addView.currentCity,
                "country" : self.addView.currentCountry,
                "category": category
            ]
            params["checkIn"] = checkIn
            if(self.addView.editPost.post_location != location) {
                params["checkInChange"] = true
            } else {
                params["checkInChange"] = false
            }

            params["oldBuddies"] = JSON(self.addView.prevBuddies)
            params["newBuddies"] = JSON(self.addView.addedBuddies)
            
            var photosJson:[JSON] = []
            for img in self.addView.imageArr {
                photosJson.append(img.parseJson())
            }
            params["photosArr"] = JSON(photosJson)
            
            request.postAddPhotosVideos(param: params) { (json) in
                print(json)
                self.getJourney();
            }
        }
        
        
        
    }
    
    func newPost(_ sender: UIButton) {
        hideHeaderAndFooter(true)
        hideAddActivity()
        let post  = Post();
        
        let buddies = JSON(self.addView.addedBuddies).rawString()
        
        var lat = ""
        if self.addView.currentLat != nil && self.addView.currentLat != 0.0 {
            lat = String(self.addView.currentLat!)
            if(lat == "0.0") {
                lat = ""
            }
        }
        var lng = ""
        if self.addView.currentLong != nil && self.addView.currentLong != 0.0 {
            lng = String(self.addView.currentLong!)
            if(lng == "0.0") {
                lng = ""
            }
        }
        var category = ""
        if self.addView.categoryLabel.text! != nil {
            category = self.addView.categoryLabel.text!
            if(category == "") {
                category = ""
            }
        }
        
        var location = ""
        if self.addView.addLocationButton.titleLabel?.text != nil {
            location = (self.addView.addLocationButton.titleLabel?.text)!
            if(location == "Add Location") {
                location = ""
            }
        }
        if(location == "") {
            location = self.addView.addLocationText.text!
        }
        
        var thoughts = ""
        if self.addView.thoughtsTextView.text! != nil {
            thoughts = self.addView.thoughtsTextView.text!
            if(thoughts == "Fill Me In...") {
                thoughts = ""
            }
        }
        
        let dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        self.currentTime = dateFormatterTwo.string(from: Date())
        
        if(self.addView.imageArr.count > 0 || self.addView.videoURL != nil || thoughts.characters.count > 0 || location.characters.count > 0) {
            let po = post.setPost(currentUser["_id"].string!, JourneyId: self.journeyId, Type: "travel-life", Date: self.currentTime, Location: location, Category: category, Latitude: lat, Longitude: lng, Country: self.addView.currentCountry, City: self.addView.currentCity, thoughts: thoughts, buddies: buddies!, imageArr: self.addView.imageArr,videoURL:self.addView.videoURL, videoCaption:self.addView.videoCaption)
            self.addPostLayout(po)
            
            let i = PostImage()
            i.uploadPhotos()
            self.addView.postButton.isHidden = true
        }
        
    }
    
    var prevPosts: [JSON] = []
    var initialPost = true
    
    
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
                checkIn.animation.makeY(0).animate(0.0)
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
        
        //        for image in checkIn.otherPhotosStack {
        //
        //            image.isHidden = true
        //
        //        }
        
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
            
            //            for i in 0 ..< count {
            //
            //
            //                checkIn.otherPhotosStack[i].hnk_setImageFromURL(URL(string:photosToBeUploaded[i + 1].url)!)
            //                checkIn.otherPhotosStack[i].isHidden = false
            //                checkIn.otherPhotosStack[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.openSinglePhoto(_:))))
            //                checkIn.otherPhotosStack[i].tag = i + 1
            //
            //                checkIn.otherPhotosStack[i].isUserInteractionEnabled = true
            //
            //            }
            
        }
            
        else if post["photos"] != nil && post["photos"].array!.count == 0 && post["checkIn"]["location"] == "" {
            
            checkIn.mainPhoto.isHidden = false
            checkIn.photosStack.isHidden = true
            //            checkIn.photosHC.constant = 0.0
            checkIn.frame.size.height = 250.0
            
        }
        
        checkIn.tag = 11
        layout.addSubview(checkIn)
        hideHeaderAndFooter(true)
        addHeightToLayout(height: checkIn.frame.height + 50)
        
        
    }
    
    func postPartTwo() {
        
        if !isEdit {
            
            var thoughts = ""
            var location = ""
            var locationCategory = ""
            var photos: [JSON] = []
            var videos: [JSON] = []
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
                //                videos = uploadedVideos as! [JSON]
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
            
            if Reachability.isConnectedToNetwork() {
                
                //                print("internet is connected post")
                request.postTravelLife(thoughts, location: location, locationCategory: locationCategory, latitude: "\(myLatitude.latitude)", longitude: "\(myLatitude.longitude)", photosArray: photos, videosArray: videos, buddies: buddies, userId: currentUser["_id"].string!, journeyId: id, userName: currentUser["name"].string!, city: currentCity, country: currentCountry, hashtags: hashtags, date: currentTime, completion: {(response) in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if response.error != nil {
                            
                            //                            print("error: \(response.error!.localizedDescription)")
                            
                        }
                        else if response["value"].bool! {
                            
                            //                            print("response arrived new post!")
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
                })
            })
        }
    }
    
    func detectLocation(_ sender: AnyObject?) {
        
        self.stopDetectingLocation()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startMonitoringSignificantLocationChanges()
        self.updateStatus(status: CLLocationManager.authorizationStatus())
    }
    
    func stopDetectingLocation() {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    func getJourney() {
       
        request.getJourney(currentUser["_id"].string!, completion: {(response) in
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                }
                else if response["value"].bool! {
                    whichJourney = ""
                    self.layout.removeAll()
                    self.prevPosts = []
                    self.isInitialLoad = true;
                    self.detectLocation(nil)
                    self.latestCity = response["data"]["startLocation"].string!
                    if self.isRefreshing {
                        self.refreshControl.endRefreshing()
                        self.isRefreshing = false
                    }
                    isJourneyOngoing = true
                    self.journeyStart = true
                    self.myJourney = response["data"]
                    print("line no : \(self.myJourney)");
                    self.journeyID = self.myJourney["_id"].stringValue
                    self.journeyName = self.myJourney["name"].stringValue
                    self.isInitialLoad = false
                    self.showJourneyOngoing(journey: response["data"])
                    self.setTopNavigation(text: "On The Go");
                }
            })
            
        })
        
    }
    
    //MARK: - getone journey added.
    func getOneJourney() {
        request.getJourneyById(fromOutSide, completion: {(response) in
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()

                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                }
                else if response["value"].bool! {
                    if response["data"]["endTime"] != nil {
                        whichJourney = "end"
                    }else{
                        whichJourney = "otg"
                    }
                    jouurneyToShow = response["data"]
                    self.layout.removeAll()
                    self.prevPosts = []
                    self.isInitialLoad = true;
                    self.detectLocation(nil)
                    self.latestCity = response["data"]["startLocation"].string!
                    if self.isRefreshing {
                        self.refreshControl.endRefreshing()
                        self.isRefreshing = false
                    }
                    isJourneyOngoing = true
                    self.journeyStart = true
                    self.myJourney = response["data"]
                    print(self.myJourney);
                    self.journeyID = self.myJourney["_id"].stringValue
                    self.journeyName = self.myJourney["name"].stringValue
                    self.isInitialLoad = false
                    self.showJourneyOngoing(journey: response["data"])
                    self.setTopNavigation(text: "\(response["data"]["name"].stringValue)");
                }
            })
            
        })
        
    }

    
    func getAllPosts(_ posts: [JSON]) {
        
        if endJourneyView != nil {
            endJourneyView.removeFromSuperview()
        }
        
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
                self.configurePost(post)
            }
        }
        print("lets go \(jouurneyToShow)")
        if whichJourney == "end" {
            endJourneyView = EndJourneyMyLife(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 329))
            
            if jouurneyToShow["post"].count > 0 {
                
                endJourneyView.placeLabel.text = jouurneyToShow["post"][jouurneyToShow["post"].count - 1]["city"].string

            }else{
            endJourneyView.placeLabel.text = jouurneyToShow["startLocation"].stringValue
            }
            endJourneyView.dateLabel.text = getDateFormat(jouurneyToShow["endTime"].stringValue, format: "dd MMM, yyyy")
            endJourneyView.timeLabel.text = getDateFormat(jouurneyToShow["endTime"].stringValue, format: "hh:mm a")
            layout.addSubview(endJourneyView)
            addHeightToLayout(height: endJourneyView.frame.height + 50.0)
        }else{
            if endJourneyView != nil {
                endJourneyView.removeFromSuperview()
            }
        }
    }
    
    func closeInfo(_ sender: UITapGestureRecognizer) {
        self.infoView.isHidden = true
    }
    
    func closeAdd(_ sender: UIButton) {
        hideAddActivity()
    }
    
    func gotoSummaries(_ sender: UIButton) {
        
        let summaryVC = storyboard?.instantiateViewController(withIdentifier: "summarySub") as! SummarySubViewController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(summaryVC, animated: true)
        summaryVC.journeyId = myJourney["_id"].string!
        //        infoView.animation.makeOpacity(0.0).animate(0.5)
        infoView.isHidden = true
        
        
    }
    
    func gotoPhotos(_ sender: UIButton) {
        if sender.tag > 0 {
            let photoVC = storyboard?.instantiateViewController(withIdentifier: "photoGrid") as! TripSummaryPhotosViewController
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.pushViewController(photoVC, animated: true)
            photoVC.noPhoto = sender.tag
            photoVC.whichView = "photos"
            photoVC.journey = myJourney["_id"].string!
            photoVC.creationDate = myJourney["startTime"].string!
            //        infoView.animation.makeOpacity(0.0).animate(0.5)
            infoView.isHidden = true
        }else{
            let tstr = Toast(text: "No Photos")
            tstr.show()
        }
        
        
    }
    
    
    func gotoVideos(_ sender: UIButton) {
        if sender.tag > 0 {
            let photoVC = storyboard?.instantiateViewController(withIdentifier: "photoGrid") as! TripSummaryPhotosViewController
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.pushViewController(photoVC, animated: true)
            photoVC.noPhoto = sender.tag
            photoVC.whichView = "videos"
            photoVC.journey = myJourney["_id"].string!
            photoVC.creationDate = myJourney["startTime"].string!
            //        infoView.animation.makeOpacity(0.0).animate(0.5)
            infoView.isHidden = true
        }else{
        }
        
        
    }
    
    func gotoReviews (_ sender: UIButton) {
        if sender.tag > 0 {

        let ratingVC = storyboard?.instantiateViewController(withIdentifier: "ratingTripSummary") as! AddYourRatingViewController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(ratingVC, animated: true)
        ratingVC.journeyId = myJourney["_id"].string!
        infoView.isHidden = true
            
        }else{
            let tstr = Toast(text: "No Reviews")
            tstr.show()
        }
        
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
    
    func addCheckInTL(sender: UIButton) {
        
        let checkInVC = storyboard?.instantiateViewController(withIdentifier: "checkInSearch") as! MainSearchViewController
//        checkInVC.whichView = "TL"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(checkInVC, animated: true)
        
    }
    
    //For videos Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info["UIImagePickerControllerMediaType"] as? String
        if(mediaType == "public.image") {
            picker.dismiss(animated: true, completion: {})
            let tempImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            let imgA:[UIImage] = [tempImage!]
            self.addView.photosAdded(assets: imgA)
        } else {
            picker.dismiss(animated: true, completion: {})
            self.addView.addVideoToBlock(video: info["UIImagePickerControllerMediaURL"] as! URL)
        }
    }
    
    
    func openSideMenu(_ sender: AnyObject) {
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.toggleLeft()
    }
    
    func setTopNavigation(text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "menu_left_icon"), for: UIControlState())
        leftButton.imageView?.image = leftButton.imageView?.image!.withRenderingMode(.alwaysTemplate)
        leftButton.imageView?.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        
        self.navigationController?.navigationBar.tintColor.withAlphaComponent(0.9)
        leftButton.addTarget(self, action: #selector(self.openSideMenu(_:)), for: .touchUpInside)
        
        //button from out side
        let outButton = UIButton()
        outButton.frame = CGRect(x: 10, y: 10, width: 30, height: 20)
        outButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        outButton.imageView?.contentMode = .scaleAspectFit
        outButton.imageView?.clipsToBounds = true
        outButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        
        
        UINavigationBar.appearance().backgroundColor = UIColor(hex: "#11d3cb")
        UINavigationBar.appearance().backgroundColor?.withAlphaComponent(0.9)
        
        let rightButton = UIView()
        rightButton.frame = CGRect(x: 0, y: 0, width: 60, height: 35)
        let rightButton1 = UIButton()
        rightButton1.frame = CGRect(x: 10, y: 10, width: 30, height: 20)
        rightButton1.setImage(UIImage(named: "nearMe"), for: UIControlState())
//        rightButton1.imageView?.tintColor = UIColor(hex: "#11d3cb")
        rightButton1.imageView?.contentMode = .scaleAspectFit
        rightButton1.imageView?.clipsToBounds = true
        
        let rightButton2 = UIButton()
        rightButton2.frame = CGRect(x: 40, y: 8, width: 25, height: 25)
        rightButton2.setImage(UIImage(named: "options_icon"), for: UIControlState())
        
        rightButton1.addTarget(self, action: #selector(self.gotoNearMe(_:)), for: .touchUpInside)
        rightButton2.addTarget(self, action: #selector(self.infoCircle(_:)), for: .touchUpInside)
        
        if  fromOutSide == "" {
            
            rightButton.addSubview(rightButton1)
            rightButton.addSubview(rightButton2)

        }else{
            
            rightButton.addSubview(rightButton2)
            
        }
        
        //        rightButton.setTitle("i", for: UIControlState())
        //        rightButton.layer.borderWidth = 1.5
        //        rightButton.layer.borderColor = UIColor.white.cgColor
        //        rightButton.layer.cornerRadius = rightButton.frame.width / 2
        
        self.title = text
        if  fromOutSide == "" {
            
            if (myJourney != nil) {
                self.customNavigationBar(left: leftButton, right: rightButton)
            }else{
                self.customNavigationBar(left: leftButton, right: nil)
            }

        }else{
            self.customNavigationBar(left: outButton, right: rightButton)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalNavigationController = self.navigationController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalActivityFeedsController = nil
        ToastView.appearance().backgroundColor = endJourneyColor

        self.layout = VerticalLayout(width: view.frame.size.width)
        mainScroll.addSubview(layout)
        let i  = PostImage();
        i.uploadPhotos()
        self.setTopNavigation(text: "")
        
        
        globalNewTLViewController = self;
        getDarkBackGroundNew(self)
        mainScroll.delegate = self
        
        
        
        self.infoView = TripInfoOTG(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1000))
        
        
        mainScroll.showsVerticalScrollIndicator = false
        mainScroll.showsHorizontalScrollIndicator = false
        
        refreshControl.addTarget(self, action: #selector(NewTLViewController.refresh(_:)), for: .valueChanged)
        let attributes = [NSForegroundColorAttributeName: UIColor.white]
        let attributedTitle = NSAttributedString(string: "Pull To Refresh", attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = lightOrangeColor
        mainScroll.addSubview(refreshControl)
        
        
        //        otgView.nameJourneyTF.becomeFirstResponder()
        //        otgView.nameJourneyView.becomeFirstResponder()
        //        otgView.clipsToBounds = true
        //        otgView.locationLabel.addTarget(self, action: #selector(NewTLViewController.showDropdown(_:)), for: .editingChanged)
        
        TLLoader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        TLLoader.center = self.view.center
        
        imagePicker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewTLViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewTLViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        mainScroll.clipsToBounds = true
        
        self.addPostsButton = UIButton(frame: CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - 200, width: 65, height: 65))
//        self.addPostsButton.layer.cornerRadius = 30
        let origImage = UIImage(named: "darkgreycircle");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        addPostsButton.setImage(tintedImage, for: .normal)
        addPostsButton.tintColor = mainOrangeTransparentColor
        self.addPostsButton.setBackgroundImage(UIImage(named:"darkgreycircle"), for: .normal)
        addPostsButton.imageView?.contentMode = .scaleAspectFit
            
            self.addPostsButton.backgroundColor?.withAlphaComponent(0.8)
//        transparentOrangeButton(self.addPostsButton)
        self.addPostsButton.setImage(UIImage(named: "plus"), for: .normal)
        self.addPostsButton.imageView?.contentMode = .scaleAspectFit
        self.addPostsButton.imageEdgeInsets = UIEdgeInsetsMake(25, 25, 25, 25)
        self.addPostsButton.addTarget(self, action: #selector(NewTLViewController.addPosts(_:)), for: .touchUpInside)
        
        //self.addPostsButton.layer.zPosition = 5
        self.view.addSubview(self.addPostsButton)
        addPostsButton.isHidden = true
        
        self.mainFooter = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - MAIN_FOOTER_HEIGHT, width: self.view.frame.width, height: MAIN_FOOTER_HEIGHT))
        self.mainFooter.layer.zPosition = 5
        self.view.addSubview(self.mainFooter)
        self.mainFooter.setHighlightStateForView(tag: 1, color: mainOrangeColor)
        
        infoButton.isHidden = true
        
//        addPostsButton.isHidden = true
        
        if fromOutSide == "" {
            getJourney()
        }else{
            addPostsButton.isHidden = true
            getOneJourney()
        }

        
        if fromOutSide != "" {
            addPostsButton.isHidden = true
        } else {
            addPostsButton.isHidden = false
        }
        
        self.view.bringSubview(toFront: infoButton)
        self.view.bringSubview(toFront: addPostsButton)
        self.view.bringSubview(toFront: toolbarView)
        self.view.addSubview(TLLoader)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        mainScroll.delegate = self
        loader.showOverlay(self.view)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideHeaderAndFooter(false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func willSee(_ sender: UIButton){
        print("GoForIt")
    }
    
    func success(_ sender: UIButton){
        let nearMe = storyboard?.instantiateViewController(withIdentifier: "nearMeVC") as! NearMeViewController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(nearMe, animated: true)
        buttons1.isHidden = true
        buttons.isHidden = true
        
        
    }
    
    @IBAction func nearMeAction(_ sender: UIButton) {
        print("aflatoon")
    }
    
    
    func hideHeaderAndFooter(_ isShow:Bool) {
        if(self.journeyStart) {
            if(isShow) {
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                if(self.toolbarView != nil ){
                    self.toolbarView.animation.makeOpacity(0.0).animate(0.5)
                }
                if(self.addPostsButton != nil) {
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                        self.addPostsButton.frame.origin.y = self.view.frame.height + 10
                        self.mainFooter.frame.origin.y = self.view.frame.height + MAIN_FOOTER_HEIGHT
                    }, completion: nil)
                }
            } else {
                if(self.toolbarView != nil ){
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.toolbarView.animation.makeOpacity(1.0).animate(0.5)
                }
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.addPostsButton.frame.origin.y = self.view.frame.height - 120
                    self.mainFooter.frame.origin.y = self.view.frame.height - MAIN_FOOTER_HEIGHT
                }, completion: nil)
            }
        }
        else {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            hideHeaderAndFooter(true);
        }
        else{
            hideHeaderAndFooter(false);
        }
        for postView in layout.subviews {
            if(postView is PhotosOTG2) {
                let photosOtg = postView as! PhotosOTG2
                if(photosOtg.videoContainer != nil) {
                    
                    photosOtg.videoToPlay()
                    
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func gotoProfile(_ sender: UIButton) {
        
        if isJourneyOngoing {
            
            let profile = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController!.pushViewController(profile, animated: false)
            buttons1.isHidden = true
            buttons.isHidden = true
            
            
        }
        else {
            
            self.popVC(sender)
            buttons1.isHidden = true
            buttons.isHidden = true
            
        }
        
    }
    
    var isRefreshing = false
    
    func refresh(_ sender: AnyObject) {
        isRefreshing = true
        getJourney()
    }
    
    var isInitialPost = true
    var otherCommentId = ""
    var latestCity = ""
    
    
    func addPostLayout(_ post:Post) {
        let checkIn = PhotosOTG2(width: layout.frame.width)
        checkIn.journeyUser = myJourney["user"]["_id"].stringValue

        checkIn.generatePost(post)
        checkIn.newTl = self
        checkIn.scrollView = mainScroll
        layout.addSubview(checkIn)
        addHeightToLayout(height: checkIn.frame.height + 50)
    }
    
    func showPost(_ whichPost: String, post: JSON) {
        
        var thoughts = String()
        var postTitle = ""
        var photos: [JSON] = []
        //        let tags = ActiveLabel()
        
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
        checkIn.likeViewLabel.text = "\(post["likeCount"].stringValue) Likes"
        checkIn.commentCount.text = "\(post["commentCount"].stringValue) Comments"
        
        checkIn.commentButton.setTitle(post["uniqueId"].string!, for: .normal)
        checkIn.commentButton.setTitle(post["_id"].string!, for: .application)
        otherCommentId = post["_id"].string!
        currentPost = post
        
        checkIn.optionsButton.setTitle(post["_id"].string!, for: .normal)
        checkIn.optionsButton.setTitle(post["uniqueId"].string!, for: .application)
        
        checkIn.clipsToBounds = true
        checkIn.commentButton.addTarget(self, action: #selector(NewTLViewController.sendComments(_:)), for: .touchUpInside)
        checkIn.optionsButton.addTarget(self, action: #selector(NewTLViewController.chooseOptions(_:)), for: .touchUpInside)
        
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
            
            //            for i in 0 ..< count {
            //
            //                let imgg = photos[i + 1]["name"]
            //                checkIn.otherPhotosStack[i].hnk_setImageFromURL(NSURL(string:"\(adminUrl)upload/readFile?file=\(imgg)&width=250") as! URL)
            //                checkIn.otherPhotosStack[i].isHidden = false
            //                checkIn.otherPhotosStack[i].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.openSinglePhoto(_:))))
            //                checkIn.otherPhotosStack[i].tag = i + 1
            //                checkIn.otherPhotosStack[i].accessibilityLabel = post["_id"].string!
            //                checkIn.otherPhotosStack[i].isUserInteractionEnabled = true
            //
            //            }
            
        }
            
        else if post["photos"].array!.count == 0 && post["videos"].array!.count == 0 && post["checkIn"]["location"] != "" {
            
            checkIn.mainPhoto.isHidden = false
            //            checkIn.photosStack.isHidden = true
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
            
            //            if post["photos"].array!.count < checkIn.otherPhotosStack.count {
            //
            //
            //                let difference = checkIn.otherPhotosStack.count - post["photos"].array!.count
            //
            //                for i in 0 ..< difference {
            //
            //
            //                    let index = checkIn.otherPhotosStack.count - i - 1
            //                    checkIn.otherPhotosStack[index].isHidden = true
            //
            //                }
            //
            //            }
            
            if post["photos"].array!.count == 0 && post["videos"].array!.count == 0 {
                
                checkIn.mainPhoto.isHidden = false
                //                checkIn.photosStack.isHidden = true
                //                checkIn.photosHC.constant = 300.0
                
                if post["showMap"].boolValue && post["showMap"] != nil {
                    
                    // CHECKIN MAP IMAGE
                    if ( post["checkIn"]["lat"].string != nil && post["checkIn"]["lat"] != "" ) && post["checkIn"]["long"].string != nil {
                        
                        let getKey = post["imageUrl"].string?.components(separatedBy: "=")
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
                    let rateButton = RatingCheckIn(frame: CGRect(x: 0, y: -4, width: width, height: 150))
                    rateButton.rateCheckInLabel.text = "Rate \(post["checkIn"]["location"])?"
                    rateButton.rateCheckInButton.addTarget(self, action: #selector(NewTLViewController.addRatingPost(_:)), for: .touchUpInside)
                    print(">>>>>>>>>>>> \(myJourney)")
                    if myJourney != nil {
                            rateButton.journeyUser = myJourney["user"]["_id"].stringValue
                    }
                    
                    rateButton.review = post["checkIn"]
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
        //            checkIn.photosStack.removeFromSuperview()
        default:
            break
        }
        let bottomOffset = CGPoint(x: 0, y: mainScroll.contentSize.height - mainScroll.bounds.size.height)
        mainScroll.setContentOffset(bottomOffset, animated: true)
    }
    
    func openSinglePhoto(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
//        singlePhotoController.mainImage?.image = sender.image
        singlePhotoController.index = sender.view.tag
        singlePhotoController.postId = sender.view.accessibilityLabel!
        singlePhotoController.fetchType = photoVCType.FROM_ACTIVITY
        self.navigationController?.pushViewController(singlePhotoController, animated: true)
    }
    
    func showReviewButton(post: JSON, isIndex: Bool, index: Int?) {
        print("one")
        let allReviews = post["review"].array!
        let lastReviewCount = post["review"].array!.count - 1
        let rateButton = ShowRating(frame: CGRect(x: 0, y: -4, width: width, height: 150))
        //        myReview = post["review"].array!
        //        rateButton.showRating(ratingCount: Int(allReviews[0]["rating"].string!)! - 1)
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
            
            //            myView.frame.size.height -= myView.photosStack.frame.height
            totalHeight += 300
        }
        else if photos == 0 {
            
            //            myView.frame.size.height -= myView.photosStack.frame.height
            //            myView.frame.size.height -= myView.mainPhoto.frame.height
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
        
        let buddy = BuddyOTG(frame: CGRect(x: 0, y: 0, width: 241, height: 260))
        buddy.center.x = self.view.center.x
        let profileImage = adminUrl + "upload/readFile?width=250&file=" + post["user"]["profilePicture"].stringValue
        buddy.profileImage.hnk_setImageFromURL(URL(string:profileImage)!)
        buddy.joinJourneytext.text = "\(post["user"]["name"])"
        HiBye(buddy.profileImage)
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
                
            })
            
            //print("inside edit check in \(self.addView), \(self.newScroll.isHidden)")
            
        }
        actionSheetControllerIOS8.addAction(EditCheckIn)
        
        let EditDnt: UIAlertAction = UIAlertAction(title: "Change Date & Time", style: .default)
        { action -> Void in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            self.inputview = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 10, width: self.view.frame.size.width, height: 240))
            self.inputview.backgroundColor = UIColor.white
            
            self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 40, width: self.inputview.frame.size.width, height: 200))
            self.datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
            self.datePickerView.maximumDate = Date()
            
            self.backView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 240, width: self.view.frame.size.width, height: 40))
            self.backView.backgroundColor = UIColor(hex: "#272b49")
            self.inputview.addSubview(self.datePickerView) // add date picker to UIView
            
            let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 100, height: 40))
            doneButton.setTitle("Save", for: .normal)
            doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            doneButton.setTitleColor(UIColor.white, for: .normal)
            //                doneButton.setTitle(sender.title(for: .application)!, for: .application)
            
            let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
            cancelButton.setTitle("Cancel", for: .normal)
            cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            cancelButton.setTitleColor(UIColor.white, for: UIControlState())
            self.inputview.addSubview(self.backView)
            self.backView.addSubview(doneButton) // add Button to UIView
            self.backView.addSubview(cancelButton) // add Cancel to UIView
            
            doneButton.addTarget(self, action: #selector(NewTLViewController.doneButton(_:)), for: .touchUpInside) // set button click event
            cancelButton.addTarget(self, action: #selector(NewTLViewController.cancelButton(_:)), for: .touchUpInside) // set button click event
            
            //sender.inputView = inputView
            self.datePickerView.addTarget(self, action: #selector(NewTLViewController.handleDatePicker(_:)), for: .valueChanged)
            
            self.handleDatePicker(self.datePickerView) // Set the date on start.
            self.view.addSubview(self.backView)
            self.view.addSubview(self.inputview)
        }
        actionSheetControllerIOS8.addAction(EditDnt)
        let DeletePost: UIAlertAction = UIAlertAction(title: "Delete Post", style: .default)
        { action -> Void in
            
            request.deletePost(self.currentPost["_id"].string!, uniqueId: self.myJourney["uniqueId"].string!, user: self.currentPost["user"]["_id"].string!, completion: {(response) in
                
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
    }
    
    func deletePost(_ footer:PhotoOTGFooter) {
        request.deletePost(footer.postTop.post_ids, uniqueId: self.myJourney["uniqueId"].string!, user: currentUser["_id"].stringValue, completion: {(response) in
            self.getJourney()
        })
    }
    
    var currentPhotoFooter:PhotoOTGFooter!
    
    func changeDateAndTime(_ footer:PhotoOTGFooter) {
        currentPhotoFooter = footer
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        self.inputview = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 200, width: self.view.frame.size.width, height: 240))
        self.inputview.backgroundColor = UIColor.white
        self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 10, width: self.inputview.frame.size.width, height: 200))
        self.datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        self.datePickerView.minimumDate = dateFormatter.date(from: myJourney["startTime"].string!)
        self.datePickerView.date = dateFormatter.date(from: footer.postTop.jsonPost["UTCModified"].stringValue)!
        self.datePickerView.maximumDate = Date()
        self.backView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 240, width: self.view.frame.size.width, height: 40))
        self.backView.backgroundColor = UIColor(hex: "#272b49")
        self.inputview.addSubview(self.datePickerView) // add date picker to UIView
        let doneButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.size.width - 100, y: 0, width: 100, height: 40))
        doneButton.setTitle("Save", for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        doneButton.setTitleColor(UIColor.white, for: .normal)
        
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        cancelButton.setTitleColor(UIColor.white, for: UIControlState())
        self.inputview.addSubview(self.backView)
        self.backView.addSubview(doneButton) // add Button to UIView
        self.backView.addSubview(cancelButton) // add Cancel to UIView
        
        doneButton.addTarget(self, action: #selector(NewTLViewController.doneButton(_:)), for: .touchUpInside) // set button click event
        cancelButton.addTarget(self, action: #selector(NewTLViewController.cancelButton(_:)), for: .touchUpInside) // set button click event
        
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        
//        view.addGestureRecognizer(tap)
        
        self.datePickerView.addTarget(self, action: #selector(NewTLViewController.handleDatePicker(_:)), for: .valueChanged)
        
        self.handleDatePicker(self.datePickerView) // Set the date on start.
        self.view.addSubview(self.backView)
        self.view.addSubview(self.inputview)
    }
    
    
    func doneButton(_ sender: UIButton){
        request.changeDateTime(currentPhotoFooter.postTop.post_uniqueId, date: "\(dateSelected) \(timeSelected)", completion: {(response) in
            self.getJourney()
        })
        self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
        self.backView.removeFromSuperview()
    }
    
    func doneButtonJourney(_ sender: UIButton){        
        request.changeDateTimeJourney(self.myJourney["_id"].stringValue, date: "\(dateSelected) \(timeSelected)", completion: {(response) in
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                    
                } else if response["value"].bool! {
                    print("edited date time response")
                    self.journeyDateChanged(date: "\(self.dateSelected)T\(self.timeSelected).000Z")
                    self.getJourney()
                } else {
                    
                }
                
            })
        })
        self.hideHeaderAndFooter(false)
        self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
        self.backView.removeFromSuperview()
    }
    
    func cancelButton(_ sender: UIButton){
        self.hideHeaderAndFooter(false)
        self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
        self.backView.removeFromSuperview()
    }
    
    func sendComments(_ sender: UIButton) {
        print("comment button tapped")
        let comment = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
        comment.postId = sender.titleLabel!.text!
        comment.ids = sender.title(for: .application)!
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(comment, animated: true)
    }
    
    func addHeightToLayout(height: CGFloat) {
        self.layout.layoutSubviews()
        self.mainScroll.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height + 220)
        if(height != 500) {
            if fromOutSide == "" {
                self.scrollToBottom1()
            }
        }
        
    }
    
    func removeHeightFromLayout(_ height: CGFloat) {
        addHeightToLayout(height:height)
        hideHeaderAndFooter(false)
    }
    
    func configurePost(_ post: JSON) {
        
        prevPosts.append(post)
        
        let po = Post();
        po.jsonToPost(post);
        self.addPostLayout(po)
        
//        if(post["checkIn"]["location"].stringValue != "") {
//            
//            if post["review"].array!.count > 0 {
//                print(post["review"])
//                for subview in layout.subviews {
//                    
//                    if subview.isKind(of: RatingCheckIn.self) {
//                        
//                        let myView = subview as! RatingCheckIn
//                        if myView.rateCheckInButton.currentTitle! == post["_id"].string! {
//                            
//                            subview.removeFromSuperview()
//                            removeHeightFromLayout(subview.frame.height)
//                            
//                        }
//                        
//                    }
//                    
//                }
//                
//                showReviewButton(post: post, isIndex: false, index: nil)
//                
//            }
//                
//            else {
//                
//                let rateButton = RatingCheckIn(frame: CGRect(x: 0, y: 0, width: width, height: 150))
//                rateButton.rateCheckInLabel.text = "Rate \(post["checkIn"]["location"])?"
//                rateButton.rateCheckInButton.addTarget(self, action: #selector(NewTLViewController.addRatingPost(_:)), for: .touchUpInside)
//                rateButton.rateCheckInButton.setTitle(post["_id"].string!, for: .normal)
//                layout.addSubview(rateButton)
//                addHeightToLayout(height: rateButton.frame.height + 20.0)
//                rateButton.tag = 10
//                
//            }
//        }
        
        
        //        if post["checkIn"]["location"] != nil &&  post["checkIn"].string != "" {
        //
        //            showPost("CheckIn", post: post)
        //        }
        //        else if post["photos"] != nil && post["photos"].array!.count > 0 {
        //
        //            showPost("Photos", post: post)
        //
        //        }
        //        else if post["videos"] != nil && post["videos"].array!.count > 0 {
        //
        //            showPost("Videos", post: post)
        //        }
        //        else if post["thoughts"] != nil &&  post["thoughts"].string != "" {
        //
        //            showPost("Thoughts", post: post)
        //
        //        }
        
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
    
    func toProfile(_ sender: AnyObject) {
        print("clickedddd")
//        print(self.buddiesJson)
        //        print("clicked \(currentFeed)")
        //        selectedPeople = currentFeed["user"]["_id"].stringValue
        //        let profile = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        //        profile.displayData = "search"
        //        globalNavigationController.pushViewController(profile, animated: true)
    }
    
    func newOtg(_ sender: UIButton) {
        
        
        
        self.journeyStart = true
        hideHeaderAndFooter(false)
        setTopNavigation(text: "On The Go");
        addNewView.animation.makeOpacity(0.0).animate(0.5)
        addNewView.isHidden = true
        addNewView.removeFromSuperview()
        //        getScrollView(height, journey: JSON(""))
        
        otgView = startOTGView(frame: CGRect(x: 0, y: 0, width: mainScroll.frame.width, height: mainScroll.frame.height + 64))
        print("ooooooooo\(myJourney)")
        otgView.buddiesJson = self.addedBuddies
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.toProfile(_:)))
        otgView.dpFriendOne.addGestureRecognizer(tapGestureRecognizer)
        
        if myJourney != nil {
            if myJourney["user"]["_id"].stringValue != user.getExistingUser() {
                otgView.optionsButton.isHidden = true
            }
        }else{
            otgView.optionsButton.isHidden = true
        }
        
        otgView.shoewImage.alpha = 0
//        otgView.bonVoyageLabel.alpha = 0
        otgView.lineOne.alpha = 0
        otgView.startJourneyButton.alpha = 0
        otgView.lineTwo.alpha = 0
//         otgView.bonVoyageLabel.
       addPostsButton.isHidden = true
        otgView.shoewImage.animation.delay(0.2).makeAlpha(1.0).moveY(-25).animateWithCompletion(0.5, {
            print("shoeImage")
        })
        otgView.bonVoyageLabel.animation.delay(0.4).makeAlpha(1.0).moveY(-25).animateWithCompletion(0.5, {
            print("bonVoyage")
        })
        
        otgView.lineOne.animation.delay(0.6).makeAlpha(1.0).moveY(-25).animateWithCompletion(0.5,{
            print("LineOne")
        })
        otgView.startJourneyButton.animation.delay(0.8).makeAlpha(1.0).moveY(-25).animateWithCompletion(0.5,{
            print("StartJourney")
        })
        
        otgView.lineTwo.animation.delay(0.10).makeAlpha(1.0).moveY(-25).animateWithCompletion(1.5, {
            print("lineTwo")
        })
        
        
        
        otgView.startJourneyButton.addTarget(self, action: #selector(NewTLViewController.startOTGJourney(_:)), for: .touchUpInside)
        otgView.selectCategoryButton.addTarget(self, action: #selector(NewTLViewController.journeyCategory(_:)), for: .touchUpInside)
        otgView.addBuddiesButton.addTarget(self, action: #selector(NewTLViewController.addBuddies(_:)), for: .touchUpInside)
       
        //                otgView.detectLocationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.detectLocationViewTap(_:))))
        //                otgView.detectLocationButton.addTarget(self, action: #selector(NewTLViewController.detectLocation(_:)), for: .touchUpInside)
        otgView.nameJourneyTF.returnKeyType = .done
        otgView.locationLabel.returnKeyType = .done
        otgView.locationLabel.delegate = self
        otgView.optionsButton.addTarget(self, action: #selector(NewTLViewController.optionsAction(_:)), for: .touchUpInside)
//        otgView.optionsButton.isHidden = true
        otgView.nameJourneyTF.delegate = self
        otgView.clipsToBounds = true
        layout.addSubview(otgView)
        self.addHeightToLayout(height: 500)
        
        
        
    }
    
    func newItinerary(_ sender: UIButton) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let itineraryVC = storyboard?.instantiateViewController(withIdentifier: "qiPVC") as! QIViewController
        self.navigationController?.pushViewController(itineraryVC, animated: true)
        
    }
    
    func closeView(_ sender: UIButton) {
        
        if (self.navigationController?.viewControllers.count)! > 1 {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController!.popViewController(animated: true)
        }
        else {
            leftViewController.profileTap(UIButton())
        }        
    }
    
    //MARK: - Keyboard Handling
    
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 64 {
                self.view.frame.origin.y -= keyboardSize.height
            }
//            let keyboardYpos = self.view.frame.height - keyboardSize.height
//            
//            if keyboardYpos < textFieldYPos {
//                difference = textFieldYPos - keyboardYpos
//                self.view.frame.origin.y -= difference 
//            }
//            else {
//                difference = CGFloat(0)
//            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
//        self.view.frame.origin.y += difference
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 64{
                self.view.frame.origin.y += keyboardSize.height
                print("helololol")
                print(keyboardSize.height)
            }
        }
    }
    
    
    //MARK: - Textfield Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("\n\n textFieldDidBeginEditing called\n")
        textFieldYPos = textField.bounds.origin.y + textField.frame.size.height
        if textField.tag == 45 {
            textFieldYPos += 364
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldYPos = 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            addView.thoughtsTextView.resignFirstResponder()
            
            if addView.thoughtsTextView.text == "" {
                
                addView.thoughtsTextView.text = "Fill Me In..."
                
            }
            return true
            
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let number = newText.characters.count
        addView.countCharacters(number)
        return number <= 180
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textFieldYPos = textView.frame.origin.y + textView.frame.size.height
        if addView.thoughtsTextView.text == "Fill Me In..." {
            addView.thoughtsTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textFieldYPos = 0
    }
    
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        otgView.locationLabel.resignFirstResponder()
        self.title = "On The Go"
        
        detectLocation(nil)
        
        otgView.drawLineView3.isHidden = false
//        otgView.bonVoyageLabel.isHidden = true
        if textField == otgView.nameJourneyTF {
            print("\n mainscroll y : \(mainScroll.frame.origin.y) origin : \(mainScroll.bounds.origin.y )")
                        otgView.closeBuddies.isHidden = true
            otgView.cityView.isHidden = false
            otgView.cityImage.isHidden = false
            
            //            otgView = startOTGView(frame: CGRect(x: 0, y: 258, width: mainScroll.frame.width, height: self.view.frame.height))
            //            self.otgView.frame.origin.y = self.view.frame.height + 258
            otgView.detectLocationView.isHidden = true
            otgView.nameJourneyTF.isHidden = true
            otgView.nameJourneyView.isHidden = true
            otgView.journeyName.isHidden = false
            otgView.journeyName.text = otgView.nameJourneyTF.text
            journeyName = otgView.nameJourneyTF.text
            otgView.nameJourneyTF.resignFirstResponder()
            height = 164
            mainScroll.animation.makeY(mainScroll.frame.origin.y + height).thenAfter(0.3).animate(0.3)
            print("showmeTheHeight\(mainScroll.frame.origin.y + height)")
            otgView.detectLocationView.layer.opacity = 0.0
            otgView.nameJourneyView.animation.moveY(-25)
            otgView.nameJourneyTF.animation.moveY(-50)
            otgView.detectLocationView.animation.makeOpacity(1.0).thenAfter(0.3).animate(0.3)
            
            //            self.otgView.cityImage.hnk_setImageFromURL(URL(string: self.locationPic)!)
            
//            otgView.bonVoyageLabel.isHidden = true
            setTopNavigation(text: "Select Kind of Journey");

            
        }
        return false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //imageCache = nil
    }
    
    func startOTGJourney(_ sender: UIButton) {
        otgView.bonVoyageLabel.isHidden = true
        setTopNavigation(text: "Name Your Journey");
        otgView.frame.origin.y = 300
        otgView.nameJourneyTF.tag = 45
        otgView.nameJourneyTF.becomeFirstResponder()
        sender.animation.makeHeight(0.0).animate(0.3)
        sender.isHidden = true
        otgView.nameJourneyView.layer.opacity = 0.0
        otgView.nameJourneyView.isHidden = false
        otgView.nameJourneyTF.isHidden = false
        otgView.nameJourneyView.animation.makeOpacity(1.0).makeHeight(otgView.nameJourneyView.frame.height).animate(0.5)
        otgView.detectLocationView.isHidden = true
        otgView.detectHide.isHidden = true
        otgView.cityView.isHidden = true
        otgView.locationLabel.isHidden = true
        otgView.closeBuddies.isHidden = true
        
        transparentCardWhite(otgView.nameJourneyView)
        self.view.bringSubview(toFront: mainFooter)
//        transparentWhiteTextField(otgView.nameJourneyTF)
    }
    
    func journeyCategory(_ sender: UIButton) {
        print("journey category clicked")
        otgView.selectCategoryButton.isHidden = true
        let categoryVC = storyboard?.instantiateViewController(withIdentifier: "kindOfJourneyVC") as! KindOfJourneyOTGViewController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(categoryVC, animated: true)
        //        showDetailsFn()
        otgView.drawLineView3.isHidden = true
        otgView.drawLineView4.isHidden = false
        otgView.bonVoyageLabel.isHidden = true
        
    }
    
    func showDetailsFn(isEdit: Bool) {
        
        if !isJourneyOngoing {
            self.journeyName = otgView.nameJourneyTF.text!
            height = 40.0
            mainScroll.animation.thenAfter(0.5).makeY(mainScroll.frame.origin.y - height).animate(0.5)
            
            request.addNewOTG(journeyName, userId: currentUser["_id"].string!, startLocation: locationData, kindOfJourney: journeyCategories, timestamp: currentTime, lp: locationPic, lat: locationLat, long: locationLong, completion: {(response) in
//                self.loader.removeFromSuperview()
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error?.localizedDescription)")
                    }
                        
                    else if response["value"].bool! {
                        
                        self.journeyId = response["data"]["uniqueId"].string!
                        isJourneyOngoing = true
                        
                        if !isEdit {
                            
                            self.setTopNavigation(text: "Add Buddies");
                            
                            self.otgView.selectCategoryButton.isHidden = true
                            self.otgView.journeyDetails.isHidden = false
                            self.otgView.buddyStack.isHidden = true
                            self.otgView.addBuddiesButton.isHidden = false
                            self.otgView.closeBuddies.isHidden = false
                        }

                        
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
        
        for i in 0..<journeyCategories.count {
            switch journeyCategories[i].lowercased() {
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
                kindOfJourneyStack.append("romance_new")
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
                fallthrough
            case "partner":
                print("11")
                kindOfJourneyStack.append("partner")
            case "colleague":
                print("12")
                kindOfJourneyStack.append("colleague")
            default:
                break
            }
        }
        
        if journeyCategories.count != 0 {
            if journeyCategories.count == 1 {
                otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
                otgView.journeyCategoryOne.isHidden = false
                otgView.journeyCategoryTwo.isHidden = true
                otgView.journeyCategoryThree.isHidden = true
                
            } else if journeyCategories.count == 2 {
                otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
                otgView.journeyCategoryOne.isHidden = false
                otgView.journeyCategoryTwo.image = UIImage(named: kindOfJourneyStack[1])
                otgView.journeyCategoryTwo.isHidden = false
                otgView.journeyCategoryThree.isHidden = true
            } else if journeyCategories.count > 2 {
                print(kindOfJourneyStack)
                otgView.journeyCategoryOne.image = UIImage(named: kindOfJourneyStack[0])
                otgView.journeyCategoryOne.isHidden = false
                otgView.journeyCategoryTwo.image = UIImage(named: kindOfJourneyStack[1])
                otgView.journeyCategoryTwo.isHidden = false
                otgView.journeyCategoryThree.isHidden = false
                otgView.journeyCategoryThree.image = UIImage(named: kindOfJourneyStack[2])
            }
            
        }
        
    }
    
    
    
    var countLabel: Int!
    var dpOne: String!
    var dpTwo: String!
    var dpThree: String!
    
    func buddyAdded(_ json:[JSON],inMiddle:Bool) {
        
        //         let po = post.setPost(currentUser["_id"].string!, JourneyId: self.journeyId, Type: "travel-life", Date: self.currentTime, Location: location, Category: category, Latitude: lat, Longitude: lng, Country: self.addView.currentCountry, City: self.addView.currentCity, thoughts: thoughts, buddies: buddies, imageArr: self.addView.imageArr)
        print( currentUser["_id"].stringValue)
        print(currentUser["name"].stringValue)
        print(self.journeyId)
        print(self.journeyName)
        request.addBuddiesOTG(json, userId: currentUser["_id"].stringValue , userName: currentUser["name"].stringValue, journeyId: self.journeyId, inMiddle: inMiddle, journeyName: self.journeyName, completion: { (json) in
            self.otgView.drawLineView4.isHidden = true
            self.otgView.bonVoyageLabel.isHidden = true
            self.otgView.bonVoyageLabel.isHidden = true
        })
    }
    
    func buddyAdded(_ json:[JSON],inMiddle:Bool,completionDone: @escaping ((JSON) -> Void)) {
        
        //         let po = post.setPost(currentUser["_id"].string!, JourneyId: self.journeyId, Type: "travel-life", Date: self.currentTime, Location: location, Category: category, Latitude: lat, Longitude: lng, Country: self.addView.currentCountry, City: self.addView.currentCity, thoughts: thoughts, buddies: buddies, imageArr: self.addView.imageArr)
        print( currentUser["_id"].stringValue)
        print(currentUser["name"].stringValue)
        print(self.journeyId)
        print(self.journeyName)
        request.addBuddiesOTG(json, userId: currentUser["_id"].stringValue , userName: currentUser["name"].stringValue, journeyId: self.journeyId, inMiddle: inMiddle, journeyName: self.journeyName, completion: { (json) in
            completionDone(json);
        })
    }
    
    func addBuddies(_ sender: UIButton) {
        print("ADD BUDDIES");
       addPostsButton.isHidden = false
        if journeyId != nil {
            buddiesStatus  = true;
        }
        else {
            addBuddies(sender)
        }
    
        let addBuddiesVC = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
        addBuddiesVC.whichView = "NewTLView"
        otgView.animation.makeY(25).animate(0.0)
        
        if journeyId != nil {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController!.pushViewController(addBuddiesVC, animated: true)
        }
        else {
            addBuddies(sender)
        }
        
    }
    
    
    func showBuddies() {
        
        for i in 0 ..< addedBuddies.count {
            if i < 3 {
            let imageUrl = addedBuddies[i]["profilePicture"].string!
            otgView.buddyStackPictures[i].hnk_setImageFromURL(getImageURL(imageUrl, width: 100))
            makeBuddiesTLProfilePicture(otgView.buddyStackPictures[i])
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
        otgView.closeBuddies.isHidden = true
        infoButton.isHidden = true
        
        if fromOutSide != "" {
            addPostsButton.isHidden = true
        } else {
            addPostsButton.isHidden = false
        }
        
        //        otgView.lineThree.isHidden = false
        
        
        if fromOutSide == "" {
            toolbarView.isHidden = false
        }else{
            toolbarView.isHidden = true
        }
        
        
//                if currentUser["_id"].stringValue == userm.getExistingUser() {
//                    if fromType == "ended-journey" {
//                        toolbarView.isHidden = true
//                    }else{
//
//                    toolbarView.isHidden = false
//                    }
//                }else{
//                    toolbarView.isHidden = true
//                }

        
    }
    
    var places: [JSON]!
    var coverImage: String!
    
    func makeCoverPic(_ imageString: String) {
        var  getImageUrl = adminUrl + "upload/readFile?file=\(imageString)&width=650"
        
        if imageString.range(of:"https://") != nil{
            getImageUrl = imageString;
        }
        print(getImageUrl);
        let url1 = URL(string:getImageUrl);
        self.otgView.cityImage.hnk_setImageFromURL(url1!)
        
    }
    
    
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
    
    
    var photosAddedMore = false
    var photosGroupId = 0
    var photosToBeUploaded: [PhotoUpload] = []
    
    
    
    
    var tempAssets: [URL] = []
    var allImageIds: [Int] = []
    var localDbPhotoIds: [Int] = []
    
    //    var uploadedPhotos: [String] = []
    
    func uploadMultiplePhotos(_ assets: [URL], localIds: [Int]) {
        
        var photosCount = 0
        
        
        request.uploadPhotos(tempAssets[0], localDbId: localIds[0], completion: {(response) in
            
            if response.error != nil {
                
                print("error: \(response.error!.localizedDescription)")
                
            }
            else if response["value"].bool! {
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
                    cameraConf.maximumVideoLength = 60
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
    
    
    //MARK: - Location Delegates
    
    func updateStatus(status: CLAuthorizationStatus) {
        switch status {
            
        case CLAuthorizationStatus.notDetermined:
            self.requestAuthorization()
            break
            
        case CLAuthorizationStatus.authorizedAlways:
            fallthrough
        case CLAuthorizationStatus.authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            break
            
        case CLAuthorizationStatus.denied:
            fallthrough
        case CLAuthorizationStatus.restricted:            
            self.handleRestrictedMode()
            break
            
            //        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LabelHasbeenUpdated"), object: nil)        
        }
    }
    
    func requestAuthorization() {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        userLocation = locValue
        print("\n lat: \(locValue.latitude) <<>> long: \(locValue.longitude)")
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
                            print(response["data"]);
                            
                            self.stopDetectingLocation()
                            
                            self.locationData = response["data"]["name"].string!
                            self.otgView.locationLabel.text = response["data"]["name"].string!
                            self.locationPic = response["data"]["image"].string!
                            self.makeCoverPic(self.locationPic)
                            //                            self.otgView.cityImage.hnk_setImageFromURL(URL(string: self.locationPic)!)
                            self.locationName = self.locationData
                            self.locationLat = String(locValue.latitude)
                            self.locationLong = String(locValue.longitude)
                            let dateFormatterTwo = DateFormatter()
                            dateFormatterTwo.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            self.currentTime = dateFormatterTwo.string(from: Date())
                            self.otgView.detectLocationView.animation.makeOpacity(0.0).animate(0.0)
                            self.otgView.detectLocationView.isHidden = false
                            self.otgView.placeLabel.text = self.locationData
                            let curDate = Date()
                            let localDate = self.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: self.currentTime, isDate: true)
                            let localTime = self.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: self.currentTime, isDate: false)
                            self.otgView.timestampDate.text = "\(localDate) | \(localTime)" //self.currentTime
                            
                            
                            //                        self.otgView.timestampDate.text = self.currentTime
                            
                            //                    self.otgView.timestampTime.text =
                            self.otgView.cityView.layer.opacity = 0.0
                            self.otgView.cityView.isHidden = false
                            self.otgView.cityView.animation.makeOpacity(1.0).animate(0.0)
                            self.otgView.journeyDetails.isHidden = true
                            self.otgView.selectCategoryButton.isHidden = false
                            self.height = 250.0
                            self.mainScroll.animation.makeY(60.0).animate(0.7)
                            self.otgView.animation.makeY(0.0).animate(0.7)
                            
                            self.scrollToBottom()
                        }
                        else {
                            
                            print("response error!")
                            print("\n show error alert")
                            self.showNetworkErrorAlert()
                        }
                    })
                })
            }
        }
        else {
            print("\n auth status : \(CLLocationManager.authorizationStatus().rawValue)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error while updating location " + error.localizedDescription)
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\n didChangeAuthorization : \(status.rawValue)")
        self.updateStatus(status: status)
    }
    
    
    //MARK: - Location Alert
    func showNetworkErrorAlert() {
        let errorAlert = UIAlertController(title: "Error", message: "It seems that you are not connected with internet. Please check your internet connection ", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        errorAlert.addAction(cancelAction)
        
        self.navigationController?.present(errorAlert, animated: true, completion: nil)
    }
    
    func handleRestrictedMode(){
        print("\n handle restricted mode")
        
        let errorAlert = UIAlertController(title: "Turn on Location Services", message: "1. Tap Settings \n 2. Tap Location \n Tap While Using the App", preferredStyle: UIAlertControllerStyle.alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        errorAlert.addAction(settingsAction)
        
        let cancelAction = UIAlertAction(title: "Not Now", style: .default, handler: nil)
        errorAlert.addAction(cancelAction)
        
        self.navigationController?.present(errorAlert, animated: true, completion: nil)
    }
}
