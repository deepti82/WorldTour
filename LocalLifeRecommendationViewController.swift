//
//  LocalLifeRecommendationViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 01/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LocalLifeRecommendationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        
        self.setNavigationBarItemText("Local Life")
        
        let thisScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        thisScroll.contentSize.height = 2100
        self.view.addSubview(thisScroll)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        titleLabel.center = CGPointMake(self.view.frame.width/2, 20)
        titleLabel.text = "Experience Mumbai like a local"
        titleLabel.font = UIFont(name: "Avenir-Roman", size: 16)
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        thisScroll.addSubview(titleLabel)
        
        let myView = LocalLifeRecommends(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 400))
        thisScroll.addSubview(myView)
        
        let myView2 = LocalLifeRecommends(frame: CGRect(x: 0, y: 435, width: self.view.frame.width, height: 400))
        thisScroll.addSubview(myView2)
        
        let myView3 = LocalLifeRecommends(frame: CGRect(x: 0, y: 835, width: self.view.frame.width, height: 400))
        thisScroll.addSubview(myView3)
        
        let myView4 = LocalLifeRecommends(frame: CGRect(x: 0, y: 1235, width: self.view.frame.width, height: 400))
        thisScroll.addSubview(myView4)
        
        let myView5 = LocalLifeRecommends(frame: CGRect(x: 0, y: 1635, width: self.view.frame.width, height: 400))
        thisScroll.addSubview(myView5)
        
//        let darkView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        darkView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
//        self.view.addSubview(darkView)
        
        let plusView = EndLocalLife(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        plusView.checkInButton.addTarget(self, action: #selector(LocalLifeRecommendationViewController.checkInTap(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(plusView)

//        let rating = AddRating(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: 310))
//        rating.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
////        rating.layer.cornerRadius = 5
////        rating.clipsToBounds = true
//        self.view.addSubview(rating)

//        let addPosts = AddPostsLocalLife(frame: CGRect(x: self.view.frame.width - 150, y: self.view.frame.height - 300, width: 150, height: 300))
//        self.view.addSubview(addPosts)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkInTap(sender: UIButton) {
        
        print("checkInButtonWasTapped")
        let checkInOneVC = storyboard?.instantiateViewControllerWithIdentifier("checkInSearch") as! CheckInSearchViewController
        self.navigationController?.pushViewController(checkInOneVC, animated: true)
        
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
