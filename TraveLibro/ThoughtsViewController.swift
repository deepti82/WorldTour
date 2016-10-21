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
        let footer = getFooter(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 45))
        footer.center = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height - 22.5)
        footer.layer.zPosition = 100
        self.view.addSubview(footer)
        
        //Check In status
//        let thoughtsView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width/2 + 50))
//        thoughtsView.center = CGPointMake(self.view.frame.size.width/2, 225)
//        thoughtsView.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(thoughtsView)
//        print("Width: \(self.view.frame.size.width/2)")
//        
//        let profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
//        profileImage.center = CGPointMake(40, 100)
//        profileImage.layer.cornerRadius = 20
//        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
//        profileImage.layer.borderWidth = 3.5
//        profileImage.image = UIImage(named: "profile_icon")
//        self.view.addSubview(profileImage)
//        
//        let editImage = IconButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        editImage.center = CGPointMake(self.view.frame.width - 35, 106.3)
//        self.view.addSubview(editImage)
//        
//        let thoughtBodyView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: thoughtsView.frame.size.height - 65))
//        thoughtBodyView.center = CGPointMake(self.view.frame.size.width/2, thoughtsView.frame.size.height/3 * 1.5 - 12.5)
//        thoughtsView.addSubview(thoughtBodyView)
//        
//        let thoughtStatus = UITextView(frame: CGRect(x: 0, y: 0, width: thoughtBodyView.frame.size.width - 60, height: 100))
//        thoughtStatus.center = CGPointMake(thoughtBodyView.frame.size.width/2 - 10, thoughtBodyView.frame.size.height/3  + 12.5)
//        thoughtStatus.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. with Sarvesh Brahme & Gayatri"
//        thoughtBodyView.addSubview(thoughtStatus)
//        
//        let timestamp = DateAndTime(frame: CGRect(x: 0, y: 0, width: 200, height: 20))
//        timestamp.center = CGPointMake(thoughtBodyView.frame.size.width/3 + 5, thoughtBodyView.frame.size.height/2 - 15)
//        thoughtBodyView.addSubview(timestamp)
//        
//        let photoBar = UIView(frame: CGRect(x: 0, y: 0, width: thoughtBodyView.frame.size.width - 50, height: 70))
//        photoBar.center = CGPointMake(thoughtBodyView.frame.size.width/3 + 60, thoughtBodyView.frame.size.height/3 * 2.5 - 20)
//        thoughtBodyView.addSubview(photoBar)
//        
//        let photo1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        photo1.center = CGPointMake(photoBar.frame.size.width/8 - 15, photoBar.frame.size.height/2)
//        photo1.image = UIImage(named: "photobar1")
//        photoBar.addSubview(photo1)
//        
//        let photo2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        photo2.center = CGPointMake(photoBar.frame.size.width/4, photoBar.frame.size.height/2)
//        photo2.image = UIImage(named: "photobar2")
//        photoBar.addSubview(photo2)
//        
//        let photo3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        photo3.center = CGPointMake(photoBar.frame.size.width/2 - 23, photoBar.frame.size.height/2)
//        photo3.image = UIImage(named: "photobar3")
//        photoBar.addSubview(photo3)
//        
//        let photo4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        photo4.center = CGPointMake(photoBar.frame.size.width/2 + 30.5, photoBar.frame.size.height/2)
//        photo4.image = UIImage(named: "photobar4")
//        photoBar.addSubview(photo4)
//        
//        let buttonBar = UILabel(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
//        buttonBar.center = CGPointMake(thoughtsView.frame.size.width/2 - 50, thoughtsView.frame.size.height/2 + 100)
//        //buttonBar.backgroundColor = UIColor.blackColor()
//        thoughtsView.addSubview(buttonBar)
//        
//        let editLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
//        editLabel.text = "Edit or Remove Photos"
//        editLabel.font = UIFont(name: "Avenir-Roman", size: 10)
//        editLabel.textColor = UIColor.lightGrayColor()
//        editLabel.center = CGPointMake(75, -10)
//        buttonBar.addSubview(editLabel)
//        
//        let button1 = IconButton(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
//        button1.center = CGPointMake(20, buttonBar.frame.size.height/2 - 5)
//        button1.view.backgroundColor = UIColor(patternImage: UIImage(named: "halfnhalfbg")!)
//        button1.button.setImage(UIImage(named: "camera_icon"), forState: .Normal)
//        buttonBar.addSubview(button1)
//        
//        let button2 = IconButton(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
//        button2.center = CGPointMake(75, buttonBar.frame.size.height/2 - 5)
//        button2.view.backgroundColor = UIColor(patternImage: UIImage(named: "halfnhalfbg")!)
//        button2.button.setImage(UIImage(named: "people_icon"), forState: .Normal)
//        buttonBar.addSubview(button2)
//        
//        let thoughtTextView = UILabel(frame: CGRect(x: 0, y: 0, width: 175, height: 30))
//        thoughtTextView.center = CGPointMake(thoughtsView.frame.size.width/2 - 20, 20)
//        thoughtTextView.text = "Thought"
//        thoughtsView.addSubview(thoughtTextView)

        
        //Add Thoughts view
