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
    var profileHeader: ActivityProfileHeader!
    var textHeader: ActivityTextHeader!
    var activityFeed: ActivityFeedsController!
    var textTag: ActivityHeaderTag!
    var mainPhoto:UIImageView!
    var videoContainer:VideoView!
    var player:Player!
    var centerView:PhotosOTGView!
    var footerView: PhotoOTGFooter!
    var activityFeedImage: ActivityFeedImageView!
    var activityDetailItinerary: ActivityDetailItinerary!
    var activityQuickItinerary: ActivityFeedQuickItinerary!
    
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
        //Image generation only
        if(feed["videos"].count > 0) {
            self.videoContainer = VideoView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
            self.player = Player()
            self.player.delegate = self
            self.player.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
            self.player.view.clipsToBounds = true
            self.player.playbackLoops = true
            self.player.muted = true
            self.player.fillMode = "AVLayerVideoGravityResizeAspectFill"
            self.videoContainer.player = self.player
            var videoUrl:URL!
            
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
                
            })
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
        }
        //End of Center
    }
    
    func footerLayout(feed:JSON) {
        
        footerView = PhotoOTGFooter(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 65))
        self.addSubview(footerView)

    }
    
    func middleLayoout(feed:JSON) {
        switch feed["type"].stringValue {
        case "on-the-go-journey","ended-journey":
            activityFeedImage = ActivityFeedImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 572))
            activityFeedImage.fillData(feed: feed)
            activityFeedImage.clipsToBounds = true
            
            self.addSubview(activityFeedImage)
        case "quick-itinerary":
            activityQuickItinerary = ActivityFeedQuickItinerary(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 572))
            activityQuickItinerary.fillData(feed: feed)
            self.addSubview(activityQuickItinerary)
        case "detail-itinerary":
            activityDetailItinerary = ActivityDetailItinerary(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 572))
            activityDetailItinerary.fillData(feed: feed)
            self.addSubview(activityDetailItinerary)
        default:
            print("default")
            videosAndPhotosLayout(feed:feed)
        }
    }
    
    func headerLayout(feed:JSON) {
        
        profileHeader = ActivityProfileHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 85))
        
        profileHeader.fillProfileHeader(feed:feed)
        
        
        
        self.addSubview(profileHeader)
        if feed["type"].stringValue == "on-the-go-journey" || feed["type"].stringValue == "ended-journey" {
            
            textHeader = ActivityTextHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 70))
            
            if feed["type"].stringValue == "on-the-go-journey" {
                textHeader.headerText.text = "Has started his " + feed["startLocation"].stringValue + " journey."
            }else{
                textHeader.headerText.text = "Has ended his " + feed["startLocation"].stringValue + " journey."
            }
            
            
            textHeader.sizeToFit()
            self.addSubview(textHeader)
            
        } else if feed["thoughts"].stringValue != "" {
            
            //  START ACTIVITY TEXT HEADER
            textHeader = ActivityTextHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 70))
            textHeader.headerText.text = feed["thoughts"].stringValue
            textHeader.sizeToFit()
            self.addSubview(textHeader)
            
            //  START ACTIVITY TEXT TAG
            if feed["videos"].count == 0 && feed["photos"].count == 0 && feed["type"].stringValue != "on-the-go-journey" {
                textTag = ActivityHeaderTag(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 30))
                if feed["type"].stringValue == "travel-life" {
                    textTag.tagText.text = "On The Go"
                    textTag.tagView.backgroundColor = mainOrangeColor
                }else{
                    textTag.tagText.text = "Local Life"
                    textTag.tagView.backgroundColor = endJourneyColor
                }
                self.addSubview(textTag)
            }

        }
        
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
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(PhotosOTG2.openSinglePhoto(_:)))
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
            print(img)
            print(String(name.characters.suffix(4)))
            if img.contains(String(name.characters.suffix(4))) {
                str = img
            }
        }
        return str
        
    }
    
    
}
