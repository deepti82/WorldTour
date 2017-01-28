//
//  ActivityFeedsLayout.swift
//  TraveLibro
//
//  Created by Jagruti  on 19/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import Player
import Spring

class ActivityFeedsLayout: VerticalLayout, PlayerDelegate {
    
    
    //    var feed: JSON!
    var blackBg: UIView!
    var profileHeader: ActivityProfileHeader!
    var textHeader: ActivityTextHeader!
    var activityFeed: ActivityFeedsController!
    var textTag: ActivityHeaderTag!
    var mainPhoto:UIImageView!
    var videoContainer:VideoView!
    var player:Player!
    var centerView:PhotosOTGView!
    var footerView: ActivityFeedFooterBasic!
    var footerViewReview: ActivityFeedFooter!
    var activityFeedImage: ActivityFeedImageView!
    var activityDetailItinerary: ActivityDetailItinerary!
    var activityQuickItinerary: ActivityFeedQuickItinerary!
    var feeds: JSON = []
    
    var scrollView:UIScrollView!
    
    let imageArr: [String] = ["restaurantsandbars", "leaftrans", "sightstrans", "museumstrans", "zootrans", "shopping", "religious", "cinematrans", "hotels", "planetrans", "health_beauty", "rentals", "entertainment", "essential", "emergency", "othersdottrans"]
    
    func createProfileHeader(feed:JSON) {
        
        headerLayout(feed: feed)
        
//        videosAndPhotosLayout(feed: feed)
        
        middleLayoout(feed:feed)
        
        footerLayout(feed:feed)
        
        self.layoutSubviews()
    }
    
    func videosAndPhotosLayout(feed:JSON) {
        self.feeds = feed
        //Image generation only
        if(feed["videos"].count > 0) {
            self.videoContainer = VideoView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
            
            self.videoContainer.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.openSingleVideo(_:)))
            self.videoContainer.addGestureRecognizer(tapGestureRecognizer)
            self.videoContainer.tag = 0
            
            self.player = Player()
            self.player.delegate = self
            self.player.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
            self.player.view.clipsToBounds = true
            self.player.playbackLoops = true
            self.player.muted = true
            self.player.fillMode = "AVLayerVideoGravityResizeAspectFill"
            self.videoContainer.player = self.player
            var videoUrl:URL!
            if feed["type"].stringValue == "travel-life" {
                videoContainer.tagText.text = "On The Go"
                videoContainer.tagView.backgroundColor = mainOrangeColor
            }else{
                videoContainer.tagText.text = "Local Life"
                videoContainer.tagView.backgroundColor = endJourneyColor
            }
            videoUrl = URL(string:feed["videos"][0]["name"].stringValue)
            self.player.setUrl(videoUrl!)
            self.videoContainer.videoHolder.addSubview(self.player.view)
            self.addSubview(self.videoContainer)
            
        } else if(feed["photos"].count > 0) {
            self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
            self.addSubview(self.mainPhoto)
            self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
            self.mainPhoto.clipsToBounds = true
            self.mainPhoto.image = UIImage(named: "logo-default")
            
            let headerTag = ActivityHeaderTag(frame: CGRect(x: 0, y: 30, width: screenWidth, height: 30))
            headerTag.tagParent.backgroundColor = UIColor.clear
            headerTag.colorTag(feed: feed)
            headerTag.tagLine.isHidden = true
            
            self.mainPhoto.addSubview(headerTag)
            
            
            self.addSubview(mainPhoto)
            let heightForBlur = 10;
            var thumbStr = "";
            let imgStr = getImageURL(feed["photos"][0]["name"].stringValue, width: 300)
            
            cache.fetch(URL: imgStr).onSuccess({ (data) in
                self.mainPhoto.image = UIImage(data: data as Data)
                
                let image = self.mainPhoto.image
                
                let widthInPixels =  image?.cgImage?.width
                let heightInPixels =  image?.cgImage?.height
                
                if((heightInPixels) != nil) {
                    let finalHeight =  CGFloat(heightInPixels!) / CGFloat(widthInPixels!) * self.frame.width;
                    
                    
                    let maxheight = screenHeight - ( 60 + 113 )
                    if(finalHeight > maxheight) {
                        self.mainPhoto.frame.size.height = maxheight
                    } else {
                        self.mainPhoto.frame.size.height = finalHeight
                    }
                }
                
                self.mainPhoto.frame.size.width = self.frame.width
                self.mainPhoto.hnk_setImageFromURL(imgStr)
                self.mainPhoto.isUserInteractionEnabled = true
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PhotosOTG2.openSinglePhoto(_:)))
                self.mainPhoto.addGestureRecognizer(tapGestureRecognizer)
                self.mainPhoto.tag = 0
                
                self.layoutSubviews()
                self.activityFeed.addHeightToLayout()
                
            })
        }else{
            if feed["imageUrl"] != nil {
            self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
            self.addSubview(self.mainPhoto)
                
            self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
            self.mainPhoto.clipsToBounds = true
           
            
                if feed["thoughts"] == nil || feed["thoughts"].stringValue == "" {
                    let headerTag = ActivityHeaderTag(frame: CGRect(x: 0, y: 30, width: screenWidth, height: 28))
                    headerTag.tagParent.backgroundColor = UIColor.clear
                    headerTag.tagLine.isHidden = true
                    headerTag.colorTag(feed: feed)
                    
                    self.mainPhoto.addSubview(headerTag)

                }
                
            
                mainPhoto.hnk_setImageFromURL(URL(string: feed["imageUrl"].stringValue)!)

            }
        }
        
        
        //End of Image
        var showImageIndexStart = 1
        if(feed["videos"].count > 0) {
            showImageIndexStart = 0
        }
        //Center Generation Only
        if(feed["photos"].count > showImageIndexStart) {
            centerView = PhotosOTGView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 91 ))
            addPhotoToLayout(feed,startIndex:showImageIndexStart)
            self.addSubview(centerView)
