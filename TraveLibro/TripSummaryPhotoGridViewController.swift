//
//  TripSummaryPhotoGridViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class TripSummaryPhotoGridViewController: UICollectionViewController {
    
    var journeyId = ""
    var myPhotos: [JSON] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        getJourneyPhotos()
        
    }

    func getJourneyPhotos() {
        
        request.journeyTypeData(journeyId, type: "photos", userId: currentUser["_id"].string!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    self.myPhotos = response["data"].array!
                    self.collectionView!.reloadData()
                    
                }
                else {
                    
                    print("response error")
                    
                }
                
            })
            
        })
        
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myPhotos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! gridCollectionViewCell
        cell.photo.image = UIImage(data: NSData(contentsOfURL: NSURL(string: "\(adminUrl)upload/readFile?file=\(myPhotos[indexPath.row]["name"])")!)!)
        return cell
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

class gridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    
}
