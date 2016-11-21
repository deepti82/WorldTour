//
//  NearMeViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 17/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class NearMeViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var nearMeCollectionView: UICollectionView!
    var city: String!
    
    let imageArr: [String] = []
    let textArr: [String] = ["Restaurants & Bars", "Netunre & Parks", "Sights & Landmarks", "Museums & Galleries", "Zoos & Aqua", "Shopping", "Religious", "Cinema & Theatre", "Hotels & Accomodations", "Transportation", "Health & Beauty", "Rentals", "Entertainment", "Essentials", "Emergency", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)
        navigationController?.hidesBarsOnSwipe = false
        nearMeCollectionView.backgroundColor = UIColor.clear
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nearMeCell", for: indexPath) as! NearMeCell
        cell.button.imageView?.image = UIImage(named: "backpack")?.withRenderingMode(.alwaysTemplate)
        cell.button.imageView?.tintColor = mainBlueColor
        cell.button.setBackgroundImage(UIImage(named: "halfnhalfbg"), for: .normal)
        cell.button.layer.cornerRadius = 25.0
        cell.button.clipsToBounds = true
        cell.label.text = textArr[indexPath.row]
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

class NearMeCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
}
