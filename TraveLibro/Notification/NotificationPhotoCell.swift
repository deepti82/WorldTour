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
    }
    
    
    //MARK: - Create View
    
    func createView(notificationData: JSON, helper: NotificationSubViewController) {
        
        var yPos = 10
        var width: Int = Int(self.frame.size.width)
        width = Int(UIScreen.main.bounds.width)
        
        let NFBackground = NotificationBackground(frame: CGRect(x: 0, y: 0, width: width, height: 200))
        self.contentView.addSubview(NFBackground)
        
        NFHeader = notificationHeader(frame: CGRect(x: 0, y: yPos, width: width, height: Int(HEADER_HEIGHT))) as notificationHeader
        self.contentView.addSubview(NFHeader)        
        yPos = yPos + Int(NFHeader.frame.size.height)
        
        NFTitle = NotificationTitle(frame: CGRect(x: 0, y: yPos, width: width, height: 50)) as NotificationTitle
        self.contentView.addSubview(NFTitle)
        yPos = yPos + Int(NFTitle.frame.size.height)
        
        NFPhoto = NotificationCommentPhoto(frame: CGRect(x: 0, y: yPos, width: width, height: (width/2 - 20)))
        self.contentView.addSubview(NFPhoto)
        yPos = yPos + Int(NFPhoto.frame.size.height)
        
        NFFooter = NotificationFooter(frame: CGRect(x: 0, y: yPos, width: width, height: 15))        
        self.contentView.addSubview(NFFooter)
        
        setData(notificationData: notificationData, helper: helper)
    }
    
    
    func setData(notificationData: JSON, helper: NotificationSubViewController) {
        if NFHeader == nil {
            createView(notificationData: notificationData, helper: helper)
        }
        _notificationData = notificationData
        
        NFHeader.setHeaderData(data: notificationData)
        
        NFTitle.setMessageLabel(data: notificationData)
    }


}
