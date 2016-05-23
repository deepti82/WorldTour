//
//  MomentsEachViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MomentsEachViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! MomentsEachCollectionViewCell
        cell.momentsImage.image = UIImage(named: "disney-world")
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 30
        
    }

}

class MomentsEachCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var momentsImage: UIImageView!
    
}
