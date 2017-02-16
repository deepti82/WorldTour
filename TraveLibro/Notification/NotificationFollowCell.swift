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

    var _notificationData: JSON? 
    var NFHeader = notificationHeader()
    var NFTitle = NotificationTitle()
    var NFFollowDetails = NotificationFollowingDetails()
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
        
        let NFBackground = NotificationBackground(frame: CGRect(x: 0, y: 0, width: width, height: 300))
        self.contentView.addSubview(NFBackground)
        
        NFHeader = notificationHeader(frame: CGRect(x: 0, y: yPos, width: width, height: Int(HEADER_HEIGHT))) as notificationHeader
        self.contentView.addSubview(NFHeader)        
        yPos = yPos + Int(NFHeader.frame.size.height)
        
        NFTitle = NotificationTitle(frame: CGRect(x: 0, y: yPos, width: width, height: 50)) as NotificationTitle
        self.contentView.addSubview(NFTitle)
        yPos = yPos + Int(NFTitle.frame.size.height)
        
        NFFollowDetails = NotificationFollowingDetails(frame: CGRect(x: 0, y: yPos, width: width, height: 60)) as NotificationFollowingDetails
        self.contentView.addSubview(NFFollowDetails)
        yPos = yPos + Int(NFFollowDetails.frame.size.height)
        
        NFPermission = NotificationFollowPermission(frame: CGRect(x: 0, y: yPos, width: width, height: 50)) as NotificationFollowPermission
        self.contentView.addSubview(NFPermission)
        yPos = yPos + Int(NFPermission.frame.size.height)
        
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
        
        NFPermission.NFLeftButton.setTitle("Accept", for: .normal)
        NFPermission.NFLeftButton.addTarget(helper, action: #selector(helper.acceptTag(_:)), for: .touchUpInside)
        
        NFPermission.NFRightButton.setTitle("Decline", for: .normal)
        NFPermission.NFLeftButton.addTarget(helper, action: #selector(helper.declineTag(_:)), for: .touchUpInside)
    }

}
