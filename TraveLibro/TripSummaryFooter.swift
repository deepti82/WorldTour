//
//  TripSummaryFooter.swift
//  TraveLibro
//
//  Created by Jagruti  on 13/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TripSummaryFooter: UIView {

    @IBOutlet weak var countryScroll: UIScrollView!
    @IBOutlet weak var countryCount: UILabel!
    var countryLayout: HorizontalFitLayout!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        countryLayout = HorizontalFitLayout(height: countryScroll.frame.height)
        countryScroll.addSubview(countryLayout)
    }
    
    func refLayout() {
        self.countryLayout.layoutSubviews()
        self.countryScroll.contentSize = CGSize(width: self.countryLayout.frame.width, height: self.countryLayout.frame.height)
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TripSummaryFooter", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }

}
