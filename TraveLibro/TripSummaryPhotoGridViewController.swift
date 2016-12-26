//
//  TripSummaryPhotoGridViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import imglyKit


class TripSummaryPhotoGridViewController: UICollectionViewController, ToolStackControllerDelegate {
    
    var journeyId = ""
    var myPhotos: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getJourneyPhotos()
        
    }
    
    func getJourneyPhotos() {
        
        self.myPhotos = journeyImages
        
        self.collectionView!.reloadData()
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! gridCollectionViewCell
        cell.photo.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(myPhotos[(indexPath as NSIndexPath).row])")!))
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("one image clicked")
        
        
        let photoEditViewController = PhotoEditViewController(photo: UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(myPhotos[(indexPath as NSIndexPath).row])")!))!)
        let toolStackController = ToolStackController(photoEditViewController: photoEditViewController)
        toolStackController.delegate = self
        toolStackController.navigationItem.title = "Editor"
        toolStackController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: photoEditViewController, action: #selector(PhotoEditViewController.save(_:)))
        let nvc = UINavigationController(rootViewController: toolStackController)
        nvc.navigationBar.isTranslucent = false
        nvc.navigationBar.barStyle = .black
        self.present(nvc, animated: true, completion: nil)
        
            
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
