//
//  QuickItineraryThree.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 06/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ItineraryThree: UIView, UITextFieldDelegate {
    
    
    @IBOutlet weak var deleteMe: UIButton!
    @IBOutlet weak var cityCountry: UILabel!
    var index : Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
    }
        

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ItineraryThree", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    func doubleTapped() {
        quickItinery["countryVisited"].arrayObject?.remove(at: index)
        self.removeFromSuperview()
    }
    
               //showCountryButton.backgroundColor = UIColor.yellow
    
   }
