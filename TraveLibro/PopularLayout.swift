//
//  PopularLayout.swift
//  TraveLibro
//
//  Created by Jagruti  on 18/03/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import Player
import Spring

class PopularLayout: VerticalLayout, PlayerDelegate, TLFooterDelegate {
    
    
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
    var dropView: DropShadow2!
    var footerViewReview: ActivityFeedFooter!
    var activityFeedImage: ActivityFeedImageView!
    var activityDetailItinerary: ActivityDetailItinerary!
    var activityQuickItinerary: ActivityFeedQuickItinerary!
    var popularItinerary: PopularItinerary!
    var popular: PopularController!
    var feeds: JSON = []
    var displayData: String = ""
    
    var scrollView:UIScrollView!
    
    let imageArr: [String] = ["restaurantsandbars", "leaftrans", "sightstrans", "museumstrans", "zootrans", "shopping", "religious", "cinematrans", "hotels", "planetrans", "health_beauty", "rentals", "entertainment", "essential", "emergency", "othersdottrans"]
    
    func createProfileHeader(feed:JSON) {
        
        if displayData != "popitinerary" {
            headerLayout(feed: feed)
        }
        
        
        
        middleLayoout(feed:feed)
        
        if !feed["offline"].boolValue {
            footerLayout(feed:feed)
        }
        
        
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
                videoContainer.tagText.text = "Travel Life"
                videoContainer.tagView.backgroundColor = mainOrangeColor
            }else{
                videoContainer.tagText.text = "  Local Life"
                videoContainer.tagText.textColor = UIColor(hex: "#303557")
                videoContainer.tagView.backgroundColor = endJourneyColor
                //                profileHeader.category.imageView?.tintColor = UIColor(hex: "#303557")
            }
            videoUrl = URL(string:feed["videos"][0]["name"].stringValue)
            if(videoUrl == nil) {
                videoUrl = URL(string:feed["videos"][0]["localUrl"].stringValue)
            }
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
            self.mainPhoto.addSubview(headerTag)
            //            if headerTag.tagText.text == "Travel Life"{
            //                profileHeader.category.imageView?.tintColor = UIColor.white
            //            } else {
            //                profileHeader.category.imageView?.tintColor = UIColor(hex: "#303557")
            //            }
            
            
            
            self.addSubview(mainPhoto)
            
            let imgStr = getImageURL(feed["photos"][0]["name"].stringValue, width: BIG_PHOTO_WIDTH)
            
            cache.fetch(URL: imgStr).onSuccess({ (data) in
                self.mainPhoto.image = UIImage(data: data as Data)
                
                let image = self.mainPhoto.image
                
                let widthInPixels =  image?.cgImage?.width
                let heightInPixels =  image?.cgImage?.height
                
                if((heightInPixels) != nil) {
                    let finalHeight =  CGFloat(heightInPixels!) / CGFloat(widthInPixels!) * self.frame.width;
                    
                    
                    let maxheight = screenHeight - ( 60 + 113 )
                    //                    if(finalHeight > maxheight) {
                    //                        self.mainPhoto.frame.size.height = maxheight
                    //                    } else {
                    //                        self.mainPhoto.frame.size.height = finalHeight
                    //                    }
                }
                
                self.mainPhoto.frame.size.width = self.frame.width
                if feed["photos"][0]["name"].stringValue == "" {
                    self.mainPhoto.image = UIImage(named: "logo-default")
                }else{
                    self.mainPhoto.hnk_setImageFromURL(imgStr)
                }
                self.mainPhoto.isUserInteractionEnabled = true
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PhotosOTG2.openSinglePhoto(_:)))
                self.mainPhoto.addGestureRecognizer(tapGestureRecognizer)
                self.mainPhoto.tag = 0
                
                self.layoutSubviews()
                if(self.activityFeed != nil) {
                    self.activityFeed.addHeightToLayout()
                }
                
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
                    headerTag.colorTag(feed: feed)
                    
