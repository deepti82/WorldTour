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

    var FBackground = NotificationBackground()
    var FProfileHeader: ActivityProfileHeader!
    var FMTextView: TLFeedHeaderTextFlagView?
    var FMCenterView:PhotosOTGView?
    var FMVideoContainer:VideoView?
    var FMMainPhoto:UIImageView?
    var FMHeaderTag: ActivityHeaderTag?
    var FMPlayer:Player?
    var FFooterViewBasic: ActivityFeedFooterBasic!
    
    var totalHeight = CGFloat(0)
    
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
            FMCenterView?.removeFromSuperview()
            FMCenterView = nil
        }
        
        if FMVideoContainer != nil {
            FMVideoContainer?.removeFromSuperview()
            FMVideoContainer = nil
        }
        
        if FMMainPhoto != nil {
            FMMainPhoto?.removeFromSuperview()
            FMMainPhoto = nil
        }
        
        if FMHeaderTag != nil {
            FMHeaderTag?.removeFromSuperview()
            FMHeaderTag = nil
        }
        
        if FMPlayer != nil {
            FMPlayer?.view?.removeFromSuperview()
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
        
        FBackground = NotificationBackground(frame: CGRect.zero)
        self.contentView.addSubview(FBackground)
        self.contentView.sendSubview(toBack: FBackground)
        
        if feedData != nil {
            setData(feedData: feedData!, helper: helper!, pageType: nil, delegate: nil)            
        }
    }    
    
    func setData(feedData: JSON, helper: UIViewController, pageType: viewType?, delegate: TLFooterDelegate?) {
        
        totalHeight = CGFloat(0)
        
        FProfileHeader.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: FEEDS_HEADER_HEIGHT)        
        FProfileHeader.parentController = helper
        FProfileHeader.fillProfileHeader(feed: feedData, pageType: pageType, cellType: feedCellType.CELL_POST_TYPE)
        totalHeight += FEEDS_HEADER_HEIGHT
        
        FMTextView?.setFlag(feed: feedData)
        FMTextView?.displayText = getTextHeader(feed: feedData, pageType: pageType!)        
        FMTextView?.setText(text: (FMTextView?.displayText)!)
        if FMTextView?.displayText.string != "" {
            let textHeight = (heightOfAttributedText(attributedString: (FMTextView?.displayText)!, width: screenWidth) + 10)
            FMTextView?.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: textHeight)
            FMTextView?.headerTextView.frame = CGRect(x: 8, y: 0, width: screenWidth-(FMTextView?.flagStackView.frame.size.width)!-13, height: textHeight)
            FMTextView?.headerTextView.center = CGPoint(x: (FMTextView?.headerTextView.center.x)!, y: (FMTextView?.flagStackView.center.y)!)
            totalHeight += textHeight            
        }
        let prevHeight = totalHeight
        
        self.videosAndPhotosLayout(feed: feedData)
        
        if prevHeight == totalHeight {
            //Only text Header
            FMHeaderTag = ActivityHeaderTag(frame: CGRect(x: 0, y: totalHeight + 30, width: screenWidth, height: 50))
            FMHeaderTag?.tagParent.backgroundColor = UIColor.clear            
            FMHeaderTag?.colorTag(feed: feedData)
            self.contentView.addSubview(FMHeaderTag!)
            totalHeight += 80
        }
        
        FFooterViewBasic.parentController = helper
        FFooterViewBasic.fillFeedFooter(feed: feedData, pageType: pageType, delegate: delegate)
        
        if shouldShowFooterCountView(feed: feedData) {
            FFooterViewBasic.lowerViewHeightConstraint.constant = FEED_FOOTER_LOWER_VIEW_HEIGHT
            FFooterViewBasic.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: FEED_FOOTER_HEIGHT)
            totalHeight += FEED_FOOTER_HEIGHT
        }
        else {
            FFooterViewBasic.lowerViewHeightConstraint.constant = 0
            FFooterViewBasic.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT))
            totalHeight += (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT)
        }
        
        FBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }
    
    func videosAndPhotosLayout(feed:JSON) {
        
        //Image generation only
        if(feed["videos"].count > 0) {
            self.FMVideoContainer = VideoView(frame: CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9))
            
            self.FMVideoContainer?.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.openSingleVideo(_:)))
            self.FMVideoContainer?.addGestureRecognizer(tapGestureRecognizer)
            self.FMVideoContainer?.tag = 0
            
            self.FMPlayer = Player()
            self.FMPlayer?.delegate = self
            self.FMPlayer?.view.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9)
            self.FMPlayer?.view.clipsToBounds = true
            self.FMPlayer?.playbackLoops = true
            self.FMPlayer?.muted = true
            self.FMPlayer?.fillMode = "AVLayerVideoGravityResizeAspectFill"
            self.FMPlayer?.playbackFreezesAtEnd = true
            self.FMVideoContainer?.player = self.FMPlayer
            self.FMVideoContainer?.bringSubview(toFront: (FMVideoContainer?.playBtn)!)
            
            
            var videoUrl = URL(string:feed["videos"][0]["name"].stringValue)
            if(videoUrl == nil) {
                videoUrl = URL(string:feed["videos"][0]["localUrl"].stringValue)
            }
            
            getThumbnailFromVideoURL(url: videoUrl!, onView: (self.FMVideoContainer?.videoHolder)!)
            
            if feed["type"].stringValue == "travel-life" {
                FMVideoContainer?.tagText.text = "Travel Life"
                FMVideoContainer?.tagView.backgroundColor = mainOrangeColor
                FMVideoContainer?.playBtn.tintColor = mainOrangeColor
            }
            else{
                FMVideoContainer?.tagText.text = "  Local Life"
                FMVideoContainer?.tagText.textColor = UIColor(hex: "#303557")
                FMVideoContainer?.tagView.backgroundColor = endJourneyColor
                FMVideoContainer?.playBtn.tintColor = endJourneyColor
            }
            self.FMVideoContainer?.videoHolder.addSubview((self.FMPlayer?.view)!)
            self.contentView.addSubview(self.FMVideoContainer!)
            totalHeight += screenWidth*0.9
            
        }
            
        else if(feed["photos"].count > 0) {
            self.FMMainPhoto = UIImageView(frame: CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9))
            self.FMMainPhoto?.contentMode = UIViewContentMode.scaleAspectFill
            self.FMMainPhoto?.clipsToBounds = true
            self.FMMainPhoto?.image = UIImage(named: "logo-default")
            
            FMHeaderTag = ActivityHeaderTag(frame: CGRect(x: 0, y: 30, width: screenWidth, height: 30))
            FMHeaderTag?.tagParent.backgroundColor = UIColor.clear
            FMHeaderTag?.colorTag(feed: feed)
            self.FMMainPhoto?.addSubview(FMHeaderTag!)
            
            self.contentView.addSubview(self.FMMainPhoto!)
            totalHeight += screenWidth*0.9
            
            let imgStr = getImageURL(feed["photos"][0]["name"].stringValue, width: 0)
            
            cache.fetch(URL: imgStr).onSuccess({ (data) in
                self.FMMainPhoto?.image = UIImage(data: data as Data)
                
                if feed["photos"][0]["name"].stringValue == "" {
                    self.FMMainPhoto?.image = UIImage(named: "logo-default")
                }else{
                    self.FMMainPhoto?.hnk_setImageFromURL(imgStr)
                }
                self.FMMainPhoto?.isUserInteractionEnabled = true
                let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(PhotosOTG2.openSinglePhoto(_:)))
                self.FMMainPhoto?.addGestureRecognizer(tapGestureRecognizer)
                self.FMMainPhoto?.tag = 0
                
                self.layoutSubviews()
            })
        }
            
        else{
            if feed["imageUrl"] != nil {
                self.FMMainPhoto = UIImageView(frame: CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9))
                self.FMMainPhoto?.contentMode = UIViewContentMode.scaleAspectFill
                self.FMMainPhoto?.clipsToBounds = true
                self.FMMainPhoto?.image = UIImage(named: "logo-default")
                self.contentView.addSubview(self.FMMainPhoto!)
                totalHeight += screenWidth*0.9
                
                if feed["thoughts"] == nil || feed["thoughts"].stringValue == "" || feed["imageUrl"] != nil{
                    FMHeaderTag = ActivityHeaderTag(frame: CGRect(x: 0, y: 30, width: screenWidth, height: 28))
                    FMHeaderTag?.tagParent.backgroundColor = UIColor.clear
                    FMHeaderTag?.colorTag(feed: feed)
                    
                    self.FMMainPhoto?.addSubview(FMHeaderTag!)
                }
                
                FMMainPhoto?.hnk_setImageFromURL(URL(string: feed["imageUrl"].stringValue)!)
            }
        }
        
        
        //End of Image
        var showImageIndexStart = 1
        if(feed["videos"].count > 0) {
            showImageIndexStart = 0
        }
        //Center Generation Only
        if(feed["photos"].count > showImageIndexStart) {
            FMCenterView = PhotosOTGView(frame: CGRect(x: 0, y: totalHeight, width: self.frame.width, height: 90))
            addPhotoToLayout(feed,startIndex:showImageIndexStart)
            self.contentView.addSubview(FMCenterView!)
            totalHeight += 90
        }
        //End of Center
    }
    
    func addPhotoToLayout(_ post: JSON, startIndex: Int) {
        FMCenterView?.horizontalScrollForPhotos.removeAll()
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
            FMCenterView?.horizontalScrollForPhotos.addSubview(photosButton)
        }
        FMCenterView?.horizontalScrollForPhotos.layoutSubviews()
        FMCenterView?.morePhotosView.contentSize = CGSize(width: (FMCenterView?.horizontalScrollForPhotos.frame.width)!, height: (FMCenterView?.horizontalScrollForPhotos.frame.height)!)
    }
    
    
    //MARK: - Actions
    
    func openSinglePhoto(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.fetchType = photoVCType.FROM_ACTIVITY
        singlePhotoController.index = sender.view.tag
//        singlePhotoController.postId = feeds["_id"].stringValue
        globalNavigationController.pushViewController(singlePhotoController, animated: true)
    } 
    
    func openSingleVideo(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.fetchType = photoVCType.FROM_ACTIVITY
        singlePhotoController.index = sender.view.tag
        singlePhotoController.type = "Video"
//        singlePhotoController.postId = feeds["_id"].stringValue
        globalNavigationController.pushViewController(singlePhotoController, animated: true)
    }
    
}
