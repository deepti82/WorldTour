//
//  NotificationFollowRequestCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 21/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationFollowRequestCell: UITableViewCell {
    
    var NFHeader = notificationHeader()
    var NFTitle = NotificationTitle()
    var NFFollowDetails = NotificationFollowingDetails()
    var NFPermission = NotificationFollowPermission()
    var NFFooter = NotificationFooter()
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
        
        var yPos = 10
        var width: Int = Int(self.frame.size.width)
        width = Int(UIScreen.main.bounds.width)
        
        NFHeader = notificationHeader(frame: CGRect(x: 0, y: yPos, width: width, height: Int(HEADER_HEIGHT))) as notificationHeader
        self.contentView.addSubview(NFHeader)        
        yPos = yPos + Int(NFHeader.frame.size.height)
        
        NFTitle = NotificationTitle(frame: CGRect(x: 0, y: yPos, width: width, height: Int(TITLE_HEIGHT))) as NotificationTitle
        self.contentView.addSubview(NFTitle)
        yPos = yPos + Int(NFTitle.frame.size.height)
        
        NFFollowDetails = NotificationFollowingDetails(frame: CGRect(x: 0, y: yPos, width: width, height: 90)) as NotificationFollowingDetails
        self.contentView.addSubview(NFFollowDetails)
        yPos = yPos + Int(NFFollowDetails.frame.size.height)
        
        NFPermission = NotificationFollowPermission(frame: CGRect(x: 0, y: yPos, width: width, height: 50)) as NotificationFollowPermission
        self.contentView.addSubview(NFPermission)
        yPos = yPos + Int(NFPermission.frame.size.height)
        
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
        
        totalHeight = CGFloat(10)
        
        NFHeader.setHeaderData(data: notificationData)
        
        totalHeight += HEADER_HEIGHT
        
        let titleHeight = NFTitle.setMessageLabel(data: notificationData)
        NFTitle.frame = CGRect(x: 0, y: NFTitle.frame.origin.y, width: screenWidth, height: titleHeight)        
        totalHeight += titleHeight
        
        NFFollowDetails.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: DETAILS_HEIGHT)
        totalHeight += CGFloat(DETAILS_HEIGHT)
        
        NFPermission.NFLeftButton.isHidden = false
        NFPermission.NFRightButton.isHidden = false
        NFPermission.NFStatusLabel.isHidden = true
        
        NFPermission.NFLeftButton.setTitle("ACCEPT", for: .normal)
        NFPermission.NFLeftButton.addTarget(helper, action: #selector(helper.journeyAcceptTabbed(_:)), for: .touchUpInside)
        
        NFPermission.NFRightButton.setTitle("DECLINE", for: .normal)
        NFPermission.NFRightButton.addTarget(helper, action: #selector(helper.journeyDeclineTabbed(_:)), for: .touchUpInside)
        
        
        NFPermission.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: BUTTON_HEIGHT)
        totalHeight += BUTTON_HEIGHT
        
        NFFooter.updateReadStatus(read: notificationData["status"].stringValue)
        NFFooter.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: FOOTER_HEIGHT)
        totalHeight += CGFloat(FOOTER_HEIGHT)
        
        NFBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }

}
