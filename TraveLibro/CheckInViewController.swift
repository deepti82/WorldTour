//
//  CheckInViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 12/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CheckInViewController: UIViewController {

    @IBOutlet weak var header: UINavigationBar!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        header.layer.zPosition = 100
        
        //Get Background
        getBackGround(self)
        
        //Get Footer
        let footer = getFooter(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45))
        footer.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height - 22.5)
        footer.layer.zPosition = 100
        self.view.addSubview(footer)
        
        //Check In status
//        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width/2))
//        statusView.center = CGPointMake(self.view.frame.size.width/2, 225)
//        statusView.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(statusView)
//        print("Width: \(self.view.frame.size.width/2)")
//        
//        let profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        profileImage.center = CGPointMake(40, 135)
//        profileImage.backgroundColor = UIColor.redColor()
//        self.view.addSubview(profileImage)
//        
//        let locationImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        locationImage.center = CGPointMake(self.view.frame.width - 35, 131.3)
//        locationImage.backgroundColor = UIColor.redColor()
//        self.view.addSubview(locationImage)
//        
//        let statusText = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: statusView.frame.size.height - 65))
//        statusText.center = CGPointMake(self.view.frame.size.width/2, statusView.frame.size.height/3 * 1.5)
//        statusText.backgroundColor = UIColor.darkGrayColor()
//        statusView.addSubview(statusText)
//        
//        let buttonBar = UIView(frame: CGRect(x: 0, y: 0, width: 210, height: 30))
//        buttonBar.center = CGPointMake(statusView.frame.size.width/2 - 50, statusView.frame.size.height/2 + 75)
//        buttonBar.backgroundColor = UIColor.blackColor()
//        statusView.addSubview(buttonBar)
//        
//        let checkinTextView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//        checkinTextView.center = CGPointMake(statusView.frame.size.width/2 - 25, 15)
//        checkinTextView.backgroundColor = UIColor.brownColor()
//        statusView.addSubview(checkinTextView)
        
        
        let scroll = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
        scroll.contentSize.height = 5000
        self.view.addSubview(scroll)
        
        
        let checkIn = CheckInLocalLife(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 800))
        scroll.addSubview(checkIn)
        
    }
    
    
}
