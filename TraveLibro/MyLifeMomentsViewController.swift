//
//  MyLifeMomentsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 07/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

var globalMyLifeMomentsViewController:MyLifeMomentsViewController!


class MyLifeMomentsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let titleLabels = ["November 2015, (25)", "October 2015, (25)", "September 2015, (25)", "August 2015, (25)", "July 2015, (25)"]
    let Month = "November 2015"
    let reviewsLL = ["Mumbai", "London"]
    let reviewsTL = ["India", "France"]
    
    var images =  ["5888812cac0b510d59f3c855.jpg"]
    
    var whichView = "Travel Life"
    var page = 1
    var momentType = "all"
    var allData:[JSON] = []
    var loadStatus = true
    var lastToken = ""
    var insideView = ""
    var tokenToShow:NSAttributedString!
    var empty: EmptyScreenView!
    var reviewType = ""
    var savedMediaType = ""
    var savedToken = ""
    var savedId = ""

    
    
    @IBOutlet weak var mainView: UICollectionView!
    
    override func viewDidLoad() {
        getDarkBackGround(self)
        loader.showOverlay(self.view)
        super.viewDidLoad()
        globalMyLifeMomentsViewController = self
        setTopNavigation("Photos")
        mainView.delegate = self
        mainView.dataSource = self
        //        loadTravelLife(pageno: page, type: momentType)
        navigationItem.leftBarButtonItem?.title = ""
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(loadStatus)
        print(insideView)
        if loadStatus {
            
            if insideView == "Monthly" {
                loadInsideMedia(mediaType: savedMediaType, pageno: page, type: momentType, token: savedToken, id: savedId)
            }else{
                if momentType == "travel-life" {
                    self.loadMomentLife(pageno: page, type: momentType, token: "")
                }
            }
            
        }
        
    }
    
    
    func loadInsideMedia(mediaType:String, pageno:Int, type:String, token:String, id:String) {
        print("loadInsideMedia")
        print(momentType)
        print("insideView \(insideView)")
        
        savedMediaType = mediaType
        savedToken = token
        savedId = id
        
        self.loadStatus = false
        if momentType == "all" || momentType == "local-life" {
            request.getTokenMoment(currentUser["_id"].stringValue, pageNumber: pageno, type: type, token: token, completion: {(request) in
                DispatchQueue.main.async {
                    loader.hideOverlayView()
                    if request["data"].count > 0 {
                        self.loadStatus = true
                        if pageno == 1 {
                            self.allData = request["data"].array!
                        }else{
                            for post in request["data"].array! {
                                self.allData.append(post)
                            }
                        }
                        self.mainView.reloadData()
                        self.page = self.page + 1
                    }else{
                        self.loadStatus = false
                    }
                }
            })
        } else {
            print("in else, pagenumber \(pageno)")
            request.getMedia(mediaType: mediaType, user: currentUser["_id"].stringValue, id: id, pageNumber: pageno, completion: {(request) in
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
                        self.mainView.reloadData()
                        self.page = self.page + 1
                    }else{
                        self.loadStatus = false
                    }
                }
            })
        }
    }
    
    func loadReview(pageno:Int, type:String, review:String) {
        momentType = type
        reviewType = review
        print("loadReview")
        print("insideView \(insideView)")

        request.getMyLifeReview(currentUser["_id"].stringValue, pageNumber: pageno, type: review, completion: {(request) in
            DispatchQueue.main.async {
                loader.hideOverlayView()
                if request["data"].count > 0 {
                    self.loadStatus = true
                    
                    if pageno == 1 {
                        self.allData = request["data"].array!
                    }else{
                        for post in request["data"].array! {
                            self.allData.append(post)
                        }
                    }
                }else{
                    self.loadStatus = false
                    
                }
                
                self.mainView.reloadData()
                
                if self.allData.count == 0 {
                    self.showNoData(show: true)
                }else{
                    self.mainView.isHidden = false
                    self.showNoData(show: false)
                }
            }
        })
    }
    
    
    func loadMomentLife(pageno:Int, type:String, token:String) {
        momentType = type
        print("loadMomentLife")
        print("insideView \(insideView)")
        self.loadStatus = false
        request.getMomentLife(currentUser["_id"].stringValue, pageNumber: pageno, type: type, token: token, completion: {(request) in
            
            DispatchQueue.main.async {
                loader.hideOverlayView()
                if type == "travel-life"{
                    
                    if request["data"].count > 0 {
                        self.loadStatus = true
                        if pageno == 1 {
                            self.allData = request["data"].array!
                        }else{
                            for post in request["data"].array! {
                                self.allData.append(post)
                            }
                        }
                        self.mainView.reloadData()
                        self.page = self.page + 1
                    }else{
                        self.loadStatus = false
                    }
                    
                }else{
                    
                    //                    if self.lastToken != "-1" {
                    self.loadStatus = true
                    if token == "" {
                        self.allData = []
                        for post in request["data"].array! {
                            if post["token"] != -1 {
                                self.allData.append(post)
                            }
                        }
                    }else{
                        for post in request["data"].array! {
                            if post["token"] != -1 {
                                self.allData.append(post)
                            }
                        }
                    }
                    self.lastToken = request["data"][request["data"].count - 1]["token"].stringValue
                    self.mainView.reloadData()
                    //                    }else{
                    //                        self.loadStatus = false
                    //                    }
                    
                }
                // if no data
                if self.allData.count == 0 {
                    self.showNoData(show: true)
                }else{
                    self.mainView.isHidden = false
                    self.showNoData(show: false)
                }
                
                self.mainView.reloadData()

            }
            
        })
    }
    
    func showNoData(show:Bool) {
        if empty != nil {
            self.empty.removeFromSuperview()
        }
        if show {
            empty = EmptyScreenView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
            switch momentType {
            case "all":
                print("in moments all")
                empty.frame.size.height = 250.0
                empty.viewHeading.text = "Unwind​ B​y Rewinding"
                empty.viewBody.text = "Revisit and reminisce the days gone by through brilliant pictures and videos of your travel and local life."
                break
            case "travel-life":
                print("in moments tl")
                empty.frame.size.height = 350.0
                empty.viewHeading.text = "Travel Becomes A Reason To Take Pictures And Store Them"
                empty.viewBody.text = "Some memories are worth sharing, travel surely tops the list. Your travels will not only inspire you to explore more of the world, you may just move another soul or two!"
                break
            case "local-life":
                print("in moments ll")
                empty.frame.size.height = 275.0
                empty.viewHeading.text = "Suspended In Time"
                empty.viewBody.text = "Beautiful memories created through fabulous pictures and videos of those precious moments shared with family, friends and yourself."
                break
            default:
                break
            }
            self.view.addSubview(empty)
            mainView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Collection Delegates and Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("insideView \(insideView)")
        print("momeentType \(momentType)")
        if insideView != "Monthly" {
            if momentType != "travel-life" && momentType != "review" {
                return allData.count
            }
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch momentType {
        case "all":
            if insideView == "Monthly" {
                return allData.count
            }else{
                return allData[section]["data"].count
            }
        case "local-life":
            if insideView == "Monthly" {
                return allData.count
            }else{
                return allData[section]["data"].count
            }
        case "travel-life":
            return allData.count
        default:
            return allData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        if insideView == "Monthly" {
            if shouldShowBigImage(position: indexPath.row) {
                return CGSize(width: collectionView.frame.size.width - 32, height: (collectionView.frame.size.width - 32) * 0.5)
            }
            
            return CGSize(width: (collectionView.frame.size.width - 32)/3 - 2, height: (collectionView.frame.size.width - 32)/3 - 2)
        }
        else{
            switch momentType {
            case "all":
                return CGSize(width: 30, height: 30)
            case "Monthly", "SelectCover":
                return CGSize(width: 110, height: 110)
            case "local-life", "travel-life":
                return CGSize(width: 165, height: 204)
            default:
                break
            }
            return CGSize(width: 150, height: 75)
        }
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
        
        if insideView == "Monthly" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MomentsLargeImageCell", for: indexPath) as! photosTwoCollectionViewCell
            cell.photoBig.image = UIImage(named: "logo-default")
            if allData[indexPath.row]["name"].stringValue != "" {
                cell.photoBig.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["name"].stringValue, width: 200))
                
            }else{
                cell.photoBig.image = UIImage(named: "logo-default")
            }
            return cell
            
        }else{
            
            switch momentType {
            case "all":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! photosCollectionViewCell
                cell.photo.image = UIImage(named: "logo-default")
                if allData[indexPath.section]["data"][indexPath.row]["name"].stringValue != "" {
                    cell.photo.hnk_setImageFromURL(getImageURL(allData[indexPath.section]["data"][indexPath.row]["name"].stringValue, width: 200))
                    
                }else{
                    cell.photo.image = UIImage(named: "logo-default")
                }
                return cell
            case "Monthly", "SelectCover":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MomentsLargeImageCell", for: indexPath) as! photosTwoCollectionViewCell
                cell.photoBig.image = UIImage(named: "logo-default")
                cell.photoBig.backgroundColor = UIColor.white
                
                cell.photoBig.hnk_setImageFromURL(URL(string: "\(adminUrl)upload/readFile?file=\(self.images[(indexPath as NSIndexPath).item])&width=200")!)
                return cell
            case "local-life":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "localLifeMomentsCell", for: indexPath) as! LocalLifeMomentsCollectionViewCell
                cell.bgImage.image = UIImage(named: "logo-default")
                cell.bgImage.transform = CGAffineTransform(rotationAngle: 0.0349066)
                cell.bgImage.layer.cornerRadius = 5
                cell.coverImage.layer.cornerRadius = cell.coverImage.frame.width/2
                cell.coverImage.clipsToBounds = true
                
                cell.coverImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["data"][indexPath.row]["name"].stringValue, width: 200))
                cell.bgImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["data"][indexPath.row]["name"].stringValue, width: 200))
                cell.albumTitle.attributedText = createHeaderDate(currDate: allData[indexPath.row]["token"].stringValue, count: allData[indexPath.row]["count"].stringValue)
                
                return cell
            case "travel-life":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "travelLifeMomentsCell", for: indexPath) as! TravelLifeMomentsCollectionViewCell
                
                cell.coverImage.layer.cornerRadius = cell.coverImage.frame.width/2
                cell.coverImage.clipsToBounds = true
                
                //            cell.albumDated.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: allData[indexPath.row]["startTime"].stringValue, isDate: false)
                
                cell.bgImage.layer.borderColor = UIColor.white.cgColor
                cell.bgImage.layer.borderWidth = 5.0
                cell.bgImage.layer.cornerRadius = 5
                cell.bgImage.layer.shadowOffset = CGSize(width: 10, height: 10)
                cell.bgImage.layer.shadowColor = UIColor.black.cgColor
                cell.bgImage.layer.shadowRadius = 10
                cell.bgImage.transform = CGAffineTransform(rotationAngle: 0.0349066)
                cell.bgImage.clipsToBounds = true
                cell.bgImage.image = UIImage(named: "logo-default")
                
                if allData[indexPath.row]["coverPhoto"] != nil {
                    cell.coverImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["coverPhoto"].stringValue, width: 200))
                    cell.bgImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["coverPhoto"].stringValue, width: 200))
                }else{
                    cell.coverImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["startLocationPic"].stringValue, width: 200))
                    cell.bgImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["startLocationPic"].stringValue, width: 200))
                }
                
                cell.albumTitle.text = allData[indexPath.row]["name"].stringValue + " (\(allData[indexPath.row]["mediaCount"].stringValue))"
                cell.albumDated.text = getDateFormat(allData[indexPath.row]["startTime"].stringValue, format: "d MMM, yyyy")
                
                
                
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewsCell", for: indexPath) as! reviewsCollectionViewCell
                if reviewType == "local-life" {
                    cell.bgImage.image = UIImage(named: "reviewsLocalLifeAlbum")
                    cell.placeName.text = allData[indexPath.row]["name"].stringValue
                    cell.foregroundImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["cityCoverPhoto"].stringValue, width: 200))
                    
                }
                else {
                    cell.bgImage.image = UIImage(named: "reviewsTLAlbum")
                    cell.placeName.text = allData[indexPath.row]["name"].stringValue
                    cell.foregroundImage.hnk_setImageFromURL(getImageURL(allData[indexPath.row]["flag"].stringValue, width: 200))
                }
                
                cell.foregroundImage.layer.cornerRadius = cell.foregroundImage.frame.width/2
                cell.foregroundImage.clipsToBounds = true
                cell.foregroundImage.layer.borderColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1).cgColor
                cell.foregroundImage.layer.borderWidth = 3.0
                return cell
                
            }
        }
        
        
        
    }
    
    func createHeaderDate(currDate:String, count:String) -> NSAttributedString {
        let array = getMonthFormat(currDate)
        let headerLabel = NSMutableAttributedString(string: "")
        let month = NSAttributedString(string: array, attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
        let count = NSAttributedString(string: " (\(count))", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 11)!])
        headerLabel.append(month)
        headerLabel.append(count)
        return headerLabel
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if insideView == "Monthly" {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! TitleHeaderView
            header.titleLabel.attributedText = tokenToShow
            return header
            
        } else if momentType == "all" {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! TitleHeaderView
            
                header.titleLabel.attributedText = createHeaderDate(currDate: allData[indexPath.section]["token"].stringValue, count: allData[indexPath.section]["count"].stringValue)
                return header
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! TitleHeaderView
        header.titleLabel.text = ""
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        page = 1
        if insideView == "Monthly" {
            let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
            singlePhotoController.index = indexPath.row
            singlePhotoController.type = allData[indexPath.row]["type"].stringValue
            singlePhotoController.postId = ""
            singlePhotoController.allDataCollection = allData
            globalNavigationController.pushViewController(singlePhotoController, animated: true)
            
        }else{
            
            if momentType == "local-life" || momentType == "all" {
                if allData[indexPath.section]["count"].stringValue == "0" {
                    showToast(msg: "No Photos in \(allData[indexPath.section]["token"].stringValue)")
                }else{
                    insideView = "Monthly"
                    tokenToShow = createHeaderDate(currDate: allData[indexPath.section]["token"].stringValue, count: allData[indexPath.section]["count"].stringValue)
                    self.loadInsideMedia(mediaType: "", pageno: 1, type: momentType, token: allData[indexPath.section]["token"].stringValue, id: "")
                }
            }else if momentType == "travel-life" {
                if allData[indexPath.row]["mediaCount"].stringValue == "0" {
                    showToast(msg: "No Photos in \(allData[indexPath.row]["name"].stringValue)")
                }else{
                    tokenToShow = NSAttributedString(string: allData[indexPath.row]["name"].stringValue, attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
                    insideView = "Monthly"
                    var type2 = ""
                    if allData[indexPath.row]["type"] != nil {
                        type2 = allData[indexPath.row]["type"].stringValue
                    }else{
                        type2 = ""
                    }
                    self.loadInsideMedia(mediaType:type2, pageno: 1, type: momentType, token: "", id: allData[indexPath.row]["_id"].stringValue)
                }
                
            }else{
                if reviewType == "travel-life" {
                    globalMyLifeController.showReviewsExtention(type: "review", inside: false, params: "country", id: allData[indexPath.row]["_id"].stringValue, name: allData[indexPath.row]["name"].stringValue)
                    
                }else{
                    globalMyLifeController.showReviewsExtention(type: "review", inside: false, params: "city", id: allData[indexPath.row]["_id"].stringValue, name: allData[indexPath.row]["name"].stringValue)
                }
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
