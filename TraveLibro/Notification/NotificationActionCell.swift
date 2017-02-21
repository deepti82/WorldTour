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

    var _notificationData: JSON? 
    var NFHeader = notificationHeader()
    var NFTitle = NotificationTitle()
    var NFMessage = NotificationTitle()
    var NFPermission = NotificationFollowPermission()
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
        
        NFHeader = notificationHeader(frame: CGRect(x: 0, y: yPos, width: width, height: Int(HEADER_HEIGHT))) as notificationHeader
        self.contentView.addSubview(NFHeader)        
        yPos = yPos + Int(NFHeader.frame.size.height)
        
        NFTitle = NotificationTitle(frame: CGRect(x: 0, y: yPos, width: width, height: Int(TITLE_HEIGHT))) as NotificationTitle
        self.contentView.addSubview(NFTitle)
        yPos = yPos + Int(NFTitle.frame.size.height)
        
        NFMessage = NotificationTitle(frame: CGRect(x: 0, y: yPos, width: width, height: Int(TITLE_HEIGHT))) as NotificationTitle
        self.contentView.addSubview(NFMessage)
        yPos = yPos + Int(NFMessage.frame.size.height)
        
        NFPermission = NotificationFollowPermission(frame: CGRect(x: 0, y: yPos, width: width, height: 50)) as NotificationFollowPermission
        self.contentView.addSubview(NFPermission)
        yPos = yPos + Int(NFPermission.frame.size.height)
        
        NFFooter = NotificationFooter(frame: CGRect(x: 0, y: yPos, width: width, height: Int(FOOTER_HEIGHT)))        
        self.contentView.addSubview(NFFooter)
        yPos = yPos + Int(NFFooter.frame.size.height)
        
        let NFBackground = NotificationBackground(frame: CGRect(x: 0, y: 0, width: width, height: yPos))
        self.contentView.addSubview(NFBackground)
        self.contentView.sendSubview(toBack: NFBackground)
        
        setData(notificationData: notificationData, helper: helper)
    }    
    
    func setData(notificationData: JSON, helper: NotificationSubViewController) {
        
        _notificationData = notificationData
        
        NFHeader.setHeaderData(data: notificationData)
        
        NFTitle.setMessageLabel(data: notificationData)
        
        if notificationData["type"] == "journeyLeft" {
            //Change message as per notification type
            NFMessage.NFMessageLabel.text = "Would you like to end your journey as well?"
            
            NFPermission.NFLeftButton.setTitle("End", for: .normal)
            NFPermission.NFLeftButton.addTarget(helper, action: #selector(helper.journeyEndTabbed(_:)), for: .touchUpInside)
            
            NFPermission.NFRightButton.setTitle("Decline", for: .normal)
            NFPermission.NFRightButton.addTarget(helper, action: #selector(helper.journeyEndDeclined(_:)), for: .touchUpInside)            
        }
        else {
            //Change message as per notification type
            NFMessage.NFMessageLabel.text = NFTitle.NFMessageLabel.text
            
            NFPermission.NFLeftButton.setTitle("Accept", for: .normal)
            NFPermission.NFLeftButton.addTarget(helper, action: #selector(helper.journeyAcceptTabbed(_:)), for: .touchUpInside)
            
            NFPermission.NFRightButton.setTitle("Decline", for: .normal)
            NFPermission.NFRightButton.addTarget(helper, action: #selector(helper.journeyDeclineTabbed(_:)), for: .touchUpInside)
        }        
    }
}
