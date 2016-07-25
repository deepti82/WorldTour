//
//  ProfilePostsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 30/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ProfilePostsViewController: UIViewController {

    var verticalLayout: VerticalLayout!
    
    var offset = CGFloat(10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        
//        self.setNavigationBarItem()
//        self.setFooterTabBar(self)
        
//        self.setNavigationBarItemText("Activity")
        
//        let otgPost = InProfileOTGPost(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 520))
//        self.view.addSubview(otgPost)
        
//        let otgPostTwo = PhotosOTG(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 500))
//        self.view.addSubview(otgPostTwo)
        
        self.verticalLayout = VerticalLayout(width: self.view.frame.width)
        
        self.verticalLayout.layoutSubviews()
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(scrollView)
        
        let newProfile = NewProfilePosts(frame: CGRect(x: 0, y: 8, width: self.view.frame.width, height: 775))
        self.verticalLayout.addSubview(newProfile)
        newProfile.videoPlayView.removeFromSuperview()
        self.verticalLayout.frame.size.height += newProfile.frame.height + offset
        
        let newProfileTwo = NewProfilePosts(frame: CGRect(x: 0, y: 8, width: self.view.frame.width, height: 775))
        self.verticalLayout.addSubview(newProfileTwo)
        newProfileTwo.videoPlayView.removeFromSuperview()
        self.verticalLayout.frame.size.height += newProfileTwo.frame.height + offset
        
        let newProfileThree = NewThoughtsView(frame: CGRect(x: 0, y: 8, width: self.view.frame.width, height: 310))
        self.verticalLayout.addSubview(newProfileThree)
        self.verticalLayout.frame.size.height += newProfileThree.frame.height + offset
        
        let newProfileFour = NewProfilePosts(frame: CGRect(x: 0, y: 8, width: self.view.frame.width, height: 775))
        self.verticalLayout.addSubview(newProfileFour)
        self.verticalLayout.frame.size.height += newProfileFour.frame.height + offset
        
        let newProfileFive = PopularJourneyView(frame: CGRect(x: 0, y: 8, width: self.view.frame.width, height: 550))
        self.verticalLayout.addSubview(newProfileFive)
        self.verticalLayout.frame.size.height += newProfileFive.frame.height + offset
        
        let newProfileSix = BlogView(frame: CGRect(x: 0, y: 8, width: self.view.frame.width, height: 600))
        self.verticalLayout.addSubview(newProfileSix)
        self.verticalLayout.frame.size.height += newProfileSix.frame.height + offset
        
        let newProfileSeven = BlogView(frame: CGRect(x: 0, y: 8, width: self.view.frame.width, height: 600))
        self.verticalLayout.addSubview(newProfileSeven)
        newProfileSeven.flagStack.removeFromSuperview()
        newProfileSeven.tripDetailStack.removeFromSuperview()
        newProfileSeven.tripDays.removeFromSuperview()
        newProfileSeven.tripBudgetLabel.removeFromSuperview()
        newProfileSeven.reviewsInStack.removeFromSuperview()
        newProfileSeven.TitleDetail.text = "Lorem ipsum - All the facts - Lipsum generator"
        self.verticalLayout.frame.size.height += newProfileSeven.frame.height + offset
        
        print("height: \(self.verticalLayout.frame.height)") 
        scrollView.contentSize.height = self.verticalLayout.frame.height
        scrollView.addSubview(self.verticalLayout)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
