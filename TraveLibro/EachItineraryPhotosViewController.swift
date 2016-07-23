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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arrow = String(format: "%C", faicon["arrow-down"]!)
        arrowDown.setTitle(arrow, forState: .Normal)
        arrowDown.addTarget(self, action: #selector(EachItineraryPhotosViewController.exitMoments(_:)), forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func exitMoments(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 25
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! EachItineraryMomentCollectionViewCell
        return cell
        
    }

}

class EachItineraryMomentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
}