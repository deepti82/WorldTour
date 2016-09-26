//
//  EditCategoryViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/26/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class EditCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let categories: [JSON] = [["title": "Restaurants & Bars", "image": "palm_trees_icon"], ["title": "Natures & Parks", "image": "palm_trees_icon"], ["title": "Sights & Landmarks", "image": "palm_trees_icon"], ["title": "Museums & Galleries", "image": "palm_trees_icon"], ["title": "Adventures & Excursions", "image": "palm_trees_icon"], ["title": "Zoos & Aquariums", "image": "palm_trees_icon"], ["title": "Events & Festivals", "image": "palm_trees_icon"], ["title": "Shopping", "image": "palm_trees_icon"], ["title": "Beaches", "image": "palm_trees_icon"], ["title": "Religious", "image": "palm_trees_icon"], ["title": "Cinema & Theatres", "image": "palm_trees_icon"], ["title": "Hotels & Accomodation", "image": "palm_trees_icon"], ["title": "Airport", "image": "palm_trees_icon"], ["title": "Others", "image": "palm_trees_icon"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)

        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categories.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! categoryCollectionViewCell
        cell.categoryLabel.text = categories[indexPath.row]["title"].string!
        return cell
        
    }
    
    var prevIndex: NSIndexPath!
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        print("selected cell")
        
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as! categoryCollectionViewCell
        
        if prevIndex == nil {
            
            print("selected same cell")
            selectedCell.categoryButton.setBackgroundImage(UIImage(named: "halfgreenbox"), forState: .Normal)
            prevIndex = indexPath
        }
        
        else if prevIndex != indexPath {
            
            print("selected different cell")
            let prevSelectedCell = collectionView.cellForItemAtIndexPath(prevIndex) as! categoryCollectionViewCell
            prevSelectedCell.categoryButton.setBackgroundImage(UIImage(named: "graybox"), forState: .Normal)
            selectedCell.categoryButton.setBackgroundImage(UIImage(named: "halfgreenbox"), forState: .Normal)
            prevIndex = indexPath
            
        }
        
    }

}

class categoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
}
