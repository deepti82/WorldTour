//
//  SignupCardsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignupCardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var profileImage: UIView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var theScrollView: UIScrollView!
    @IBOutlet weak var pageCard: UIView!
    @IBOutlet weak var theCollectionView: UICollectionView!
    
    var iconLabelArray = ["Island & Beach", "City", "Safari", "Mountains", "Cruise", "Countryside", "Island & Beach", "City", "Safari", "Mountains", "Cruise", "Countryside"]
    
    var cardText: String!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("In the SignupCardsViewController")
        cardTitle.text = cardText
        
        let dp = ProfilePic(frame: CGRect(x: 0, y: 0, width: profileImage.frame.width, height: profileImage.frame.height))
        profileImage.addSubview(dp)
        
        let myCount: CGFloat = CGFloat(iconLabelArray.count)
        
        theScrollView.contentSize.height = theScrollView.frame.size.height
        
        self.getCardHeight(myCount)
        
        print("page card height: \(pageCard.frame.size.height)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! PageViewControllerCollectionViewCell
        cell.checkboxImage.image = UIImage(named: "palm_trees_icon")
        cell.checkboxLabel.text = iconLabelArray[indexPath.item]
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return iconLabelArray.count
        
    }
    
    func getCardHeight(count: CGFloat) -> Void {
        
        let heightIncrease: CGFloat = (count - 6)/2
        
        if (count > 6) {
            
            theCollectionView.frame.size.height += 500 * heightIncrease
            theScrollView.contentSize.height += 500 * heightIncrease
            pageCard.frame.size.height += 500 * heightIncrease
            
        }
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

class PageViewControllerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var checkboxImage: UIImageView!
    @IBOutlet weak var checkboxLabel: UILabel!
    
}
