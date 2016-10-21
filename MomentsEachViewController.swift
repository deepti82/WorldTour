//
//  MomentsEachViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MomentsEachViewController: UIViewController, UICollectionViewDataSource {

    @IBAction func dragGesture(_ sender: AnyObject) {
        
        print("In the swipe gesture function 2")
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet var panGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor.clear
//        collectionView.delaysContentTouches = false
        self.view.bringSubview(toFront: collectionView)
        
    }
    
    func modalDismiss(_ sender: UITapGestureRecognizer) {
        
        print("In the swipe gesture function")
        dismiss(animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MomentsEachCollectionViewCell
        cell.momentsImage.image = UIImage(named: "disney-world")
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 90
        
    }

}

class MomentsEachCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var momentsImage: UIImageView!
    
}
