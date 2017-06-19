
//
//  TripSummaryPhotosViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import imglyKit
import Player
import Spring

enum contentType {
    case TL_CONTENT_IMAGE_TYPE
    case TL_CONTENT_VIDEO_TYPE
}

enum contentViewType {
    case TL_LIST_VIEW
    case TL_GRID_VIEW
}

class TripSummaryPhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PlayerDelegate, ToolStackControllerDelegate, TLFooterBasicDelegate {
    
    
    @IBOutlet weak var contentCollectionView: UICollectionView!    
    @IBOutlet weak var contentTableView: UITableView!
    
    var loader = LoadingOverlay()
    
    var contentDataArray: [JSON] = []
    var videoContainer:VideoView!
    var player:Player!    
    
    private let pageType : viewType = viewType.VIEW_TYPE_OTG
    private let separatorOffset = CGFloat(5.0)
    private let TL_VISIBLE_CELL_TAG = 6789
    
    var fromView = ""
    var noPhoto = 0
    
    var currentContentType : contentType = contentType.TL_CONTENT_IMAGE_TYPE
    var currentContentViewType: contentViewType = contentViewType.TL_GRID_VIEW
    
    var journeyID = ""
    var creationDate = ""
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        loader.showOverlay(self.view)
        
        self.getJourneyContent()
        
        if currentContentType == contentType.TL_CONTENT_VIDEO_TYPE {
            showNavigationIn(text: "Videos (\(noPhoto))")
        }
        else{
            showNavigationIn(text: "Photos (\(noPhoto))")
        }
        
        changeView(toView: currentContentViewType)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setAnalytics(name: "Trip Summary Photos")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Fetch Data
    
    func getJourneyContent() {
       
        loader.hideOverlayView()
        
        request.journeyTypeData(journeyID, type: ((currentContentType == contentType.TL_CONTENT_IMAGE_TYPE) ? "photos" : "videos"), userId: user.getExistingUser(), completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                self.loader.hideOverlayView()
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    print("response : \(response)")
                    self.creationDate = response["data"]["startTime"].stringValue
                    
                    if (self.currentContentType == contentType.TL_CONTENT_IMAGE_TYPE) {
                        self.contentDataArray = response["data"]["photos"].arrayValue
                    }
                    else {
                        self.contentDataArray = response["data"]["videos"].arrayValue
                    }
                    
//                    self.contentDataArray = sortJSONArray(inputArray: self.contentDataArray, key: "UTCModified")
                    
                    self.reloadContent()
                    
                }
                else {
                    
                    print("response error")
                    
                }
                
            })
            
        })
        
    }
    
    
    //MARK: - Reload
    
    func reloadContent() {
        if (!contentTableView.isHidden) {
            contentTableView.reloadData()
            if contentDataArray.isNotEmpty {
                contentTableView.scrollToRow(at: (IndexPath(row: 0, section: 0)), at: .top, animated: true)                
            }
        }
        else if (!contentCollectionView.isHidden) {
            contentCollectionView.reloadData()
            if contentDataArray.isNotEmpty {
                contentCollectionView.scrollToItem(at: (IndexPath(item: 0, section: 0)), at: .top, animated: true)                
            }
        }
    }
    
    
    //MARK: - Navigation
    
    func showNavigationIn(text: String) {
        
        if fromView == "endJourney" {
            self.title = "Photos"
        }
        else {
            self.title = text
        }
        
        let navImageIconName = ((currentContentViewType == contentViewType.TL_LIST_VIEW) ? "grid" : "list")
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: navImageIconName), for: UIControlState())
        rightButton.addTarget(self, action: #selector(self.toggleViews(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 20, height: 20)        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        if fromView == "endJourney" {
            self.customNavigationBar(left: leftButton, right: nil)
        }else{
            self.customNavigationBar(left: leftButton, right: rightButton)
        }
        
    }
    
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.customNavigationBar(left: leftButton, right: rightButton)
    }    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    //MARK: - Toggle View
    
    func toggleViews(_ sender: UIButton) {
        
        if !(contentCollectionView.isHidden) {
            currentContentViewType = contentViewType.TL_LIST_VIEW
            if currentContentType == contentType.TL_CONTENT_VIDEO_TYPE {
                showNavigationIn(text: "Videos (\(noPhoto))")
            }
            else{
                showNavigationIn(text: "Photos (\(noPhoto))")
            }
        }
        else {
            currentContentViewType = contentViewType.TL_GRID_VIEW
            if currentContentType == contentType.TL_CONTENT_VIDEO_TYPE {
                showNavigationIn(text: "Videos (\(noPhoto))")
            }
            else{
                showNavigationIn(text: "Photos (\(noPhoto))")
            }
        }
        
        changeView(toView: currentContentViewType)
    }
    
    func changeView(toView: contentViewType) {
        
        if toView == contentViewType.TL_LIST_VIEW {
            contentTableView.isHidden = false
            contentCollectionView.isHidden = true
            self.view.bringSubview(toFront: contentTableView)
        }
        else {
            contentTableView.isHidden = true
            contentCollectionView.isHidden = false
            self.view.bringSubview(toFront: contentCollectionView)
        }
        
        self.reloadContent()
        
    }
    
    
    //MARK: - CollectionView Delegates and Datasource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if shouldShowBigImage(position: indexPath.row) {
