//
//  TLOTGPhotosTableViewCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 16/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TLOTGPhotosTableViewCell: UITableViewCell {

    var FBackground: NotificationBackground!
    var FProfileHeader: TripPhotoHeader!
    var FMiddleImageView: UIImageView!
    var FMiddlePlayButton: UIImageView!
    var FFooterViewBasic: ActivityFeedFooterBasic!
    
    var totalHeight = CGFloat(0)
    var parentController: UIViewController!
    
    var feeds: JSON!
    var willPlay = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String, feedData: JSON, contentType: contentType, helper: UIViewController){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createView(feedData: feedData, contentType: contentType, helper: helper)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
        createView(feedData: nil, contentType: nil, helper: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if FMiddleImageView != nil {
            FMiddleImageView.frame = CGRect.zero
        }
    }
    
    
    
    
    //MARK: - Create View
    
    func createView(feedData: JSON?, contentType: contentType?, helper: UIViewController?) {
        
        FProfileHeader = TripPhotoHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: FEEDS_HEADER_HEIGHT))
        FProfileHeader.timeLabel.text = String(format: "%C", faicon["clock"]!)
        self.contentView.addSubview(FProfileHeader)
        
        FMiddleImageView = UIImageView(frame: CGRect.zero)
        FMiddleImageView.contentMode = UIViewContentMode.scaleAspectFill
        FMiddleImageView.clipsToBounds = true
        self.contentView.addSubview(FMiddleImageView!)
        
        FMiddlePlayButton = UIImageView(frame: CGRect.zero)
        FMiddlePlayButton.image = UIImage(named: "red_video_play_icon")
        FMiddlePlayButton.tintColor = mainOrangeColor
        FMiddlePlayButton.contentMode = UIViewContentMode.scaleAspectFill
        FMiddlePlayButton.clipsToBounds = true
        self.contentView.addSubview(FMiddlePlayButton!)
        
        FFooterViewBasic = ActivityFeedFooterBasic(frame: CGRect.zero)
        self.contentView.addSubview(FFooterViewBasic)
        
        FBackground = NotificationBackground(frame: CGRect.zero)
        self.contentView.addSubview(FBackground)
        self.contentView.sendSubview(toBack: FBackground)
        
        if feedData != nil {
            setData(feedData: feedData!, currentContentType: contentType, helper: helper!, delegate: nil)            
        }
    }
    
    func setData(feedData: JSON, currentContentType: contentType?, helper: UIViewController, delegate: TLFooterBasicDelegate?) {        
        
        self.feeds = feedData
        self.parentController = helper
        
        totalHeight = CGFloat(0)
        
        FProfileHeader.frame = CGRect(x: 0, y: 0, width: screenWidth, height: FEEDS_HEADER_HEIGHT)
        FProfileHeader.fillProfileHeader(feed:self.feeds)
        FProfileHeader.layer.zPosition = 100
        totalHeight += FEEDS_HEADER_HEIGHT
        
        FMiddleImageView?.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9)
        
        if currentContentType == contentType.TL_CONTENT_IMAGE_TYPE {
            FMiddleImageView.sd_setImage(with: getImageURL(self.feeds["name"].stringValue, width: BIG_PHOTO_WIDTH), placeholderImage: getPlaceholderImage())
            FMiddlePlayButton.frame = CGRect.zero
            FMiddlePlayButton.isHidden = true
        }
        else {
            FMiddleImageView.sd_setImage(with: getImageURL(self.feeds["thumbnail"].stringValue, width: BIG_PHOTO_WIDTH), placeholderImage: getPlaceholderImage())
            FMiddlePlayButton.isHidden = false
            FMiddlePlayButton.frame = CGRect(x: 0, y: 0, width: FMiddleImageView.frame.size.width*0.2, height: FMiddleImageView.frame.size.width*0.15)
            FMiddlePlayButton.center = FMiddleImageView.center
        }
        totalHeight += screenWidth*0.9
        
        FFooterViewBasic.parentController = helper
        FFooterViewBasic.fillFeedFooter(feed: feedData, pageType: viewType.VIEW_TYPE_OTG_CONTENTS, delegate: delegate!)
        FFooterViewBasic.footerType = (currentContentType == contentType.TL_CONTENT_IMAGE_TYPE) ? "photos" : "videos"
        FFooterViewBasic.photoId = self.feeds["_id"].stringValue
        FFooterViewBasic.photoPostId = self.feeds["post"].stringValue
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
        
        FBackground.frame = CGRect(x: 0, y: 33, width: screenWidth, height: (totalHeight-33))
    }
    
}
