//
//  QuickCountry.swift
//  TraveLibro
//
//  Created by Jagruti  on 06/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickCountry: UIView {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var deleteOut: UIButton!
    var countryTag = 0
    var parentView:QuickIteneraryThree!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    @IBAction func deleteCountry(_ sender: Any) {
        quickItinery["countryVisited"].arrayObject?.remove(at: self.countryTag)
        parentView.createLayout()
    }
    
    @IBAction func editCountry(_ sender: UIButton) {
        selectedCountry = quickItinery["countryVisited"][self.countryTag]
        selectedCity = quickItinery["countryVisited"][self.countryTag]["cityVisited"]
        parentView.fillText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QuickCountry", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
