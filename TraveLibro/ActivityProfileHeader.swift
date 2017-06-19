//
//  ActivityProfileHeader.swift
//  TraveLibro
//
//  Created by Jagruti  on 17/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityProfileHeader: UIView {

    @IBOutlet var activityProView: UIView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!    
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var localDate: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var localTime: UILabel!
    @IBOutlet weak var blurImageView: UIImageView!
    var parentController: UIViewController!
    
    var currentFeed:JSON = []
    let imageArr: [String] = ["restaurantsandbars", "leaftrans", "sightstrans", "museumstrans", "zootrans", "shopping", "religious", "cinematrans", "hotels", "planetrans", "health_beauty", "rentals", "entertainment", "essential", "emergency", "othersdottrans"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        makeBuddiesTLProfilePicture(profilePic)
        clockLabel.text = String(format: "%C", faicon["calendar"]!)
        calendarLabel.text = String(format: "%C", faicon["clock"]!)
        
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topLeft, .topRight],
                                cornerRadii: CGSize(width: 10, height:  10))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
                
    }
        required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityProfileHeader", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    
    func fillProfileHeader(feed:JSON, pageType: viewType?, cellType: feedCellType?) {
        
        currentFeed = feed
        
        profilePic.image = UIImage(named: "logo-default")
        
        if isLocalFeed(feed: currentFeed) {
            fillProfileHeaderLocalFeed(feed: feed, pageType: pageType, cellType: cellType)
        }
        else {
        
            self.removePreviousGesture()
            
            self.sendSubview(toBack: self.profilePic)
            self.sendSubview(toBack: self.userName)
            
            self.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.handleProfileTap(_:)))
            self.addGestureRecognizer(tapGestureRecognizer)
            
            setFollowButtonTitle(button: followButton, followType: feed["following"].intValue, otherUserID: (feed["_id"] != nil ? feed["_id"].stringValue : "admin"))
            
            
            if (pageType == viewType.VIEW_TYPE_ACTIVITY ||
                pageType == viewType.VIEW_TYPE_SHOW_SINGLE_POST ||
                pageType == viewType.VIEW_TYPE_OTG ||
                (currentUser != nil) && feed["user"]["_id"].stringValue == currentUser["_id"].stringValue) {
                followButton.isHidden = true
            }
            
            if pageType == viewType.VIEW_TYPE_ACTIVITY {
                
                localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["timestamp"].stringValue, isDate: true)
                localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["timestamp"].stringValue, isDate: false)
                
                switch feed["type"].stringValue {
                case "on-the-go-journey":
                    fallthrough
                case "ended-journey":
                    userName.text = feed["user"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["user"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    break
                    
                    
                case "quick-itinerary":
                    fallthrough
                case "detail-itinerary":
                    userName.text = feed["creator"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["creator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    
                    if feed["timestamp"].stringValue == "" {
                        localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["createdAt"].stringValue, isDate: true)
                        localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["createdAt"].stringValue, isDate: false)                        
                    }
                    
                    break
                    
                default:
                    userName.text = feed["postCreator"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["postCreator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                }
            }
            
            else if pageType == viewType.VIEW_TYPE_OTG {
                userName.text = feed["postCreator"]["name"].stringValue
                profilePic.hnk_setImageFromURL(getImageURL(feed["postCreator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["UTCModified"].stringValue, isDate: true)
                localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["UTCModified"].stringValue, isDate: false)
            }
            
            else if pageType == viewType.VIEW_TYPE_MY_LIFE {
                
                switch feed["type"].stringValue {
                case "on-the-go-journey":
                    fallthrough
                case "ended-journey":
                    userName.text = feed["user"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["user"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["startTime"].stringValue, isDate: true)
                    localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["startTime"].stringValue, isDate: false)
                    break
                    
                    
                case "quick-itinerary":
                    fallthrough
                case "detail-itinerary":
                    userName.text = feed["creator"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["creator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["startTime"].stringValue, isDate: true)
                    localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["startTime"].stringValue, isDate: false)
                    break
                    
                default:
                    userName.text = feed["postCreator"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["postCreator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["UTCModified"].stringValue, isDate: true)
                    localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["UTCModified"].stringValue, isDate: false)
                }
            }
            
            else if pageType == viewType.VIEW_TYPE_LOCAL_LIFE {
                
                switch feed["type"].stringValue {
                case "on-the-go-journey":
                    fallthrough
                case "ended-journey":
                    userName.text = feed["user"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["user"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["UTCModified"].stringValue, isDate: true)
                    localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["UTCModified"].stringValue, isDate: false)
                    break
                    
                    
                case "quick-itinerary":
                    fallthrough
                case "detail-itinerary":
                    userName.text = feed["creator"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["creator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["UTCModified"].stringValue, isDate: true)
                    localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["UTCModified"].stringValue, isDate: false)
                    break
                    
                default:
                    userName.text = feed["postCreator"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["postCreator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["UTCModified"].stringValue, isDate: true)
                    localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["UTCModified"].stringValue, isDate: false)
                }
                
            }
            
            else if pageType == viewType.VIEW_TYPE_POPULAR_JOURNEY ||
                pageType == viewType.VIEW_TYPE_POPULAR_ITINERARY {
                
                localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["startTime"].stringValue, isDate: true)
                localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["startTime"].stringValue, isDate: false)
                
                switch feed["type"].stringValue {
                case "on-the-go-journey":
                    fallthrough
                case "ended-journey":
                    userName.text = feed["user"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["user"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    break
                    
                    
                case "quick-itinerary":
                    fallthrough
                case "detail-itinerary":
                    userName.text = feed["creator"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["creator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    break
                    
                default:
                    userName.text = feed["postCreator"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["postCreator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                }
            }
            
            else if pageType == viewType.VIEW_TYPE_SHOW_SINGLE_POST {
                
                localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["UTCModified"].stringValue, isDate: true)
                localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["UTCModified"].stringValue, isDate: false)
                
                switch feed["type"].stringValue {
                case "on-the-go-journey":
                    fallthrough
                case "ended-journey":
                    userName.text = feed["user"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["user"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["startTime"].stringValue, isDate: true)
                    localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["startTime"].stringValue, isDate: false)                    
                    break
                    
                    
                case "quick-itinerary":
                    fallthrough
                case "detail-itinerary":
                    userName.text = feed["creator"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["creator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                    
                    if feed["timestamp"].stringValue == "" {
                        localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["createdAt"].stringValue, isDate: true)
                        localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["createdAt"].stringValue, isDate: false)                        
                    }
                    
                    break
                    
                default:
                    userName.text = feed["postCreator"]["name"].stringValue
                    profilePic.hnk_setImageFromURL(getImageURL(feed["postCreator"]["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
                }
            } 
            
        }
    }
    
    func fillProfileHeaderLocalFeed(feed:JSON, pageType: viewType?, cellType: feedCellType?) {
        
        self.followButton.isHidden = true
        
        userName.text = currentUser["name"].stringValue
        profilePic.hnk_setImageFromURL(getImageURL(currentUser["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
        
        if feed["date"].stringValue != "" {
            localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: feed["date"].stringValue, isDate: true)
            localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["date"].stringValue, isDate: false)
        }
        else {
            if feed["type"].stringValue == "quick-itinerary" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
                let showDate = dateFormatter.string(from: Date())
                
                localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: showDate, isDate: true)
                localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: showDate, isDate: false)                
            }
            else {
                localDate.text = ""
                localTime.text = ""
            }
        }
    }
    
    func fillProfileHeaderForLocalPost(post: Post) {
        
        self.followButton.isHidden = true
        
        userName.text = currentUser["name"].stringValue
        profilePic.hnk_setImageFromURL(getImageURL(currentUser["profilePicture"].stringValue, width: SMALL_PHOTO_WIDTH))
        
        if post.post_date != "" {
            localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: post.post_date, isDate: true)
            localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: post.post_date, isDate: false)
        }
        else {
            localDate.text = ""
            localTime.text = ""
        }
    }
    
    private func removePreviousGesture() {
        for recognizer in self.gestureRecognizers ?? [] {
            self.removeGestureRecognizer(recognizer)
        }
    }
    
    @IBAction func followClick(_ sender: UIButton) {
        
        if currentUser != nil {
            if followButton.titleLabel?.text == "Follow" {
                request.followUser(currentUser["_id"].string!, followUserId: currentFeed["user"]["_id"].stringValue, completion: {(response) in
                    
                    DispatchQueue.main.async(execute: {
                        
                        if response.error != nil {
                            
                            print("error: \(response.error!.localizedDescription)")
                            
                        }
                        else if response["value"].bool! {
                            
                            print("response arrived!")
                            setFollowButtonTitle(button: self.followButton, followType: response["data"]["responseValue"].intValue, otherUserID: "")
                        }
                        else {
                            
                            print("error: \(response["error"])")
                            
                        }
                    })
                })
            }
            else if followButton.titleLabel?.text == "Following" {
                request.unfollow(currentUser["_id"].string!, unFollowId: currentFeed["user"]["_id"].stringValue, completion: {(response) in
                    DispatchQueue.main.async(execute: {
                        if response.error != nil {
                            
                            print("error: \(response.error!.localizedDescription)")
                            
                        }
                        else if response["value"].bool! {
                            
                            print("response arrived!")
                            setFollowButtonTitle(button: self.followButton, followType: response["data"]["responseValue"].intValue, otherUserID: "")
                            
                        }
                        else {
                            
                            print("error: \(response["error"])")
                            
                        }
                    })
                })
            }
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }

    func handleProfileTap(_ sender: AnyObject) {
        
        if currentUser != nil {
            selectedUser = currentFeed["user"]
            let profile = storyboard?.instantiateViewController(withIdentifier: "TLProfileView") as! TLProfileViewController
            profile.displayData = "search"
            profile.currentSelectedUser = selectedUser
            parentController.navigationController?.pushViewController(profile, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
}
