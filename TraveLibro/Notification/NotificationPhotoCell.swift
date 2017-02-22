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

    var _notificationData: JSON? 
    var NFHeader = notificationHeader()
    var NFTitle = NotificationTitle()
    var NFPhoto = NotificationCommentPhoto()
    var NFFooter = NotificationFooter()
    
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
        
        NFPhoto = NotificationCommentPhoto(frame: CGRect(x: 0, y: yPos, width: width, height: min((width-10), Int(IMAGE_HEIGHT) ) ))
        self.contentView.addSubview(NFPhoto)
        yPos = yPos + Int(NFPhoto.frame.size.height)
        
        NFFooter = NotificationFooter(frame: CGRect(x: 0, y: yPos, width: width, height: Int(FOOTER_HEIGHT)))        
        self.contentView.addSubview(NFFooter)
        yPos = yPos + Int(NFFooter.frame.size.height)
        
        let NFBackground = NotificationBackground(frame: CGRect(x: 0, y: 0, width: width, height: yPos))
        self.contentView.addSubview(NFBackground)
        self.contentView.sendSubview(toBack: NFBackground)
        
        if notificationData != nil {
            setData(notificationData: notificationData!, helper: helper!)            
        }
    }
    
    
    func setData(notificationData: JSON, helper: NotificationSubViewController) {
        
        _notificationData = notificationData
        
        NFHeader.setHeaderData(data: notificationData)
        
        NFTitle.setMessageLabel(data: notificationData)
        
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
            NFPhoto.NFPhotoImage.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(imageURL!)", width: 100))
        }
        else{
            NFPhoto.setPhoto(data: notificationData["data"])
        }
        
        NFFooter.updateReadStatus(read: notificationData["status"].stringValue)
    }


}
