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
    var totalHeight = CGFloat(0)
    
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
    
    func createView (notificationData: JSON?, helper: NotificationSubViewController?) {
        emptyView = notificationEmptyView(frame: CGRect(x: 0, y: 5, width: screenWidth, height: 180))
        emptyView.tag = 45
        self.contentView.addSubview(emptyView)
    }
    
    func setData(notificationData: JSON, helper: NotificationSubViewController) {        
        
        totalHeight = CGFloat(0)
        
        emptyView.frame = CGRect(x: 0, y: 5, width: screenWidth, height: 180)
        
        totalHeight += CGFloat(180)
        
        //        blurView.frame.size.height = totalHeight
        //        blurView.frame.size.width = screenWidth
        //        blr.frame = CGRect(x: 0, y: 0, width: screenWidth, height: totalHeight)
    }

}
