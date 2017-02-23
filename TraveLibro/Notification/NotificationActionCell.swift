//
//  NotificationActionCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 16/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

//NOTE: This is a cell with Header, titleMessage, two buttons and footer 

class NotificationActionCell: UITableViewCell {
    
    var NFHeader = notificationHeader()
    var NFTitle = NotificationTitle()
    var NFMessage = NotificationTitle()
    var NFPermission = NotificationFollowPermission()
    var NFFooter = NotificationFooter()
    var NFBackground = NotificationBackground()
    var totalHeight = CGFloat(0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        NFMessage = NotificationTitle(frame: CGRect(x: 0, y: yPos, width: width, height: Int(TITLE_HEIGHT))) as NotificationTitle
        self.contentView.addSubview(NFMessage)
        yPos = yPos + Int(NFMessage.frame.size.height)
        
        NFPermission = NotificationFollowPermission(frame: CGRect(x: 0, y: yPos, width: width, height: Int(BUTTON_HEIGHT))) as NotificationFollowPermission
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
        
        if notificationData["answeredStatus"].stringValue == "" {
            
            NFPermission.NFLeftButton.isHidden = false
            NFPermission.NFRightButton.isHidden = false
            NFPermission.NFStatusLabel.isHidden = true
            
            if notificationData["type"] == "journeyLeft" {
                
                let msg = "Would you like to end your journey as well?"
                let messageHeight = (heightForView(text: msg, font: NFMessage.NFMessageLabel.font, width: screenWidth) + CGFloat(10))
                NFMessage.NFMessageLabel.text = msg
                NFMessage.NFMessageLabel.sizeToFit()
                NFMessage.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: messageHeight)        
                totalHeight += messageHeight            
                
                NFPermission.NFLeftButton.setTitle("End", for: .normal)
                NFPermission.NFLeftButton.addTarget(helper, action: #selector(helper.journeyEndTabbed(_:)), for: .touchUpInside)
                
                NFPermission.NFRightButton.setTitle("Decline", for: .normal)
                NFPermission.NFRightButton.addTarget(helper, action: #selector(helper.journeyEndDeclined(_:)), for: .touchUpInside)            
            }
            else if notificationData["type"] == "journeyRequest" {
                
                let message = NSMutableAttributedString(string: "Accept ")        
                let firstName = notificationData["userFrom"]["name"].stringValue        
                message.append(getBoldString(string: firstName))
                
                message.append(getRegularString(string: "'s request to create your travel memories together. "))
                
                let messageHeight = (heightForView(text: "Accept"+firstName+"'s request to create your travel memories together.        ", font: NFMessage.NFMessageLabel.font, width: screenWidth) + CGFloat(10))
                NFMessage.NFMessageLabel.attributedText = message
                NFMessage.NFMessageLabel.sizeToFit()
                NFMessage.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: messageHeight)
                totalHeight += messageHeight
                
                
                NFPermission.NFLeftButton.setTitle("Accept", for: .normal)
                NFPermission.NFLeftButton.addTarget(helper, action: #selector(helper.journeyAcceptTabbed(_:)), for: .touchUpInside)
                
                NFPermission.NFRightButton.setTitle("Decline", for: .normal)
                NFPermission.NFRightButton.addTarget(helper, action: #selector(helper.journeyDeclineTabbed(_:)), for: .touchUpInside)
            }            
        }
        else {
            NFMessage.frame = CGRect.zero
            
            NFPermission.NFLeftButton.isHidden = true
            NFPermission.NFRightButton.isHidden = true
            NFPermission.NFStatusLabel.isHidden = false
            
            if notificationData["type"] == "journeyLeft"{
                NFPermission.NFStatusLabel.text = notificationData["answeredStatus"].stringValue == "accept" ? "This journey is ended" : "This journey is declined"
                print(notificationData)
            }
            else if notificationData["type"] == "journeyRequest"{
                NFPermission.NFStatusLabel.text = notificationData["answeredStatus"].stringValue == "reject" ? "This request is Rejected " : "This request is Accepted"
            }
            
        }
        
        NFPermission.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: BUTTON_HEIGHT)
        totalHeight += BUTTON_HEIGHT
        
        NFFooter.updateReadStatus(read: notificationData["status"].stringValue)
        NFFooter.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: FOOTER_HEIGHT)
        totalHeight += CGFloat(FOOTER_HEIGHT)
        
        NFBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)        
    }
}
