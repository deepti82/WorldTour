//
//  TripSummaryViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TripSummaryViewController: UIViewController {

    @IBOutlet weak var header: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.layer.zPosition = 100
        
        //Get Background
        getBackGround(self)
        
        //Get Footer
        let footer = getFooter(frame: CGRectMake(0, 0, self.view.frame.size.width, 45))
        footer.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 22.5)
        footer.layer.zPosition = 100
        self.view.addSubview(footer)
        
//        let profileDetails = TripSummaryProfile(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/2 - 20))
//        profileDetails.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.width/2 + 40)
//        self.view.addSubview(profileDetails)
        
        
        //Adding Scroll View
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 50))
        scrollView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
        scrollView.contentSize.height = 1000
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.backgroundColor = UIColor.redColor()
//        print("Is dragging? \(scrollView.dragging)")
        self.view.addSubview(scrollView)
        
        
        // video post
        let videoPost = VideoPost(frame: CGRectMake(0, 0, self.view.frame.size.width, 350))
        videoPost.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2)
        scrollView.addSubview(videoPost)
        
        //line
        let backdropLine = drawLine(frame: CGRect(x: 0, y: 0, width: 3, height: self.view.frame.size.height))
        backdropLine.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
        backdropLine.layer.zPosition = -100
        backdropLine.backgroundColor = UIColor.clearColor()
        self.view.addSubview(backdropLine)
        
        //Plus Menu
//        let plusMenu = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3 + 75, height: self.view.frame.size.height/2.25))
//        plusMenu.center = CGPointMake(self.view.frame.size.width/2 + 100, self.view.frame.size.height/2 + 100)
//        plusMenu.layer.zPosition = 102
//        self.view.addSubview(plusMenu)
//        
//        //Blur to Plus Menu
//        let blurBackground = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
//        blurBackground.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
//        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//        let blurView = UIVisualEffectView(effect: darkBlur)
//        blurView.frame = blurBackground.bounds
//        blurView.layer.zPosition = 101
//        self.view.addSubview(blurView)
//        
//        //Add labels to plus menu
//        let label1 = FriendView(frame: CGRect(x: 0, y: 0, width: plusMenu.frame.size.width/2, height: plusMenu.frame.size.height/3))
//        label1.center = CGPointMake(plusMenu.frame.size.width/4, plusMenu.frame.size.height/6)
//        label1.profileName.text = "Add Buddies"
//        label1.profileName.numberOfLines = 0
//        label1.profileImage.image = UIImage(named: "travel_life_icon")
//        plusMenu.addSubview(label1)
//        
//        let label2 = FriendView(frame: CGRect(x: 0, y: 0, width: plusMenu.frame.size.width/2, height: plusMenu.frame.size.height/3))
//        label2.center = CGPointMake(plusMenu.frame.size.width/4 * 3, plusMenu.frame.size.height/6)
//        label2.profileName.text = "End Journey"
//        label2.profileName.numberOfLines = 0
//        label2.profileImage.image = UIImage(named: "travel_life_icon")
//        plusMenu.addSubview(label2)
//        
//        let label3 = FriendView(frame: CGRect(x: 0, y: 0, width: plusMenu.frame.size.width/2, height: plusMenu.frame.size.height/3))
//        label3.center = CGPointMake(plusMenu.frame.size.width/4, plusMenu.frame.size.height/2)
//        label3.profileName.text = "Photos"
//        label3.profileName.numberOfLines = 0
//        label3.profileImage.image = UIImage(named: "travel_life_icon")
//        plusMenu.addSubview(label3)
//        
//        let label4 = FriendView(frame: CGRect(x: 0, y: 0, width: plusMenu.frame.size.width/2, height: plusMenu.frame.size.height/3))
//        label4.center = CGPointMake(plusMenu.frame.size.width/4 * 3, plusMenu.frame.size.height/2)
//        label4.profileName.text = "Videos"
//        label4.profileName.numberOfLines = 0
//        label4.profileImage.image = UIImage(named: "travel_life_icon")
//        plusMenu.addSubview(label4)
//        
//        let label5 = FriendView(frame: CGRect(x: 0, y: 0, width: plusMenu.frame.size.width/2, height: plusMenu.frame.size.height/3))
//        label5.center = CGPointMake(plusMenu.frame.size.width/4, plusMenu.frame.size.height/6 * 5)
//        label5.profileName.text = "Check in"
//        label5.profileName.numberOfLines = 0
//        label5.profileImage.image = UIImage(named: "travel_life_icon")
//        plusMenu.addSubview(label5)
//        
//        let label6 = FriendView(frame: CGRect(x: 0, y: 0, width: plusMenu.frame.size.width/2, height: plusMenu.frame.size.height/3))
//        label6.center = CGPointMake(plusMenu.frame.size.width/4 * 3, plusMenu.frame.size.height/6 * 5)
//        label6.profileName.text = "Thoughts"
//        label6.profileName.numberOfLines = 0
//        label6.profileImage.image = UIImage(named: "travel_life_icon")
//        plusMenu.addSubview(label6)
        
        
        //Info Menu
