//
//  ProfileViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 21/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    let labelOne = ["300", "223", "10", "10", "20", "40", "50"]
    let labelTwo = ["Following", "Followers", "Countries Visited", "Bucket List", "Following", "Followers", "Followers"]
    
    @IBOutlet weak var profileCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
         let footer = getFooter(frame: CGRect(x: 0, y: self.view.frame.height - 45, width: self.view.frame.width, height: 45))
        footer.layer.zPosition = 100
        self.view.addSubview(footer)
        
        let profileSquare = ProfileMainView(frame: CGRect(x: 10, y: self.view.frame.size.height/3 - 45, width: self.view.frame.size.width - 20,  height: 450))
        self.view.addSubview(profileSquare)
        
        let orangeTab = OrangeButton(frame: CGRect(x: 5, y: self.view.frame.size.height - 100, width: self.view.frame.size.width - 10, height: 55))
        orangeTab.orangeButtonTitle.setTitle("My Life", forState: .Normal)
        let fontAwesomeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: orangeTab.frame.size.height))
        fontAwesomeLabel.center = CGPointMake(orangeTab.frame.size.width/2 + 50, orangeTab.frame.size.height/2)
        fontAwesomeLabel.font = FontAwesomeFont
        fontAwesomeLabel.text = String(format: "%C", faicon["angle_up"]!)
        fontAwesomeLabel.textColor = UIColor.whiteColor()
        orangeTab.orangeButtonTitle.addSubview(fontAwesomeLabel)
        self.view.addSubview(orangeTab)
        
        self.view.bringSubviewToFront(profileCollectionView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ProfileDetailCell
        cell.LabelTop.text = labelOne[indexPath.item]
        cell.LabelBottom.text = labelTwo[indexPath.item]
        print("Loading \(indexPath.item)")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return labelTwo.count
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("Selected item: \(indexPath.item)")
        
    }

}


class ProfileDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var LabelTop: UILabel!
    @IBOutlet weak var LabelBottom: UILabel!
    
}
