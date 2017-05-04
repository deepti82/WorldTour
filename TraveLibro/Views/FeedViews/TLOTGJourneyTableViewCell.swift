//
//  TLOTGJourneyTableViewCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 02/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TLOTGJourneyTableViewCell: UITableViewCell {

    var FBackground = NotificationBackground()
    var FProfileHeader: ActivityProfileHeader!
    var FTextHeader: TLFeedHeaderTextFlagView!
    var FMiddleView: ActivityFeedImageView!
    var FFooterView: ActivityFeedFooter!
    
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
        
        let hasContentView = self.subviews.contains(self.contentView)
        if hasContentView {
            self.contentView.removeFromSuperview()
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
        
        FFooterView = ActivityFeedFooter(frame: CGRect.zero)
        self.contentView.addSubview(FFooterView)
        
        FBackground = NotificationBackground(frame: CGRect.zero)
        self.contentView.addSubview(FBackground)
        self.contentView.sendSubview(toBack: FBackground)
        
        if feedData != nil {
            setData(feedData: feedData!, helper: helper!, pageType: nil)            
        }
    }
    
    
    func setData(feedData: JSON, helper: UIViewController, pageType: viewType?) {        
        
        totalHeight = CGFloat(0)
        
        FProfileHeader.frame = CGRect(x: 0, y: 0, width: screenWidth, height: FEEDS_HEADER_HEIGHT)        
        FProfileHeader.parentController = helper
        FProfileHeader.fillProfileHeader(feed: feedData)
        totalHeight += FEEDS_HEADER_HEIGHT
        
        
        FTextHeader.setFlag(feed: feedData)
        FTextHeader.displayText = getTextHeader(feed: feedData)        
        FTextHeader.setText(text: FTextHeader.displayText)
        
        var textHeight = (heightOfAttributedText(attributedString: FTextHeader.displayText, width: screenWidth) + 10)
        textHeight = ((feedData["countryVisited"].arrayValue).isEmpty) ? textHeight : max(textHeight, 36)        
        FTextHeader.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: textHeight)
        FTextHeader.headerTextView.frame = CGRect(x: 8, y: 0, width: screenWidth-(FTextHeader.flagStackView.frame.size.width)-13, height: textHeight)       
        
        FTextHeader.headerTextView.center = CGPoint(x: FTextHeader.headerTextView.center.x, y: FTextHeader.flagStackView.center.y)
        totalHeight += textHeight
        
        
        FMiddleView.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: screenWidth*0.9)
        FMiddleView.fillData(feed: feedData)
        FMiddleView.headerTagTextLabel.isHidden = false
        if pageType == viewType.VIEW_TYPE_POPULAR_JOURNEY {
            FMiddleView.headerTagTextLabel.isHidden = true
        }
        totalHeight += screenWidth*0.9
        
        
        FFooterView.parentController = helper
        FFooterView.fillFeedFooter(feed: feedData, pageType: pageType)
        if shouldShowFooterCountView(feed: feedData) {
            FFooterView.lowerViewHeightConstraint.constant = 40
            FFooterView.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: 90)
            totalHeight += 90
        }
        else {
            FFooterView.lowerViewHeightConstraint.constant = 0
            FFooterView.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: 50)
            totalHeight += 50
        }
        
        FBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }

}
