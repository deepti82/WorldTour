import UIKit
import Player
import Spring

class PhotosOTG2: VerticalLayout,PlayerDelegate {
    var postTop:Post!
    var endJourneyView: EndJourneyMyLife?    
    var lines: OnlyLine?
    var profileHeader:ActivityProfileHeader?
    var textHeader:ActivityTextHeader?
    var centerView:PhotosOTGView?
    var footerView:PhotoOTGFooter?
    var mainPhoto:UIImageView?
    var videoContainer:VideoView?
    var uploadingView:UploadingToCloud?
    var newTl:NewTLViewController!
    var player:Player!
    var scrollView:UIScrollView!
    var rateButton:RatingCheckIn?
    var headerLine:DottedLine?    
    var journeyUser: String = ""
    var willPlay = false
    var mainPhotoImageURL: URL?
    
    //MARK: - Post Creation
    
    func generatePost(_ post:Post) {
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
                
        postTop = post
        
        print("\n is postOffline : \(postTop.post_isOffline) \n\n")        
        
        //Header generation only
        if (postTop.jsonPost != nil) {
            headerLayout(feed: postTop.jsonPost)
        }
        else {
            if isSelfUser(otherUserID: postTop.post_userId) {
                headerLayoutForLocalPost(post: postTop)                
            }
        }
        
        //Image generation only
        if(post.videoArr.count > 0) {
            if self.videoContainer == nil {
                self.videoContainer = VideoView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
                self.player = Player()
                self.player.delegate = self
                self.player.view.clipsToBounds = true
                self.player.playbackLoops = true
                self.player.muted = true
                self.player.fillMode = "AVLayerVideoGravityResizeAspectFill"
                self.videoContainer?.player = self.player
                self.videoContainer?.videoHolder.addSubview(self.player.view)
                self.addSubview(self.videoContainer!)
            }            
            
            self.player.view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width)
            self.videoContainer?.tagText.isHidden = true
            videoContainer?.tagView.isHidden = true
            
            let serverThumbnailURL = post.videoArr[0].serverUrlThumbnail
            
            videoContainer?.playBtn.tintColor = mainOrangeColor
            
            
            self.videoContainer?.videoHolder.sd_setImage(with: getImageURL(serverThumbnailURL, width: BIG_PHOTO_WIDTH),
                                                         placeholderImage: getPlaceholderImage())
            
            
            if(!post.post_isOffline) {
                self.videoContainer?.isUserInteractionEnabled = true
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.openSingleVideo(_:)))
                self.videoContainer?.addGestureRecognizer(tapGestureRecognizer)
                self.videoContainer?.tag = 0
            }
        } 
            
        else if(post.imageArr.count > 0) {
            if self.mainPhoto == nil {
                self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
                self.mainPhoto?.contentMode = UIViewContentMode.scaleAspectFill
                self.mainPhoto?.clipsToBounds = true
                self.mainPhoto?.tag = 0
                self.addSubview(mainPhoto!)
            }
            
            self.mainPhoto?.image = UIImage(named: "logo-default")
            
            if(!post.post_isOffline) {
                self.mainPhoto?.isUserInteractionEnabled = true
                self.mainPhoto?.tag = 0
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PhotosOTG2.openSinglePhoto(_:)))
                self.mainPhoto?.addGestureRecognizer(tapGestureRecognizer)
                
                self.mainPhoto?.sd_setImage(with: getImageURL(post.imageArr[0].imageUrl.absoluteString, width: BIG_PHOTO_WIDTH),
                                            placeholderImage: getPlaceholderImage())
            }
            else {
                self.mainPhoto?.image = post.imageArr[0].image
            }
        }
            
        else if(post.post_locationImage != nil && post.post_locationImage != "") {
            if self.mainPhoto == nil {
                self.mainPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width))
                self.mainPhoto?.tag = 0
                self.mainPhoto?.contentMode = UIViewContentMode.scaleAspectFill
                self.addSubview(mainPhoto!)                
            }
            
            self.mainPhoto?.image = UIImage(named: "logo-default")
            self.mainPhoto?.sd_setImage(with: (URL(string:self.postTop.post_locationImage)!), 
                                        placeholderImage: getPlaceholderImage())
        }
        
        //End of Image
        var showImageIndexStart = 1
        if(post.videoArr.count > 0) {
            showImageIndexStart = 0
        }
        
        //Center Generation Only
        if(post.imageArr.count > showImageIndexStart) {
            if centerView == nil {
                centerView = PhotosOTGView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 90))
                self.addSubview(centerView!)
            }
            
            centerView?.backgroundColor = UIColor(white: 1, alpha: 0.8)
            addPhotoToLayout(post,startIndex:showImageIndexStart)
        }
        
        if(post.post_isOffline) {
            
            //Offline Generation Only
            
            if uploadingView == nil {
                uploadingView = UploadingToCloud(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 23))
                self.addSubview(uploadingView!)
            }
            
            var text = ""            
            switch post.post_editType {
            case 0:
                text = "EDIT_NEW_POST"
                
            case 1:
                text = "EDITING_ACTIVITY"
                
            case 2:
                text = "EDITING_PHOTO_VIDEO"
                
            default:
                text = ""
            }
            let localJson:JSON = ["type":"editTravelLifePost","editType":text]
            
            uploadingView?.fillUploadingStrip(feed: localJson)
        }
        else {
           
            //Footer Generation Only
            
            if footerView == nil {
                footerView = PhotoOTGFooter(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 65))
                self.addSubview(footerView!)
            }
            
            if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
                footerView?.optionButton.isHidden = false
            }else{
                footerView?.optionButton.isHidden = true
            }
            
            footerView?.PhotoOtg = self;
            footerView?.postTop = self.postTop;
            footerView?.setLikeCount(post.post_likeCount)
            footerView?.setCommentCount(post.post_commentCount)
            footerView?.setLikeSelected(post.post_likeDone)
            
            if post.postCreator["_id"].stringValue == user.getExistingUser() {
                footerView?.optionButton.isHidden = false
            }else{
                footerView?.optionButton.isHidden = true
            }
            
            if(post.post_location != "" && !post.post_isOffline) {
                if rateButton == nil {
                    rateButton = RatingCheckIn(frame: CGRect(x: 0, y: 0, width: width, height: 150))
                    rateButton?.whichView = "otg"
                    self.addSubview(rateButton!)
                }
                
                rateButton?.photosOtg = self
                rateButton?.journeyUser = self.journeyUser
                
                if post.postCreator["_id"].stringValue != user.getExistingUser() {
                    rateButton?.showRating = false
                    rateButton?.rateCheckInLabel.text = post.post_location
                }
                else{
                    rateButton?.showRating = true
                    rateButton?.rateCheckInLabel.text = "Rate " + post.post_location
                }
                
                if((post.jsonPost["review"].count) > 0) {
                    let review = post.jsonPost["review"].array?[0]
                    rateButton?.review = review
                    rateButton?.modifyAsReview()
                }
            }
        }
        
        self.layoutSubviews()
        
        if post.post_isOffline {
            for subvs in self.subviews {
                if !(subvs.isKind(of: DottedLine.self)) {
                    subvs.backgroundColor = offlinePostColor                    
                }
            }
        }
        
    }
    
    func headerLayout(feed:JSON) {
        if headerLine == nil {
            headerLine = DottedLine(frame: CGRect(x: 0, y: 2, width: self.frame.width, height: 38))
            self.addSubview(headerLine!)
        }
        
        if profileHeader == nil {
            profileHeader = ActivityProfileHeader(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: FEEDS_HEADER_HEIGHT))
            self.addSubview(profileHeader!)
            profileHeader?.parentController = globalNewTLViewController
        }
        
        profileHeader?.backgroundColor = UIColor(white: 1, alpha: 0.8)        
        profileHeader?.followButton.isHidden = true
        profileHeader?.fillProfileHeader(feed:feed, pageType: viewType.VIEW_TYPE_OTG, cellType: feedCellType.CELL_POST_TYPE)
        
        
        profileHeader?.localDate.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd MM, yyyy", date: feed["UTCModified"].stringValue, isDate: true)
        profileHeader?.localTime.text = request.changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "h:mm a", date: feed["UTCModified"].stringValue, isDate: false)
        
        
        //  START ACTIVITY TEXT HEADER
        var flag = false
        if textHeader == nil {
            textHeader = ActivityTextHeader(frame: CGRect.zero)
            flag = true
        }
        
        textHeader?.backgroundColor = UIColor(white: 1, alpha: 0.8)
        textHeader?.displayText = getThought(feed)
        textHeader?.setText(text: (textHeader?.displayText)!)
        
        if textHeader?.displayText.string != "" {
            let textHeight = (heightOfAttributedText(attributedString: (textHeader?.displayText)!, width: (self.frame.width-25)) + 10)
            textHeader?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: textHeight)
            textHeader?.headerText.frame = CGRect(x: 8, y: 0, width: self.frame.width-16, height: textHeight)
            textHeader?.headerText.center = (textHeader?.headerText.center)!
            if flag {
                self.addSubview(textHeader!)                
            }
        }
    }
    
    func headerLayoutForLocalPost(post: Post) {
        
        if headerLine == nil {
            headerLine = DottedLine(frame: CGRect(x: 0, y: 2, width: self.frame.width, height: 38))
            self.addSubview(headerLine!)
        }
        
        if profileHeader == nil {
            profileHeader = ActivityProfileHeader(frame: CGRect(x: 0, y: 20, width: self.frame.width, height: FEEDS_HEADER_HEIGHT))
            self.addSubview(profileHeader!)
        }
        
        profileHeader?.parentController = globalNewTLViewController
        profileHeader?.backgroundColor = UIColor(white: 1, alpha: 0.8)
        profileHeader?.followButton.isHidden = true
        profileHeader?.fillProfileHeaderForLocalPost(post: post)
        
        if post.post_thoughts != "" {
            
            var flag = false
            
            if textHeader == nil {
                textHeader = ActivityTextHeader(frame: CGRect.zero)
                flag = true
            }
            
            textHeader?.backgroundColor = UIColor(white: 1, alpha: 0.8)
            textHeader?.displayText = getThoughtForLocalPost(post)
            textHeader?.setText(text: (textHeader?.displayText)!)
            if textHeader?.displayText.string != "" {
                let textHeight = (heightOfAttributedText(attributedString: (textHeader?.displayText)!, width: (self.frame.width-25)) + 10)
                textHeader?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: textHeight)
                textHeader?.headerText.frame = CGRect(x: 8, y: 0, width: self.frame.width-16, height: textHeight)
                textHeader?.headerText.center = (textHeader?.headerText.center)!
                if flag {
                    self.addSubview(textHeader!)
                }
            }
        }
    }
    
    func setText(text: String) {
        textHeader?.headerText.text = text
    }
    
    func openSingleVideo(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.index = sender.view.tag
        singlePhotoController.type = "Video"
        singlePhotoController.postId = self.postTop.post_ids
        globalNavigationController.pushViewController(singlePhotoController, animated: true)
    }
    
    func addPhotoToLayout(_ post: Post, startIndex: Int) {
        centerView?.horizontalScrollForPhotos.removeAll()
        for i in startIndex ..< post.imageArr.count {
            let photosButton = UIImageView(frame: CGRect(x: 5, y: 5, width: 80, height: 80))
            photosButton.image = UIImage(named: "logo-default")
            photosButton.contentMode = UIViewContentMode.scaleAspectFill
            if(post.post_isOffline) {
                photosButton.image = post.imageArr[i].image
            } else {
                photosButton.frame.size.height = 82
                photosButton.frame.size.width = 82
                let urlStr = post.imageArr[i].imageUrl.absoluteString + "&width=500"
                photosButton.sd_setImage(with: URL(string:urlStr)!,
                                         placeholderImage: getPlaceholderImage())
                if(!post.post_isOffline) {
                    let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(PhotosOTG2.openSinglePhoto(_:)))
                    photosButton.isUserInteractionEnabled = true
                    photosButton.addGestureRecognizer(tapGestureRecognizer)
                }
            }     
            photosButton.tag = i
            photosButton.clipsToBounds = true
            centerView?.horizontalScrollForPhotos.addSubview(photosButton)
        }
        centerView?.horizontalScrollForPhotos.layoutSubviews()
        centerView?.morePhotosView.contentSize = CGSize(width: (centerView?.horizontalScrollForPhotos.frame.width)!, height: (centerView?.horizontalScrollForPhotos.frame.height)!)
    }
    
    func openSinglePhoto(_ sender: UIGestureRecognizer?) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
