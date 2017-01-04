//
//  PhotosOTGView.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 28/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PhotosOTGView: UIView {

    @IBOutlet weak var morePhotosView: UIScrollView!
    var horizontalScrollForPhotos:HorizontalLayout!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PhotosOTGView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        self.horizontalScrollForPhotos = HorizontalLayout(height: morePhotosView.frame.height)
        self.morePhotosView.addSubview(horizontalScrollForPhotos)
    }
   

}
