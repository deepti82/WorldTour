//
//  NotificationCommentCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 20/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationCommentCell: UITableViewCell {
    
    var NFHeader = notificationHeader()
    var NFTitle = NotificationTitle()
    var NFMessage = NotificationTitle()
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
        
        NFMessage = NotificationTitle(frame: CGRect(x: 0, y: yPos, width: width, height: Int(TITLE_HEIGHT)))
        self.contentView.addSubview(NFMessage)
        yPos = yPos + Int(NFMessage.frame.size.height)
        
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
        
        totalHeight += HEADER_HEIGHT
        
        NFHeader.setHeaderData(data: notificationData)
        
        let titleHeight = NFTitle.setMessageLabel(data: notificationData)
        NFTitle.frame = CGRect(x: 0, y: NFTitle.frame.origin.y, width: screenWidth, height: titleHeight)        
        totalHeight += titleHeight
        
        let messageHeight = (heightForView(text: notificationData["data"]["thoughts"].stringValue, font: NFMessage.NFMessageLabel.font, width: screenWidth) + CGFloat(10))
        NFMessage.NFMessageLabel.text = notificationData["data"]["thoughts"].stringValue
        NFMessage.NFMessageLabel.sizeToFit()
        NFMessage.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: messageHeight)        
        totalHeight += messageHeight
        
        NFFooter.updateReadStatus(read: notificationData["status"].stringValue)
        NFFooter.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: FOOTER_HEIGHT)
        totalHeight += CGFloat(FOOTER_HEIGHT)
        
        NFBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
        
    }

}