//        singlePhotoController.mainImage?.image = sender.image
        singlePhotoController.index = (sender?.view?.tag == 0 || sender?.view?.tag == 1) ? ((sender?.view?.isEqual(self.mainPhoto))! ? 0 : 1) : sender?.view?.tag
        singlePhotoController.postId = postTop.post_ids
        globalNavigationController.pushViewController(singlePhotoController, animated: true)
    
    }
    
    
    //MARK: - Loading Video
    
    func videoToPlay ()  {
        
        if isVideoViewInRangeToPlay() {
            if !self.willPlay {
                self.videoContainer?.showLoadingIndicator(color: mainOrangeColor)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                self.videoContainer?.stopLoadingIndicator()
                if self.isVideoViewInRangeToPlay() {
                    if !self.willPlay {
//                        self.videoContainer.playBtn.isHidden = true
                        self.willPlay = true
                        var videoUrl : URL?
                        
                        if(!self.postTop.post_isOffline) {
                            videoUrl = URL(string: self.postTop.videoArr[0].serverUrl)
                        } else {
                            videoUrl = self.postTop.videoArr[0].imageUrl
                        }
                        if videoUrl != nil {
                            self.player.setUrl(videoUrl!)
                            self.player.playFromBeginning()
                        }
                    }
                }
                else {
                    self.player.stop()
                    self.willPlay = false
//                    self.videoContainer.playBtn.isHidden = false
                    self.videoContainer?.stopLoadingIndicator()
                }
            })
        }
        else {
            self.player.stop()
            self.willPlay = false
//            self.videoContainer.playBtn.isHidden = false
            self.videoContainer?.stopLoadingIndicator()
        }
    }
    
    func isVideoViewInRangeToPlay() -> Bool {
        let min = self.frame.origin.y + (self.videoContainer?.frame.origin.y)!
        let max = min + (self.videoContainer?.frame.size.height)!
        let scrollMin = self.scrollView.contentOffset.y
        let scrollMax = scrollMin + self.scrollView.frame.height
        
        if (scrollMin < min && scrollMax > max ) {
            return true
        }
        
        return false
    }
    
    func playerReady(_ player: Player) {
//        videoToPlay()
    }
    
    
    //MARK: - Loading Images
    
    func loadImagesOnlayout ()  {
        
        if isMainPhotoViewInRangeToLoad() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: { 
                
                if self.isMainPhotoViewInRangeToLoad() {
                    
                    if self.postTop.imageArr.count > 0 {
                        
                        if self.mainPhoto?.tag == 0 {
                            print("\n Loading started for mainPhoto :  \(self.postTop.imageArr[0].imageUrl)")
                            
                            self.mainPhoto?.hnk_setImageFromURL(self.postTop.imageArr[0].imageUrl, placeholder: UIImage(named: "logo-default"), format: nil, failure: nil, success: { (img) in
                                self.mainPhoto?.image = img
                                self.mainPhoto?.tag = 1
                            })
                            
                            var showImageIndexStart = 1
                            if(self.postTop.videoArr.count > 0) {
                                showImageIndexStart = 0
                            }
                            for i in showImageIndexStart ..< self.postTop.imageArr.count {
                                
                                let photosButton = (self.centerView?.horizontalScrollForPhotos.viewWithTag(i) as! UIImageView)
                                
                                photosButton.image = UIImage(named: "logo-default")
                                if(self.postTop.post_isOffline) {
                                    photosButton.image = self.postTop.imageArr[i].image
                                } else {
                                    photosButton.hnk_setImageFromURL(URL(string:(self.postTop.imageArr[i].imageUrl.absoluteString + "&width=500"))!)
                                }
                            }
                            
                        }
                    }
                        
                    else if (self.postTop.post_locationImage != nil && self.postTop.post_locationImage != "") {
                        if self.mainPhoto?.tag == 0 {
                            self.mainPhoto?.hnk_setImageFromURL(URL(string:self.postTop.post_locationImage)!, placeholder: UIImage(named: "logo-default"), format: nil, failure: nil, success: { (img) in
                                self.mainPhoto?.image = img
                                self.mainPhoto?.tag = 1
                            })
                        }
                    }                    
                }
            })
            
        }
    }
    
    func isMainPhotoViewInRangeToLoad() -> Bool {
//        print("MainPhono : start \(self.mainPhoto?.frame.origin.y)  End: \((self.mainPhoto?.frame.origin.y)!+(self.mainPhoto?.frame.size.height)!) ")
//        print("MainPhono : start \(self.mainPhoto?.bounds.origin.y)  End: \((self.mainPhoto?.bounds.origin.y)!+(self.mainPhoto?.bounds.size.height)!) ")
//        print("ScrollView : start \(self.scrollView.contentOffset.y)  End: \((self.scrollView.contentOffset.y)+(self.scrollView.frame.height))\n\n ")
        if self.mainPhoto != nil {
//            let viewRect = self.mainPhoto?.frame
//            let mainRect = CGRect(origin: scrollView.contentOffset, size: scrollView.contentSize)
//            
//            if (viewRect?.intersects(mainRect))! {
//                return true
//            }
            
            let min = self.frame.origin.y + (self.mainPhoto?.frame.origin.y)!
            let max = min + (self.mainPhoto?.frame.size.height)!
            let scrollMin = 1.2*(self.scrollView.contentOffset.y)
            let scrollMax = 1.2*(scrollMin + self.scrollView.frame.height)
            
            
            if (max > scrollMin && min < scrollMax) {
                return true
            }
        }
        
        return false
    }
    
//    func isCenterViewInRangeToLoad() -> Bool {
//        if self.centerView != nil {
//            let viewRect = self.centerView?.frame
//            let mainRect = self.scrollView.frame            
//            
//            if (mainRect.intersects(viewRect!)) {
//                return true
//            }
//        }
//        
//        return false
//    }

}
