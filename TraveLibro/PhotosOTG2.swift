//
//  OnlyPhoto.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 18/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PhotosOTG2: VerticalLayout {
    var postTop:Post!
    var header:PhotosOTGHeader!
    
    func generatePost(_ post:Post) {
        //header generation only
        header = PhotosOTGHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 120 ))
        self.addSubview(header)
        self.layoutSubviews()
        self.postTop = post;
        post.getThought()
        header.photosTitle.text = post.finalThought
        post.getTypeOfPost()
        
        header.postDp.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!)
        header.makeTLProfilePicture(header.postDp)
        
        header.dateLabel.text = post.post_dateDay
        header.timeLabel.text = post.post_dateTime
        
        if((post.typeOfPost) != nil) {
            switch(post.typeOfPost) {
            case "Location":
                header.whatPostIcon.setImage(UIImage(named: "location_icon"), for: .normal)
            case "Image":
                header.whatPostIcon.setImage(UIImage(named: "camera_icon"), for: .normal)
            case "Videos":
                header.whatPostIcon.setImage(UIImage(named: "video"), for: .normal)
            case "Thoughts":
                header.whatPostIcon.setImage(UIImage(named: "pen_icon"), for: .normal)
            default:
                break
            }
        }
    }
    
    //    func generatePost(_ post: Post) {
    //        self.postTop = post;
    //        post.getThought()
    //        self.photosTitle.text = post.finalThought
    //
    //        if(!post.post_isOffline) {
    //            self.UploadToCloud.alpha = 0
    //            self.UploadingToCloudLabel.alpha = 0
    //        }
    //
    //        headerView.frame.size = CGSize(width: screenWidth, height: 75)
    //        if(post.post_likeCount != nil) {
    //            if(post.post_likeCount == 0) {
    //                self.likeViewLabel.text = "Be first to Like"
    //            } else if(post.post_likeCount == 1) {
    //                self.likeViewLabel.text = "1 Like"
    //            } else if(post.post_likeCount > 1) {
    //                let counts = String(post.post_likeCount)
    //                self.likeViewLabel.text = "\(counts) Likes"
    //            }
    //        }
    //
    //        if(post.post_commentCount != nil) {
    //            if(post.post_commentCount == 0) {
    //                self.commentCount.text = "Be first to Comment"
    //            } else if(post.post_commentCount == 1) {
    //                self.commentCount.text = "1 Comment"
    //            } else if(post.post_commentCount > 1) {
    //                let counts = String(post.post_commentCount)
    //                self.commentCount.text = "\(counts) Comments"
    //            }
    //        }
    //
    //        self.dateLabel.text = post.post_dateDay
    //        self.timeLabel.text = post.post_dateTime
    //
    //        if(post.imageArr.count > 0) {
    //            self.isImage = true;
    //            self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
    //
    //
    //            if(post.post_isOffline) {
    //                self.mainPhoto.image = post.imageArr[0].image
    //            } else {
    //                self.mainPhoto.hnk_setImageFromURL(post.imageArr[0].imageUrl)
    //                mainPhoto.isUserInteractionEnabled = true
    //                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PhotosOTG.openSinglePhoto(_:)))
    //                mainPhoto.addGestureRecognizer(tapGestureRecognizer)
    //                mainPhoto.tag = 0
    //            }
    //
    //            updateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PhotosOTG.callFunction), userInfo: nil, repeats: true)
    //            if(post.imageArr.count > 1) {
    //                self.addPhotoToLayout(post)
    //                isMoreImage = true;
    //            }
    //        } else {
    //            if(post.post_locationImage != nil) {
    //                self.isImage = true;
    //                self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
    //                print(post.post_locationImage)
    //                self.mainPhoto.hnk_setImageFromURL(URL(string:post.post_locationImage)!)
    //                updateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PhotosOTG.callFunction), userInfo: nil, repeats: true)
    //            } else {
    //                self.setHeight(0)
    //            }
    //        }
    //
    //        post.getTypeOfPost()
    //
    //        if((post.typeOfPost) != nil) {
    //            switch(post.typeOfPost) {
    //            case "Location":
    //                self.whatPostIcon.setImage(UIImage(named: "location_icon"), for: .normal)
    //            case "Image":
    //                self.whatPostIcon.setImage(UIImage(named: "camera_icon"), for: .normal)
    //            case "Videos":
    //                self.whatPostIcon.setImage(UIImage(named: "video"), for: .normal)
    //            case "Thoughts":
    //                self.whatPostIcon.setImage(UIImage(named: "pen_icon"), for: .normal)
    //            default:
    //                break
    //            }
    //        }
    //    }
}
