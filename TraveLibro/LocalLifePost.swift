//
//  OnlyPhoto.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 18/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Player
import Spring

class LocalLifePost: VerticalLayout,PlayerDelegate {
    var postTop:Post!
    var header:PhotosOTGHeader!
    var centerView:PhotosOTGView!
    var footerView:PhotoOTGFooter!
    var mainPhoto:UIImageView!
    var videoContainer:VideoView!
    var uploadingView:UploadingToCloud!
    var newTl:NewTLViewController!
    var player:Player!
    var scrollView:UIScrollView!
    var rateButton:RatingCheckIn!
    
    func generatePost(_ post:JSON) {
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
        //header generation only
        header = PhotosOTGHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 102 ))
        
        self.addSubview(header)
        
        header.postDp.layer.zPosition = 5
        header.calendarLabel.layer.zPosition = 5
        header.clockLabel.layer.zPosition = 5
        header.dateLabel.layer.zPosition = 5
        header.whatPostIcon.layer.zPosition = 5
        header.timeLabel.layer.zPosition = 5
        header.photosTitle.layer.zPosition = 5
        
//        self.postTop = post;
//        post.getThought()
//        header.photosTitle.text = post.finalThought
//        post.getTypeOfPost()
//        
//        if(post.postCreator != nil) {
//            header.postDp.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(post.postCreator["profilePicture"])&width=100")!)
//        }
//        else {
//            header.postDp.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!)
//        }
//        
//        header.makeTLProfilePicture(header.postDp)
//        
//        header.dateLabel.text = post.post_dateDay
//        header.timeLabel.text = post.post_dateTime
//        
//        if((post.typeOfPost) != nil) {
//            switch(post.typeOfPost) {
//            case "Location":
//                header.whatPostIcon.setImage(UIImage(named: "location_icon"), for: .normal)
//            case "Image":
//                header.whatPostIcon.setImage(UIImage(named: "camera_icon"), for: .normal)
//            case "Videos":
//                header.whatPostIcon.setImage(UIImage(named: "video"), for: .normal)
//            case "Thoughts":
//                header.whatPostIcon.setImage(UIImage(named: "pen_icon"), for: .normal)
//            default:
//                break
//            }
//        }
        // End of Header
        
        //Image generation only
