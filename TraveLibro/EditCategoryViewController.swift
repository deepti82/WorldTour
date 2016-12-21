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
    let categories: [JSON] = [["title": "Beaches", "image": "palm_trees_icon"], ["title": "Airport", "image": "planetrans"], ["title": "Hotels", "image": "hotels"], ["title": "Restaurants", "image": "restaurantsandbars"], ["title": "Netunre & parks", "image": "leaftrans"], ["title": "sights & Landmarks", "image": "sightstrans"], ["title": "Museums & Gallaries", "image": "museumstrans"], ["title": "Religious", "image": "religious"], ["title": "Shopping", "image": "shopping"], ["title": "Adventure & Excursion", "image": "adventureExcursion"], ["title": "Zoos & Aqua", "image": "zootrans"], ["title": "Cinemas & Theatre", "image": "cinematrans"], ["title": "Others", "image": "othersdottrans"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBackGround(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! categoryCollectionViewCell
        cell.categoryButton.imageView?.contentMode = .scaleAspectFit
        cell.categoryButton.setImage(UIImage(named:"\(categories[indexPath.row]["image"].string!)"), for: .normal)
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
