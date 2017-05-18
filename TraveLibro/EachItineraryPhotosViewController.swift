//
//  EachItineraryPhotosViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 22/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class EachItineraryPhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var arrowDown: UIButton!
    
    @IBOutlet weak var itineraryNameLabel: UILabel!
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    
    var selectedItinerary:JSON!
    var photoJSON : [JSON] = []
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollectionView.delegate = self
        getDarkBackGround(self)
        
        itineraryNameLabel.text = (selectedItinerary["name"].stringValue)
        
        photoJSON = (selectedItinerary["photos"].arrayValue)
        
        if selectedItinerary != "" {
            itineraryNameLabel.text = "Photo (\(self.photoJSON.count))"            
        }else{
            itineraryNameLabel.text = "Photo (\(globalPostImage.count))"
        }      
        
//        if (photoJSON.count == 0) {
//            Toast(text: "No photos in \(selectedItinerary["name"].stringValue) itinerary").show()
//        }
        
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
    
    //MARK: - CollectionView Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedItinerary != "" {
            return photoJSON.count
        }else{
            return globalPostImage.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if shouldShowBigImage(position: indexPath.row) {
//            return CGSize(width: (collectionView.frame.size.width), height: collectionView.frame.size.width * 0.7)
//        }
        
        let wdth = (screenWidth - 15)/2
        
        return CGSize(width: wdth, height: (wdth / 80) * 100)
        
//        return CGSize(width: (collectionView.frame.size.width/3 - 2), height: (collectionView.frame.size.width/3 - 2))       
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EachItineraryMomentCollectionViewCell        
//        cell.photo.image = UIImage(named: "logo-default")
        
        if selectedItinerary != "" {
            cell.photo.hnk_setImageFromURL(getImageURL(photoJSON[indexPath.row]["name"].stringValue, width: BLUR_PHOTO_WIDTH))
            cell.photo.hnk_setImageFromURL(getImageURL(photoJSON[indexPath.row]["name"].stringValue, width: 0))
        }else{
            cell.photo.image = globalPostImage[indexPath.row].image
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let singlePhotoController = self.storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.index = indexPath.row        
       
        if selectedItinerary != "" {
            singlePhotoController.photos = self.photoJSON
            singlePhotoController.fetchType = photoVCType.FROM_DETAIL_ITINERARY
            singlePhotoController.shouldShowBottomView = (selectedItinerary["type"].stringValue == "quick-itinerary") ? true : selectedItinerary["status"].boolValue
        }
        else {            
            singlePhotoController.fetchType = photoVCType.FROM_QUICK_ITINERARY_LOCAL
            singlePhotoController.shouldShowBottomView = false
        }
        
        singlePhotoController.postId = "unknown"        
        self.dismiss(animated: true) {
            print("globalNavigationController: \(globalNavigationController)")
            globalNavigationController.pushViewController(singlePhotoController, animated: true)
        }
    }
}


class EachItineraryMomentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
}
