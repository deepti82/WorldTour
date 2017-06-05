//
//  TLCropImageViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 31/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

@objc protocol TLImageCroppingDelagete{
    func imageCroppingCancelled(sender: UIButton)
    func imageCroppingFinished(croppedImage: UIImage?)
}

class TLCropImageViewController: UIViewController, CroppableImageViewDelegateProtocol, UINavigationControllerDelegate {
    
    @IBOutlet weak var cropView: CroppableImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var selectedImage: UIImage!
    var croppingDelegate: TLImageCroppingDelagete?
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cropView.cropDelegate = self
        
        self.setImageToCrop(img: self.selectedImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setImageToCrop(img: UIImage) {
        cropView.imageToCrop = img
    }
    
    
    //MARK: - Delegate
    
    func haveValidCropRect(_ haveValidCropRect:Bool) {
        saveButton.isEnabled = haveValidCropRect
    }
    
    
    // MARK: - Button Actions   
    
    @IBAction func cancelButtonTabbed(_ sender: UIButton) {
        croppingDelegate?.imageCroppingCancelled(sender: sender)
        self.popVC(sender)
    }
    
    @IBAction func saveButtonTabbed(_ sender: UIButton) {
        
        if let croppedImage = cropView.croppedImage() {
            cropView.imageToCrop = croppedImage
            self.cancelButtonTabbed(sender)
            croppingDelegate?.imageCroppingFinished(croppedImage: croppedImage)
        }
    }
    
    
    
}
