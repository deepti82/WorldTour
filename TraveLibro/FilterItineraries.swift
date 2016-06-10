//
//  FilterItineraries.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 10/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FilterItineraries: UIView {

    @IBOutlet weak var searchView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let search = SearchFieldView(frame: CGRect(x: 0, y: 0, width: searchView.frame.width, height: searchView.frame.height))
        search.searchField.placeholder = "Search a city"
        searchView.addSubview(search)
        
//        let blurBackground = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
//        blurBackground.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.bounds
        blurView.layer.zPosition = -1
        self.addSubview(blurView)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FilterItineraries", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}
