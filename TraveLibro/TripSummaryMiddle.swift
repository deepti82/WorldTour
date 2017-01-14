//
//  TripSummaryMiddle.swift
//  TraveLibro
//
//  Created by Jagruti  on 13/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TripSummaryMiddle: UIView {

    @IBOutlet weak var countryStack: UIStackView!
    @IBOutlet weak var countryScroll: UIScrollView!
    var countryLayout: HorizontalLayout!
    var allData: JSON = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        countryLayout = HorizontalLayout(height: countryScroll.frame.height)
        
        countryScroll.addSubview(countryLayout)
        
        
    }
    
    func refLayout() {
//        countryLayout.center.equalTo(countryScroll)
        self.countryLayout.layoutSubviews()
        self.countryScroll.contentSize = CGSize(width: self.countryLayout.frame.width, height: self.countryLayout.frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TripSummaryMiddle", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
}
