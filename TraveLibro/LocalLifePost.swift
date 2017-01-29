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

class LocalLifePost: VerticalLayout, PlayerDelegate {
    
    
    var feed: JSON!
    var profileHeader: ActivityProfileHeader!
    var textHeader: ActivityTextHeader!
    var activityFeed: LocalLifePostsViewController!
    var textTag: ActivityHeaderTag!
    var mainPhoto:UIImageView!
    var videoContainer:VideoView!
    var player:Player!
    var centerView:PhotosOTGView!
    var footerView: ActivityFeedFooterBasic!
    var activityFeedImage: ActivityFeedImageView!
    var activityDetailItinerary: ActivityDetailItinerary!
    var activityQuickItinerary: ActivityFeedQuickItinerary!
    
    var scrollView:UIScrollView!
    
    let imageArr: [String] = ["restaurantsandbars", "leaftrans", "sightstrans", "museumstrans", "zootrans", "shopping", "religious", "cinematrans", "hotels", "planetrans", "health_beauty", "rentals", "entertainment", "essential", "emergency", "othersdottrans"]
    
    func createProfileHeader(feed:JSON) {
        self.feed = feed
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
            self.videoContainer.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LocalLifePost.openSingleVideo(_:)))
            self.videoContainer.addGestureRecognizer(tapGestureRecognizer)
            self.videoContainer.tag = 0
            videoContainer.tagView.isHidden = true
            
            self.player = Player()
            self.player.delegate = self
            self.player.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
            self.player.view.clipsToBounds = true
            self.player.playbackLoops = true
            self.player.muted = true
            self.player.fillMode = "AVLayerVideoGravityResizeAspectFill"
            self.videoContainer.player = self.player
            var videoUrl:URL!
            self.videoContainer.tagText.isHidden = true
            if feed["type"].stringValue == "travel-life" {
                videoContainer.tagText.text = "On The Go"
                videoContainer.tagView.backgroundColor = mainOrangeColor
            }else{
                videoContainer.tagText.text = "Local Life"
                videoContainer.tagText.backgroundColor = UIColor(hex: "303557")
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
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(LocalLifePost.openSinglePhoto(_:)))
                self.mainPhoto.addGestureRecognizer(tapGestureRecognizer)
                self.mainPhoto.tag = 0
                
                self.layoutSubviews()
                if((self.activityFeed) != nil) {
                    self.activityFeed.addHeightToLayout()
                }
                
                
            })
        }else{
            if feed["imageUrl"] != nil {
                self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
                self.addSubview(self.mainPhoto)
                self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
                self.mainPhoto.clipsToBounds = true
                
                
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
        }
        //End of Center
    }
    
    func openSinglePhoto(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.mainImage?.image = sender.image
        singlePhotoController.index = sender.view.tag
        singlePhotoController.postId = feed["_id"].stringValue
        globalNavigationController.present(singlePhotoController, animated: true, completion: nil)
    }
    
    func openSingleVideo(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.mainImage?.image = sender.image
        singlePhotoController.index = sender.view.tag
        singlePhotoController.type = "Video"
        singlePhotoController.postId = feed["_id"].stringValue
        globalNavigationController.present(singlePhotoController, animated: true, completion: nil)
    }
    
    
    func footerLayout(feed:JSON) {
        footerView = ActivityFeedFooterBasic(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 65))
        footerView.postTop = feed
        footerView.topLayout = self
        footerView.type = "LocalLife"
        footerView.setCommentCount(footerView.postTop["commentCount"].intValue)
        footerView.setLikeCount(footerView.postTop["likeCount"].intValue)
        footerView.setView(feed:feed)
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
        
        
        // For header text
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
            textHeader.headerText.text = getThought(feed)
        }
        textHeader.headerText.sizeToFit()
        textHeader.sizeToFit()
        textHeader.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: textHeader.headerText.frame.height + 1.5)
        self.addSubview(textHeader)
        
       
        
    }
    func setText(text: String) {
        textHeader.headerText.text = text
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
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(LocalLifePost.openSinglePhoto(_:)))
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