//            return CGSize(width: (collectionView.frame.size.width), height: collectionView.frame.size.width * 0.7)
//        }

        return CGSize(width: ((screenWidth-4)/2), height: (((screenWidth-4)/2) * 1.35))

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! contentCollectionViewCell
        if currentContentType == contentType.TL_CONTENT_IMAGE_TYPE {
            
            cell.contentImageView.sd_setImage(with: (getImageURL(self.contentDataArray[indexPath.row]["name"].stringValue, width: BIG_PHOTO_WIDTH)),
                                                  placeholderImage: getPlaceholderImage())
            
            cell.contentPlayImageView.isHidden = true
        }
        else{
            
            cell.contentImageView.sd_setImage(with: (getImageURL(self.contentDataArray[indexPath.row]["thumbnail"].stringValue, width: BIG_PHOTO_WIDTH)),
                                              placeholderImage: getPlaceholderImage())
            cell.contentPlayImageView.isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Cell select at index : \(indexPath.row)")
        
        if fromView == "endJourney" {
            let cell = collectionView.cellForItem(at: indexPath) as! contentCollectionViewCell
            
            let conf = Configuration(builder: { (builder) in
                builder.configurePhotoEditorViewController({ (photoOptionBuilder) in                    
                    photoOptionBuilder.actionButtonConfigurationClosure = { cell, action in
                        cell.tintColor = UIColor.white 
                    }                    
                })
            })
            
            let photoEditViewController = PhotoEditViewController(photo: cell.contentImageView.image!, configuration: conf)
            let toolStackController = ToolStackController(photoEditViewController: photoEditViewController)            
            toolStackController.delegate = self            
            toolStackController.navigationItem.title = "Editor"
            //            toolStackController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: photoEditViewController, action: #selector(PhotoEditViewController.save(_:)))
            let nvc = UINavigationController(rootViewController: toolStackController)
            nvc.navigationBar.isTranslucent = false
            nvc.navigationBar.barStyle = .black
            self.present(nvc, animated: true, completion: nil)            
        }
            
        else if currentContentType == contentType.TL_CONTENT_IMAGE_TYPE {            
            self.openSinglePhoto(index: indexPath.row)
        }
        
        else if currentContentType == contentType.TL_CONTENT_VIDEO_TYPE {
            self.openSingleVideo(index: indexPath.row)
        }
        
    }
    
    
    //MARK: - Photo Editor Delegate
    
    func toolStackController(_ toolStackController: ToolStackController, didFinishWith image: UIImage){
        
        dismiss(animated: true, completion: {
            editedImage = image
            let allvcs = self.navigationController!.viewControllers
            for vc in allvcs {
                
                if vc.isKind(of: EndJourneyViewController.self) {
                    
                    let endvc = vc as! EndJourneyViewController
                    endvc.coverImage = String(describing: image)
                    endvc.makeCoverPictureImageEdited(image: image)
                    self.navigationController!.popToViewController(endvc, animated: true)
                    
                }
                
            }
        })
    }
    
    func toolStackControllerDidCancel(_ toolStackController: ToolStackController){
        print("on cancel toolstackcontroller")
        dismiss(animated: true, completion:nil)
    }
    
    func toolStackControllerDidFail(_ toolStackController: ToolStackController){
        print("on fail toolstackcontroller")
    }
    
    //MARK: - TableView DataSource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return contentDataArray.count
    }    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (indexPath.row < contentDataArray.count) {
            
            var height = separatorOffset
            
            let cellData = self.contentDataArray[indexPath.row]
            
            height = height + FEEDS_HEADER_HEIGHT + screenWidth*0.9 + (shouldShowFooterCountView(feed: cellData) ? FEED_FOOTER_HEIGHT : (FEED_FOOTER_HEIGHT-FEED_FOOTER_LOWER_VIEW_HEIGHT))
            
            return height
        }
        else {
            return CGFloat(100)
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = self.contentDataArray[indexPath.row]
        
        var feedCell = tableView.dequeueReusableCell(withIdentifier: "OTGTripContentCell", for: indexPath) as? TLOTGPhotosTableViewCell
        
        if feedCell == nil {
            feedCell = TLOTGPhotosTableViewCell(style: .default, reuseIdentifier: "OTGTripContentCell", feedData: cellData, contentType: currentContentType, helper: self)
        }
        print("\n cellData: \(cellData)")
        feedCell?.setData(feedData: cellData, currentContentType: currentContentType, journeyStartTime: self.creationDate, helper: self, delegate: self)        
        feedCell?.FFooterViewBasic.tag = indexPath.row
        feedCell?.FFooterViewBasic.type = "TripPhotos"        
        feedCell?.tag = TL_VISIBLE_CELL_TAG
        return feedCell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentContentType == contentType.TL_CONTENT_IMAGE_TYPE {
            self.openSinglePhoto(index: indexPath.row)
        }
        else if currentContentType == contentType.TL_CONTENT_VIDEO_TYPE {
            self.openSingleVideo(index: indexPath.row)
        } 
    }
    
    
    //MARK: - Actions
    
    func openSinglePhoto(index: Int) {
        let singlePhotoController = self.storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.index = index
        singlePhotoController.fetchType = photoVCType.FROM_DETAIL_ITINERARY
        singlePhotoController.postId = "unknown"
        singlePhotoController.allDataCollection = contentDataArray
        self.navigationController?.pushViewController(singlePhotoController, animated: true)
    } 
    
    func openSingleVideo(index: Int) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.index = index
        singlePhotoController.type = "Video"
        singlePhotoController.postId = contentDataArray[index]["post"].stringValue
        self.navigationController?.pushViewController(singlePhotoController, animated: true)
    }
    
    
    //MARK: - Delegate Actions
    
    func footerLikeCommentCountUpdated(likeDone: Bool, likeCount: Int, commentCount: Int, tag: Int) {
        var cellData = contentDataArray[tag]        
        cellData["likeCount"] = JSON(String(likeCount))
        cellData["commentCount"] = JSON(String(commentCount))
        cellData["likeDone"] = JSON(Bool(likeDone))        
        contentDataArray[tag] = cellData
        
        if likeDone {
            UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {                
            }) { (true) in
                self.contentTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
            }
        }
        else { 
            self.contentTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
        }               
    }
    
    func footerRatingUpdated(rating: JSON, tag: Int) {        
        var currentJson = contentDataArray[tag]            
        currentJson["review"][0] = ["rating":"\(rating["rating"].stringValue)","review":rating["review"].stringValue]            
        if (currentJson["review"].isEmpty){
            currentJson["review"] = [["rating":"\(rating["rating"].stringValue)","review":rating["review"].stringValue]]
        }
        contentDataArray[tag] = currentJson
        
        self.contentTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .none)
    }

}


class contentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentPlayImageView: UIImageView!
    
}
