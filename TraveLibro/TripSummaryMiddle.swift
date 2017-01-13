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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        countryLayout = HorizontalLayout(height: countryScroll.frame.height)
        countryScroll.addSubview(countryLayout)
        let tripfo = TripSummaryCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        countryLayout.addSubview(tripfo)
        let tripfo1 = TripSummaryCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        countryLayout.addSubview(tripfo1)
        let tripfo2 = TripSummaryCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        countryLayout.addSubview(tripfo2)
        let tripfo3 = TripSummaryCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        countryLayout.addSubview(tripfo3)
        let tripfo4 = TripSummaryCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        countryLayout.addSubview(tripfo4)
        let tripfo5 = TripSummaryCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        countryLayout.addSubview(tripfo5)
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
