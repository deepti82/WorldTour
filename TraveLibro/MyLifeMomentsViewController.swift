//
//  MyLifeMomentsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 07/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class MyLifeMomentsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let titleLabels = ["November 2015, (25)", "October 2015, (25)", "September 2015, (25)", "August 2015, (25)", "July 2015, (25)"]
    let Month = "November 2015"
    let reviewsLL = ["Mumbai", "London"]
    let reviewsTL = ["India", "France"]
    
    var images =  ["5888812cac0b510d59f3c855.jpg"]
    
    var whichView = "Travel Life"
    var page = 1
    var momentType = "travel-life"
    var allData:[JSON] = []
    var loadStatus = true
    
    
    @IBOutlet weak var mainView: UICollectionView!
    
    override func viewDidLoad() {
        print("in play....")
        super.viewDidLoad()
        setTopNavigation("Photos")
        mainView.delegate = self
        mainView.dataSource = self
//        loadTravelLife(pageno: page, type: momentType)
        navigationItem.leftBarButtonItem?.title = ""
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(loadStatus)
        if scrollView.contentOffset.y == (scrollView.contentSize.height - scrollView.frame.size.height) {

            if loadStatus {
                print("in load more of data.")
                page = page + 1
                loadTravelLife(pageno: page, type: momentType)
            }
        }
        
    }
    

    
    func loadTravelLife(pageno:Int, type:String) {
        request.getMomentTravelife(currentUser["_id"].stringValue, pageNumber: pageno, completion: {(request) in
            DispatchQueue.main.async {
                if request["data"].count > 0 {
                    self.loadStatus = true
                    if pageno == 1 {
                        self.allData = request["data"].array!
                    }else{
                    for post in request["data"].array! {
                        self.allData.append(post)
                    }
                    }
                    print("after load ")
                    print(request["data"])
                    self.mainView.reloadData()
                }else{
                    self.loadStatus = false
                }
            }
        })
    }

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
            return allData.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        
        switch whichView {
        case "All":
            return CGSize(width: 30, height: 30)
        case "Monthly", "SelectCover":
            return CGSize(width: 110, height: 110)
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
            cell.photoBig.image = nil
            cell.photoBig.backgroundColor = UIColor.white
//            DispatchQueue.main.async(execute: {
                cell.photoBig.hnk_setImageFromURL(URL(string: "\(adminUrl)upload/readFile?file=\(self.images[(indexPath as NSIndexPath).item])&width=200")!)
//            })
            return cell
        case "Local Life":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "localLifeMomentsCell", for: indexPath) as! LocalLifeMomentsCollectionViewCell
            cell.bgImage.transform = CGAffineTransform(rotationAngle: 0.0349066)
            cell.bgImage.layer.cornerRadius = 5
            cell.coverImage.layer.cornerRadius = cell.coverImage.frame.width/2
            cell.coverImage.clipsToBounds = true
            let getImageUrl = URL(string:adminUrl + "upload/readFile?file=" + allData[indexPath.row]["coverPhoto"].stringValue + "&width=500")
            
            cell.coverImage.hnk_setImageFromURL(getImageUrl!)
            cell.bgImage.hnk_setImageFromURL(getImageUrl!)

            return cell
        case "Travel Life":
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "travelLifeMomentsCell", for: indexPath) as! TravelLifeMomentsCollectionViewCell
            
            
            cell.coverImage.layer.cornerRadius = cell.coverImage.frame.width/2
            cell.coverImage.clipsToBounds = true
            
            print(allData[indexPath.row]["name"].stringValue)
            print(indexPath.row)
            
//            cell.albumDated.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: allData[indexPath.row]["startTime"].stringValue, isDate: false)
            
            cell.bgImage.layer.borderColor = UIColor.white.cgColor
            cell.bgImage.layer.borderWidth = 5.0
            cell.bgImage.layer.cornerRadius = 5
            cell.bgImage.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.bgImage.layer.shadowColor = UIColor.black.cgColor
            cell.bgImage.layer.shadowRadius = 10
            cell.bgImage.transform = CGAffineTransform(rotationAngle: 0.0349066)
            cell.bgImage.clipsToBounds = true
            cell.coverImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["coverPhoto"].stringValue, width: 200))
            cell.albumTitle.text = allData[indexPath.row]["name"].stringValue + " (\(allData[indexPath.row]["mediaCount"].stringValue))"
            cell.bgImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["coverPhoto"].stringValue, width: 200))


            return cell
        default:
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
        else if whichView == "Monthly" {
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
            if allData[indexPath.row]["mediaCount"].stringValue == "0" {
                showToast(msg: "No Photos in \(allData[indexPath.row]["name"].stringValue)")
            }else{
            whichView = "Monthly"
            collectionView.reloadData()
            }
        }
            
        else if whichView == "SelectCover" {
            
            print("inside select cover")
            selectImage(indexPath.item)
            
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
        
//        let imageCropperVC = self.storyboard!.instantiateViewController(withIdentifier: "imageCropperVC") as! ImageCropperViewController
//        print("selected image: \(images[index])")
//        imageCropperVC.sentImage = images[index]
//        self.navigationController?.pushViewController(imageCropperVC, animated: true)
        
        let allvcs = self.navigationController!.viewControllers
        for vc in allvcs {
            
            if vc.isKind(of: EndJourneyViewController.self) {
                
                let endvc = vc as! EndJourneyViewController
                endvc.coverImage = images[index] 
                endvc.makeCoverPictureImage(image: images[index])
                self.navigationController!.popToViewController(endvc, animated: true)
                
            }
            
        }
    }
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]

        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    func changeDateFormat(_ givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = getFormat
        
        if isDate {
            
            dateFormatter.dateStyle = .medium
            
        }
        
        let goodDate = dateFormatter.string(from: date!)
        return goodDate
        
    }
    
    func showToast(msg:String) {
        let show = Toast(text: msg)
        show.show()
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