//        let infoMenu = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3 + 100, height: self.view.frame.size.height - 60))
//        infoMenu.center = CGPointMake(self.view.frame.size.width/2 - 100, self.view.frame.size.height/2 + 60)
//        infoMenu.layer.zPosition = 102
//        infoMenu.backgroundColor = UIColor.blackColor()
//        self.view.addSubview(infoMenu)
//        
//        let infoMenuYourJourney = UIView(frame: CGRect(x: 0, y: 0, width: infoMenu.frame.size.width, height: infoMenu.frame.size.height/7 * 3))
//        infoMenuYourJourney.center = CGPointMake(infoMenu.frame.size.width/2, infoMenu.frame.size.height/3 - 75)
//        infoMenuYourJourney.layer.zPosition = 102
//        infoMenuYourJourney.backgroundColor = UIColor.blueColor()
//        infoMenu.addSubview(infoMenuYourJourney)
//        
//        let yourJourneyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width, height: infoMenuYourJourney.frame.height/6))
//        yourJourneyLabel.center = CGPointMake(infoMenuYourJourney.frame.width/2, infoMenuYourJourney.frame.height/12)
//        yourJourneyLabel.text = "Your Journey"
//        yourJourneyLabel.font = avenirFont
//        yourJourneyLabel.textAlignment = .Center
//        infoMenuYourJourney.addSubview(yourJourneyLabel)
//        
//        let yourJourneyInfo1 = FriendView(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width/2, height: infoMenuYourJourney.frame.width/2))
//        yourJourneyInfo1.center = CGPointMake(infoMenuYourJourney.frame.width/4 + 10, infoMenuYourJourney.frame.height/4 + yourJourneyLabel.frame.size.height/2)
//        yourJourneyInfo1.profileImage.image = UIImage(named: "add_circle")
//        yourJourneyInfo1.profileName.text = "Summary"
//        infoMenuYourJourney.addSubview(yourJourneyInfo1)
//        
//        let yourJourneyInfo2 = FriendView(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width/2, height: infoMenuYourJourney.frame.width/2))
//        yourJourneyInfo2.center = CGPointMake(infoMenuYourJourney.frame.width/4 * 3, infoMenuYourJourney.frame.height/4 + yourJourneyLabel.frame.size.height/2)
//        yourJourneyInfo2.profileImage.image = UIImage(named: "add_circle")
//        yourJourneyInfo2.profileName.text = "Videos"
//        infoMenuYourJourney.addSubview(yourJourneyInfo2)
//        
//        let yourJourneyInfo3 = FriendView(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width/2, height: infoMenuYourJourney.frame.width/2))
//        yourJourneyInfo3.center = CGPointMake(infoMenuYourJourney.frame.width/4 + 10, infoMenuYourJourney.frame.height/4 * 3 + yourJourneyLabel.frame.size.height/2)
//        yourJourneyInfo3.profileImage.image = UIImage(named: "add_circle")
//        yourJourneyInfo3.profileName.text = "Photos"
//        infoMenuYourJourney.addSubview(yourJourneyInfo3)
//        
//        let yourJourneyInfo4 = FriendView(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width/2, height: infoMenuYourJourney.frame.width/2))
//        yourJourneyInfo4.center = CGPointMake(infoMenuYourJourney.frame.width/4 * 3, infoMenuYourJourney.frame.height/4 * 3 + yourJourneyLabel.frame.size.height/2)
//        yourJourneyInfo4.profileImage.image = UIImage(named: "add_circle")
//        yourJourneyInfo4.profileName.text = "Rating"
//        infoMenuYourJourney.addSubview(yourJourneyInfo4)
//        
//        let infoMenuAbout = UIView(frame: CGRect(x: 0, y: 0, width: infoMenu.frame.size.width, height: infoMenu.frame.size.height/7 * 4))
//        infoMenuAbout.center = CGPointMake(infoMenu.frame.size.width/2, self.view.frame.size.height/3 * 2.25)
//        infoMenuAbout.layer.zPosition = 102
//        infoMenuAbout.backgroundColor = UIColor.brownColor()
//        self.view.addSubview(infoMenuAbout)
//
//        let aboutLabel = UILabel(frame: CGRect(x: 0, y: 0, width: infoMenuAbout.frame.width, height: infoMenuAbout.frame.height/6))
//        aboutLabel.center = CGPointMake(infoMenuAbout.frame.width/2, infoMenuAbout.frame.height/12)
//        aboutLabel.text = "About London"
//        aboutLabel.font = avenirFont
//        aboutLabel.textAlignment = .Center
//        infoMenuAbout.addSubview(aboutLabel)
//        
//        let aboutInfo1 = FriendView(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width/2, height: infoMenuYourJourney.frame.width/2))
//        aboutInfo1.center = CGPointMake(infoMenuYourJourney.frame.width/4 + 10, infoMenuYourJourney.frame.height/6 + yourJourneyLabel.frame.size.height/2)
//        aboutInfo1.profileImage.image = UIImage(named: "add_circle")
//        aboutInfo1.profileName.text = "Must Do's"
//        infoMenuAbout.addSubview(aboutInfo1)
//        
//        let aboutInfo2 = FriendView(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width/2, height: infoMenuYourJourney.frame.width/2))
//        aboutInfo2.center = CGPointMake(infoMenuYourJourney.frame.width/4 * 3, infoMenuYourJourney.frame.height/6 + yourJourneyLabel.frame.size.height/2)
//        aboutInfo2.profileImage.image = UIImage(named: "add_circle")
//        aboutInfo2.profileName.text = "Videos"
//        infoMenuAbout.addSubview(aboutInfo2)
//        
//        let aboutInfo3 = FriendView(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width/2, height: infoMenuYourJourney.frame.width/2))
//        aboutInfo3.center = CGPointMake(infoMenuYourJourney.frame.width/4 + 10, infoMenuYourJourney.frame.height/4 * 3 + yourJourneyLabel.frame.size.height/2)
//        aboutInfo3.profileImage.image = UIImage(named: "add_circle")
//        aboutInfo3.profileName.text = "Photos"
//        infoMenuYourJourney.addSubview(yourJourneyInfo3)
//        
//        let yourJourneyInfo4 = FriendView(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width/2, height: infoMenuYourJourney.frame.width/2))
//        yourJourneyInfo4.center = CGPointMake(infoMenuYourJourney.frame.width/4 * 3, infoMenuYourJourney.frame.height/4 * 3 + yourJourneyLabel.frame.size.height/2)
//        yourJourneyInfo4.profileImage.image = UIImage(named: "add_circle")
//        yourJourneyInfo4.profileName.text = "Rating"
//        infoMenuYourJourney.addSubview(yourJourneyInfo4)
//        
//        let yourJourneyInfo4 = FriendView(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width/2, height: infoMenuYourJourney.frame.width/2))
//        yourJourneyInfo4.center = CGPointMake(infoMenuYourJourney.frame.width/4 * 3, infoMenuYourJourney.frame.height/4 * 3 + yourJourneyLabel.frame.size.height/2)
//        yourJourneyInfo4.profileImage.image = UIImage(named: "add_circle")
//        yourJourneyInfo4.profileName.text = "Rating"
//        infoMenuYourJourney.addSubview(yourJourneyInfo4)
//        
//        let yourJourneyInfo4 = FriendView(frame: CGRect(x: 0, y: 0, width: infoMenuYourJourney.frame.width/2, height: infoMenuYourJourney.frame.width/2))
//        yourJourneyInfo4.center = CGPointMake(infoMenuYourJourney.frame.width/4 * 3, infoMenuYourJourney.frame.height/4 * 3 + yourJourneyLabel.frame.size.height/2)
//        yourJourneyInfo4.profileImage.image = UIImage(named: "add_circle")
//        yourJourneyInfo4.profileName.text = "Rating"
//        infoMenuYourJourney.addSubview(yourJourneyInfo4)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return 12
//        
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("placesVisited", forIndexPath: indexPath) 
//        return cell
//        
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
