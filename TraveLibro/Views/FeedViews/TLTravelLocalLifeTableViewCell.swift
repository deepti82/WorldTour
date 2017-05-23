//
//  TLTravelLocalLifeTableViewCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 04/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import Player


class TLTravelLocalLifeTableViewCell: UITableViewCell, PlayerDelegate {

    var FBackground: NotificationBackground!
    var FProfileHeader: ActivityProfileHeader!
    var FMTextView: TLFeedHeaderTextFlagView?
    var FMCenterView:PhotosOTGView?
    var FMVideoContainer:VideoView?
    var FMMainPhoto:UIImageView?
    var FMHeaderTag: ActivityHeaderTag?
    var FMPlayer:Player?
    var FFooterViewBasic: ActivityFeedFooterBasic!
    var FUploadingView: UploadingToCloud?
    
    var parentController: UIViewController!
    
    var willPlay = false
    var totalHeight = CGFloat(0)
    var feeds: JSON!
    var pageType: viewType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String, feedData: JSON, helper: UIViewController){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createView(feedData: feedData, helper: helper)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
        createView(feedData: nil, helper: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if FMCenterView != nil {
            FMCenterView?.frame = CGRect.zero
        }
        
        if FMVideoContainer != nil {
            FMVideoContainer?.frame = CGRect.zero
        }
        
        if FMMainPhoto != nil {
            for subview in (FMMainPhoto?.subviews)! {
                if subview.tag == 123 {
                    subview.removeFromSuperview()
                }
                else if subview.tag == 1234 {
                    subview.removeFromSuperview()
                }
            }
            FMMainPhoto?.frame = CGRect.zero
        }
        
        if FMHeaderTag != nil {
            FMHeaderTag?.resetActivityHeaderTag()
            FMHeaderTag?.frame = CGRect.zero
            
            FMHeaderTag?.removeFromSuperview()
            FMHeaderTag = nil            
        }
        
        if FMPlayer != nil {
            FMPlayer?.view.frame = CGRect.zero
            
            FMPlayer?.view.removeFromSuperview()
            FMPlayer = nil
        }
        
        FFooterViewBasic.lowerViewHeightConstraint.constant = 0
        FFooterViewBasic.frame = CGRect.zero       
        
    }
    
    //MARK: - Create View
    
    func createView(feedData: JSON?, helper: UIViewController?) {
        
        FProfileHeader = ActivityProfileHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: FEEDS_HEADER_HEIGHT))
        self.contentView.addSubview(FProfileHeader)
        
        FMTextView = TLFeedHeaderTextFlagView(frame: CGRect.zero)
        self.contentView.addSubview(FMTextView!)
        
        FFooterViewBasic = ActivityFeedFooterBasic(frame: CGRect.zero)
        self.contentView.addSubview(FFooterViewBasic)
        
        FUploadingView = UploadingToCloud(frame: CGRect.zero)
        self.contentView.addSubview(FUploadingView!)
        
        FBackground = NotificationBackground(frame: CGRect.zero)
        self.contentView.addSubview(FBackground)
        self.contentView.sendSubview(toBack: FBackground)
        
        if feedData != nil {
            setData(feedData: feedData!, helper: helper!, pageType: nil, delegate: nil)            
        }
    }
    
    func setData(feedData: JSON, helper: UIViewController, pageType: viewType?, delegate: TLFooterBasicDelegate?) {
        
        self.feeds = feedData
        self.parentController = helper
        self.pageType = pageType
        
        FMHeaderTag?.frame = CGRect.zero
        FMHeaderTag?.removeFromSuperview()
        FMHeaderTag = nil
        
        totalHeight = CGFloat(0)
        
        if pageType == viewType.VIEW_TYPE_MY_LIFE {
            FProfileHeader.frame = CGRect.zero            
        }
        else {
            FProfileHeader.frame = CGRect(x: 0, y: 0, width: screenWidth, height: FEEDS_HEADER_HEIGHT)        
            FProfileHeader.parentController = helper
            FProfileHeader.fillProfileHeader(feed: feedData, pageType: pageType, cellType: feedCellType.CELL_OTG_TYPE)
            totalHeight += FEEDS_HEADER_HEIGHT
        }
        
        
        FMTextView?.setFlag(feed: self.feeds)
        FMTextView?.displayText = getTextHeader(feed: self.feeds, pageType: pageType!)        
        FMTextView?.setText(text: (FMTextView?.displayText)!)
        if FMTextView?.displayText.string != "" || pageType == viewType.VIEW_TYPE_MY_LIFE {
            let textHeight = (heightOfAttributedText(attributedString: (FMTextView?.displayText)!, width: (screenWidth-21)) + 10)
            FMTextView?.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: textHeight)
            FMTextView?.headerTextView.frame = CGRect(x: 8, y: 0, width: screenWidth-(FMTextView?.flagStackView.frame.size.width)!-13, height: textHeight)
            FMTextView?.headerTextView.center = CGPoint(x: (FMTextView?.headerTextView.center.x)!, y: (FMTextView?.flagStackView.center.y)!)
            totalHeight += textHeight
        }
        let prevHeight = totalHeight
        
        self.videosAndPhotosLayout(feed: self.feeds, pageType: pageType)
        
        if prevHeight == totalHeight {
            //Only text Header
            FMHeaderTag = ActivityHeaderTag(frame: CGRect(x: 0, y: totalHeight + 30, width: screenWidth, height: 50))
            FMHeaderTag?.tagParent.backgroundColor = UIColor.clear            
            FMHeaderTag?.colorTag(feed: self.feeds)
            self.contentView.addSubview(FMHeaderTag!)
            totalHeight += 80
        }
        
        FMHeaderTag?.isHidden = false
        if pageType == viewType.VIEW_TYPE_MY_LIFE ||
            pageType == viewType.VIEW_TYPE_LOCAL_LIFE {
            FMHeaderTag?.isHidden = true
        }
        
        FFooterViewBasic.parentController = helper
        FFooterViewBasic.fillFeedFooter(feed: self.feeds, pageType: pageType, delegate: delegate)
        
        if shouldShowFooterCountView(feed: self.feeds) {
            FFooterViewBasic.lowerViewHeightConstraint.constant = FEED_FOOTER_LOWER_VIEW_HEIGHT
            FFooterViewBasic.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: FEED_FOOTER_HEIGHT)
            totalHeight += FEED_FOOTER_HEIGHT
        }
        else {
            FFooterViewBasic.lowerViewHeightConstraint.constant = 0
            FFooterViewBasic.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT))
            totalHeight += (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT)
        }
        
        if (pageType != viewType.VIEW_TYPE_SHOW_SINGLE_POST && isLocalFeed(feed: feedData) ) {
            FUploadingView?.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: FEED_UPLOADING_VIEW_HEIGHT)
            FUploadingView?.fillUploadingStrip(feed: feedData)
            totalHeight += FEED_UPLOADING_VIEW_HEIGHT
        }
        else {
            FUploadingView?.frame = CGRect.zero
            FUploadingView?.uploadText.text = ""
        }
        
        FBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }
    
    private func removePreviousGestureFromPhotoView() {
        for recognizer in self.FMMainPhoto?.gestureRecognizers ?? [] {
            self.removeGestureRecognizer(recognizer)
        }
    }
    
    private func videosAndPhotosLayout(feed: JSON, pageType: viewType?) {
        
        self.removePreviousGestureFromPhotoView()
        
        //Image generation only
        if(feed["videos"].count > 0) {
            
            if self.FMVideoContainer == nil {
                self.FMVideoContainer = VideoView(frame: CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9))
                self.FMVideoContainer?.isUserInteractionEnabled = true
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.openSingleVideo(_:)))
                self.FMVideoContainer?.addGestureRecognizer(tapGestureRecognizer)
                self.contentView.addSubview(self.FMVideoContainer!)
            }
            else {
                self.FMVideoContainer?.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9)
            }
            
            self.FMVideoContainer?.tag = 0
            
            if self.FMPlayer == nil {
                self.FMPlayer = Player()
                self.FMPlayer?.delegate = self
                self.FMPlayer?.view.clipsToBounds = true
                self.FMPlayer?.playbackLoops = true
                self.FMPlayer?.muted = true
                self.FMPlayer?.fillMode = "AVLayerVideoGravityResizeAspectFill"
                self.FMPlayer?.playbackFreezesAtEnd = true
                self.FMVideoContainer?.videoHolder.addSubview((self.FMPlayer?.view)!)
            }
            
            self.FMPlayer?.view.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth*0.9)            
            self.FMVideoContainer?.player = self.FMPlayer
            self.FMVideoContainer?.bringSubview(toFront: (FMVideoContainer?.playBtn)!)            

            
            self.FMVideoContainer?.videoHolder.sd_setImage(with: getImageURL(feed["videos"][0]["thumbnail"].stringValue, width: BIG_PHOTO_WIDTH), 
                                                           placeholderImage: getPlaceholderImage())
            
            if pageType != viewType.VIEW_TYPE_MY_LIFE {
                FMVideoContainer?.tagText.isHidden = false
                if (!(__CGSizeEqualToSize((self.FMVideoContainer?.frame.size)!, CGSize(width: 0, height: 0)))) {
                    if pageType != viewType.VIEW_TYPE_MY_LIFE &&
                        pageType != viewType.VIEW_TYPE_LOCAL_LIFE {
                        
                        if feed["type"].stringValue == "travel-life" {
                            FMVideoContainer?.tagText.text = "Travel Life"
                            FMVideoContainer?.tagText.textColor = UIColor.white
                            FMVideoContainer?.tagView.backgroundColor = mainOrangeColor
                            FMVideoContainer?.playBtn.tintColor = mainOrangeColor
                        }
                        else{
                            FMVideoContainer?.tagText.text = "  Local Life"
                            FMVideoContainer?.tagText.textColor = UIColor(hex: "#303557")
                            FMVideoContainer?.tagView.backgroundColor = endJourneyColor
                            FMVideoContainer?.playBtn.tintColor = endJourneyColor
                        }
                    }
                    else {
                        FMVideoContainer?.tagText.text = ""
                        FMVideoContainer?.tagText.textColor = UIColor.clear
                        FMVideoContainer?.tagView.backgroundColor = UIColor.clear
                        FMVideoContainer?.playBtn.tintColor = UIColor.clear
                    }
                }                
            }
                        
            if pageType == viewType.VIEW_TYPE_MY_LIFE ||
                pageType == viewType.VIEW_TYPE_LOCAL_LIFE {
                FMVideoContainer?.tagText.text = ""
                FMVideoContainer?.tagText.textColor = UIColor.clear
                FMVideoContainer?.tagView.backgroundColor = UIColor.clear
                FMVideoContainer?.playBtn.tintColor = UIColor.clear
            }
            
            totalHeight += screenWidth*0.9
        }
            
        else if(feed["photos"].count > 0) {
            
            FMVideoContainer?.tagText.text = ""
            FMVideoContainer?.tagText.textColor = UIColor.clear
            FMVideoContainer?.tagView.backgroundColor = UIColor.clear
            FMVideoContainer?.playBtn.tintColor = UIColor.clear
            
            if self.FMMainPhoto == nil {
                self.FMMainPhoto = UIImageView(frame: CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9))
                self.FMMainPhoto?.contentMode = UIViewContentMode.scaleAspectFill
                self.FMMainPhoto?.clipsToBounds = true                
                self.contentView.addSubview(self.FMMainPhoto!)
            }
            else {
                self.FMMainPhoto?.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9)
            }
            
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.openSinglePhoto(_:)))
            self.FMMainPhoto?.isUserInteractionEnabled = true
            self.FMMainPhoto?.addGestureRecognizer(tapGestureRecognizer)
            
            if pageType != viewType.VIEW_TYPE_MY_LIFE &&
                pageType != viewType.VIEW_TYPE_LOCAL_LIFE {
                
                if self.FMHeaderTag == nil {
                    FMHeaderTag = ActivityHeaderTag(frame: CGRect(x: 0, y: 30, width: screenWidth, height: 30))
                    FMHeaderTag?.tag = 1234
                    self.FMMainPhoto?.addSubview(FMHeaderTag!)
                }
                else {
                    FMHeaderTag?.frame = CGRect(x: 0, y: 30, width: screenWidth, height: 30)
                }
                
                FMHeaderTag?.tagParent.backgroundColor = UIColor.clear
                FMHeaderTag?.colorTag(feed: feed)
            }
            
            totalHeight += screenWidth*0.9
            
