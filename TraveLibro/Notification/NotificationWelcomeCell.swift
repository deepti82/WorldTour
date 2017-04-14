//
//  NotificationWelcomeCell.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 14/04/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationWelcomeCell: UITableViewCell {

    var emptyView = notificationEmptyView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView(notificationData: nil, helper: nil)
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String, notificationData: JSON, helper: NotificationSubViewController){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createView(notificationData: notificationData, helper: helper)        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func createView() {
        emptyView = notificationEmptyView(frame: CGRect(x: 0, y: 5, width: screenWidth, height: 150))
        noNotification.tag = 45
        self.view.addSubview(noNotification)
    }
    
    func setData(notificationData: JSON, helper: NotificationSubViewController) {        
        
        totalHeight = CGFloat(0)
        
        emptyView.frame = CGRect(x: 0, y: 5, width: screenWidth, height: 150)
        
        totalHeight += CGFloat(150)
        
        NFBackground.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
        
        //        blurView.frame.size.height = totalHeight
        //        blurView.frame.size.width = screenWidth
        //        blr.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }

}
