//
//  QuickIteneraryFive.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 07/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Photos
import  BSImagePicker

class QuickIteneraryFive: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var photosAddMore: UIButton!
    @IBOutlet weak var photosGalleryFirstView: UIView!
    @IBOutlet weak var photoGallerySecondView: UIView!
    @IBOutlet weak var photosCollection: UICollectionView!
    @IBOutlet weak var addTripPhotos: UIButton!
    var thumbnail1 = [UIImage]()
//    var quickItinery: JSON = ["name": ""]
    let image1 = UIImage()
    let imagePicker = UIImagePickerController()
    var selectPhotosCount = 10
        override func viewDidLoad() {
            
        super.viewDidLoad()
        photosCollection.dataSource = self
        photosCollection.delegate = self
        photoGallerySecondView.isHidden = true
            addTripPhotos.addTarget(self, action: #selector(addTripPhotosGallery(_:)), for: .touchUpInside)
            photosAddMore.addTarget(self, action: #selector(addMoreTripPhotos(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(quickItinery)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.thumbnail1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosFromGallery", for: indexPath)
            as! photosSelection
        
        cell.photosImage.image = self.thumbnail1[indexPath.row]
        return cell
    }
    
    
    
    func addTripPhotosGallery(_ sender: UIButton){
        let multipleImage = BSImagePickerViewController()
        multipleImage.maxNumberOfSelections = 20
        
        self.bs_presentImagePickerController(multipleImage, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
                                                print("Selected: \(asset)")
                                                
                    
            }, deselect: { (assets: PHAsset) -> Void in
                
                print("deselected: \(assets)")
                
            },  cancel: { (assets: [PHAsset]) -> Void in
                
                print("Cancel: \(assets)")
                }, finish: { (assets: [PHAsset]) -> Void in
                DispatchQueue.main.async {
                    print("test imagepicker")
                    let manage1 = PHImageManager.default()
                    let option1 = PHImageRequestOptions()
                    var n = 0
                    option1.isSynchronous = true
                    for n in 0...assets.count - 1{
                        print(n)
                        manage1.requestImage(for: assets[n], targetSize: CGSize(width: 400, height: 400), contentMode: .aspectFit, options: option1, resultHandler: {(result, info)->Void in
                            
                            print(result!)
                            
                            self.thumbnail1.append(result!)
                            print("showcell0: \(self.thumbnail1)")
                            
                        })
                    }
                   
                    self.photoGallerySecondView.isHidden = false
                    self.photosGalleryFirstView.isHidden = true
                    self.photosCollection.reloadData()

                }
            }, completion: nil)

    }
    
    
    func addMoreTripPhotos(_ sender: UIButton){
        let multipleImage = BSImagePickerViewController()
        multipleImage.maxNumberOfSelections = 10
        
        self.bs_presentImagePickerController(multipleImage, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
                                                print("Selected: \(asset)")
                                                
                                                
        }, deselect: { (assets: PHAsset) -> Void in
            
            print("deselected: \(assets)")
            
        },  cancel: { (assets: [PHAsset]) -> Void in
            
            print("Cancel: \(assets)")
        }, finish: { (assets: [PHAsset]) -> Void in
            DispatchQueue.main.async {
                print("test imagepicker")
                let manage1 = PHImageManager.default()
                let option1 = PHImageRequestOptions()
                
                option1.isSynchronous = true
                for n in 0...assets.count - 1{
                    print(n)
                    manage1.requestImage(for: assets[n], targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option1, resultHandler: {(result, info)->Void in
                        
                        print(result!)
                        
                        self.thumbnail1.append(result!)
                        
                    })
                }
                
                self.photoGallerySecondView.isHidden = false
                self.photosGalleryFirstView.isHidden = true
                self.photosCollection.reloadData()
                
            }
        }, completion: nil)

        
    }
    
}

class photosSelection: UICollectionViewCell {
 
    
  
    @IBOutlet weak var photosImage: UIImageView!
    
    
    
}
