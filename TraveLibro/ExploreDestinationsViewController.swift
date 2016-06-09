//
//  ExploreDestinationsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ExploreDestinationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchHeader = SearchFieldView(frame: CGRect(x: 15, y: 35, width: self.view.frame.width - 30, height: 30))
//        searchHeader.center = CGPointMake(self.view.frame.width/2, 20)
        self.view.addSubview(searchHeader)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let coverImageGradient = CAGradientLayer()
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell") as! ExploreDestinationsTableViewCell
        
        let blackColour = UIColor.blackColor().colorWithAlphaComponent(0.9).CGColor as CGColorRef
        let transparent = UIColor.clearColor().CGColor as CGColorRef
        
        coverImageGradient.frame = cell.contentMainView.frame
        coverImageGradient.frame.size.width = cell.contentMainView.frame.width + 100
        coverImageGradient.colors = [blackColour, transparent]
        coverImageGradient.locations = [0.0, 0.25]
        
        cell.contentMainView.layer.addSublayer(coverImageGradient)
        cell.countryLabel.layer.zPosition = 10
        cell.flagImage.layer.zPosition = 10
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! ExploreDestinationsCollectionViewCell
        
        let cityImageGradient = CAGradientLayer()
        
        let blackColour = UIColor.blackColor().colorWithAlphaComponent(0.9).CGColor as CGColorRef
        let transparent = UIColor.clearColor().CGColor as CGColorRef
        
        cityImageGradient.frame = cell.cityLabel.bounds
        cityImageGradient.colors = [blackColour, transparent]
        cityImageGradient.locations = [0.0, 0.75]
        
        cell.cityLabel.layer.addSublayer(cityImageGradient)
        cell.cityText.layer.zPosition = 10
        return cell
        
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        
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


class ExploreDestinationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var contentMainView: UIView!
    
    
}

class ExploreDestinationsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityLabel: UIView!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityText: UILabel!
    
}