                    self.mainPhoto.addSubview(headerTag)
                    //                    if headerTag.tagText.text == "Travel Life"{
                    //                        profileHeader.category.imageView?.tintColor = UIColor.white
                    //                    } else {
                    //                        profileHeader.category.imageView?.tintColor = UIColor(hex: "#303557")
                    //                    }
                    
                    
                    
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
        //        singlePhotoController.mainImage?.image = sender.image
        singlePhotoController.index = sender.view.tag
        singlePhotoController.type = "Video"
        singlePhotoController.postId = feeds["_id"].stringValue
        globalNavigationController.pushViewController(singlePhotoController, animated: true)
    }
    
    
    func footerLayout(feed:JSON) {
        print("in footer")
        footerView = ActivityFeedFooterBasic(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 65))
        footerView.topLayout = self
        footerView.type = "popular"
        footerView.footerType = feed["type"].stringValue        
        footerView.setCommentCount(feed["commentCount"].intValue)
        footerView.setLikeCount(feed["likeCount"].intValue)
        footerView.fillFeedFooter(feed: feed, pageType: viewType.VIEW_TYPE_POPULAR_JOURNEY, delegate: self)
        footerView.setLikeSelected(feed["likeDone"].boolValue)

        self.addSubview(footerView)
        
    }
    
    func middleLayoout(feed:JSON) {
        switch feed["type"].stringValue {
        case "on-the-go-journey","ended-journey":
            activityFeedImage = ActivityFeedImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
            activityFeedImage.fillData(feed: feed)
            let tapRecognizer = UITapGestureRecognizer()
            tapRecognizer.numberOfTapsRequired = 1
            activityFeedImage.headerTagTextLabel.isHidden = true
            tapRecognizer.addTarget(self, action: #selector(self.toggleFullscreen))
            activityFeedImage.addGestureRecognizer(tapRecognizer)
            
            activityFeedImage.clipsToBounds = true
            
            self.addSubview(activityFeedImage)
        case "quick-itinerary":
            if self.displayData == "popitinerary" {
                popularItinerary = PopularItinerary(frame: CGRect(x: 0, y: 10, width: self.frame.width, height: 400))
                let tapRecognizer = UITapGestureRecognizer()
                tapRecognizer.numberOfTapsRequired = 1
                tapRecognizer.addTarget(self, action: #selector(self.gotoDetail))
                popularItinerary.addGestureRecognizer(tapRecognizer)
                popularItinerary.fillData(feed: feed)
                self.addSubview(popularItinerary)
            }else{
                activityQuickItinerary = ActivityFeedQuickItinerary(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
                let tapRecognizer = UITapGestureRecognizer()
                tapRecognizer.numberOfTapsRequired = 1
                tapRecognizer.addTarget(self, action: #selector(self.gotoDetail))
                activityQuickItinerary.addGestureRecognizer(tapRecognizer)
                activityQuickItinerary.fillData(feed: feed)
                self.addSubview(activityQuickItinerary)
            }
            
        case "detail-itinerary":
            if self.displayData == "popitinerary" {
                popularItinerary = PopularItinerary(frame: CGRect(x: 0, y: 10, width: self.frame.width, height: 400))
                let tapRecognizer = UITapGestureRecognizer()
                tapRecognizer.numberOfTapsRequired = 1
                tapRecognizer.addTarget(self, action: #selector(self.showDetailedItinerary(_:)))
                popularItinerary.addGestureRecognizer(tapRecognizer)
                popularItinerary.fillData(feed: feed)
                self.addSubview(popularItinerary)
                
            }else{
                activityDetailItinerary = ActivityDetailItinerary(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
                activityDetailItinerary.fillData(feed: feed)
                self.addSubview(activityDetailItinerary)
                let tapRecognizer = UITapGestureRecognizer()
                tapRecognizer.numberOfTapsRequired = 1
                tapRecognizer.addTarget(self, action: #selector(self.showDetailedItinerary(_:)))
                activityDetailItinerary.addGestureRecognizer(tapRecognizer)
            }
            
        default:
            print("default")
            videosAndPhotosLayout(feed:feed)
        }
    }
    
    func headerLayout(feed:JSON) {
        
        profileHeader = ActivityProfileHeader(frame: CGRect(x: 0, y: 20, width: self.frame.width, height: 69))
        
        profileHeader.fillProfileHeader(feed:feed, pageType: viewType.VIEW_TYPE_ACTIVITY, cellType: feedCellType.CELL_OTG_TYPE)
        self.addSubview(profileHeader)
        
        if feed["type"].stringValue == "on-the-go-journey"{
            profileHeader.localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["startTime"].stringValue, isDate: true)
            profileHeader.localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["startTime"].stringValue, isDate: false)
        }else if feed["type"].stringValue == "ended-journey"{
            profileHeader.localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["endTime"].stringValue, isDate: true)
            profileHeader.localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["endTime"].stringValue, isDate: false)
        }else if feed["type"].stringValue == "quick-itinerary"{
            profileHeader.localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["startDate"].stringValue, isDate: true)
            profileHeader.localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["startTime"].stringValue, isDate: false)
        }else if feed["type"].stringValue == "detail-itinerary"{
            profileHeader.localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["startDate"].stringValue, isDate: true)
            profileHeader.localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["startTime"].stringValue, isDate: false)
        }else {
            profileHeader.localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["UTCModified"].stringValue, isDate: true)
            profileHeader.localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["UTCModified"].stringValue, isDate: false)
            
        }

        
        if feed["thoughts"].stringValue != "" {
            
            //  START ACTIVITY TEXT HEADER
            textHeader = ActivityTextHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0))
            textHeader.headerText.attributedText = getThought(feed)
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
            
        } else {
            // For header text
            textHeader = ActivityTextHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 70))
            switch feed["type"].stringValue {
            case "on-the-go-journey":
                setText(text: "Has started a Journey.")
                
            case "ended-journey":
                setText(text: "Has ended this Journey.")
                
            case "quick-itinerary":
                setText(text: "Has uploaded a new Itinerary.")
                
            case "detail-itinerary":
                setText(text: "Has uploaded a new Itinerary.")
            default:
                textHeader.headerText.attributedText = getThought(feed)
            }
            textHeader.headerText.sizeToFit()
            textHeader.sizeToFit()
            textHeader.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: textHeader.headerText.frame.height + 1.5)
            if(textHeader.headerText.text != "") {
                self.addSubview(textHeader)
            }
            
            
        }
        
    }
    
    
    //MARK: - GestureRecognizers
    
    func gotoDetail(_ sender: UIButton){
        if currentUser != nil {
            print("in quick itinerary")
            selectedQuickI = self.feeds["_id"].stringValue
            let profile = storyboard.instantiateViewController(withIdentifier: "previewQ") as! QuickItineraryPreviewViewController
            globalNavigationController.pushViewController(profile, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func showDetailedItinerary(_ sender: UIButton) {        
        if currentUser != nil {
            print("detail itinerary clicked \(feeds["_id"].stringValue)")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "EachItineraryViewController") as! EachItineraryViewController
            controller.fromOutSide = feeds["_id"].stringValue
            globalNavigationController?.setNavigationBarHidden(false, animated: false)
            globalNavigationController?.pushViewController(controller, animated: true)
        }
        else {
            if (feeds["itineraryBy"].stringValue.lowercased() != "admin") {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)                
            }
        }
    }
    
    func toggleFullscreen(_ sender: UIButton){
        if currentUser != nil {
            if feeds["type"].stringValue == "on-the-go-journey" || feeds["type"].stringValue == "ended-journey"{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
                controller.fromOutSide = feeds["_id"].stringValue
                controller.fromType = feeds["type"].stringValue
                
                globalPopularController.navigationController!.pushViewController(controller, animated: false)
                
                //            globalNewTLViewController.toolbarView.isHidden = true
                //            globalNewTLViewController.hideVisual.isHidden = true
                //            globalNewTLViewController.hideToolBar.isHidden = true
                
            }else {
                
            }
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    func setText(text: String) {
        textHeader.headerText.text = text
        //        self.addSubview(textHeader)
    }
    
    func addPhotoToLayout(_ post: JSON, startIndex: Int) {
        centerView.horizontalScrollForPhotos.removeAll()
        for i in startIndex ..< post["photos"].count {
            let photosButton = UIImageView(frame: CGRect(x: 10, y: 5, width: 87, height: 87))
            photosButton.image = UIImage(named: "logo-default")
            photosButton.contentMode = UIViewContentMode.scaleAspectFill
            
            photosButton.frame.size.height = 82
            photosButton.frame.size.width = 82
            let urlStr = getImageURL(post["photos"][i]["name"].stringValue, width: BIG_PHOTO_WIDTH)
            photosButton.hnk_setImageFromURL(urlStr)
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(PopularLayout.openSinglePhoto(_:)))
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
        //        singlePhotoController.mainImage?.image = sender.image
        singlePhotoController.index = sender.view.tag
        singlePhotoController.postId = feeds["_id"].stringValue
        globalNavigationController.pushViewController(singlePhotoController, animated: true)
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
        
        blackBg = UIView(frame: CGRect(x: 0, y: 0, width: activityFeed.view.frame.width, height: activityFeed.view.frame.height))
        blackBg.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        activityFeed.view.addSubview(blackBg)
        
        let closeButton = UIButton(frame: CGRect(x: 8, y: 20, width: 20, height: 20))
        let close = String(format: "%C", faicon["close"]!)
        
        closeButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
        closeButton.setTitle(close, for: UIControlState())
        closeButton.addTarget(self, action: #selector(PopularLayout.exitDialog(_:)), for: .touchUpInside)
        blackBg.addSubview(closeButton)
        
        let ratingDialog = AddRating(frame: CGRect(x: 0, y: 0, width: activityFeed.view.frame.width - 40, height: 400))
        ratingDialog.center = CGPoint(x: activityFeed.view.frame.width/2, y: activityFeed.view.frame.height/2)
        
        ratingDialog.postReview.addTarget(self, action: #selector(PopularLayout.closeDialog(_:)), for: .touchUpInside)
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
    
    //Delegate Actions
    func footerOptionButtonClicked(sender: UIButton) {
        print("\n Option button clicked")
    }
    
}