//        let AddThoughtsView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.width/2))
//        AddThoughtsView.center = CGPointMake(self.view.frame.size.width/2, 225)
//        AddThoughtsView.backgroundColor = UIColor.whiteColor()
//        self.view.addSubview(AddThoughtsView)
//        
//        let profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
//        profileImage.center = CGPointMake(40, 130)
//        profileImage.layer.cornerRadius = 20
//        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
//        profileImage.layer.borderWidth = 3.5
//        profileImage.image = UIImage(named: "profile_icon")
//        self.view.addSubview(profileImage)
//
//        let editImage = IconButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//        editImage.center = CGPointMake(self.view.frame.width - 35, 131.3)
//        self.view.addSubview(editImage)
//        
//        let thoughtTextView = UILabel(frame: CGRect(x: 0, y: 0, width: 175, height: 30))
//        thoughtTextView.center = CGPointMake(AddThoughtsView.frame.size.width/3 + 50, 20)
//        thoughtTextView.text = "Thought"
//        thoughtTextView.font = UIFont(name: "Avenir-Roman", size: 18)
//        thoughtTextView.textColor = UIColor(red: 255/255, green: 104/255, blue: 88/255, alpha: 255/255)
//        AddThoughtsView.addSubview(thoughtTextView)
//        
//        let thoughtStatus = UITextView(frame: CGRect(x: 0, y: 0, width: AddThoughtsView.frame.size.width - 60, height: 100))
//        thoughtStatus.center = CGPointMake(AddThoughtsView.frame.size.width/2, AddThoughtsView.frame.size.height/3 + 30)
//        thoughtStatus.font = avenirFont
//        thoughtStatus.textColor = UIColor.lightGrayColor()
//        thoughtStatus.text = "What's your inner traveller thinking?"
//        AddThoughtsView.addSubview(thoughtStatus)
//        
//        let buttonBar = UILabel(frame: CGRect(x: 0, y: 0, width: 210, height: 40))
//        
//        buttonBar.center = CGPointMake(AddThoughtsView.frame.size.width/2 - 50, AddThoughtsView.frame.size.height/2 + 100)
//        AddThoughtsView.addSubview(buttonBar)
//
//        let button1 = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
//        button1.center = CGPointMake(20, buttonBar.frame.size.height/3 - 25)
//        button1.view.backgroundColor = UIColor(patternImage: UIImage(named: "halfnhalfbg")!)
//        button1.button.setImage(UIImage(named: "camera_icon"), forState: .Normal)
//        buttonBar.addSubview(button1)
//
//        let button2 = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
//        button2.center = CGPointMake(75, buttonBar.frame.size.height/3 - 25)
//        button2.view.backgroundColor = UIColor(patternImage: UIImage(named: "halfnhalfbg")!)
//        button2.button.setImage(UIImage(named: "people_icon"), forState: .Normal)
//        buttonBar.addSubview(button2)
        
        
        //photos view
        let thoughtsView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/1.5))
        thoughtsView.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2 - 20)
        thoughtsView.backgroundColor = UIColor.white
        self.view.addSubview(thoughtsView)
        print("Width: \(self.view.frame.size.width/2)")
        
        let profileImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        profileImage.center = CGPoint(x: 40, y: 100)
        profileImage.layer.cornerRadius = 20
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 3.5
        profileImage.image = UIImage(named: "profile_icon")
        self.view.addSubview(profileImage)
        
        let editImage = IconButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        editImage.center = CGPoint(x: self.view.frame.width - 35, y: 95)
        self.view.addSubview(editImage)
        
        let thoughtStatus = UITextView(frame: CGRect(x: 0, y: 0, width: thoughtsView.frame.size.width/2 + 40, height: 100))
        thoughtStatus.center = CGPoint(x: thoughtsView.frame.size.width/2 - 10, y: thoughtsView.frame.size.height/4 - 60)
        thoughtStatus.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. with Sarvesh Brahme & Gayatri"
        thoughtsView.addSubview(thoughtStatus)
        
        let timestamp = DateAndTime(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        timestamp.center = CGPoint(x: thoughtsView.frame.size.width/4 + 60, y: thoughtsView.frame.size.height/6 - 10)
        thoughtsView.addSubview(timestamp)
        
        let coverImage = UIImageView(frame: CGRect(x: 0, y: 0, width: thoughtsView.frame.size.width, height: thoughtsView.frame.size.height/2))
        coverImage.center = CGPoint(x: thoughtsView.frame.size.width/2, y: thoughtsView.frame.size.height/2 - 20)
        coverImage.image = UIImage(named: "photobar1")
        thoughtsView.addSubview(coverImage)

        let photoBar = UIView(frame: CGRect(x: 0, y: 0, width: thoughtsView.frame.size.width - 50, height: 70))
        photoBar.center = CGPoint(x: thoughtsView.frame.size.width/3 + 60, y: thoughtsView.frame.size.height/3 * 2.5 - 20)
        thoughtsView.addSubview(photoBar)
        
        let photo1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        photo1.center = CGPoint(x: photoBar.frame.size.width/8 - 15, y: photoBar.frame.size.height/2)
        photo1.image = UIImage(named: "photobar1")
        photoBar.addSubview(photo1)
        
        let photo2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        photo2.center = CGPoint(x: photoBar.frame.size.width/4, y: photoBar.frame.size.height/2)
        photo2.image = UIImage(named: "photobar2")
        photoBar.addSubview(photo2)
        
        let photo3 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        photo3.center = CGPoint(x: photoBar.frame.size.width/2 - 23, y: photoBar.frame.size.height/2)
        photo3.image = UIImage(named: "photobar3")
        photoBar.addSubview(photo3)
        
        let photo4 = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        photo4.center = CGPoint(x: photoBar.frame.size.width/2 + 30.5, y: photoBar.frame.size.height/2)
        photo4.image = UIImage(named: "photobar4")
        photoBar.addSubview(photo4)

        let buttonBar = UILabel(frame: CGRect(x: 0, y: 0, width: thoughtsView.frame.size.width - 50, height: 30))
        buttonBar.center = CGPoint(x: thoughtsView.frame.size.width/2, y: thoughtsView.frame.size.height - 40)
        thoughtsView.addSubview(buttonBar)
        
        let button1 = IconButton(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        button1.center = CGPoint(x: 10, y: buttonBar.frame.size.height/2 - 5)
        button1.view.backgroundColor = UIColor.white
        button1.button.setImage(UIImage(named: "like-empty_icon"), for: UIControlState())
        buttonBar.addSubview(button1)
        
        let button2 = IconButton(frame: CGRect(x: 0, y: 0, width: 30, height: 25))
        button2.center = CGPoint(x: 40, y: buttonBar.frame.size.height/2 - 5)
        button2.view.backgroundColor = UIColor.white
        button2.button.setImage(UIImage(named: "speech_icon"), for: UIControlState())
        buttonBar.addSubview(button2)
        
        let button3 = IconButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        button3.center = CGPoint(x: 70, y: buttonBar.frame.size.height/2 - 5)
        button3.view.backgroundColor = UIColor.white
        button3.button.setImage(UIImage(named: "share_icon"), for: UIControlState())
        buttonBar.addSubview(button3)
        
        let button4 = IconButton(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        button4.center = CGPoint(x: buttonBar.frame.size.width - 10, y: buttonBar.frame.size.height/2 - 5)
        button4.view.backgroundColor = UIColor.white
        button4.button.setImage(UIImage(named: "options_icon"), for: UIControlState())
        buttonBar.addSubview(button4)

        let thoughtTextView = UILabel(frame: CGRect(x: 0, y: 0, width: 175, height: 30))
        thoughtTextView.center = CGPoint(x: 130, y: thoughtsView.frame.size.height - 20)
        thoughtTextView.text = "155660 Likes"
        thoughtTextView.font = UIFont(name: "Avenir-Roman", size: 10)
        thoughtTextView.textColor = mainBlueColor
        thoughtsView.addSubview(thoughtTextView)
        
    
    }
}
