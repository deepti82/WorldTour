//
//  MomentsEachViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MomentsEachViewController: UIViewController, UICollectionViewDataSource {

    @IBAction func dragGesture(sender: AnyObject) {
        
        print("In the swipe gesture function 2")
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBOutlet var panGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.clearColor()
//        collectionView.delaysContentTouches = false
        self.view.bringSubviewToFront(collectionView)
        
    }
    
    func modalDismiss(sender: UITapGestureRecognizer) {
        
        print("In the swipe gesture function")
        dismissViewControllerAnimated(true, completion: nil)
        
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
        
        return 90
        
    }

}

class MomentsEachCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var momentsImage: UIImageView!
    
}
