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
    var Month = "November 2015"
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
    var reviewPage = ""
    var loader = LoadingOverlay()
    
    @IBOutlet weak var mainView: UICollectionView!
    
    override func viewDidLoad() {
        getDarkBackGround(self)
        super.viewDidLoad()
        globalMyLifeMomentsViewController = self
        setTopNavigation("Photos")
        mainView.delegate = self
        mainView.dataSource = self
        allData = []
        //        loadTravelLife(pageno: page, type: momentType)
        navigationItem.leftBarButtonItem?.title = ""
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if insideView == "Monthly" {
            page = 1
            loadInsideMedia(mediaType: savedMediaType, pageno: page, type: momentType, token: savedToken, id: savedId)
        }
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {

        if loadStatus {
            
            if insideView == "Monthly" {
                loadInsideMedia(mediaType: savedMediaType, pageno: page, type: momentType, token: savedToken, id: savedId)
            }else{
                if momentType == "travel-life"{
                    self.loadMomentLife(pageno: page, type: momentType, token: "")
                }
                else if momentType == "all" || momentType == "local-life"{
                    if lastToken != "-1" {
                        self.loadMomentLife(pageno: 0, type: momentType, token: lastToken)
                    }
                }
            }
            
        }
//        }
        
    }
    
    
    func loadInsideMedia(mediaType:String, pageno:Int, type:String, token:String, id:String) {
        
        if pageno == 1 {
            loader.showOverlay(mainView)
            allData = []
        }
        savedMediaType = mediaType
        savedToken = token
        savedId = id
        
        self.loadStatus = false
        if momentType == "all" || momentType == "local-life" {
            request.getTokenMoment(user.getExistingUser(), pageNumber: pageno, type: type, token: token, urlSlug: selectedUser["urlSlug"].stringValue, completion: {(request) in
                DispatchQueue.main.async {
                    self.loader.hideOverlayView()
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
            request.getMedia(mediaType: mediaType, user: user.getExistingUser(), id: id, pageNumber: pageno, urlSlug: selectedUser["urlSlug"].stringValue, completion: {(request) in
                DispatchQueue.main.async {
                    self.loader.hideOverlayView()
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
        reviewPage = review
        
        if pageno == 1 {
        loader.showOverlay(mainView)
            allData = []
        }
        momentType = type
        reviewType = review
        
        request.getMyLifeReview(user.getExistingUser(), pageNumber: pageno, type: review, urlSlug: selectedUser["urlSlug"].stringValue, completion: {(request) in
            DispatchQueue.main.async {
                self.loader.hideOverlayView()
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
                    if pageno == 1 {
                        self.allData = []
                    }
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
        if pageno == 1 {
        loader.showOverlay(mainView)
            allData = []
        }
        momentType = type
        self.loadStatus = false
        request.getMomentLife(user.getExistingUser(), pageNumber: pageno, type: type, token: token, urlSlug: selectedUser["urlSlug"].stringValue, completion: {(request) in
            
            DispatchQueue.main.async {
                self.loader.hideOverlayView()
                
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
                print(self.allData.count)
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
    
    let cnfg = Config()
    func showNoData(show:Bool) {
        if empty != nil {
            self.empty.removeFromSuperview()
        }
        if show {
            empty = EmptyScreenView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + 10))
            empty.parentController = self
            
            if reviewPage == "travel-life" {
                empty.frame.size.height = CGFloat(cnfg.getHeight(ht: Double(self.view.frame.height + 10)))
                empty.viewHeading.text = "The World I​s Your Oyster"
                empty.viewBody.text = "A five star or a four star? What does that historical monument qualify for? Rate it and write a review. Help others with your rating and review."
                empty.setColor(life: "", buttonLabel: "Start a New Journey")

            }else if reviewPage == "local-life" {
                empty.frame.size.height = CGFloat(cnfg.getHeight(ht: Double(self.view.frame.height + 10)))
                empty.viewHeading.text = "A Touch Of Your Daily Dose"
                empty.viewBody.text = "Now how about rating and writing a super review for that newly-opened restaurant in your town? Wherever you go, click on a star and pen down your experiences."
                empty.setColor(life: "locallife", buttonLabel: "Add your first Local Activity")

            }else{
            
            switch momentType {
            case "all":
                print("in moments all")
                empty.frame.size.height = CGFloat(cnfg.getHeight(ht: Double(self.view.frame.height + 10)))
                empty.viewHeading.text = "Unwind​ B​y Rewinding"
                empty.viewBody.text = "Revisit and reminisce the days gone by through those special pictures and videos of your travel and local life."
                empty.setColor(life: "", buttonLabel: "Start a New Journey")

                break
            case "travel-life":
                print("in moments tl")
                
                    empty.frame.size.height = CGFloat(cnfg.getHeight(ht: Double(self.view.frame.height + 10)))
                    empty.viewHeading.text = "Travel Becomes A Reason To Take Pictures And Relive Them"
                    empty.viewBody.text = "Some memories are worth sharing, travel surely tops the list. Your travels will not only inspire you to explore more of the world, you may just move another soul or two!"
                    empty.setColor(life: "", buttonLabel: "Add a Travel Journey")

                
                break
            case "local-life":
                print("in moments ll")
                
                    empty.frame.size.height = CGFloat(cnfg.getHeight(ht: Double(self.view.frame.height + 10)))
                    empty.viewHeading.text = "Suspended In Time"
                    empty.viewBody.text = "Beautiful memories created through fabulous pictures and videos of those precious moments shared with family, friends and yourself."
                empty.setColor(life: "locallife", buttonLabel: "Add your first Local Activity")

                
                break
            default:
                break
            }
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
            if momentType != "travel-life" && momentType != "review" && momentType != "local-life" {
                return allData.count
            }
        }
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(allData)
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
                return allData.count
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
//            if shouldShowBigImage(position: indexPath.row) {
//                return CGSize(width: screenWidth - 10, height: (screenWidth - 10) * 0.7)
//            }
            
            return CGSize(width: ((screenWidth - 10)/2), height: (((screenWidth-10)/2) * 1.35))

        }
        else{
            switch momentType {
            case "all":
                let a = (screenWidth - 15) / 5
                return CGSize(width: a, height: a)
//                return CGSize(width: 70, height: 70)
            case "Monthly", "SelectCover":
                return CGSize(width: 110, height: 110)
            case "travel-life":
                let a = (screenWidth - 20) / 2
                return CGSize(width: a + 5, height: a + 75)
            case "local-life":
                let a = (screenWidth - 20) / 2
                return CGSize(width: a, height: a + 45)
            case "review":
                let a = (screenWidth - 15) / 3
                return CGSize(width: a, height: a + 100)
            default:
                break
            }
//            var a = (screenWidth - 30) / 2
//            print("width \(a)")

            return CGSize(width: 124, height: 204)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if insideView == "Monthly" {
            return 2
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if insideView == "Monthly" {
            return 2
        }else{
            return 1
        }
    }
    
    func getShortCountry(country: String) -> String {
        let stringInput = country
        let stringInputArr = stringInput.components(separatedBy: " ")
        var stringNeed = ""
        
        if stringInputArr.count > 1 {
            for string in stringInputArr {
                stringNeed = stringNeed + String(string.characters.first!)
            }
        }else{
            stringNeed = country
        }
        
        
        return stringNeed
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if insideView == "Monthly" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MomentsLargeImageCell", for: indexPath) as! photosTwoCollectionViewCell
            if allData[indexPath.row]["name"].stringValue != "" {
                
                cell.photoBig.sd_setImage(with: getImageURL(self.allData[indexPath.row]["name"].stringValue, width: BIG_PHOTO_WIDTH),
                                          placeholderImage: getPlaceholderImage())
                
            }else{
                cell.photoBig.image = UIImage(named: "logo-default")
            }
            return cell
            
        }else{
            
            switch momentType {
            case "all":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! photosCollectionViewCell                
                if allData[indexPath.section]["data"][indexPath.row]["name"].stringValue != "" {
                    cell.photo.sd_setImage(with: getImageURL(allData[indexPath.section]["data"][indexPath.row]["name"].stringValue, width: SMALL_PHOTO_WIDTH),
                                           placeholderImage: getPlaceholderImage())
                    
                }else{
                    cell.photo.image = UIImage(named: "logo-default")
                }
                return cell
            case "Monthly", "SelectCover":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MomentsLargeImageCell", for: indexPath) as! photosTwoCollectionViewCell                
                cell.photoBig.backgroundColor = UIColor.white
                cell.photoBig.sd_setImage(with: URL(string: "\(adminUrl)upload/readFile?file=\(self.images[(indexPath as NSIndexPath).item])&width=\(SMALL_PHOTO_WIDTH)")!,
                                          placeholderImage: getPlaceholderImage())                
                return cell
            case "local-life":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "localLifeMomentsCell", for: indexPath) as! LocalLifeMomentsCollectionViewCell                
                cell.bgImage.layer.cornerRadius = 8
                cell.bgImage.clipsToBounds = true
                cell.bgImage.sd_setImage(with: getImageURL(allData[indexPath.row]["data"][0]["name"].stringValue, width: VERY_BIG_PHOTO_WIDTH),
                                         placeholderImage: getPlaceholderImage())                
                cell.albumTitle.attributedText = createHeaderDate(currDate: allData[indexPath.row]["data"][0]["UTCModified"].stringValue, count: allData[indexPath.row]["count"].stringValue, new:false)

                
                return cell
            case "travel-life":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "travelLifeMomentsCell", for: indexPath) as! TravelLifeMomentsCollectionViewCell
                
                
                cell.bgImage.layer.cornerRadius = 8
                cell.bgImage.clipsToBounds = true
                
                if allData[indexPath.row]["coverPhoto"] != nil {
                    cell.bgImage.sd_setImage(with: getImageURL(allData[indexPath.row]["coverPhoto"].stringValue, width: BIG_PHOTO_WIDTH),
                                             placeholderImage: getPlaceholderImage())                   
                }else if !allData[indexPath.row]["photos"].isEmpty {
                    cell.bgImage.sd_setImage(with: getImageURL(allData[indexPath.row]["photos"]["name"].stringValue, width: BIG_PHOTO_WIDTH),
                                             placeholderImage: getPlaceholderImage())
                }else{
                    cell.bgImage.sd_setImage(with: getImageURL(allData[indexPath.row]["startLocationPic"].stringValue, width: BIG_PHOTO_WIDTH),
                                             placeholderImage: getPlaceholderImage())
                }
                
                cell.albumTitle.text = allData[indexPath.row]["name"].stringValue + " (\(allData[indexPath.row]["mediaCount"].stringValue))"
                
                if allData[indexPath.row]["endTime"] != nil {
                    cell.albumDated.text = getDateFormat(allData[indexPath.row]["endTime"].stringValue, format: "MMMM, yyyy")

                }else{
                    cell.albumDated.text = getDateFormat(allData[indexPath.row]["startTime"].stringValue, format: "MMMM, yyyy")
                }
                
                return cell
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewsCell", for: indexPath) as! reviewsCollectionViewCell
                if reviewType == "local-life" {
                    
                    cell.bgImage.image = UIImage(named: "Local_Life-2")
                    cell.placeName.text = getShortCountry(country: allData[indexPath.row]["name"].stringValue)
                    cell.foregroundImage.sd_setImage(with: getImageURL(allData[indexPath.row]["cityCoverPhoto"].stringValue, width: BIG_PHOTO_WIDTH),
                                             placeholderImage: getPlaceholderImage())
                    
                }
                else {
                    cell.bgImage.image = UIImage(named: "Travel_Life-2")
                    cell.placeName.text = getShortCountry(country: allData[indexPath.row]["name"].stringValue)
                    cell.foregroundImage.sd_setImage(with: getImageURL(allData[indexPath.row]["countryCoverPhoto"].stringValue, width: BIG_PHOTO_WIDTH),
                                                     placeholderImage: getPlaceholderImage())
                    cell.foregroundImage.clipsToBounds = true
                    cell.foregroundImage.contentMode = .scaleAspectFill
                    
                }
                cell.bgImage.layer.shadowColor = UIColor.black.cgColor
                cell.bgImage.layer.shadowOffset = CGSize(width: 2, height: 2)
                cell.bgImage.layer.masksToBounds = true
                cell.bgImage.layer.shadowOpacity = 0.5

//                cell.foregroundImage.layer.cornerRadius = cell.foregroundImage.frame.width/2
                cell.foregroundImage.clipsToBounds = true
//                cell.foregroundImage.layer.borderColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1).cgColor
//                cell.foregroundImage.layer.borderWidth = 3.0
                return cell
                
            }
        }
        
        
        
    }
    
    func createHeaderDate(currDate:String, count:String, new: Bool) -> NSAttributedString {
        let headerLabel = NSMutableAttributedString(string: "")
        if new {
            let array = getMonthFormat(currDate)
            let month = NSAttributedString(string: array, attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
            
            
            let count = NSAttributedString(string: " (\(count))", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 11)!])
            headerLabel.append(month)
            headerLabel.append(count)

        }else{
            let month = NSAttributedString(string: getDateFormat(currDate, format: "MMMM, yyyy")
                , attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
            
            
            
            let count = NSAttributedString(string: " (\(count))", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 11)!])
            headerLabel.append(month)
            headerLabel.append(count)

        }
    
        return headerLabel
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if insideView == "Monthly" {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! TitleHeaderView
            header.titleLabel.attributedText = tokenToShow
            return header
            
        } else if momentType == "all" {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! TitleHeaderView
            
            header.titleLabel.attributedText = createHeaderDate(currDate: allData[indexPath.section]["token"].stringValue, count: allData[indexPath.section]["count"].stringValue, new:true)
                return header
        }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerCell", for: indexPath) as! TitleHeaderView
        header.titleLabel.text = ""
        
        return header
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if momentType == "all" {
            
                return CGSize(width: 50, height: 30)
            
        }else if insideView == "Monthly"{
            return CGSize(width: 50, height: 20)
        }else{
            return CGSize(width: 0, height: 5)
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        page = 1
        if insideView == "Monthly" {
            let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
            singlePhotoController.index = indexPath.row
            singlePhotoController.type = "photo"
            /*singlePhotoController.type = (allData[indexPath.row]["type"].stringValue == "video") ? "Video" : "photo"
            if singlePhotoController.type == "Video" {
                singlePhotoController.postId = allData[indexPath.row]["post"].stringValue
            }else {
                 singlePhotoController.postId = "unknown"
            }*/
            singlePhotoController.postId = "unknown"
            singlePhotoController.allDataCollection = allData
            singlePhotoController.fetchType = photoVCType.FROM_MY_LIFE
            globalNavigationController.pushViewController(singlePhotoController, animated: true)
            
        }else{
            
            if momentType == "local-life" || momentType == "all" {
                if allData[indexPath.section]["count"].stringValue == "0" {
                    showToast(msg: "No Photos in \(allData[indexPath.section]["token"].stringValue)")
                }else{
                    insideView = "Monthly"
                    tokenToShow = createHeaderDate(currDate: allData[indexPath.section]["token"].stringValue, count: allData[indexPath.section]["count"].stringValue, new:true)
                    if momentType == "local-life" {
                        self.loadInsideMedia(mediaType: "", pageno: 1, type: momentType, token: allData[indexPath.row]["token"].stringValue, id: "")
                    }else{
                        self.loadInsideMedia(mediaType: "", pageno: 1, type: momentType, token: allData[indexPath.section]["token"].stringValue, id: "")
                    }
                    
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
    @IBOutlet weak var localLifeImage: UIImageView!
    
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
