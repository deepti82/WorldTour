//
//  NotificationAcknolwdgementCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 16/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

//NOTE: This is a cell with Header, titleMessage and footer
//Example : Andrea Christina has commented on your On The Go Activity

class NotificationAcknolwdgementCell: UITableViewCell {
    
    var NFHeader = notificationHeader()
    var NFTitle = NotificationTitle()
    var NFFooter = NotificationFooter()
    var NFTime = NotificationTime()    
    var NFBackground = NotificationBackground()
    var totalHeight = CGFloat(0)
//    var blr: UIView!
//    var blurView: UIVisualEffectView!
    
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
        
        NFTitle = NotificationTitle(frame: CGRect.zero) as NotificationTitle
        self.contentView.addSubview(NFTitle)
        yPos = yPos + Int(NFTitle.frame.size.height)       
        
        NFTime = NotificationTime(frame: CGRect.zero) as NotificationTime
        self.contentView.addSubview(NFTime)       
        
        NFFooter = NotificationFooter(frame: CGRect(x: 0, y: yPos, width: width, height: Int(FOOTER_HEIGHT)))        
        self.contentView.addSubview(NFFooter)
        yPos = yPos + Int(NFFooter.frame.size.height)
        
        NFBackground = NotificationBackground(frame: CGRect(x: 0, y: 0, width: width, height: yPos))
        self.contentView.addSubview(NFBackground)
        self.contentView.sendSubview(toBack: NFBackground)
        
//        blr = UIView()
//        
//        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.light)
//        blurView = UIVisualEffectView(effect: darkBlur)
//        
//        blurView.isUserInteractionEnabled = false               
//        blr.addSubview(blurView)
//        blr.addSubview(NFBackground)
//        self.addSubview(blr)
//        self.sendSubview(toBack: blr)
        
        if notificationData != nil {
            setData(notificationData: notificationData!, helper: helper!)            
        }
        
        self.backgroundColor = UIColor(white: 1, alpha: 0.8)
    }
    
    
    func setData(notificationData: JSON, helper: NotificationSubViewController) {        
        
        totalHeight = CGFloat(0)
        
        NFHeader.frame = CGRect(x: 0, y: 0, width: Int(HEADER_HEIGHT), height: Int(HEADER_HEIGHT))
        NFHeader.setHeaderData(data: notificationData)
        let xPos = NFHeader.frame.origin.x + NFHeader.frame.size.width
        
        if notificationData["type"] == "userBadge" {
            
            let message = getRegularString(string: "Congratulations! You have moved from  ", size: 12)        
            let from = notificationData["data"]["from"].stringValue        
            message.append(getBoldString(string: from, size: 12))
            
            message.append(getRegularString(string: " to ", size: 12))
            
            let to = notificationData["data"]["to"].stringValue        
            message.append(getBoldString(string: to, size: 12))
            
            message.append(getRegularString(string: ". Hope you enjoy your status and grow in your journeys.", size: 12))
            
            let messageHeight = CGFloat(50)
            NFTitle.NFMessageLabel.attributedText = message
            NFTitle.NFMessageLabel.frame = CGRect(x: 0, y: 0, width: screenWidth - xPos - 10, height: messageHeight) 
            NFTitle.frame = CGRect(x: xPos, y: totalHeight, width: screenWidth - xPos, height: messageHeight + 10)                
            totalHeight += messageHeight
            
        }
        else{
            let titleHeight = NFTitle.setMessageLabel(data: notificationData)
            //        NFTitle.frame = CGRect(x: xPos, y: 0, width: screenWidth - xPos, height: titleHeight)
            NFTitle.frame = CGRect(x: xPos, y: 0, width: screenWidth - xPos - IMAGE_HEIGHT, height: titleHeight)
            totalHeight += titleHeight
        }
        
        totalHeight += CGFloat(8)
        
        NFTime.frame = CGRect(x: xPos, y: totalHeight, width: screenWidth - xPos, height: TIME_HEIGHT)
        NFTime.setTimeData(date: notificationData["updatedAt"].stringValue)
        
        NFFooter.updateReadStatus(read: notificationData["answeredStatus"].stringValue)
        NFFooter.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: FOOTER_HEIGHT)
        totalHeight += CGFloat(FOOTER_HEIGHT)
        
        totalHeight += CGFloat(3)
        
        totalHeight = max(totalHeight, (NFHeader.frame.origin.y + NFHeader.frame.size.height + 5))
        NFBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
        
//        blurView.frame.size.height = totalHeight
//        blurView.frame.size.width = screenWidth
//        blr.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }
}
