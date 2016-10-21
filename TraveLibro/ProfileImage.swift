//
//  ProfileImage.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 01/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ProfileImage: UIView {

    @IBOutlet var profileView: UIView!
    @IBOutlet weak var foregroundImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let image = UIImage(named: "profile_image.png")
        let maskingImage = UIImage(named: "profile_mask.png")
        foregroundImage.image = maskImage(image!, mask: maskingImage!)
        
        let bgImage = UIImage(named: "profile_border")
        let bgImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: foregroundImage.frame.width, height: foregroundImage.frame.height))
        bgImageView.image = bgImage
        bgImageView.layer.zPosition = -1
        
        profileView.addSubview(bgImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProfileImage", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
    func maskImage(_ image:UIImage, mask:(UIImage))->UIImage{
        
        let imageReference = image.cgImage
        let maskReference = mask.cgImage
        
        let imageMask = CGImage(maskWidth: (maskReference?.width)!,
                                          height: (maskReference?.height)!,
                                          bitsPerComponent: (maskReference?.bitsPerComponent)!,
                                          bitsPerPixel: (maskReference?.bitsPerPixel)!,
                                          bytesPerRow: (maskReference?.bytesPerRow)!,
                                          provider: (maskReference?.dataProvider!)!, decode: nil, shouldInterpolate: true)
        
        let maskedReference = imageReference?.masking(imageMask!)
        
        let maskedImage = UIImage(cgImage:maskedReference!)
        
        return maskedImage
    }
    

}
