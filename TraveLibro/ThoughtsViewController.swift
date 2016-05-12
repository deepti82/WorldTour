//
//  ThoughtsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 12/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ThoughtsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get Background
        getBackGround(self)
        
        //Get Footer
        let footer = getFooter(frame: CGRectMake(0, 0, self.view.frame.size.width, 45))
        footer.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 22.5)
        footer.layer.zPosition = 100
        self.view.addSubview(footer)
        
        //Check In status
        let thoughtsView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width/2))
        thoughtsView.center = CGPointMake(self.view.frame.size.width/2, 225)
        thoughtsView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(thoughtsView)
        print("Width: \(self.view.frame.size.width/2)")
        
        let profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        profileImage.center = CGPointMake(40, 135)
        profileImage.backgroundColor = UIColor.redColor()
        profileImage.image = UIImage(named: "profile_icon")
        self.view.addSubview(profileImage)
        
        let editImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        editImage.center = CGPointMake(self.view.frame.width - 35, 131.3)
        editImage.backgroundColor = UIColor.redColor()
        editImage.image = UIImage(named: "pen_icon")
        self.view.addSubview(editImage)
        
        let thoughtBodyView = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: thoughtsView.frame.size.height - 65))
        thoughtBodyView.center = CGPointMake(self.view.frame.size.width/2, thoughtsView.frame.size.height/3 * 1.5)
        thoughtsView.addSubview(thoughtBodyView)
        
        let thoughtStatus = UITextView(frame: CGRect(x: 0, y: 0, width: thoughtBodyView.frame.size.width - 60, height: 100))
        thoughtStatus.center = CGPointMake(thoughtBodyView.frame.size.width/2 - 10, thoughtBodyView.frame.size.height/3)
        thoughtStatus.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. with Sarvesh Brahme & Gayatri"
        thoughtBodyView.addSubview(thoughtStatus)
        
        let timestamp = DateAndTime(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
        timestamp.center = CGPointMake(thoughtBodyView.frame.size.width/3 + 10, thoughtBodyView.frame.size.height/2)
        thoughtBodyView.addSubview(timestamp)
        
        let photoBar = UIView(frame: CGRect(x: 0, y: 0, width: thoughtBodyView.frame.size.width - 50, height: 70))
        photoBar.center = CGPointMake(thoughtBodyView.frame.size.width/3 + 65, thoughtBodyView.frame.size.height/3 * 2.5)
        thoughtBodyView.addSubview(photoBar)
        
        let photo1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        photo1.center = CGPointMake(photoBar.frame.size.width/8 - 15, photoBar.frame.size.height/2)
        photo1.backgroundColor = UIColor.redColor()
        photoBar.addSubview(photo1)
        
        let photo2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        photo2.center = CGPointMake(photoBar.frame.size.width/4, photoBar.frame.size.height/2)
        photo2.backgroundColor = UIColor.redColor()
        photoBar.addSubview(photo2)
        
        let photo3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        photo3.center = CGPointMake(photoBar.frame.size.width/2 - 23, photoBar.frame.size.height/2)
        photo3.backgroundColor = UIColor.redColor()
        photoBar.addSubview(photo3)
        
        let photo4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        photo4.center = CGPointMake(photoBar.frame.size.width/2 + 30.5, photoBar.frame.size.height/2)
        photo4.backgroundColor = UIColor.redColor()
        photoBar.addSubview(photo4)
        
        let buttonBar = UILabel(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
        buttonBar.center = CGPointMake(thoughtsView.frame.size.width/2 - 50, thoughtsView.frame.size.height/2 + 85)
        //buttonBar.backgroundColor = UIColor.blackColor()
        thoughtsView.addSubview(buttonBar)
        
        let button1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button1.center = CGPointMake(30, buttonBar.frame.size.height/2)
        button1.backgroundColor = UIColor.blueColor()
        button1.image = UIImage(named: "camera_icon")
        buttonBar.addSubview(button1)
        
        let button2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button2.center = CGPointMake(75, buttonBar.frame.size.height/2)
        button2.backgroundColor = UIColor.blueColor()
        buttonBar.addSubview(button2)
        
        let thoughtTextView = UILabel(frame: CGRect(x: 0, y: 0, width: 175, height: 30))
        thoughtTextView.center = CGPointMake(thoughtsView.frame.size.width/2 - 25, 15)
        thoughtTextView.text = "Thought"
        thoughtsView.addSubview(thoughtTextView)
    }
}