//            if pageType == viewType.VIEW_TYPE_SHOW_SINGLE_POST {
//                self.FMMainPhoto?.sd_setImage(with: getImageURL((feed["photos"].arrayValue)[0].stringValue, width: BIG_PHOTO_WIDTH),
//                                              placeholderImage: getPlaceholderImage())
//                
//            }
//            else {
                self.FMMainPhoto?.sd_setImage(with: getImageURL(feed["photos"][0]["name"].stringValue, width: BIG_PHOTO_WIDTH),
                                              placeholderImage: getPlaceholderImage())
//            }
        }
            
        else{
            FMVideoContainer?.tagText.text = ""
            FMVideoContainer?.tagText.textColor = UIColor.clear
            FMVideoContainer?.tagView.backgroundColor = UIColor.clear
            FMVideoContainer?.playBtn.tintColor = UIColor.clear
            
            if feed["imageUrl"] != nil {
                
                if self.FMMainPhoto == nil {
                    self.FMMainPhoto = UIImageView(frame: CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9))
                    self.FMMainPhoto?.contentMode = UIViewContentMode.scaleAspectFill
                    self.FMMainPhoto?.clipsToBounds = true                    
                    self.contentView.addSubview(self.FMMainPhoto!)
                }
                else {
                    self.FMMainPhoto?.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9)
                }
                totalHeight += screenWidth*0.9
                
                if ((pageType != viewType.VIEW_TYPE_MY_LIFE && pageType != viewType.VIEW_TYPE_LOCAL_LIFE) &&
                    (feed["thoughts"] == nil || feed["thoughts"].stringValue == "" || feed["imageUrl"] != nil)) {
                    
                    if self.FMHeaderTag == nil {
                        FMHeaderTag = ActivityHeaderTag(frame: CGRect(x: 0, y: 30, width: screenWidth, height: 28))
                        FMHeaderTag?.tag = 123
                        self.FMMainPhoto?.addSubview(FMHeaderTag!)
                    }
                    else {
                        FMHeaderTag?.frame = CGRect(x: 0, y: 30, width: screenWidth, height: 28)
                    }
                    FMHeaderTag?.tagParent.backgroundColor = UIColor.clear
                    FMHeaderTag?.colorTag(feed: feed)
                }
                self.FMMainPhoto?.sd_setImage(with: getImageURL(feed["imageUrl"].stringValue, width: BIG_PHOTO_WIDTH),
                                              placeholderImage: getPlaceholderImage())                
            }
        }
        
        
        //End of Image
        var showImageIndexStart = 1
        if(feed["videos"].count > 0) {
            showImageIndexStart = 0
        }
        
        //Center Generation Only
        if(feed["photos"].count > showImageIndexStart) {
            if self.FMCenterView == nil {
                FMCenterView = PhotosOTGView(frame: CGRect(x: 0, y: totalHeight, width: self.frame.width, height: 90))
                self.contentView.addSubview(FMCenterView!)
            }
            else {
                FMCenterView?.frame = CGRect(x: 0, y: totalHeight, width: self.frame.width, height: 90)
            }            
            addPhotoToLayout(feed,startIndex:showImageIndexStart)
            totalHeight += 90
        }
        //End of Center
    }
    
    func addPhotoToLayout(_ post: JSON, startIndex: Int) {
        FMCenterView?.horizontalScrollForPhotos.removeAll()
        for i in startIndex ..< post["photos"].count {
            let photosButton = UIImageView(frame: CGRect(x: 5, y: 5, width: 80, height: 80))
            photosButton.image = UIImage(named: "logo-default")
            photosButton.contentMode = UIViewContentMode.scaleAspectFill
            
            photosButton.frame.size.height = 82
            photosButton.frame.size.width = 82
            
            var urlStr: URL!
//            if self.pageType == viewType.VIEW_TYPE_SHOW_SINGLE_POST {
//                urlStr = getImageURL((post["photos"].arrayValue)[i].stringValue, width: BIG_PHOTO_WIDTH)
//            }
//            else {
                urlStr = getImageURL(post["photos"][i]["name"].stringValue, width: BIG_PHOTO_WIDTH)
//            }
            
            photosButton.hnk_setImageFromURL(urlStr)
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.openSinglePhoto(_:)))
            photosButton.isUserInteractionEnabled = true
            photosButton.addGestureRecognizer(tapGestureRecognizer)
            //photosButton.layer.cornerRadius = 5.0
            photosButton.tag = i
            photosButton.clipsToBounds = true
            FMCenterView?.horizontalScrollForPhotos.addSubview(photosButton)
        }
        FMCenterView?.horizontalScrollForPhotos.layoutSubviews()
        FMCenterView?.morePhotosView.contentSize = CGSize(width: (FMCenterView?.horizontalScrollForPhotos.frame.width)!, height: (FMCenterView?.horizontalScrollForPhotos.frame.height)!)
    }
    
    
    //MARK:- Video Playing
    
    func videoToPlay(scrollView: UIScrollView)  {
        if self.FMVideoContainer != nil {
            if isVideoViewInRangeToPlay(scrollView: scrollView) {
                if !self.willPlay {
                    if (!(__CGSizeEqualToSize((self.FMVideoContainer?.frame.size)!, CGSize(width: 0, height: 0)))) {
                        self.FMVideoContainer?.showLoadingIndicator(color: (feeds["type"].stringValue == "travel-life" ? mainOrangeColor : endJourneyColor))
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.FMVideoContainer?.stopLoadingIndicator()
                    if (!(__CGSizeEqualToSize((self.FMVideoContainer?.frame.size)!, CGSize(width: 0, height: 0)))){
                        if self.isVideoViewInRangeToPlay(scrollView: scrollView) {
                            if !self.willPlay {
                                //                        self.videoContainer.playBtn.isHidden = true                        
                                self.willPlay = true
                                var videoUrl = URL(string:self.feeds["videos"][0]["name"].stringValue)
                                if(videoUrl == nil) {
                                    videoUrl = URL(string:self.feeds["videos"][0]["localUrl"].stringValue)
                                }
                                self.FMPlayer?.setUrl(videoUrl!)
                                self.FMPlayer?.playFromBeginning()
                            }
                        }
                        else {
                            self.FMPlayer?.stop()
                            self.willPlay = false
                            if (!(__CGSizeEqualToSize((self.FMVideoContainer?.frame.size)!, CGSize(width: 0, height: 0)))) {
                                self.FMVideoContainer?.stopLoadingIndicator()
                            }
                        }
                    }
                })
            }
            else {
                self.FMPlayer?.stop()
                self.willPlay = false
                if (!(__CGSizeEqualToSize((self.FMVideoContainer?.frame.size)!, CGSize(width: 0, height: 0)))) {
                    self.FMVideoContainer?.stopLoadingIndicator()
                }
            }
        }        
    }
    
    private func isVideoViewInRangeToPlay(scrollView: UIScrollView) -> Bool {
        let min = self.frame.origin.y + (self.FMVideoContainer?.frame.origin.y)!
        let max = min + (self.FMVideoContainer?.frame.size.height)!
        let scrollMin = scrollView.contentOffset.y
        let scrollMax = scrollMin + scrollView.frame.height
        
        if (scrollMin < min && scrollMax > max ) {
            return true
        }
        
        return false
    }
    
    func playerReady(_ player: Player) {
        //videoToPlay()
    }
    
    
    //MARK: - Actions
    
    func openSinglePhoto(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.fetchType = photoVCType.FROM_ACTIVITY
        singlePhotoController.index = sender.view.tag
        singlePhotoController.postId = self.feeds["_id"].stringValue
        parentController.navigationController?.pushViewController(singlePhotoController, animated: true)
    } 
    
    func openSingleVideo(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.fetchType = photoVCType.FROM_ACTIVITY
        singlePhotoController.index = sender.view.tag
        singlePhotoController.type = "Video"
        singlePhotoController.postId = self.feeds["_id"].stringValue
        parentController.navigationController?.pushViewController(singlePhotoController, animated: true)
    }
    
}
