//
//  SummarySubViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 27/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SummarySubViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var tripSummaryView: UIView!
    
    var labels = ["8 Restaurants & Bars", "8 Nature & Parks", "8 Beaches", "8 Restaurants & Bars", "8 Nature & Parks", "8 Beaches"]
    var images = ["martini_icon", "nature_checkin", "palm_trees_icon", "martini_icon", "nature_checkin", "palm_trees_icon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("cell view: \(tripSummaryEach(frame: CGRect(x: 0, y: 0, width: cellView.frame.width, height: 100)))")
        
        print("cell view Two: \(cellView)")
        
        tripSummaryView.layer.cornerRadius = 5
//        tripSummaryView.clipsToBounds = true
        
        let cellSubview = VerticalLayout(width: self.view.frame.width - 55)
//        cellSubview.backgroundColor = UIColor.whiteColor()
//        cellSubview.frame.size.height = cellView.frame.height
        cellSubview.clipsToBounds = true
        cellView.addSubview(cellSubview)

        let cellOne = tripSummaryEach(frame: CGRect(x: 0, y: 0, width: cellSubview.frame.width, height: 75))
        cellOne.layer.cornerRadius = 5
        cellOne.clipsToBounds = true
        cellSubview.addSubview(cellOne)

        let cellTwo = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
        cellTwo.layer.cornerRadius = 5
        cellTwo.clipsToBounds = true
        cellSubview.addSubview(cellTwo)
        
        let cellThree = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
        cellThree.layer.cornerRadius = 5
        cellThree.clipsToBounds = true
        cellSubview.addSubview(cellThree)
        
        let cellFour = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
        cellFour.layer.cornerRadius = 5
        cellFour.clipsToBounds = true
        cellSubview.addSubview(cellFour)
        
        let cellFive = tripSummaryEach(frame: CGRect(x: 0, y: 20, width: cellSubview.frame.width, height: 75))
        cellFive.layer.cornerRadius = 5
        cellFive.clipsToBounds = true
        cellSubview.addSubview(cellFive)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return labels.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TripStatsCollectionViewCell
        cell.statImage.setImage(UIImage(named: images[indexPath.item]), forState: .Normal)
        cell.statLabel.text = labels[indexPath.item]
        return cell
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class TripStatsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var statImage: UIButton!
    @IBOutlet weak var statLabel: UILabel!
    
}
