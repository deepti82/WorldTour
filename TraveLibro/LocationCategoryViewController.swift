//
//  LocationCategoryViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class LocationCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var labels = ["Restaurants & Bars", "Nature & Parks", "Beaches", "Museums & Galleries", "Sights & Landmarks", "Religious Sites", "Restaurants & Bars", "Nature & Parks", "Beaches", "Museums & Galleries", "Sights & Landmarks", "Religious Sites", "Restaurants & Bars", "Nature & Parks", "Beaches", "Museums & Galleries", "Sights & Landmarks", "Religious Sites"]
    var images = ["martini_icon", "windmill_icon", "palm_trees_icon", "museum_icon", "landmark_icon", "namaste_icon", "martini_icon", "windmill_icon", "palm_trees_icon", "museum_icon", "landmark_icon", "namaste_icon", "martini_icon", "windmill_icon", "palm_trees_icon", "museum_icon", "landmark_icon", "namaste_icon"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getDarkBackGround(self)
        collectionView.backgroundColor = UIColor.clearColor()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! LCCollectionViewCell
        cell.theLabel.text = labels[indexPath.item]
        
        let myImage = UIImageView(frame: CGRect(x: -20, y: 0, width: 40, height: 40))
        myImage.image = UIImage(named: images[indexPath.item])
        myImage.contentMode = .ScaleAspectFit
        cell.theButton.titleLabel?.addSubview(myImage)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

class LCCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var theButton: UIButton!
    @IBOutlet weak var theLabel: UILabel!
    
    
}
