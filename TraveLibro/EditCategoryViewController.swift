//
//  EditCategoryViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/26/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit


class EditCategoryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    var categoryTextView: UILabel!
    let categories: [JSON] = [["title": "Restaurants & Bars", "image": "palm_trees_icon"], ["title": "Natures & Parks", "image": "palm_trees_icon"], ["title": "Sights & Landmarks", "image": "palm_trees_icon"], ["title": "Museums & Galleries", "image": "palm_trees_icon"], ["title": "Adventures & Excursions", "image": "palm_trees_icon"], ["title": "Zoos & Aquariums", "image": "palm_trees_icon"], ["title": "Events & Festivals", "image": "palm_trees_icon"], ["title": "Shopping", "image": "palm_trees_icon"], ["title": "Beaches", "image": "palm_trees_icon"], ["title": "Religious", "image": "palm_trees_icon"], ["title": "Cinema & Theatres", "image": "palm_trees_icon"], ["title": "Hotels & Accomodation", "image": "palm_trees_icon"], ["title": "Airport", "image": "palm_trees_icon"], ["title": "Others", "image": "palm_trees_icon"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBackGround(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! categoryCollectionViewCell
        cell.categoryLabel.text = categories[indexPath.row]["title"].string!
        if(cell.categoryLabel.text == categoryTextView.text) {
            cell.categoryButton.setBackgroundImage(UIImage(named: "halfgreenbox"), for: UIControlState())
        } else {
            cell.categoryButton.setBackgroundImage(UIImage(named: "graybox"), for: UIControlState())
        }
        return cell
        
    }
    
    var prevIndex: IndexPath!
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryTextView.text = categories[indexPath.row]["title"].stringValue
        collectionView.reloadData()
    }

}

class categoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
}