//        if(post.videoArr.count > 0) {
//            self.videoContainer = VideoView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
//            self.player = Player()
//            self.player.delegate = self
//            self.player.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
//            self.player.view.clipsToBounds = true
//            self.player.playbackLoops = true
//            self.player.muted = true
//            self.player.fillMode = "AVLayerVideoGravityResizeAspectFill"
//            self.videoContainer.player = self.player
//            var videoUrl:URL!
//            if(!post.post_isOffline) {
//                videoUrl = URL(string: post.videoArr[0].serverUrl)
//            } else {
//                videoUrl = post.videoArr[0].imageUrl
//            }
//            self.player.setUrl(videoUrl!)
//            self.videoContainer.videoHolder.addSubview(self.player.view)
//            self.addSubview(self.videoContainer)
//            
//        } else if(post.imageArr.count > 0) {
//            self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
//            self.addSubview(self.mainPhoto)
//            self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
//            self.mainPhoto.clipsToBounds = true
//            self.mainPhoto.image = UIImage(named: "logo-default")
//            self.addSubview(mainPhoto)
//            let heightForBlur = 10;
//            var thumbStr = "";
//            if(!post.post_isOffline) {
//                thumbStr = "&width=\(heightForBlur)"
//            }
//            let imgStr = post.imageArr[0].imageUrl.absoluteString + thumbStr
//            
//            cache.fetch(URL: URL(string:imgStr)!).onSuccess({ (data) in
//                self.mainPhoto.image = UIImage(data: data as Data)
//                
//                let image = self.mainPhoto.image
//                
//                let widthInPixels =  image?.cgImage?.width
//                let heightInPixels =  image?.cgImage?.height
//                
//                if((heightInPixels) != nil) {
//                    let finalHeight =  CGFloat(heightInPixels!) / CGFloat(widthInPixels!) * self.frame.width;
//                    
//                    
//                    let maxheight = screenHeight - ( 60 + 113 )
//                    if(finalHeight > maxheight) {
//                        self.mainPhoto.frame.size.height = maxheight
//                    } else {
//                        self.mainPhoto.frame.size.height = finalHeight
//                    }
//                }
//                
//                self.mainPhoto.frame.size.width = self.frame.width
//                self.mainPhoto.hnk_setImageFromURL(post.imageArr[0].imageUrl)
//                if(!post.post_isOffline) {
//                    self.mainPhoto.isUserInteractionEnabled = true
//                    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PhotosOTG2.openSinglePhoto(_:)))
//                    self.mainPhoto.addGestureRecognizer(tapGestureRecognizer)
//                    self.mainPhoto.tag = 0
//                }
//                
//                self.layoutSubviews()
//                globalNewTLViewController.addHeightToLayout(height: 50)
//            })
//        } else if(post.post_locationImage != nil && post.post_locationImage != "") {
//            self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
//            self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
//            self.mainPhoto.image = UIImage(named: "logo-default")
//            self.mainPhoto.hnk_setImageFromURL(URL(string:post.post_locationImage)!)
//            self.addSubview(mainPhoto)
//        }
//        
//        //End of Image
//        var showImageIndexStart = 1
//        if(post.videoArr.count > 0) {
//            showImageIndexStart = 0
//        }
//        //Center Generation Only
//        if(post.imageArr.count > showImageIndexStart) {
//            centerView = PhotosOTGView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 91 ))
//            addPhotoToLayout(post,startIndex:showImageIndexStart)
//            self.addSubview(centerView)
//        }
//        //End of Center
//        
//        
//        if(post.post_isOffline) {
//            //Offline Generation Only
//            uploadingView = UploadingToCloud(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 23))
//            self.addSubview(uploadingView)
//            //End of Footer
//        }
//        else {
//            //Footer Generation Only
//            footerView = PhotoOTGFooter(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 65))
//            footerView.postTop = self.postTop;
//            footerView.setLikeCount(post.post_likeCount)
//            footerView.setCommentCount(post.post_commentCount)
//            footerView.setLikeSelected(post.post_likeDone)
//            self.addSubview(footerView)
//            
//                       //End of Footer
//        }
        self.layoutSubviews()
    }
    
    func addPhotoToLayout(_ post: Post, startIndex: Int) {
        centerView.horizontalScrollForPhotos.removeAll()
        for i in startIndex ..< post.imageArr.count {
            let photosButton = UIImageView(frame: CGRect(x: 10, y: 5, width: 87, height: 87))
            photosButton.image = UIImage(named: "logo-default")
            photosButton.contentMode = UIViewContentMode.scaleAspectFill
            if(post.post_isOffline) {
                photosButton.image = post.imageArr[i].image
            } else {
                photosButton.frame.size.height = 82
                photosButton.frame.size.width = 82
                let urlStr = post.imageArr[i].imageUrl.absoluteString + "&width=100"
                photosButton.hnk_setImageFromURL(URL(string:urlStr)!)
                if(!post.post_isOffline) {
                    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(PhotosOTG2.openSinglePhoto(_:)))
                    photosButton.isUserInteractionEnabled = true
                    photosButton.addGestureRecognizer(tapGestureRecognizer)
                }
            }
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
        singlePhotoController.postId = postTop.post_ids
        globalNavigationController.present(singlePhotoController, animated: true, completion: nil)
    }
    
    
    func playerReady(_ player: Player) {
        videoToPlay()
    }
    
    func videoToPlay ()  {
        let min = self.frame.origin.y + self.videoContainer.frame.origin.y
        let max = min + self.videoContainer.frame.size.height
        let scrollMin = scrollView.contentOffset.y
        let scrollMax = scrollMin + scrollView.frame.height
        if(scrollMin < min && scrollMax > max ) {
            self.player.playFromCurrentTime()
        }
        else {
            self.player.pause()
        }
    }
    
}
