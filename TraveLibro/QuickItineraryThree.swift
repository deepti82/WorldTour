//
//  QuickItineraryThree.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 06/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItineraryThree: UIView, UITextFieldDelegate {

   
    @IBOutlet weak var addCountry: UIButton!
    @IBOutlet var quickThree: UIView!
    
    @IBOutlet weak var cityVisitedText: UITextField!
    @IBOutlet weak var countryVisitedText: UITextField!
    @IBOutlet weak var showCountryCityView: UIView!
    @IBOutlet weak var cityDropDown: UIButton!
    @IBOutlet weak var countryDropDown: UIButton!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    
        
//        addCountry.layer.cornerRadius = 5
//        addCity.layer.cornerRadius = 5
       
        
        countryDropDown.isHidden = true
        cityDropDown.isHidden = true
        

 
        
        
    }
        

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QuickItineraryThree", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
         }
    
   }
