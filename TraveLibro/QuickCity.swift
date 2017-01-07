//
//  QuickCity.swift
//  TraveLibro
//
//  Created by Jagruti  on 07/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickCity: UIView {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var deleteOut: UIButton!
    @IBOutlet weak var countryId: UILabel!
    var cityTag = 0
    var countryTag = 0
    var parentView:QuickIteneraryThree!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func deleteCity(_ sender: UIButton) {
        
        quickItinery["countryVisited"][self.countryTag]["cityVisited"].arrayObject?.remove(at: self.cityTag)
        selectedCity.arrayObject?.remove(at: self.cityTag)
        parentView.createLayout()
        
    }
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QuickCity", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
}
