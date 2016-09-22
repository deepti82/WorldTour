//
//  NotificationsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import PageMenu

class NotificationsViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu!
    
    let orangeColor = UIColor(red: 252/255, green: 80/255, blue: 71/255, alpha: 1)
    let blueColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
    let hairlineColor = UIColor(red: 210/255, green: 211/255, blue: 211/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nvcTwo = self.navigationController
        
        var controllerArray : [UIViewController] = []
        
        let controller = storyboard!.instantiateViewControllerWithIdentifier("notifySub") as! NotificationSubViewController
        controller.whichView = "Notify"
        controller.title = "Notifications"
        controllerArray.append(controller)
        
        let controllerTwo = storyboard!.instantiateViewControllerWithIdentifier("notifySub") as! NotificationSubViewController
        controllerTwo.whichView = "Messages"
        controllerTwo.title = "Messages"
        controllerArray.append(controllerTwo)
        
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(1),
            .MenuItemSeparatorPercentageHeight(20),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemFont(UIFont(name: "Avenir-Roman", size: 14)!),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor.clearColor()),
            .UnselectedMenuItemLabelColor(blueColor),
            .SelectedMenuItemLabelColor(orangeColor),
            .MenuItemWidthBasedOnTitleTextWidth(true),
            .MenuHeight(45.0),
            .BottomMenuHairlineColor(hairlineColor),
            .MenuItemSeparatorColor(hairlineColor)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0, 60, self.view.frame.width, self.view.frame.height - 60), pageMenuOptions: parameters)
        self.view.addSubview(pageMenu!.view)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


class NotificationViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var notificationText: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    
    
    
}

class NotificationAddAlbumViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var notifyText: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var decilneButton: UIButton!
    
}
