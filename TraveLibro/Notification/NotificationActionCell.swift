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
    var NFTime = NotificationTime()    
    var totalHeight = CGFloat(0)
//    var blr: UIView!
//    var blurView: UIVisualEffectView!
    
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
        
        var yPos = 0
        var width: Int = Int(self.frame.size.width)
        width = Int(UIScreen.main.bounds.width)
        
        NFHeader = notificationHeader(frame: CGRect(x: 0, y: yPos, width: Int(HEADER_HEIGHT), height: Int(HEADER_HEIGHT))) as notificationHeader
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
        
        let titleHeight = NFTitle.setMessageLabel(data: notificationData)
//        NFTitle.frame = CGRect(x: xPos, y: 0, width: screenWidth - xPos, height: titleHeight)
        NFTitle.frame = CGRect(x: xPos, y: 0, width: screenWidth - xPos - IMAGE_HEIGHT, height: titleHeight)
        totalHeight += titleHeight
        
        NFPermission.NFLeftButton.removeTarget(helper, action: #selector(helper.journeyEndTabbed(_:)), for: .touchUpInside)
        NFPermission.NFLeftButton.removeTarget(helper, action: #selector(helper.journeyAcceptTabbed(_:)), for: .touchUpInside)
        NFPermission.NFLeftButton.removeTarget(helper, action: #selector(helper.itineraryAcceptTabbed(_:)), for: .touchUpInside)
        
        NFPermission.NFRightButton.removeTarget(helper, action: #selector(helper.journeyEndDeclined(_:)), for: .touchUpInside)
        NFPermission.NFRightButton.removeTarget(helper, action: #selector(helper.journeyDeclineTabbed(_:)), for: .touchUpInside)
        NFPermission.NFRightButton.removeTarget(helper, action: #selector(helper.itineraryDeclinedTabbed(_:)), for: .touchUpInside)
        
        NFPermission.NFViewButton.removeTarget(helper, action: #selector(helper.itineraryViewTabbed(_:)), for: .touchUpInside)
        
        NFPermission.NFViewButton.isHidden = true
        
        if notificationData["answeredStatus"].stringValue == "" {
            
            NFPermission.NFLeftButton.isHidden = false
            NFPermission.NFRightButton.isHidden = false
            NFPermission.NFStatusLabel.isHidden = true
            
            if notificationData["type"] == "journeyLeft" {
                
                let msg = "Would you like to end your journey as well?"
                let messageHeight = (heightForView(text: msg, font: NFMessage.NFMessageLabel.font, width: screenWidth - xPos) + CGFloat(10))
                NFMessage.NFMessageLabel.attributedText = getRegularString(string: msg, size: 12)
                
                NFMessage.NFMessageLabel.frame = CGRect(x: 0, y: 0, width: screenWidth - xPos - 10, height: messageHeight)
                NFMessage.frame = CGRect(x: xPos, y: totalHeight, width: screenWidth - xPos, height: messageHeight)        
                totalHeight += messageHeight            
                
                NFPermission.NFLeftButton.setTitle("End", for: .normal)
                NFPermission.NFLeftButton.addTarget(helper, action: #selector(helper.journeyEndTabbed(_:)), for: .touchUpInside)
                
                NFPermission.NFRightButton.setTitle("Decline", for: .normal)
                NFPermission.NFRightButton.addTarget(helper, action: #selector(helper.journeyEndDeclined(_:)), for: .touchUpInside)            
            }
            else if notificationData["type"] == "journeyRequest" {
                
                NFMessage.frame = CGRect.zero
                
                NFPermission.NFLeftButton.setTitle("Accept", for: .normal)
                NFPermission.NFLeftButton.addTarget(helper, action: #selector(helper.journeyAcceptTabbed(_:)), for: .touchUpInside)
                
                NFPermission.NFRightButton.setTitle("Decline", for: .normal)
                NFPermission.NFRightButton.addTarget(helper, action: #selector(helper.journeyDeclineTabbed(_:)), for: .touchUpInside)
            }
            else if notificationData["type"] == "itineraryRequest" {
                
                NFPermission.NFViewButton.isHidden = false
                NFPermission.NFViewButtonXpos.constant = 156
                
                NFMessage.frame = CGRect.zero
                
                NFPermission.NFLeftButton.setTitle("Accept", for: .normal)
                NFPermission.NFLeftButton.addTarget(helper, action: #selector(helper.itineraryAcceptTabbed(_:)), for: .touchUpInside)
                
                NFPermission.NFRightButton.setTitle("Decline", for: .normal)
                NFPermission.NFRightButton.addTarget(helper, action: #selector(helper.itineraryDeclinedTabbed(_:)), for: .touchUpInside)
                
                NFPermission.NFViewButton.setTitle("View", for: .normal)
                NFPermission.NFViewButton.addTarget(helper, action: #selector(helper.itineraryViewTabbed(_:)), for: .touchUpInside)
            }
        }
        else {
            NFMessage.frame = CGRect.zero
            
            NFPermission.NFLeftButton.isHidden = true
            NFPermission.NFRightButton.isHidden = true
            NFPermission.NFStatusLabel.isHidden = false
            
            if notificationData["type"] == "journeyLeft"{
                NFPermission.NFStatusLabel.text = notificationData["answeredStatus"].stringValue == "accept" ? " Ended " : " Declined "
                print(notificationData)
            }
            else if notificationData["type"] == "journeyRequest"{
                NFPermission.NFStatusLabel.text = notificationData["answeredStatus"].stringValue == "reject" ? " Rejected " : " Accepted "
            }
            else if notificationData["type"] == "itineraryRequest"{
                
                if (notificationData["answeredStatus"].stringValue != "reject") {
                    NFPermission.NFViewButton.isHidden = false
                    NFPermission.NFViewButtonXpos.constant = 78
                }
                
                NFPermission.NFStatusLabel.text = notificationData["answeredStatus"].stringValue == "reject" ? " Rejected " : " Accepted "
                
                NFPermission.NFViewButton.setTitle("View", for: .normal)
                NFPermission.NFViewButton.addTarget(helper, action: #selector(helper.itineraryViewTabbed(_:)), for: .touchUpInside)
            } 
        }
        
        NFPermission.frame = CGRect(x: xPos, y: totalHeight, width: screenWidth - xPos, height: BUTTON_HEIGHT)
        totalHeight += BUTTON_HEIGHT
        
        NFTime.frame = CGRect(x: xPos, y: totalHeight, width: screenWidth - xPos, height: TIME_HEIGHT)
        NFTime.setTimeData(date: notificationData["updatedAt"].stringValue)
        
        NFFooter.updateReadStatus(read: notificationData["answeredStatus"].stringValue)
        NFFooter.frame = CGRect(x: 0, y: totalHeight, width: screenWidth, height: FOOTER_HEIGHT)
        totalHeight += CGFloat(FOOTER_HEIGHT)
        
        totalHeight += CGFloat(8)
        
        NFBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
        
//        blurView.frame.size.height = totalHeight
//        blurView.frame.size.width = screenWidth
//        blr.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }
}
