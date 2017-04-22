//
//  NotificationPhotoCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 16/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

//NOTE: This is a cell with Header, titleMessage, Photos and footer
//Example : Andrea Christina has commented on photo in your local life
//Example : Andrea Christina has added photos of you in On The Go Activity

class NotificationPhotoCell: UITableViewCell {
    
    var NFHeader = notificationHeader()
    var NFTitle = NotificationTitle()
    var NFPhoto = NotificationCommentPhoto()
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
        
        NFTitle = NotificationTitle(frame: CGRect(x: 0, y: 0, width: Int(screenWidth - HEADER_HEIGHT - IMAGE_HEIGHT), height: TITLE_HEIGHT)) as NotificationTitle
        self.contentView.addSubview(NFTitle)
        yPos = yPos + Int(NFTitle.frame.size.height)
        
        NFPhoto = NotificationCommentPhoto(frame: CGRect(x: screenWidth - IMAGE_HEIGHT - CGFloat(30), y: CGFloat(5), width: IMAGE_HEIGHT, height: IMAGE_HEIGHT))
        self.contentView.addSubview(NFPhoto)
        yPos = yPos + Int(NFPhoto.frame.size.height)
        
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
        NFTitle.frame = CGRect(x: xPos, y: 0, width: screenWidth - xPos - IMAGE_HEIGHT, height: titleHeight)        
        
        NFPhoto.NFPhotoImage.image = UIImage(named: "logo-default")
        
        NFPhoto.frame = CGRect(x: screenWidth - IMAGE_HEIGHT, y: CGFloat(0), width: IMAGE_HEIGHT, height: IMAGE_HEIGHT)
        if notificationData["type"] == "journeyMentionComment" ||
            notificationData["type"] == "journeyComment" ||
            notificationData["type"] == "journeyLike" ||
            notificationData["type"] == "journeyAccept" ||
            notificationData["type"] == "itineraryMentionComment" ||
            notificationData["type"] == "itineraryLike" ||
            notificationData["type"] == "itineraryComment" {
            var imageURL = notificationData["data"]["coverPhoto"].string
            if imageURL == nil || imageURL == "" {
                imageURL = notificationData["data"]["startLocationPic"].stringValue
            }
            NFPhoto.NFPlayImage.isHidden = true
            NFPhoto.NFPhotoImage.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(imageURL!)", width: SMALL_PHOTO_WIDTH))
        }
        else{
            NFPhoto.setPhoto(data: notificationData["data"])
        }        
        totalHeight += IMAGE_HEIGHT
        
        NFTime.frame = CGRect(x: xPos, y: IMAGE_HEIGHT - TIME_HEIGHT + 10, width: screenWidth - xPos, height: TIME_HEIGHT)
        NFTime.setTimeData(date: notificationData["updatedAt"].stringValue)
        
        NFFooter.updateReadStatus(read: notificationData["answeredStatus"].stringValue)
        NFFooter.frame = CGRect(x: 0, y: NFTime.frame.origin.y, width: screenWidth, height: FOOTER_HEIGHT)
        
        totalHeight += CGFloat(8)
        
        NFBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)        
        
//        blurView.frame.size.height = totalHeight
//        blurView.frame.size.width = screenWidth
//        blr.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }


}
