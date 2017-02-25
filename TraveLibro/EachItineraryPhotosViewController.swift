//
//  EachItineraryPhotosViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 22/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EachItineraryPhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var arrowDown: UIButton!
    
    @IBOutlet weak var itineraryNameLabel: UILabel!
    
    var selectedItinerary:JSON!
    var photoJSON : [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itineraryNameLabel.text = (selectedItinerary["name"].stringValue)
        photoJSON = (selectedItinerary["photos"].arrayValue)
        
        let arrow = String(format: "%C", faicon["arrow-down"]!)
        arrowDown.setTitle(arrow, for: UIControlState())
        arrowDown.addTarget(self, action: #selector(EachItineraryPhotosViewController.exitMoments(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func exitMoments(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoJSON.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EachItineraryMomentCollectionViewCell        
        cell.photo.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(photoJSON[indexPath.row]["name"].stringValue)", width: 100))
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell = self.collectionView(collectionView, cellForItemAt: indexPath) as! EachItineraryMomentCollectionViewCell
        
        self.dismiss(animated: true) {
            let singlePhotoController = self.storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
            singlePhotoController.mainImage?.image = selectedCell.photo.image
            singlePhotoController.index = indexPath.row
            singlePhotoController.whichView = "detail_itinerary"
            singlePhotoController.photos = self.photoJSON
            singlePhotoController.postId = "unknown"
            print("globalNavigationController: \(globalNavigationController)")
            globalNavigationController.pushViewController(singlePhotoController, animated: true)
        }
    }
}


class EachItineraryMomentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
}
