//
//  MyLifeMomentsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 07/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MyLifeMomentsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let titleLabels = ["November 2015, (25)", "October 2015, (25)", "September 2015, (25)", "August 2015, (25)", "July 2015, (25)"]
    let Month = "November 2015"
    let reviewsLL = ["Mumbai", "London"]
    let reviewsTL = ["India", "France"]
    
    var images =  [""]
    
    var whichView = "All"
    
    @IBOutlet weak var mainView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.addObserver(self, forKeyPath: "whichView", options: .Prior, context: nil)
//        if isEmptyProfile {
//            
//            let myLifeVC = self.parentViewController as! MyLifeViewController
//            myLifeVC.whatTab = "Moments"
//            myLifeVC.collectionContainer.alpha = 0
//            myLifeVC.tableContainer.alpha = 0
//            myLifeVC.journeysContainerView.alpha = 1
////            myLifeVC.view.setNeedsDisplay()
//            
//        }
        
    }
    
//    func reloadViews(sender: AnyObject) {
//        
//        mainView.reloadData()
//        
//    }
//    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        mainView.reloadData()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if whichView == "All" {
            return titleLabels.count
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch whichView {
        case "All":
            return 3*11
        case "Monthly", "SelectCover":
            return images.count
        case "Local Life":
            return 4
        case "Travel Life":
            return 4
        default:
            break
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        
        switch whichView {
        case "All":
            return CGSize(width: 30, height: 30)
        case "Monthly", "SelectCover":
            return CGSize(width: 115, height: 115)
        case "Local Life", "Travel Life":
            return CGSize(width: 165, height: 204)
        default:
            break
        }
        
        return CGSize(width: 150, height: 75)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch whichView {
        case "All":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! photosCollectionViewCell
            return cell
        case "Monthly", "SelectCover":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MomentsLargeImageCell", for: indexPath) as! photosTwoCollectionViewCell
            DispatchQueue.main.async(execute: {
                cell.photoBig.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(self.images[(indexPath as NSIndexPath).item])")!))
            })
            return cell
        case "Local Life":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "localLifeMomentsCell", for: indexPath) as! LocalLifeMomentsCollectionViewCell
            cell.bgImage.transform = CGAffineTransform(rotationAngle: 0.0349066)
            cell.bgImage.layer.cornerRadius = 5
            cell.coverImage.layer.cornerRadius = cell.coverImage.frame.width/2
            cell.coverImage.clipsToBounds = true
            return cell
        case "Travel Life":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "travelLifeMomentsCell", for: indexPath) as! TravelLifeMomentsCollectionViewCell
            cell.coverImage.layer.cornerRadius = cell.coverImage.frame.width/2
            cell.coverImage.clipsToBounds = true
            cell.bgImage.layer.borderColor = UIColor.white.cgColor
            cell.bgImage.layer.borderWidth = 5.0
            cell.bgImage.layer.cornerRadius = 5
            cell.bgImage.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.bgImage.layer.shadowColor = UIColor.black.cgColor
            cell.bgImage.layer.shadowRadius = 10
            cell.bgImage.transform = CGAffineTransform(rotationAngle: 0.0349066)
            cell.bgImage.clipsToBounds = true
            return cell
        default:
            break
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewsCell", for: indexPath) as! reviewsCollectionViewCell
        if whichView == "Reviews LL" {
            cell.bgImage.image = UIImage(named: "reviewsLocalLifeAlbum")
            cell.placeName.text = reviewsTL[(indexPath as NSIndexPath).row]
            
        }
        else {
            cell.bgImage.image = UIImage(named: "reviewsTLAlbum")
            cell.placeName.text = reviewsLL[(indexPath as NSIndexPath).row]
        }
        cell.foregroundImage.layer.cornerRadius = cell.foregroundImage.frame.width/2
        cell.foregroundImage.clipsToBounds = true
        cell.foregroundImage.layer.borderColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1).cgColor
        cell.foregroundImage.layer.borderWidth = 3.0
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if whichView == "All" {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! TitleHeaderView
            let array = titleLabels[(indexPath as NSIndexPath).section].components(separatedBy: ", ")
            print(array)
            let headerLabel = NSMutableAttributedString(string: "")
            let month = NSAttributedString(string: array[0], attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
            let count = NSAttributedString(string: " \(array[1])", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 11)!])
            headerLabel.append(month)
            headerLabel.append(count)
            header.titleLabel.attributedText = headerLabel
            return header
            
        }
        else if whichView == "Monthly"{
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! TitleHeaderView
            header.titleLabel.text = Month
            return header
            
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! TitleHeaderView
        header.titleLabel.text = ""
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if whichView == "Local Life" || whichView == "Travel Life" || whichView == "All" {
            whichView = "Monthly"
            collectionView.reloadData()
        }
            
        else if whichView == "SelectCover" {
            
            print("inside select cover")
            selectImage((indexPath as NSIndexPath).item)
            
        }
        
        else if whichView == "Reviews TL" || whichView == "Reviews LL" {
            
            let myLifeVC = self.parent as! MyLifeViewController
            myLifeVC.whatTab = "Reviews"
            myLifeVC.collectionContainer.alpha = 0
            myLifeVC.tableContainer.alpha = 1
            myLifeVC.view.setNeedsDisplay()
            
            let tableVC = myLifeVC.childViewControllers.last as! AccordionViewController
            tableVC.whichView = self.whichView
            tableVC.accordionTableView.reloadData()
        }
        
        
    }
    
    func selectImage(_ index: Int) {
        
        print("inside select image")
        let allvcs = self.navigationController!.viewControllers
        for vc in allvcs {
            
            if vc.isKind(of: EndJourneyViewController.self) {
                
                let endvc = vc as! EndJourneyViewController
                endvc.coverImage = images[index] as! String
                endvc.makeCoverPicture(images[index] as! String)
                self.navigationController!.popToViewController(endvc, animated: true)
                
            }
            
        }
    }

}


class TitleHeaderView: UICollectionReusableView {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
}

class photosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
}

class photosTwoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoBig: UIImageView!
    
}

class reviewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var foregroundImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    
}

class TravelLifeMomentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumDated: UILabel!
    
    
}

class LocalLifeMomentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var fileImage: UIImageView!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    
}
