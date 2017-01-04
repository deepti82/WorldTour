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
    var centerView:PhotosOTGView!
    var footerView:PhotoOTGFooter!
    var mainPhoto:UIImageView!
    var uploadingView:UploadingToCloud!
    
    func generatePost(_ post:Post) {
        
        //header generation only
        header = PhotosOTGHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 113 ))
        self.addSubview(header)
        self.postTop = post;
        post.getThought()
        header.photosTitle.text = post.finalThought
        post.getTypeOfPost()
        
        if(post.postCreator != nil) {
            header.postDp.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(post.postCreator["profilePicture"])&width=100")!)
        }
        else {
            header.postDp.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])&width=100")!)
        }
        
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
        // End of Header
        
        //Image generation only
        
        if(post.imageArr.count > 0) {
            self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 100))
            self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
            self.mainPhoto.clipsToBounds = true
            let heightForBlur = 10;
            var thumbStr = "";
            if(!post.post_isOffline) {
                thumbStr = "&width=\(heightForBlur)"
            }
            let imgStr = post.imageArr[0].imageUrl.absoluteString + thumbStr
            
            if let url = URL(string: imgStr) {
                if let data = NSData(contentsOf: url) {
                    self.mainPhoto.image = UIImage(data: data as Data)
                    
                    let image = self.mainPhoto.image
                    
                    let widthInPixels =  image?.cgImage?.width
                    let heightInPixels =  image?.cgImage?.height
                    
                    if((heightInPixels) != nil) {
                        self.mainPhoto.frame.size.height = CGFloat(heightInPixels!) / CGFloat(widthInPixels!) * self.frame.width
                    }
                    
                    mainPhoto.frame.size.width = self.frame.width
                    self.mainPhoto.hnk_setImageFromURL(post.imageArr[0].imageUrl)
                    
                    mainPhoto.isUserInteractionEnabled = true
                    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PhotosOTG2.openSinglePhoto(_:)))
                    mainPhoto.addGestureRecognizer(tapGestureRecognizer)
                    mainPhoto.tag = 0
                    
                    self.addSubview(mainPhoto)
                }
            }
        } else if(post.post_locationImage != nil && post.post_locationImage != "") {
            self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
            self.mainPhoto.contentMode = UIViewContentMode.scaleAspectFill
            self.mainPhoto.image = UIImage(named: "logo-default")
            self.mainPhoto.hnk_setImageFromURL(URL(string:post.post_locationImage)!)
            self.addSubview(mainPhoto)
        }
        
        //End of Image
        
        //Center Generation Only
        if(post.imageArr.count > 1) {
            centerView = PhotosOTGView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 60 ))
            addPhotoToLayout(post)
            self.addSubview(centerView)
        }
        //End of Center
        
        
        if(post.post_isOffline) {
            //Offline Generation Only
            uploadingView = UploadingToCloud(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 23))
            self.addSubview(uploadingView)
            //End of Footer
        }
        else {
            //Footer Generation Only
            footerView = PhotoOTGFooter(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 65))
            if(post.post_likeCount != nil) {
                if(post.post_likeCount == 0) {
                    footerView.likeViewLabel.text = "0 Like"
                } else if(post.post_likeCount == 1) {
                    footerView.likeViewLabel.text = "1 Like"
                } else if(post.post_likeCount > 1) {
                    let counts = String(post.post_likeCount)
                    footerView.likeViewLabel.text = "\(counts) Likes"
                }
            }
            
            if(post.post_commentCount != nil) {
                if(post.post_commentCount == 0) {
                    footerView.commentCount.text = "0 Comment"
                } else if(post.post_commentCount == 1) {
                    footerView.commentCount.text = "1 Comment"
                } else if(post.post_commentCount > 1) {
                    let counts = String(post.post_commentCount)
                    footerView.commentCount.text = "\(counts) Comments"
                }
            }
            
            
            
            self.addSubview(footerView)
            //End of Footer
        }
        
        
        
        
        
        self.layoutSubviews()
        
    }
    
    func addPhotoToLayout(_ post: Post) {
        
        centerView.horizontalScrollForPhotos.removeAll()
        for i in 1 ..< post.imageArr.count {
            let photosButton = UIImageView(frame: CGRect(x: 10, y: 3, width: 55, height: 55))
            photosButton.image = UIImage(named: "logo-default")
            photosButton.contentMode = UIViewContentMode.scaleAspectFill
            if(post.post_isOffline) {
                photosButton.image = post.imageArr[i].image
            } else {
                photosButton.frame.size.height = 55
                photosButton.frame.size.width = 55
                let urlStr = post.imageArr[i].imageUrl.absoluteString + "&width=100"
                photosButton.hnk_setImageFromURL(URL(string:urlStr)!)
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PhotosOTG2.openSinglePhoto(_:)))
                photosButton.isUserInteractionEnabled = true
                photosButton.addGestureRecognizer(tapGestureRecognizer)
                
            }
            photosButton.layer.cornerRadius = 5.0
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
