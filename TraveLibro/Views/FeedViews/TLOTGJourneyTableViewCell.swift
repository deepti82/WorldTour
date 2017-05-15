//
//  TLOTGJourneyTableViewCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 02/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TLOTGJourneyTableViewCell: UITableViewCell {

    var FBackground: NotificationBackground!
    var FProfileHeader: ActivityProfileHeader!
    var FTextHeader: TLFeedHeaderTextFlagView!
    var FMiddleView: ActivityFeedImageView!
    var FFooterViewBasic: ActivityFeedFooterBasic!
    var FUploadingView: UploadingToCloud?
    
    var totalHeight = CGFloat(0)
    
    var feeds: JSON!
    
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
        
        self.FTextHeader.headerTextView.text = ""
        self.FTextHeader.headerTextView.attributedText = getRegularString(string: "", size: TL_REGULAR_FONT_SIZE)
        
        for imgView in self.FTextHeader.flagImageArray {
            imgView.image = nil
            imgView.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    
    //MARK: - Create View
    
    func createView(feedData: JSON?, helper: UIViewController?) {
        
        FProfileHeader = ActivityProfileHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: FEEDS_HEADER_HEIGHT))
        self.contentView.addSubview(FProfileHeader)
        
        FTextHeader = TLFeedHeaderTextFlagView(frame: CGRect(x: 0, y: totalHeight, width: screenWidth, height: 21))
        self.contentView.addSubview(FTextHeader)
        
        FMiddleView = ActivityFeedImageView(frame: CGRect.zero)
        self.contentView.addSubview(FMiddleView)
        
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
        
        FTextHeader.setFlag(feed: feedData)
        FTextHeader.displayText = getTextHeader(feed: feedData, pageType: pageType!)        
        FTextHeader.setText(text: FTextHeader.displayText)
        
        var textHeight = (heightOfAttributedText(attributedString: FTextHeader.displayText, width: (screenWidth-21)) + 10)
        textHeight = ((feedData["countryVisited"].arrayValue).isEmpty) ? textHeight : max(textHeight, 36)        
        FTextHeader.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: textHeight)
        FTextHeader.headerTextView.frame = CGRect(x: 8, y: 0, width: screenWidth-(FTextHeader.flagStackView.frame.size.width)-13, height: textHeight)       
        
        FTextHeader.headerTextView.center = CGPoint(x: FTextHeader.headerTextView.center.x, y: FTextHeader.flagStackView.center.y)
        totalHeight += textHeight
        
        
        FMiddleView.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9)
        FMiddleView.fillData(feed: feedData)
        FMiddleView.headerTagTextLabel.isHidden = false
        if pageType == viewType.VIEW_TYPE_POPULAR_JOURNEY ||
            pageType == viewType.VIEW_TYPE_MY_LIFE {
            FMiddleView.headerTagTextLabel.isHidden = true
        }
        totalHeight += screenWidth*0.9
        
        
        FFooterViewBasic.parentController = helper
        FFooterViewBasic.fillFeedFooter(feed: feedData, pageType: pageType, delegate: delegate!)
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
        
        
        if isLocalFeed(feed: feedData) {
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

}
