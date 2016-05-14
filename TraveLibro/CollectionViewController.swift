//
//  CollectionViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewTwo: UICollectionView!

    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var labels = ["Korea", "India"]
    var images = ["korean_flag", "indian_flag"]
    var labelsTwo = ["8 Restaurants & Bars", "8 Nature & Parks", "8 Beaches"]
    var imagesTwo = ["korean_flag", "indian_flag", "korean_flag"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tripSummary = TripSummaryProfile(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/3))
        tripSummary.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3)
        self.view.addSubview(tripSummary)
        
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionViewTwo.backgroundColor = UIColor.whiteColor()
        
        collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3)
        collectionView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3)
        self.view.addSubview(collectionView)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView == self.collectionView) {
            return self.labels.count
        }
        
        return self.labelsTwo.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        if(collectionView == self.collectionView) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
    //        print("\(labels[indexPath.item])")
            cell.label.text = labels[indexPath.item]
            cell.label.textColor = mainBlueColor
            cell.image.image = UIImage(named: images[indexPath.item])
            return cell
        }
        
        else {
            let cellTwo = collectionView.dequeueReusableCellWithReuseIdentifier("cellTwo", forIndexPath: indexPath) as! MyCollectionViewCell
            cellTwo.labelTwo.text = labelsTwo[indexPath.item]
            cellTwo.labelTwo.textColor = mainBlueColor
            cellTwo.imageTwo.image = UIImage(named: imagesTwo[indexPath.item])
            return cellTwo
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        print("You selected cell #\(indexPath.item)!")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
