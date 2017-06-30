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
var globalNewTLViewController:NewTLViewController?


class NewTLViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    var isRequestFromNewPost = false
    var myJourney: JSON!
    var isJourney = false
    var imageView1: UIImageView!
    var isActivityHidden = true
    var height: CGFloat!
    var otgView:startOTGView!
    var showDetails = false
    var journeyStart = false
    var infoView: TripInfoOTG!
    var addPosts: AddPostsOTGView!
    var addNewView = NewQuickItinerary()
    var changeText = AddBuddiesViewController()
    var endJourneyView: EndJourneyMyLife!
    var textFieldYPos = CGFloat(0)
    var difference = CGFloat(0)
    var loader = LoadingOverlay()
    var insideView:String = "both"
    
    var editingPostLayout: PhotosOTG2?
    
    var prevPosts: [JSON] = []
    var initialPost = true
    
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
//    var buttons = NearMeOptionButton()
    var addPostsButton: UIButton!
    var mainFooter: FooterViewNew?
    var layout: VerticalLayout!
    var refreshControl = UIRefreshControl()
    var isInitialLoad = true
    var fromOutSide = ""
    var fromType = ""
    let userm = User()
    var journeyCreator = ""

    
    @IBAction func addMoreBuddies(_ sender: AnyObject) {
        if isNetworkReachable {
            buddiesStatus = false;
            let getBuddies = storyboard?.instantiateViewController(withIdentifier: "addBuddies") as! AddBuddiesViewController
            getBuddies.addedFriends = myJourney["buddies"].arrayValue
            getBuddies.whichView = "NewTLMiddle"
            getBuddies.uniqueId = journeyId
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.pushViewController(getBuddies, animated: true)
        }
        else {
            let tstr = Toast(text: "No Internet Connection.")
            tstr.show()
        }
        
    }
    
    @IBAction func endJourneyTapped(_ sender: UIButton) {
       
        if isNetworkReachable {
            let end = storyboard!.instantiateViewController(withIdentifier: "endJourney") as! EndJourneyViewController
            end.journeyId = myJourney["_id"].stringValue
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController!.pushViewController(end, animated: true)
        }
        else {
            let tstr = Toast(text: "No Internet Connection.")
            tstr.show()
        }
    }
    
    
    @IBAction func infoCircle(_ sender: AnyObject) {
        getInfoCount()
    }
    
    
    var newScroll: UIScrollView!
    var backView:UIView!
    var backView1: UIView!
    
    func addPosts(_ sender: UIButton) {
        
        if locationManager == nil {
            isRequestFromNewPost = true
            self.detectLocation()            
        }
        self.showAddActivity()
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
    
    
    //MARK: - Post Create / Edit
    
    func savePhotoVideo (_ sender: UIButton) {
        
        print("\n\n videoURL : \(self.addView.videoURL) \n videoCaption : \(self.addView.videoCaption)")
        
        for img in self.addView.editPost.imageArr {
            self.addView.imageArr.append(img)
        }
        
        let dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        self.currentTime = dateFormatterTwo.string(from: Date())
        
        let prevVideo = (self.addView.videoURL != nil) ? (self.addView.editPost.jsonPost["videos"].isEmpty ? nil : (self.addView.editPost.jsonPost["videos"].rawString())) : nil
        
        let post = Post()
        let po = post.setPost(user.getExistingUser(), 
                              username: "", 
                              JourneyId: self.addView.editPost.post_uniqueId,
                              editPostId: self.addView.editPost.post_ids,
                              editPostUniqueID: self.addView.editPost.post_uniqueId,
                              type: "addPhotosVideos", 
                              Date: self.currentTime, 
                              Location: "", 
                              Category: "", 
                              Latitude: "", 
                              Longitude: "", 
                              Country: "", 
                              City: "", 
                              thoughts: "", 
                              newbuddies: JSON(self.addView.addedBuddies).rawString()!, 
                              oldbuddies: nil,
                              imageArr: self.addView.imageArr,
                              videoURL: self.addView.videoURL,
                              videoCaption: self.addView.videoCaption,
                              isCheckInChange: false,
                              oldVideoStream: prevVideo,
                              postType: editPostType.EDITING_PHOTO_VIDEO)
        
        self.editPostFromLayout(post: po, postLayout: self.editingPostLayout)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.startUploadingPostInBackground()
        
        self.addView.postButton.isHidden = true
        
        hideAddActivity()
    }
    
    func editActivity(_ sender: UIButton) {
        
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
        if self.addView.categoryLabel.text != nil {
            category = self.addView.categoryLabel.text!
            if(category == "Label") {
                category = ""
            }
        }
        
        if (userLocation == nil) {
            self.addView.addLocationButton.titleLabel?.text = self.addView.addLocationText.text
            lat = ""
            lng = ""
        }
        var location = self.addView.addLocationButton.titleLabel?.text
        if location != nil {
            location = (self.addView.addLocationButton.titleLabel?.text)!
            if(location == "Add Location") {
                location = ""
            }
        }
        else{
            location = ""
        }
        
        var thoughts = ""
        if self.addView.thoughtsTextView.text != nil {
            thoughts = self.addView.thoughtsTextView.text!
            if(thoughts == "Fill Me In...") {
                thoughts = ""
            }
        }
        
        if(self.addView.imageArr.count > 0 || self.addView.videoURL != nil  || thoughts.characters.count > 0 || (location?.characters.count)! > 0) {
            
            let newbuddies = JSON(self.addView.addedBuddies).rawString()
            let prevbuddies = JSON(self.addView.prevBuddies).rawString()
            
            let prevVideo = (self.addView.videoURL != nil) ? (self.addView.editPost.jsonPost["videos"].rawString()) : nil 
            //JSON(self.addView.editPost.jsonPost["videos"]).rawString()
            
            let isCheckInchanged = (self.addView.editPost.post_location != location) ? true : false
            
            let dateFormatterTwo = DateFormatter()
            dateFormatterTwo.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
            self.currentTime = dateFormatterTwo.string(from: Date())
            
            print("\n VideoURL : \(self.addView.videoURL) caption : \(self.addView.videoCaption)")
            
            let post  = Post()
            let po = post.setPost(currentUser["_id"].stringValue, username: currentUser["name"].stringValue, JourneyId: self.myJourney["uniqueId"].stringValue, editPostId: self.addView.editPost.post_ids, editPostUniqueID: self.addView.editPost.post_uniqueId, type: "editPost", Date: self.currentTime, Location: location!, Category: category, Latitude: lat, Longitude: lng, Country: self.addView.currentCountry, City: self.addView.currentCity, thoughts: thoughts, newbuddies: newbuddies!, oldbuddies: prevbuddies, imageArr: self.addView.imageArr, videoURL: self.addView.videoURL, videoCaption: self.addView.videoCaption, isCheckInChange: isCheckInchanged, oldVideoStream: prevVideo, postType: editPostType.EDITING_ACTIVITY)
            self.editPostFromLayout(post: po, postLayout: self.editingPostLayout)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.startUploadingPostInBackground()
            
            self.addView.postButton.isHidden = true
        }
        
        hideAddActivity()
       
    }
    
    func newPost(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        hideHeaderAndFooter(true)
        
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
            let post  = Post()
            let po = post.setPost(currentUser["_id"].stringValue, username: currentUser["name"].stringValue, JourneyId: self.journeyId, editPostId: nil, editPostUniqueID: nil, type: "travel-life", Date: self.currentTime, Location: location, Category: category, Latitude: lat, Longitude: lng, Country: self.addView.currentCountry, City: self.addView.currentCity, thoughts: thoughts, newbuddies: buddies!, oldbuddies: nil, imageArr: self.addView.imageArr, videoURL: self.addView.videoURL, videoCaption: self.addView.videoCaption, isCheckInChange: false, oldVideoStream: "", postType: editPostType.EDIT_NEW_POST)            
            self.addPostLayout(po)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.startUploadingPostInBackground()
            
            self.addView.postButton.isHidden = true
        }
        
        hideAddActivity()
    }
    
    func showOfflinePost(post: JSON, postId: Int) {
        var thoughts = String()
        var postTitle = ""
//        var photos: [JSON] = []
        
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
            
//            photos = post["photos"].array!
            checkIn.mainPhoto.hnk_setImageFromURL(NSURL(string: "\(adminUrl)upload/readFile?file=\(post["photos"][0]["name"].string!)&width=500") as! URL)
            checkIn.mainPhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(NewTLViewController.openSinglePhoto(_:))))
            checkIn.mainPhoto.tag = 0
            
            let likeMainPhoto = UITapGestureRecognizer(target: self, action: #selector(PhotosOTG.sendLikes(_:)))
            likeMainPhoto.numberOfTapsRequired = 2
            checkIn.mainPhoto.addGestureRecognizer(likeMainPhoto)
            checkIn.mainPhoto.isUserInteractionEnabled = true
            //            print("photobar count: \(photos.count)")
//            var count = 4
//            if photos.count < 5 {
//                
//                count = photos.count - 1
//                //                print("in the if statement \(count)")
//                
//            }
            
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
    
    
    //MARK: - Fetch Journey Data
    
    func getJourney(canGetFromCache: Bool) {
        
        request.getJourney(currentUser["_id"].string!, canGetCachedData: canGetFromCache, completion: {(response, isFromCache) in
            DispatchQueue.main.async(execute: {
                if (canGetFromCache == isFromCache) {
                    
                    self.loader.hideOverlayView()
                    print("\n\n JourneyJSON : \(response)")
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                    }
                    else if response["value"].bool! {
                        whichJourney = ""
                        
                        self.journeyCreator = response["data"]["journeyCreator"].stringValue
                        
                        self.cancelButton(nil)
                        self.layout.removeAll()
                        self.prevPosts = []
                        self.isInitialLoad = true                    
                        isJourneyOngoing = true
                        self.journeyStart = true
                        self.myJourney = response["data"]
                        self.checkFetchedLocation()
                        self.latestCity = response["data"]["startLocation"].string!
                        if self.isRefreshing {
                            self.refreshControl.endRefreshing()
                            self.isRefreshing = false
                        }
                        self.journeyID = self.myJourney["_id"].stringValue
                        self.journeyName = self.myJourney["name"].stringValue
                        self.isInitialLoad = false
                        
                        self.showJourneyOngoing(journey: response["data"])
                        self.setTopNavigation(text: "On The Go");
                    }
                    else{
                        self.cancelButton(nil)
                        self.layout.removeAll()
                        if self.insideView == "journey" {
                            self.checkForLocation(nil)
                            
                        }else if self.insideView == "itinerary" {
                            self.newItinerary(nil)
                        }
                    }
                }
                else {
                    print("\n canGetFromCache : \(canGetFromCache) \n isFromCache: \(isFromCache)")
                }
            })
        })
    }
    
    func getOneJourney() {
        request.getJourneyById(fromOutSide, completion: {(response) in
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()

                print("\n\n JourneyJSON : \(response)")
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                }
                else if response["value"].bool! {
                    if response["data"]["endTime"] != nil {
                        whichJourney = "end"
                    }else{
                        whichJourney = "otg"
                    }
                    self.journeyCreator = response["data"]["journeyCreator"].stringValue
                    
                    jouurneyToShow = response["data"]
                    self.cancelButton(nil)
                    self.layout.removeAll()
                    self.prevPosts = []
                    self.isInitialLoad = true
                    isJourneyOngoing = true
                    self.checkFetchedLocation()
                    self.latestCity = response["data"]["startLocation"].string!
                    if self.isRefreshing {
                        self.refreshControl.endRefreshing()
                        self.isRefreshing = false
                    }
                    self.journeyStart = true
                    self.myJourney = response["data"]
                    print(self.myJourney);
                    self.journeyID = self.myJourney["_id"].stringValue
                    self.journeyName = self.myJourney["name"].stringValue
                    self.isInitialLoad = false
                    if self.insideView == "journey" {
                        self.checkForLocation(nil)
                        
                    }else if self.insideView == "itinerary" {
//                        self.newItinerary(nil)
                    }
                    else{
                        self.showJourneyOngoing(journey: response["data"])
                    }
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
//        self.loader.hideOverlayView()
    }
    
    func closeInfo(_ sender: UITapGestureRecognizer) {
        self.infoView.isHidden = true
    }
    
    func closeAdd(_ sender: UIButton) {
        hideAddActivity()
    }
    
    
    //MARK: - Navigate To Other Controller
    
    func gotoSummaries(_ sender: UIButton) {
        if isNetworkReachable {
            let summaryVC = storyboard?.instantiateViewController(withIdentifier: "summarySub") as! SummarySubViewController
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.pushViewController(summaryVC, animated: true)
            summaryVC.journeyId = myJourney["_id"].string!
            //        infoView.animation.makeOpacity(0.0).animate(0.5)
            infoView.isHidden = true
        }
        else {
            let tstr = Toast(text: "No Internet Connection.")
            tstr.show()
        }
    }
    
    func gotoPhotos(_ sender: UIButton) {
        
        if isNetworkReachable {
            if sender.tag > 0 {
                let photoVC = storyboard?.instantiateViewController(withIdentifier: "photoGrid") as! TripSummaryPhotosViewController
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.pushViewController(photoVC, animated: true)
                photoVC.noPhoto = sender.tag
                photoVC.currentContentType = contentType.TL_CONTENT_IMAGE_TYPE
                photoVC.journeyID = myJourney["_id"].string!
                photoVC.creationDate = myJourney["startTime"].string!
                //        infoView.animation.makeOpacity(0.0).animate(0.5)
                infoView.isHidden = true
            }else{
                let tstr = Toast(text: "No Photos")
                tstr.show()
            }
        }
        else {
            let tstr = Toast(text: "No Internet Connection.")
            tstr.show()
        }
        
        
        
    }
    
    func gotoVideos(_ sender: UIButton) {
        if isNetworkReachable {
            if sender.tag > 0 {
                let photoVC = storyboard?.instantiateViewController(withIdentifier: "photoGrid") as! TripSummaryPhotosViewController
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController?.pushViewController(photoVC, animated: true)
                photoVC.noPhoto = sender.tag
                photoVC.currentContentType = contentType.TL_CONTENT_VIDEO_TYPE
                photoVC.journeyID = myJourney["_id"].string!
                photoVC.creationDate = myJourney["startTime"].string!
                //        infoView.animation.makeOpacity(0.0).animate(0.5)
                infoView.isHidden = true
            }else{
                let tstr = Toast(text: "No Videos")
                tstr.show()
            }
        }
        else{
            let tstr = Toast(text: "No Internet Connection.")
            tstr.show()
        }
    }
    
    func gotoReviews (_ sender: UIButton) {
        if isNetworkReachable {
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
        else {
            let tstr = Toast(text: "No Internet Connection.")
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
            self.addView.addVideoToBlock(video: (info["UIImagePickerControllerMediaURL"] as! URL))
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
        
        self.title = "On The Go"
        if  fromOutSide == "" {
            if insideView == "journey" {
                self.customNavigationBar(left: outButton, right: nil)
            }else{
            if (myJourney != nil) {
                self.customNavigationBar(left: leftButton, right: rightButton)
            }else{
                self.customNavigationBar(left: leftButton, right: nil)
            }
            }

        }else{
            self.customNavigationBar(left: outButton, right: rightButton)
        }
        
    }
    
   
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalNewTLViewController = self
        globalTLMainFeedsViewController = nil
        
        getDarkBackGroundNew(self)
        
        ToastView.appearance().backgroundColor = endJourneyColor
        
        self.setTopNavigation(text: "")

        self.layout = VerticalLayout(width: view.frame.size.width)
        
        mainScroll.addSubview(layout)
        mainScroll.delegate = self
        mainScroll.showsVerticalScrollIndicator = false
        mainScroll.showsHorizontalScrollIndicator = false
        mainScroll.clipsToBounds = true
                
        refreshControl.addTarget(self, action: #selector(NewTLViewController.refresh(_:)), for: .valueChanged)
        let attributes = [NSForegroundColorAttributeName: UIColor.white]
        let attributedTitle = NSAttributedString(string: "Pull To Refresh", attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = lightOrangeColor
        mainScroll.addSubview(refreshControl)
        
        self.infoView = TripInfoOTG(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1000))
        
        TLLoader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        TLLoader.center = self.view.center
        
        imagePicker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewTLViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewTLViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        self.addPostsButton = UIButton(frame: CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - 135, width: 65, height: 65))
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
        
        infoButton.isHidden = true
        
        self.fetchJourneyData(true)
        
        self.view.bringSubview(toFront: infoButton)
        self.view.bringSubview(toFront: addPostsButton)
        self.view.bringSubview(toFront: toolbarView)
        self.view.addSubview(TLLoader)
        
        self.hideHeaderAndFooter(true)
        
        mainScroll.delegate = self
        loader.showOverlay(self.view)
        
        self.mainFooter = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - MAIN_FOOTER_HEIGHT, width: self.view.frame.width, height: MAIN_FOOTER_HEIGHT))
        self.mainFooter?.layer.zPosition = 5
        self.view.addSubview(self.mainFooter!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAnalytics(name: "On The Go Page")
        if fromOutSide == "" {           
            self.mainFooter?.setHighlightStateForView(tag: 1, color: mainOrangeColor)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalNavigationController = self.navigationController
        self.mainFooter?.frame = CGRect(x: 0, y: self.view.frame.height - MAIN_FOOTER_HEIGHT, width: self.view.frame.width, height: MAIN_FOOTER_HEIGHT)
    }
            
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideHeaderAndFooter(false)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.mainFooter?.setFooterDefaultState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()        
    }
    
    func success(_ sender: UIButton){
        let nearMe = storyboard?.instantiateViewController(withIdentifier: "nearMeVC") as! NearMeViewController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(nearMe, animated: true)        
//        buttons.isHidden = true
        
        
    }
    
    @IBAction func nearMeAction(_ sender: UIButton) {
        print("aflatoon")
    }
    
    
    func hideHeaderAndFooter(_ isShow:Bool) {
        if(self.journeyStart) {
            if(isShow) {
                if isActivityHidden {
                    self.navigationController?.setNavigationBarHidden(true, animated: true)
                    if(self.toolbarView != nil ){
                        self.toolbarView.animation.makeOpacity(0.0).animate(0.5)
                    }
                    //                if(self.addPostsButton != nil) {
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                        self.addPostsButton.frame.origin.y = self.view.frame.height - self.addPostsButton.frame.size.height - 10
                        self.mainFooter?.frame.origin.y = self.view.frame.height + MAIN_FOOTER_HEIGHT
                    }, completion: nil)
                    //                }
                }                
            } else {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                if(self.toolbarView != nil ){
                    self.toolbarView.animation.makeOpacity(1.0).animate(0.5)
                }
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    self.addPostsButton.frame.origin.y = self.view.frame.height - 120
                    self.mainFooter?.frame.origin.y = self.view.frame.height - MAIN_FOOTER_HEIGHT
                }, completion: nil)
            }
        }
        else {  
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.addPostsButton.frame.origin.y = self.view.frame.height - self.addPostsButton.frame.size.height - 10
            self.mainFooter?.frame.origin.y = self.view.frame.height + MAIN_FOOTER_HEIGHT
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
                if (photosOtg.videoContainer != nil) {
                    photosOtg.videoToPlay()
                }
            }
        }        
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        for postView in layout.subviews {
//            if(postView is PhotosOTG2) {
//                let photosOtg = postView as! PhotosOTG2
//                if (photosOtg.mainPhoto != nil) {
//                    photosOtg.loadImagesOnlayout()
//                }
//            }
//        }
//    }
    
    
    var isRefreshing = false
    
    func fetchJourneyData(_ getFromCache: Bool) {
        if fromOutSide == "" {
            getJourney(canGetFromCache: getFromCache)
        }else{            
            if ((!isSelfJourney(journeyID: fromOutSide, creatorId: self.journeyCreator)) || (self.fromType == "ended-journey")) {
                addPostsButton.isHidden = true
            }
            getOneJourney()
        }
    }
    
    func refresh(_ sender: AnyObject) {
        isRefreshing = true
        self.fetchJourneyData(false)
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
    
    func editPostFromLayout(post:Post, postLayout:PhotosOTG2?) {
       
        if postLayout != nil {
            
            (postLayout!.rateButton)?.removeFromSuperview()
            postLayout?.rateButton = nil
            
            (postLayout!.footerView)?.removeFromSuperview()
            postLayout?.footerView = nil
            
            if postLayout?.postTop.videoArr.count != post.videoArr.count ||
                postLayout?.postTop.imageArr.count != post.imageArr.count ||
                postLayout?.postTop.post_locationImage != post.post_locationImage {
                
                postLayout?.mainPhoto?.removeFromSuperview()
                postLayout?.mainPhoto = nil
                
                postLayout?.videoContainer?.removeFromSuperview()
                postLayout?.videoContainer = nil
                
                postLayout?.centerView?.removeFromSuperview()
                postLayout?.centerView = nil
            }
            
            postLayout?.generatePost(post)

            self.layout.layoutSubviews()            
        }
    }
    
    func openSinglePhoto(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
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
        if isNetworkReachable {
            self.hideHeaderAndFooter(false)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.loader.showOverlay(self.view)
                request.deletePost(footer.postTop.post_ids, uniqueId: self.myJourney["uniqueId"].string!, user: currentUser["_id"].stringValue, completion: {(response) in
                    self.fetchJourneyData(false)
                })
            }
        }
        else {
            let tstr = Toast(text: "No Internet Connection.")
            tstr.show()
        }
    }
    
    var currentPhotoFooter:PhotoOTGFooter!
    
    func changeDateAndTime(_ footer:PhotoOTGFooter) {
        if isNetworkReachable {
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
        else {
            let tstr = Toast(text: "No Internet Connection.")
            tstr.show()
        }
    }
    
    
    func doneButton(_ sender: UIButton){
        
        self.hideHeaderAndFooter(false)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { 
            self.loader.showOverlay(self.view)
            request.changeDateTime(self.currentPhotoFooter.postTop.post_uniqueId, postID: self.currentPhotoFooter.postTop.post_ids,  date: "\(self.dateSelected) \(self.timeSelected)", completion: {(response) in
                self.fetchJourneyData(false)
            })
            self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
            self.backView.removeFromSuperview()
        }        
        
    }
    
    func doneButtonJourney(_ sender: UIButton){        
        request.changeDateTimeJourney(self.myJourney["_id"].stringValue, date: "\(dateSelected) \(timeSelected)", completion: {(response) in
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                    
                } else if response["value"].bool! {
                    print("edited date time response")
                    self.journeyDateChanged(date: "\(self.dateSelected)T\(self.timeSelected).000Z")
                    self.fetchJourneyData(false)
                } else {
                    
                }
                
            })
        })
        self.hideHeaderAndFooter(false)
        self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
        self.backView.removeFromSuperview()
    }
    
    func cancelButton(_ sender: UIButton?){
        self.hideHeaderAndFooter(false)
        print("\n InputView : \(self.inputView)")
        print("\n InputView : \(self.datePickerView)")
        
        if self.datePickerView != nil {
            self.inputview.removeFromSuperview() // To resign the inputView on clicking done.
            self.backView.removeFromSuperview()            
        }
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
    
    //MARK:- First View Actions
    
    func checkForLocation(_ sender: UIButton?) {
        if isSelfJourney(journeyID: fromOutSide, creatorId: self.journeyCreator) {
            self.detectLocation()            
        }
    }
    
    func newOtg(_ sender: UIButton?) {
        
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
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.toProfile(_:)))
//        otgView.dpFriendOne.addGestureRecognizer(tapGestureRecognizer)
        
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
    
    func newItinerary(_ sender: UIButton?) {
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
            if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
                selectedPeople = ""
                selectedUser = []
                
                let vc = storyboard?.instantiateViewController(withIdentifier: "TLProfileView") as! TLProfileViewController
                vc.displayData = ""
                vc.currentSelectedUser = currentUser
                
                let nvc = UINavigationController(rootViewController: vc)
                leftViewController.mainViewController = nvc
                leftViewController.slideMenuController()?.changeMainViewController(leftViewController.mainViewController, close: true)
                
                UIViewController().customiseNavigation()
                nvc.delegate = UIApplication.shared.delegate as! UINavigationControllerDelegate?
                
            }
            else {
                request.getUserFromCache(user.getExistingUser(), completion: { (response) in
                    DispatchQueue.main.async {
                        
                        currentUser = response["data"]
                        selectedPeople = ""
                        selectedUser = []
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TLProfileView") as! TLProfileViewController
                        vc.displayData = ""
                        vc.currentSelectedUser = currentUser
                        
                        let nvc = UINavigationController(rootViewController: vc)
                        leftViewController.mainViewController = nvc
                        leftViewController.slideMenuController()?.changeMainViewController(leftViewController.mainViewController, close: true)
                        
                        UIViewController().customiseNavigation()
                        nvc.delegate = UIApplication.shared.delegate as! UINavigationControllerDelegate?
                        
                    }
                })
            }
        }        
    }
    
    //MARK: - Keyboard Handling
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 64 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
            let keyboardYpos = self.view.frame.height - keyboardSize.height
            
            if keyboardYpos < textFieldYPos {
                difference = textFieldYPos - keyboardYpos
                self.view.frame.origin.y -= difference 
            }
            else {
                difference = CGFloat(0)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        self.view.frame.origin.y += difference
//        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 64{
//                self.view.frame.origin.y += keyboardSize.height
//                print("helololol")
//                print(keyboardSize.height)
//            }
//        }
    }
    
    
    //MARK: - Textfield Delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("\n\n textFieldDidBeginEditing called\n")
        textFieldYPos = textField.bounds.origin.y + textField.frame.size.height
        if textField.tag == 45 {
            textFieldYPos += 464
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
        print("\n textView frame : \(textView.frame.origin.y) \n bounds : \(addView.thoughtsTextView.frame)")
        print("\n thoughtFinalView : \(addView.thoughtsFinalView.frame)")
        print("\n  y: \(addView.thoughtsTextView.bounds.origin.y)  Height : \(addView.thoughtsTextView.frame.size.height)")
        textFieldYPos = addView.thoughtsFinalView.frame.origin.y + (2*addView.thoughtsTextView.frame.origin.y + addView.thoughtsTextView.frame.size.height)
        if addView.thoughtsTextView.text == "Fill Me In..." {
            addView.thoughtsTextView.text = ""
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 45 {
            if textField.text == "" {
                return false
            }
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textFieldYPos = 0
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        otgView.locationLabel.resignFirstResponder()
        self.title = "On The Go"
        
        otgView.drawLineView3.isHidden = false
        if textField == otgView.nameJourneyTF {
            
            if otgView.nameJourneyTF.text == "" {
                let errorAlert = UIAlertController(title: "Error", message: "Please name your journey", preferredStyle: UIAlertControllerStyle.alert)
                let DestructiveAction = UIAlertAction(title: "Ok", style: .destructive) {
                    (result : UIAlertAction) -> Void in
                    //Cancel Action
                }            
                errorAlert.addAction(DestructiveAction)
                self.navigationController?.present(errorAlert, animated: true, completion: nil)
            }
            else {
                
                self.checkFetchedLocation()
            
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
                _ = otgView.nameJourneyView.animation.moveY(-25)
                _ = otgView.nameJourneyTF.animation.moveY(-50)
                otgView.detectLocationView.animation.makeOpacity(1.0).thenAfter(0.3).animate(0.3)
                
                //            self.otgView.cityImage.hnk_setImageFromURL(URL(string: self.locationPic)!)
                
    //            otgView.bonVoyageLabel.isHidden = true
                setTopNavigation(text: "Select Kind of Journey");
                
                return true
            }

            
        }
        return false
        
    }
    
    func checkFetchedLocation() {
        if !isJourneyOngoing {
            //            request.getLocation(15.8514, long: 73.6389, completion: { (response) in
            if userLocation != nil {
                request.getLocation(userLocation.latitude, long: userLocation.longitude, completion: { (response) in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if (response.error != nil) {
                            print("error: \(response.error?.localizedDescription)")
                        }
                        else if response["value"].bool! {
                            print(response["data"]);
                            
                            self.locationData = response["data"]["name"].string!
                            self.otgView.locationLabel.text = response["data"]["name"].string!
                            self.locationPic = response["data"]["image"].string!
                            self.makeCoverPic(self.locationPic)
                            //                            self.otgView.cityImage.hnk_setImageFromURL(URL(string: self.locationPic)!)
                            self.locationName = self.locationData
                            self.locationLat = String(userLocation.latitude)
                            self.locationLong = String(userLocation.longitude)
                            let dateFormatterTwo = DateFormatter()
                            dateFormatterTwo.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            self.currentTime = dateFormatterTwo.string(from: Date())
                            self.otgView.detectLocationView.animation.makeOpacity(0.0).animate(0.0)
                            self.otgView.detectLocationView.isHidden = false
                            self.otgView.placeLabel.text = self.locationData                        
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
            else {
                if isSelfJourney(journeyID: fromOutSide, creatorId: self.journeyCreator) {
                    self.detectLocation()
                }
            }
        }
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
        if mainFooter != nil {
            self.view.bringSubview(toFront: mainFooter!)                        
        }
        
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
                        
                        DispatchQueue.global().async {
                            request.getUser(user.getExistingUser(), urlSlug: "") { (response, isFromCache) in
                                if !isFromCache {
                                    DispatchQueue.main.async {
                                        if response.error != nil {
                                            print("error: \(response.error!.localizedDescription)")
                                        }
                                        else if response["value"].bool! {
                                            currentUser = response["data"]
                                        }
                                        else {
                                            print("Response error")
                                        }
                                    }
                                }
                            }
                        }
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
        
        
        
        if ((!isSelfJourney(journeyID: fromOutSide, creatorId: self.journeyCreator)) || (self.fromType == "ended-journey")) {
            addPostsButton.isHidden = true
        }
        else {
            addPostsButton.isHidden = false
        }
        
        
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
                    if eachImage.currentImage != editedImagesArray[index][index] && index < subviewCount {                        
                        eachImage.setImage(editedImagesArray[index][index], for: .normal)                        
                        let exportFileUrl = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/image\(index).jpg"
                        
                        DispatchQueue.main.async(execute: {
                            do {                                
                                if let data = UIImageJPEGRepresentation(editedImagesArray[index][index]!, 0.35) {
                                    try data.write(to: URL(string: exportFileUrl)!, options: .atomic)
                                }
                            } catch let error as NSError {
                                print("error creating file: \(error.localizedDescription)")
                            }
                        })
                    }
                })
            }
        }
        print("for loop over")
    }
    
    
    //MARK: - Helper Functions
    
    func isSelfJourney(journeyID: String, creatorId: String) -> Bool {
        print("\n currentUser : \(currentUser["_id"].stringValue)     isSelfUser : \(isSelfUser(otherUserID: currentUser["_id"].stringValue))     journeyID: \(currentUser["journeyId"].stringValue)")
        if ((journeyID == "") ||
            (isSelfUser(otherUserID: currentUser["_id"].stringValue) && (currentUser["_id"].stringValue == self.journeyCreator))) {
            return true
        }
        return false
    }
    
    
    //MARK: - -- Location --
    
    func detectLocation() {
        
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
            handleRestrictedMode(onVC: self)
            break        
        }
    }
    
    func requestAuthorization() {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    //MARK:-  Location Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        userLocation = locValue
        print("\n lat: \(locValue.latitude) <<>> long: \(locValue.longitude)")        
        if manager.location?.coordinate != nil {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            userLocation = locValue
            
            self.stopDetectingLocation()
            
            if !isRequestFromNewPost {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    if !self.journeyStart {
                        self.newOtg(nil)
                    }
                })                
            }
            else {
                self.addView.addLocationTapped()
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
    
    
    //MARK: - Location Error Handler
    
    func showNetworkErrorAlert() {
        let errorAlert = UIAlertController(title: "Error", message: "Please check your internet connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        errorAlert.addAction(cancelAction)
        
        self.navigationController?.present(errorAlert, animated: true, completion: nil)
    }    
}
