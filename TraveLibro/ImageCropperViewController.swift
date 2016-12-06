//
//  ImageCropperViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ImageCropperViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scroll: UIScrollView!
    @IBOutlet var imageToBeCropped: UIImageView!
    @IBOutlet var cropAreaView: UIView!
    
    @IBAction func crop(_ sender: UIButton) {
        
        print("crop frame: \(cropAreaView.frame)")
        let crop = cropAreaView.frame
        let cgImage = imageToBeCropped.image!.cgImage!.cropping(to: crop)
        imageToBeCropped.image = UIImage(cgImage: cgImage!)
        
    }
    
    var sentImage: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        //rightButton.setTitle("Done", for: UIControlState())
        //rightButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        let image = UIImage(cgImage: (UIImage(named: "arrow_next_fa")?.cgImage!)!, scale: 1.0, orientation: .upMirrored)
        rightButton.setImage(image, for: UIControlState())
        rightButton.addTarget(self, action: #selector(EndJourneyViewController.doneEndJourney(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        scroll.delegate = self
        scroll.minimumZoomScale = 1.0
        scroll.maximumZoomScale = 10.0
        scroll.zoomScale = 1
        print("sent image: \(sentImage!)")
        imageToBeCropped.hnk_setImageFromURL(URL(string: "\(adminUrl)upload/readFile?file=\(sentImage!)&width=250")!)
        
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageToBeCropped
    }

}

class CropAreaView: UIView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        return false
    }
}
