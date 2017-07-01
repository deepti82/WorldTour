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
    let categories: [JSON] = [["title": "Transportation", "image": "planetrans"], ["title": "Hotels & Accomodations", "image": "hotels"], ["title": "Restaurants & Bars", "image": "restaurantsandbars"], ["title": "Nature & Parks", "image": "leaftrans"], ["title": "Sights & Landmarks", "image": "sightstrans"], ["title": "Museums & Galleries", "image": "museumstrans"], ["title": "Religious", "image": "regli"], ["title": "Shopping", "image": "shopping"], ["title": "Zoo & Aquariums", "image": "zootrans"], ["title": "Cinema & Theatres", "image": "cinematrans"], ["title": "City", "image": "city_icon"], ["title": "Health & Beauty", "image": "health_beauty"], ["title": "Rentals", "image": "rentals"], ["title": "Entertainment", "image": "entertainment"], ["title": "Essentials", "image": "essential"], ["title": "Emergency", "image": "emergency"], ["title": "Others", "image": "othersdottrans"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBackGround(self)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setTopNavigation("Select Category")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! categoryCollectionViewCell
        cell.categoryButton.imageView?.contentMode = .scaleAspectFit
        cell.categoryButton.clipsToBounds = true
        cell.categoryButton.setImage(UIImage(named:"\(categories[indexPath.row]["image"].string!)"), for: .normal)
        cell.categoryButton.tintColor = mainBlueColor
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

    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }

}

class categoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    
}
