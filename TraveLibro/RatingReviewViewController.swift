//
//  RatingReviewViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class RatingReviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setNavigationBarItem()
        getBackGround(self)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        scrollView.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/2 + 60)
        scrollView.contentSize.height = self.view.frame.size.height * 2
        self.view.addSubview(scrollView)
        
        let friendName = FriendView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        friendName.center = CGPoint(x: self.view.frame.size.width/2, y: 150)
        friendName.profileImage.image = UIImage(named: "profile_icon")
        friendName.profileName.text = "Manan Vora"
        scrollView.addSubview(friendName)
        
        let ratingOne = Rating(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150))
        ratingOne.center = CGPoint(x: self.view.frame.size.width/2, y: 275)
        scrollView.addSubview(ratingOne)
        
        let ratingTwo = Rating(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150))
        ratingTwo.center = CGPoint(x: self.view.frame.size.width/2, y: ratingOne.frame.size.height + 300)
        scrollView.addSubview(ratingTwo)
        
        let ratingThree = Rating(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150))
        ratingThree.center = CGPoint(x: self.view.frame.size.width/2, y: ratingOne.frame.size.height * 2 + 325)
        scrollView.addSubview(ratingThree)
        
        
        
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
