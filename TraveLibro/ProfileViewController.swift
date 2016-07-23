//
//  ProfileViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 21/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import DKChainableAnimationKit

class ProfileViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    let labels = ["300 Following", "223 Followers", "10 Countries Visited", "10 Bucket List", "20 Journeys Created", "3 Check Ins", "23 Photos", "1000 Reviews"]
    dynamic var profileViewYPosition: CGFloat = 0
    
    private var kvoContext: UInt8 = 0
    
    @IBOutlet weak var MAMatterView: UIView!
    var MAMScrollView: UIScrollView?
    
    @IBOutlet weak var mainProfileView: UIView!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    var toggle = false
    
    @IBOutlet weak var MAMButton: UIButton!
    @IBAction func MAMTapped(sender: AnyObject) {
        
        if !toggle {
            
            MAMButton.transform = CGAffineTransformRotate(MAMButton.transform, CGFloat(M_PI))
            MAMatterView.animation.makeOpacity(1.0).animate(0.5)
            mainProfileView.animation.moveY(-100.0).moveHeight(100.0).animate(0.5)
            toggle = true
        }
        
        else {
            
            MAMButton.transform = CGAffineTransformRotate(MAMButton.transform, CGFloat(M_PI))
            MAMatterView.animation.makeOpacity(0.0).animate(0.5)
            mainProfileView.animation.moveY(100.0).moveHeight(-50.0).animate(0.5)
            toggle = false
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "search_toolbar"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(ProfileViewController.search(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.setOnlyRightNavigationButton(rightButton)
//        self.setNavigationBarItemText("Yash's Profile")
        getDarkBackGround(self)
        MAMatterView.layer.opacity = 0.0
//         let footer = getFooter(frame: CGRect(x: 0, y: self.view.frame.height - 45, width: self.view.frame.width, height: 45))
//        footer.layer.zPosition = 100
//        self.view.addSubview(footer)
        
//        let profileSquare = ProfileMainView(frame: CGRect(x: 10, y: self.view.frame.size.height/3 - 100, width: self.view.frame.size.width - 20,  height: 500))
//        self.view.addSubview(profileSquare)
        
//        MAMScrollView = UIScrollView(frame: CGRect(x: 10, y: self.view.frame.size.height/3 - 45, width: self.view.frame.size.width - 20, height: 600))
//        MAMScrollView!.scrollEnabled = true
//        self.view.addSubview(MAMScrollView!)
//      
        MAMButton.transform = CGAffineTransformRotate(MAMButton.transform, CGFloat(M_PI))
        
        let MAM = MoreAboutMe(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 20, height: 150))
        MAM.backgroundColor = UIColor.clearColor()
        MAMatterView!.addSubview(MAM)
//
//        MAMScrollView!.contentSize.height = 750
//        MAMScrollView?.delegate = self
        
        let orangeTab = OrangeButton(frame: CGRect(x: 5, y: self.view.frame.size.height - 100, width: self.view.frame.size.width - 10, height: 55))
        orangeTab.orangeButtonTitle.setTitle("My Life", forState: .Normal)
        let fontAwesomeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: orangeTab.frame.size.height))
        fontAwesomeLabel.center = CGPointMake(75, orangeTab.orangeButtonTitle.titleLabel!.frame.size.height/2 + 10)
        fontAwesomeLabel.font = FontAwesomeFont
        fontAwesomeLabel.text = String(format: "%C", faicon["angle_up"]!)
        fontAwesomeLabel.textColor = UIColor.whiteColor()
        orangeTab.orangeButtonTitle.titleLabel!.addSubview(fontAwesomeLabel)
        self.view.addSubview(orangeTab)
        
        orangeTab.orangeButtonTitle.addTarget(self, action: #selector(ProfileViewController.MyLifeDetailsShow(_:)), forControlEvents: .TouchUpInside)
        
//        self.view.bringSubviewToFront(profileCollectionView)
        
//        self.addObserver(self, forKeyPath: "profileViewYPosition", options: .New, context: nil)
        
//        profileViewYPosition = profileViewY
        
//        self.view.setNeedsDisplay()
    }
    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        
//        print("this function is getting called!!")
//        
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func search(sender: AnyObject) {
        
        print("Search Tapped!")
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let myValues = labels[indexPath.item]
        let valueArray = myValues.characters.split{$0 == " "}.map(String.init)
        
        let textOne = NSAttributedString(string: valueArray[0], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
        let textTwo = NSMutableAttributedString(string: valueArray[1], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 12)!])
        
        if valueArray.count > 2 {
        
            let textThree = NSAttributedString(string: valueArray[2], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 12)!])
            textTwo.appendAttributedString(NSAttributedString(string: " "))
            textTwo.appendAttributedString(textThree)
            
        }
        
        let fullText = NSMutableAttributedString(attributedString: textOne)
        fullText.appendAttributedString(NSAttributedString(string: "\n"))
        fullText.appendAttributedString(textTwo)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ProfileDetailCell
        cell.infoLabel.attributedText = fullText
        print("Loading \(cell.infoLabel.attributedText)")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("Selected item: \(indexPath.item)")
        switch indexPath.item {
        case 0:
            let followersVC = storyboard?.instantiateViewControllerWithIdentifier("followers") as! FollowersViewController
            followersVC.whichView = "Following"
            self.navigationController?.pushViewController(followersVC, animated: true)
            break
        case 1:
//            let followersVC = storyboard?.instantiateViewControllerWithIdentifier("followers") as! FollowersViewController
//            followersVC.whichView = "No Followers"
//            self.navigationController?.pushViewController(followersVC, animated: true)
            let followersVC = storyboard?.instantiateViewControllerWithIdentifier("NoFollowing") as! NoFollowingViewController
            self.navigationController?.pushViewController(followersVC, animated: true)
            break
        case 2:
//            let bucketVC = storyboard?.instantiateViewControllerWithIdentifier("bucketList") as! BucketListTableViewController
//            self.navigationController?.pushViewController(bucketVC, animated: true)
            let noBucketVC = storyboard?.instantiateViewControllerWithIdentifier("emptyPages") as! EmptyPagesViewController
            self.navigationController?.pushViewController(noBucketVC, animated: true)
            break
        case 3:
            let bucketVC = storyboard?.instantiateViewControllerWithIdentifier("bucketList") as! BucketListTableViewController
            self.navigationController?.pushViewController(bucketVC, animated: true)
            break
        default:
            break
        }
        
    }
    
//    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        
//        print("fn 2")
//        scrollView.delegate = self
//        MAMScrollView?.layer.zPosition = 20
//        
//    }
//    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        
//        MAMScrollView?.layer.zPosition = 0
//    }
//    
//    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
//        
//        MAMScrollView?.layer.zPosition = 20
//        
//    }
//    
//    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        
//        MAMScrollView?.layer.zPosition = 0
//        
//    }
    
    func MyLifeDetailsShow(sender: AnyObject) {
        
        let myLifeVC = storyboard?.instantiateViewControllerWithIdentifier("myLife") as! MyLifeViewController
        self.navigationController?.presentViewController(myLifeVC, animated: true, completion: nil)
        
    }
    
    
}


class ProfileDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    
}
