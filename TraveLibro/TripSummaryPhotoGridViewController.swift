//
//  TripSummaryPhotoGridViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import imglyKit
import UIKit
import Player
import Spring


class TripSummaryPhotoGridViewController: UICollectionViewController, ToolStackControllerDelegate, PlayerDelegate, UICollectionViewDelegateFlowLayout {
    var loader = LoadingOverlay()
    var journeyId = ""
    var myPhotos: [JSON] = []
    var videos: JSON = []
    var fromView = ""
    var type = ""
    var videoContainer:VideoView!
    var player:Player!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.delegate = self
//        loader.showOverlay(self.view)
        getJourneyPhotos()
        
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // Set up desired width
//
//        _ = collectionView.cellForItem(at: indexPath as IndexPath) as! gridCollectionViewCell
//        let size = CGSize(width: 10, height: 10)
//        return size
//    }
    
    func getJourneyPhotos() {
        
        
//        if !endJourneyState {
            print("oooyyyy in journey images")
            request.journeyTypeData(journeyId, type: type, userId: currentUser["_id"].string!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        if self.type == "photos" {
                            if response["data"]["photos"] != nil {                            
                                self.myPhotos = response["data"]["photos"].array!                           
                            }
                        }else{
                            self.videos = response["data"]["videos"]
                        }
                        self.collectionView!.reloadData()
                        self.loader.hideOverlayView()
                    }
                    else {
                        
                        print("response error")
                        
                    }
                    
                })
                
            })

//        }else{
//            print("in else fron journey")
//            print(journeyImages)
//            self.myPhotos = journeyImages
//            self.collectionView!.reloadData()
//        }
        
        
        
    }
    
    //MARK: - CollectionView Delegates and Datasource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
        
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == "photos" {
            return myPhotos.count

        }else{
            return videos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if shouldShowBigImage(position: indexPath.row) {
            return CGSize(width: (collectionView.frame.size.width - 3), height: (collectionView.frame.size.width - 3) * 0.7)
        }
        
        return CGSize(width: (collectionView.frame.size.width/3 - 3), height: (collectionView.frame.size.width/3 - 3))       
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
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! gridCollectionViewCell
        cell.photo.image = UIImage(named: "logo-default")
        
        
        if type == "photos" {
            cell.photo.hnk_setImageFromURL(getImageURL(myPhotos[indexPath.row]["name"].stringValue, width: 500))

        }else{
            self.videoContainer = VideoView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.width))
            
            self.videoContainer.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.openSingleVideo(_:)))
            self.videoContainer.addGestureRecognizer(tapGestureRecognizer)
            self.videoContainer.tag = indexPath.row
            
            self.player = Player()
            self.player.delegate = self
            self.player.view.frame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.width)
            self.player.view.clipsToBounds = true
            self.player.playbackLoops = true
            self.player.muted = true
            self.player.fillMode = "AVLayerVideoGravityResizeAspectFill"
            self.videoContainer.player = self.player
            var videoUrl:URL!
            self.videoContainer.tagView.isHidden = true
            
            videoUrl = URL(string:videos[indexPath.row]["name"].stringValue)
            self.player.setUrl(videoUrl!)
            self.videoContainer.videoHolder.addSubview(self.player.view)
            cell.addSubview(self.videoContainer)

        }
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("one image clicked")
        print(fromView)
        
        if fromView == "endJourney" {
            let cell = collectionView.cellForItem(at: indexPath) as! gridCollectionViewCell
            
            let conf = Configuration(builder: { (builder) in
                builder.configurePhotoEditorViewController({ (photoOptionBuilder) in
                    
                    photoOptionBuilder.actionButtonConfigurationClosure = { cell, action in
                        cell.tintColor = UIColor.white 
                    }                    
                })
            })
            
            let photoEditViewController = PhotoEditViewController(photo: cell.photo.image!, configuration: conf)
            let toolStackController = ToolStackController(photoEditViewController: photoEditViewController)            
            toolStackController.delegate = self            
            toolStackController.navigationItem.title = "Editor"
//            toolStackController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: photoEditViewController, action: #selector(PhotoEditViewController.save(_:)))
            let nvc = UINavigationController(rootViewController: toolStackController)
            nvc.navigationBar.isTranslucent = false
            nvc.navigationBar.barStyle = .black
            self.present(nvc, animated: true, completion: nil)

        }
        
        else if type == "photos" {            
            let singlePhotoController = self.storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
            singlePhotoController.index = indexPath.row
            singlePhotoController.fetchType = photoVCType.FROM_DETAIL_ITINERARY
            singlePhotoController.postId = "unknown"
            singlePhotoController.allDataCollection = myPhotos
            globalNavigationController.pushViewController(singlePhotoController, animated: true)
        }            
    }
    
    
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
    func openSingleVideo(_ sender: AnyObject) {
        let singlePhotoController = storyboard?.instantiateViewController(withIdentifier: "singlePhoto") as! SinglePhotoViewController
        singlePhotoController.index = sender.view.tag
        singlePhotoController.type = "Video"
        singlePhotoController.postId = videos[sender.view.tag]["post"].stringValue
        globalNavigationController.pushViewController(singlePhotoController, animated: true)
    }
    
    func toolStackControllerDidCancel(_ toolStackController: ToolStackController){
        print("on cancel toolstackcontroller")
        dismiss(animated: true, completion:nil)
    }
    
    func toolStackControllerDidFail(_ toolStackController: ToolStackController){
        print("on fail toolstackcontroller")
    }

    
}

class gridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
}
