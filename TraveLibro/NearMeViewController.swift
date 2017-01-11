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
    
    let imageArr: [String] = ["restaurantsandbars", "leaftrans", "sightstrans", "museumstrans", "zootrans", "shopping", "religious", "cinematrans", "hotels", "planetrans", "health_beauty", "rentals", "entertainment", "essential", "emergency", "othersdottrans"]
    let textArr: [String] = ["Restaurants & Bars", "Nature & Parks", "Sights & Landmarks", "Museums & Galleries", "Zoo & Aquariums", "Shopping", "Religious", "Cinema & Theatres", "Hotels & Accomodations", "Transportation", "Health & Beauty", "Rentals", "Entertainment", "Essentials", "Emergency", "Others"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)
        navigationController?.hidesBarsOnSwipe = false
        nearMeCollectionView.backgroundColor = UIColor.clear
        self.setTopNavigation("Near Me")
    }
    
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nearMeCell", for: indexPath) as! NearMeCell
        
        //cell.button.imageView?.image = UIImage(named: self.imageArr[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.button.setImage(UIImage(named: self.imageArr[indexPath.row])?.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.button.imageView?.contentMode = .scaleAspectFit
        cell.button.imageView?.tintColor = mainBlueColor
        cell.button.isUserInteractionEnabled = false
        cell.button.setBackgroundImage(UIImage(named: "orange"), for: .normal)
        cell.button.layer.cornerRadius = 25.0
        cell.button.clipsToBounds = true
        cell.label.text = self.textArr[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nearMeListController = storyboard?.instantiateViewController(withIdentifier: "nearMeListVC") as! NearMeListViewController
        nearMeListController.city = city
        nearMeListController.nearMeType = textArr[indexPath.row]
        navigationController?.pushViewController(nearMeListController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

class NearMeCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    
}
