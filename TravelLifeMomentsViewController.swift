//
//  TravelLifeMomentsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TravelLifeMomentsViewController: UIViewController, UICollectionViewDataSource {

    let titles = ["London Journey (40)", "Goa Reunion (35)", "London Journey (40)", "Goa Reunion (35)", "London Journey (40)"]
    let titleDate = ["14 Jan, 2014", "14 Feb, 2014", "14 Jan, 2014", "14 Feb, 2014", "14 Jan, 2014"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! TravelLifeMomentsCollectionViewCell
        cell.coverImage.layer.cornerRadius = cell.coverImage.frame.size.height/2
        cell.coverImage.clipsToBounds = true
        cell.albumTitle.text = titles[indexPath.item]
        cell.albumDated.text = titleDate[indexPath.item]
        cell.bgImage.layer.borderColor = UIColor.whiteColor().CGColor
        cell.bgImage.layer.borderWidth = 3.0
        cell.bgImage.layer.cornerRadius = 8.0
        cell.bgImage.transform = CGAffineTransformMakeRotation(0.0349066)
        //cell.bgImage.layer.shadowColor = UIColor.blackColor().CGColor
        cell.bgImage.layer.shadowRadius = 10.0
        cell.bgImage.layer.shadowOffset = CGSize(width: 10, height: 10)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class TravelLifeMomentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumDated: UILabel!
    
    
}