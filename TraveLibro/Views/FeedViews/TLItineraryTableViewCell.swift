//
//  TLItineraryTableViewCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 04/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TLItineraryTableViewCell: UITableViewCell, TLFooterDelegate {

    var FProfileHeader: ActivityProfileHeader!
    var FBackground = NotificationBackground()    
    var FTextHeader: TLFeedHeaderTextFlagView!
    var FMiddleView: TLItinerayPostView!
    var FFooterViewBasic: ActivityFeedFooterBasic!
    
    var totalHeight = CGFloat(0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String, feedData: JSON, helper: TLMainFeedsViewController){
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
    
    func createView(feedData: JSON?, helper: TLMainFeedsViewController?) {
        
        FProfileHeader = ActivityProfileHeader(frame: CGRect(x: 0, y: 0, width: screenWidth, height: FEEDS_HEADER_HEIGHT))
        self.contentView.addSubview(FProfileHeader)
        
        FTextHeader = TLFeedHeaderTextFlagView(frame: CGRect(x: 0, y: totalHeight, width: screenWidth, height: 21))
        self.contentView.addSubview(FTextHeader)
        
        FMiddleView = TLItinerayPostView(frame: CGRect.zero)
        self.contentView.addSubview(FMiddleView)
        
        FFooterViewBasic = ActivityFeedFooterBasic(frame: CGRect.zero)
        self.contentView.addSubview(FFooterViewBasic)
        
        FBackground = NotificationBackground(frame: CGRect.zero)
        self.contentView.addSubview(FBackground)
        self.contentView.sendSubview(toBack: FBackground)
        
        if feedData != nil {
            setData(feedData: feedData!, helper: helper!, pageType: nil)            
        }
    }    
    
    func setData(feedData: JSON, helper: TLMainFeedsViewController, pageType: viewType?) {        
        
        print("\n FeedData : \(feedData) \n\n")
        
        totalHeight = CGFloat(0)
        
        if pageType == viewType.VIEW_TYPE_ACTIVITY {
            FProfileHeader.frame = CGRect(x: 0, y: 0, width: screenWidth, height: FEEDS_HEADER_HEIGHT)        
            FProfileHeader.parentController = helper
            FProfileHeader.fillProfileHeader(feed: feedData, pageType: pageType, cellType: feedCellType.CELL_ITINERARY_TYPE)
            totalHeight += FEEDS_HEADER_HEIGHT
        }
        else {
            FProfileHeader.frame = CGRect.zero
        }
        
        FTextHeader.setFlag(feed: feedData)
        FTextHeader.displayText = getTextHeader(feed: feedData, pageType: pageType!)        
        FTextHeader.setText(text: FTextHeader.displayText)
        
        var textHeight = (heightOfAttributedText(attributedString: FTextHeader.displayText, width: screenWidth) + 10)
        textHeight = ((feedData["countryVisited"].arrayValue).isEmpty) ? textHeight : max(textHeight, 36)        
        FTextHeader.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: textHeight)
        FTextHeader.headerTextView.frame = CGRect(x: 8, y: 0, width: screenWidth-(FTextHeader.flagStackView.frame.size.width)-13, height: textHeight)       
        
        FTextHeader.headerTextView.center = CGPoint(x: FTextHeader.headerTextView.center.x, y: FTextHeader.flagStackView.center.y)
        totalHeight += textHeight
        
        
        FMiddleView.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9)
        FMiddleView.fillData(feed: feedData, pageType: pageType!)
        totalHeight += screenWidth*0.9
        
        
        FFooterViewBasic.parentController = helper
        FFooterViewBasic.fillFeedFooter(feed: feedData, pageType: pageType, delegate: self)
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
    
    
    //MARK: - Delegate Actions
    
    func footerOptionButtonClicked(sender: UIButton) {
        print("\n Option button clicked")
    }

}
