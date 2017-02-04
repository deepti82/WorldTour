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
    
    var journeyId = ""
    var myPhotos: [String] = []
    var videos: JSON = []
    var fromView = ""
    var type = ""
    var videoContainer:VideoView!
    var player:Player!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getJourneyPhotos()
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Set up desired width

        var cell = collectionView.cellForItem(at: indexPath as IndexPath) as! gridCollectionViewCell
        var size = CGSize(width: 10, height: 10)
        return size
    }
    
    func getJourneyPhotos() {
        
        
//        if !endJourneyState {
            print("oooyyyy in journey images")
            request.journeyTypeData(journeyId, type: type, userId: currentUser["_id"].string!, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"].bool! {
                        if self.type == "photos" {
                        if response["data"]["photos"] != nil {
                            for n in response["data"]["photos"].array! {
                                self.myPhotos.append(n["name"].string!)
                            }
                        }
                        }else{
                            self.videos = response["data"]["videos"]
                        }
                        self.collectionView!.reloadData()
                        
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
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! gridCollectionViewCell
        
        if type == "photos" {
            cell.photo.hnk_setImageFromURL(getImageURL(myPhotos[(indexPath as NSIndexPath).row], width: 300))

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
            let photoEditViewController = PhotoEditViewController(photo: cell.photo.image!)
            let toolStackController = ToolStackController(photoEditViewController: photoEditViewController)
            toolStackController.delegate = self
            toolStackController.navigationItem.title = "Editor"
            toolStackController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: photoEditViewController, action: #selector(PhotoEditViewController.save(_:)))
            let nvc = UINavigationController(rootViewController: toolStackController)
            nvc.navigationBar.isTranslucent = false
            nvc.navigationBar.barStyle = .black
            self.present(nvc, animated: true, completion: nil)

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
        singlePhotoController.mainImage?.image = sender.image
        singlePhotoController.index = sender.view.tag
        singlePhotoController.type = "Video"
        singlePhotoController.postId = videos[sender.view.tag]["post"].stringValue
        globalNavigationController.present(singlePhotoController, animated: true, completion: nil)
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
