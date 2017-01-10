
//  QuickItineraryPreview.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 08/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItineraryPreview: UIView {

    @IBOutlet weak var qiView: UIView!
    @IBOutlet weak var countryScroll: UIScrollView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var displayPiture: UIImageView!
    @IBOutlet weak var quickTitle: UILabel!
    @IBOutlet weak var cityScroll: UIScrollView!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var quickDescription: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        
//        self.qiView.layer.cornerRadius = 5
//        self.qiView.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QuickItineraryPreview", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }

}
