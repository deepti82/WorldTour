//
//  HotelTypeSelect.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class HotelTypeSelect: UIView {

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet var hotelFiltersButton: [UIButton]!
    @IBOutlet var starButtons: [UIButton]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.frame
//        blurView.frame.size.height = self.frame.height + 300 
        blurView.layer.zPosition = -1
        blurView.isUserInteractionEnabled = false
        self.addSubview(blurView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HotelTypeSelect", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