//            centerView.centerLineView.isHidden = true
        }
        //End of Center
    }
    
    func openSingleVideo(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.mainImage?.image = sender.image
        singlePhotoController.index = sender.view.tag
        singlePhotoController.type = "Video"
        singlePhotoController.postId = feeds["_id"].stringValue
        globalNavigationController.present(singlePhotoController, animated: true, completion: nil)
    }

    
    func footerLayout(feed:JSON) {
        if(feed["type"].stringValue == "ended-journey" || feed["type"].stringValue == "quick-itinerary" || feed["type"].stringValue == "detail-itinerary" || feed["type"].stringValue == "on-the-go-journey") {
            print("in review")
            footerViewReview = ActivityFeedFooter(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 65))
            footerViewReview.postTop = feed
            footerViewReview.topLayout = self
            footerViewReview.type = "ActivityFeeds"
            footerViewReview.setCommentCount(footerViewReview.postTop["commentCount"].intValue)
            footerViewReview.setLikeCount(footerViewReview.postTop["likeCount"].intValue)
            footerViewReview.setReviewCount(count: footerViewReview.postTop["userReviewCount"].intValue)
            //footerViewReview.reviewButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ActivityFeedsLayout.rateButtonTapped(_:))))
            self.addSubview(footerViewReview)
        } else {
            print("in footer")
            footerView = ActivityFeedFooterBasic(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 65))
            footerView.postTop = feed
            footerView.topLayout = self
            footerView.type = "ActivityFeeds"
            
            footerView.setCommentCount(footerView.postTop["commentCount"].intValue)
            footerView.setLikeCount(footerView.postTop["likeCount"].intValue)
            
            footerView.setView(feed:feed)
            self.addSubview(footerView)
        }
        

    }
    
    func middleLayoout(feed:JSON) {
        switch feed["type"].stringValue {
        case "on-the-go-journey","ended-journey":
            activityFeedImage = ActivityFeedImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 572))
            activityFeedImage.fillData(feed: feed)
            activityFeedImage.clipsToBounds = true
            
            self.addSubview(activityFeedImage)
        case "quick-itinerary":
            activityQuickItinerary = ActivityFeedQuickItinerary(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 590))
            activityQuickItinerary.fillData(feed: feed)
            self.addSubview(activityQuickItinerary)
        case "detail-itinerary":
            activityDetailItinerary = ActivityDetailItinerary(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 528))
            activityDetailItinerary.fillData(feed: feed)
            self.addSubview(activityDetailItinerary)
        default:
            print("default")
            videosAndPhotosLayout(feed:feed)
        }
    }
    
    func headerLayout(feed:JSON) {
        
        profileHeader = ActivityProfileHeader(frame: CGRect(x: 0, y: 20, width: self.frame.width, height: 76))
        
        profileHeader.fillProfileHeader(feed:feed)
        
        
        
        self.addSubview(profileHeader)
        
        if feed["thoughts"].stringValue != "" {
            
            //  START ACTIVITY TEXT HEADER
            textHeader = ActivityTextHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0))
            textHeader.headerText.text = feed["thoughts"].stringValue
            textHeader.headerText.sizeToFit()
            textHeader.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: textHeader.headerText.frame.height + 1.5)
            self.addSubview(textHeader)
            
            //  START ACTIVITY TEXT TAG
            if feed["videos"].count == 0 && feed["photos"].count == 0 && feed["type"].stringValue != "on-the-go-journey" {
                textTag = ActivityHeaderTag(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
                textTag.transparentBack()
                textTag.colorTag(feed: feed)
                
                self.addSubview(textTag)
            }

        }else{
            textHeader = ActivityTextHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 70))
            
            switch feed["type"].stringValue {
            case "on-the-go-journey":
                setText(text: "Has started his " + feed["startLocation"].stringValue + " journey.")
                
            case "ended-journey":
                setText(text: "Has ended his " + feed["startLocation"].stringValue + " journey.")

            case "quick-itinerary":
                setText(text: "Has uploaded a new Itinerary.")

            case "detail-itinerary":
                setText(text: "Has uploaded a new Itinerary.")

            default:
                textHeader.headerText.text = ""
            }
            textHeader.headerText.sizeToFit()
            textHeader.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: textHeader.headerText.frame.height + 1.5)
            textHeader.sizeToFit()
        
        }
        
    }
    func setText(text: String) {
        textHeader.headerText.text = text
        self.addSubview(textHeader)
    }
    
    func addPhotoToLayout(_ post: JSON, startIndex: Int) {
        centerView.horizontalScrollForPhotos.removeAll()
        for i in startIndex ..< post["photos"].count {
            let photosButton = UIImageView(frame: CGRect(x: 10, y: 5, width: 87, height: 87))
            photosButton.image = UIImage(named: "logo-default")
            photosButton.contentMode = UIViewContentMode.scaleAspectFill
            
            photosButton.frame.size.height = 82
            photosButton.frame.size.width = 82
            let urlStr = getImageURL(post["photos"][i]["name"].stringValue, width: 300)
            photosButton.hnk_setImageFromURL(urlStr)
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(ActivityFeedsLayout.openSinglePhoto(_:)))
            photosButton.isUserInteractionEnabled = true
            photosButton.addGestureRecognizer(tapGestureRecognizer)
            //photosButton.layer.cornerRadius = 5.0
            photosButton.tag = i
            photosButton.clipsToBounds = true
            centerView.horizontalScrollForPhotos.addSubview(photosButton)
        }
        centerView.horizontalScrollForPhotos.layoutSubviews()
        centerView.morePhotosView.contentSize = CGSize(width: centerView.horizontalScrollForPhotos.frame.width, height: centerView.horizontalScrollForPhotos.frame.height)
    }
    
    func openSinglePhoto(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.mainImage?.image = sender.image
        singlePhotoController.index = sender.view.tag
        singlePhotoController.postId = feeds["_id"].stringValue
        globalNavigationController.present(singlePhotoController, animated: true, completion: nil)
    }
    
    func videoToPlay ()  {
        let min = self.frame.origin.y + self.videoContainer.frame.origin.y
        let max = min + self.videoContainer.frame.size.height
        let scrollMin = self.scrollView.contentOffset.y
        let scrollMax = scrollMin + self.scrollView.frame.height
        if(scrollMin < min && scrollMax > max ) {
            self.player.playFromCurrentTime()
        }
        else {
            self.player.pause()
        }
    }
    
    func playerReady(_ player: Player) {
        videoToPlay()
    }
    
    func rateButtonTapped(_ sender: AnyObject) {
        
        print("review clickedd")
        
        blackBg = UIView(frame: CGRect(x: 0, y: 0, width: activityFeed.view.frame.width, height: activityFeed.view.frame.height))
        blackBg.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        activityFeed.view.addSubview(blackBg)
        
        let closeButton = UIButton(frame: CGRect(x: 8, y: 20, width: 20, height: 20))
        let close = String(format: "%C", faicon["close"]!)
        
        closeButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
        closeButton.setTitle(close, for: UIControlState())
        closeButton.addTarget(self, action: #selector(ActivityFeedsLayout.exitDialog(_:)), for: .touchUpInside)
        blackBg.addSubview(closeButton)
        
        let ratingDialog = AddRating(frame: CGRect(x: 0, y: 0, width: activityFeed.view.frame.width - 40, height: 400))
        ratingDialog.center = CGPoint(x: activityFeed.view.frame.width/2, y: activityFeed.view.frame.height/2)
        
        ratingDialog.postReview.addTarget(self, action: #selector(ActivityFeedsLayout.closeDialog(_:)), for: .touchUpInside)
        blackBg.addSubview(ratingDialog)
        
    }
    func closeDialog(_ sender: AnyObject) {
        
        blackBg.isHidden = true
//        checkInPost.rateButton.isHidden = true
//        checkInPost.ratingLabel.isHidden = false
//        checkInPost.ratingStack.isHidden = false
        
    }
    
    func exitDialog(_ sender: AnyObject) {
        
        blackBg.isHidden = true
//        checkInPost.rateButton.isHidden = true
//        checkInPost.ratingLabel.isHidden = false
//        checkInPost.ratingStack.isHidden = false
        
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
    
    func getCategoryImage(name: String) -> String {
        var str:String! = ""
        for img in imageArr {
            if img.contains(String(name.characters.suffix(4))) {
                str = img
            }
        }
        return str
        
    }
    
    
}
