//
//  NotificationFollowCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 16/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

//NOTE: This is a cell with Header, titleMessage, followDetails, two buttons and footer
//Example : Andrea Christina has requested to follow your travel and local activities

class NotificationFollowCell: UITableViewCell {
    
    var NFHeader = notificationHeader()
    var NFTitle = NotificationTitle()
//    var NFFollowDetails = NotificationFollowingDetails()
    var NFFollow = NotificationUserFollowing()
    var NFFooter = NotificationFooter()
    var NFTime = NotificationTime()     
    var NFBackground = NotificationBackground()
    var totalHeight = CGFloat(0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String, notificationData: JSON, helper: NotificationSubViewController){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        createView(notificationData: notificationData, helper: helper)        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView(notificationData: nil, helper: nil)
    }
    
    
    //MARK: - Create View
    
    func createView(notificationData: JSON?, helper: NotificationSubViewController?) {
        
        var yPos = 0
        var width: Int = Int(self.frame.size.width)
        width = Int(UIScreen.main.bounds.width)
        
        NFHeader = notificationHeader(frame: CGRect(x: 0, y: yPos, width: Int(HEADER_HEIGHT), height: Int(HEADER_HEIGHT))) as notificationHeader
        self.contentView.addSubview(NFHeader)        
//        yPos = yPos + Int(NFHeader.frame.size.height)
        
        NFTitle = NotificationTitle(frame: CGRect(x: 0, y: yPos, width: width, height: Int(TITLE_HEIGHT))) as NotificationTitle
        self.contentView.addSubview(NFTitle)
        yPos = yPos + Int(NFTitle.frame.size.height)
        
//        NFFollowDetails = NotificationFollowingDetails(frame: CGRect(x: 0, y: yPos, width: width, height: 90)) as NotificationFollowingDetails
//        self.contentView.addSubview(NFFollowDetails)
//        yPos = yPos + Int(NFFollowDetails.frame.size.height)
        
        NFFollow = NotificationUserFollowing(frame: CGRect(x: 0, y: yPos, width: width, height: 40)) as NotificationUserFollowing
        self.contentView.addSubview(NFFollow)
        yPos = yPos + Int(NFFollow.frame.size.height)
        
        NFTime = NotificationTime(frame: CGRect.zero) as NotificationTime
        self.contentView.addSubview(NFTime)
        
        NFFooter = NotificationFooter(frame: CGRect(x: 0, y: yPos, width: width, height: Int(FOOTER_HEIGHT)))        
        self.contentView.addSubview(NFFooter)
        yPos = yPos + Int(NFFooter.frame.size.height)
        
        NFBackground = NotificationBackground(frame: CGRect(x: 0, y: 0, width: width, height: yPos))
        self.contentView.addSubview(NFBackground)
        self.contentView.sendSubview(toBack: NFBackground)
        
        
        if notificationData != nil {
            setData(notificationData: notificationData!, helper: helper!)            
        }
    }    
    
    func setData(notificationData: JSON, helper: NotificationSubViewController) {
        
        print("\n data : \(notificationData)")
        totalHeight = CGFloat(0)
        
        NFHeader.setHeaderData(data: notificationData)
        let xPos = NFHeader.frame.origin.x + NFHeader.frame.size.width
        
        let titleHeight = NFTitle.setMessageLabel(data: notificationData)
//        NFTitle.frame = CGRect(x: xPos, y: 0, width: screenWidth - xPos - (IMAGE_HEIGHT + CGFloat(20)), height: titleHeight)
        NFTitle.frame = CGRect(x: xPos, y: 0, width: screenWidth - xPos - IMAGE_HEIGHT, height: titleHeight)
        totalHeight += CGFloat(titleHeight)
        
//        NFFollowDetails.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: DETAILS_HEIGHT)
//        totalHeight += DETAILS_HEIGHT
        
        NFFollow.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: BUTTON_HEIGHT)
        totalHeight += CGFloat(BUTTON_HEIGHT)
        
        NFTime.frame = CGRect(x: xPos, y: totalHeight, width: screenWidth - xPos, height: TIME_HEIGHT)
        NFTime.setTimeData(date: notificationData["updatedAt"].stringValue)
        
        NFFooter.updateReadStatus(read: notificationData["status"].stringValue)
        NFFooter.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: FOOTER_HEIGHT)
        totalHeight += CGFloat(FOOTER_HEIGHT)
        
        totalHeight += CGFloat(8)
        
        NFBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }

}
