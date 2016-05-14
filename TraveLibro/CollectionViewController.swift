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
    var imagesTwo = ["martini_icon", "windmill_icon", "palm_trees_icon"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)

        let tripSummary = TripSummaryProfile(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/3))
        tripSummary.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3 - 50)
        self.view.addSubview(tripSummary)
        
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionViewTwo.layer.zPosition = 10
        collectionView.layer.zPosition = 10
        collectionViewTwo.backgroundColor = UIColor.whiteColor()
        
        let countryCountLabel  = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        countryCountLabel.text = "2 Countries Visited"
        countryCountLabel.font = UIFont(name: "Avenir-Roman", size: 10)
        countryCountLabel.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.width + collectionView.frame.size.height - 50)
        countryCountLabel.layer.zPosition = 10
        self.view.addSubview(countryCountLabel)
        
        let background = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 150))
        background.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
        background.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(background)
        
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        scrollView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/3 * 2.5 - 20)
        scrollView.contentSize.height = 1000
        self.view.addSubview(scrollView)
        
        let dayOne = TripSummaryItinerary(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        dayOne.center = CGPointMake(self.view.frame.size.width/2, 50)
        scrollView.addSubview(dayOne)
        
        let dayTwo = TripSummaryItinerary(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 100))
        dayTwo.center = CGPointMake(self.view.frame.size.width/2, dayOne.frame.size.height + 100)
        scrollView  .addSubview(dayTwo)
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
            cellTwo.imageTwo.backgroundColor = UIColor(patternImage: UIImage(named: "halfnhalfbgGreen")!)
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
