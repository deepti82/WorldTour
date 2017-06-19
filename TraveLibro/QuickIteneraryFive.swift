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

class QuickIteneraryFive: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var photosAddMore: UIButton!
    @IBOutlet weak var photosGalleryFirstView: UIView!
    @IBOutlet weak var photoGallerySecondView: UIView!
    @IBOutlet weak var photosCollection: UICollectionView!
    @IBOutlet weak var addTripPhotos: UIButton!
    var imageArr:[PostImage] = []
    
    var thumbnail1 = [UIImage]()
    let image1 = UIImage()
    let imagePicker = UIImagePickerController()
    var selectPhotosCount = 10
        override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCollection.dataSource = self
        photosCollection.delegate = self
        photoGallerySecondView.isHidden = true
            addTripPhotos.addTarget(self, action: #selector(addTripPhotosGallery(_:)), for: .touchUpInside)
            photosAddMore.addTarget(self, action: #selector(addTripPhotosGallery(_:)), for: .touchUpInside)
            
            transparentCardWhite(photosGalleryFirstView)
            transparentCardWhite(photoGallerySecondView)
            photosAddMore.clipsToBounds = true
            photosAddMore.layer.cornerRadius = 5
            addTripPhotos.layer.cornerRadius = 5
            addTripPhotos.clipsToBounds = true
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(quickItinery)
        setAnalytics(name: "Quickitinerary page Five")

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(self.imageArr.count > 0) {
            self.photoGallerySecondView.isHidden = false
            self.photosGalleryFirstView.isHidden = true
        } else {
            self.photoGallerySecondView.isHidden = true
            self.photosGalleryFirstView.isHidden = false
        }
        
        return self.imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        if shouldShowBigImage(position: indexPath.row) {
//            return CGSize(width: (collectionView.frame.size.width), height: collectionView.frame.size.width * 0.7)
//        }
        return CGSize(width: ((photosCollection.frame.size.width - 2)/2), height: (((photosCollection.frame.size.width - 2)/2) * 1.35))
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photosFromGallery", for: indexPath)
            as! photosSelection
        if(self.imageArr[indexPath.row].imageUrl != nil) {
            cell.photosImage.sd_setImage(with: self.imageArr[indexPath.row].imageUrl,
                                         placeholderImage: getPlaceholderImage())
        } else {
            cell.photosImage.image = self.imageArr[indexPath.row].image
        }
        
        
        cell.photosImage.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let n = indexPath.row
        self.addCaption(n);
    }
    
    
    
    func addTripPhotosGallery(_ sender: UIButton){
        
//        let captionVC = storyboard?.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
//        captionVC.imageArr = thumbnail1
        
        let multipleImage = BSImagePickerViewController()
        multipleImage.maxNumberOfSelections = 20
        multipleImage.navigationBar.isTranslucent = true
        multipleImage.navigationBar.barTintColor = mainBlueColor
        multipleImage.navigationBar.tintColor = UIColor.white
        multipleImage.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.white
        ] // Title color

        
        self.bs_presentImagePickerController(multipleImage, animated: true,
                                             select: { (asset: PHAsset) -> Void in
                                                
                                                print("Selected: \(asset)")
                                                
                    
            }, deselect: { (assets: PHAsset) -> Void in
                
                print("deselected: \(assets)")
                
            },  cancel: { (assets: [PHAsset]) -> Void in
                
                print("Cancel: \(assets)")
                }, finish: { (assets: [PHAsset]) -> Void in
                    
                    var img11 = [UIImage]()
                DispatchQueue.main.async {
                    let option1 = PHImageRequestOptions()
                    option1.isSynchronous = true
                    for n in 0...assets.count-1{
                        PHImageManager.default().requestImage(for: assets[n], targetSize: CGSize(width: assets[n].pixelWidth, height: assets[n].pixelHeight), contentMode: .aspectFit, options: option1, resultHandler: {(result, info) in
                            img11.append(result!)
                        })
                    }
                    self.photosAdded(assets: img11)
                    

                }
            }, completion: nil)

    }
    
    func photosAdded(assets: [UIImage]) {
        for asset in assets {
            let postImg = PostImage()
            postImg.image = asset.resizeWith(width:800)            
            imageArr.append(postImg)
            globalPostImage.append(postImg)
        }
        
        self.addCaption(0);
        self.photoGallerySecondView.isHidden = false
        self.photosGalleryFirstView.isHidden = true
        self.photosCollection.reloadData()
    }
    
    
    func addCaption(_ n: Int) {
        let captionVC = storyboard?.instantiateViewController(withIdentifier: "addCaptions") as! AddCaptionsViewController
        captionVC.imageArr = imageArr
        captionVC.quickIt = self
        captionVC.currentImageIndex = n
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(captionVC, animated: true)
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
                for n in 0...assets.count - 1 {
                    manage1.requestImage(for: assets[n], targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option1, resultHandler: {(result, info)->Void in
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
