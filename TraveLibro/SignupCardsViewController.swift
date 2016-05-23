//
//  SignupCardsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignupCardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cardTitle: UILabel!
    @IBOutlet weak var cardDescription: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var iconLabelArray = ["Island & Beach", "City", "Safari", "Mountains", "Cruise", "Countryside", "Island & Beach", "City", "Safari", "Mountains", "Cruise", "Countryside", "Island & Beach", "City", "Safari", "Mountains", "Cruise", "Countryside"]
    
    var cardText: String!
    var pageIndex: Int!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("In the SignupCardsViewController")
        collectionView.backgroundColor = UIColor.whiteColor()
        cardTitle.text = cardText
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SignUpCardsCollectionViewCell
        cell.iconImage.image = UIImage(named: "adventure_icon")
        cell.iconLabel.text = iconLabelArray[indexPath.item]
        print("in the cell collection view function")
        return cell
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return iconLabelArray.count
        
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

class SignUpCardsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var iconLabel: UILabel!
    
    
}
