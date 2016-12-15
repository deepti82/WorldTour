//
//  QuickItineraryThree.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 06/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItineraryThree: UIView, UITextFieldDelegate {

    
   
    @IBOutlet var quickThree: UIView!
   
    var showCountryButton = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 20))
    var cancelLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 10, height: 10))

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    
        
//        addCountry.layer.cornerRadius = 5
//        addCity.layer.cornerRadius = 5
       
        showCountryButton.layoutIfNeeded()
        showCountryButton.titleLabel?.textAlignment = NSTextAlignment.left
        showCountryButton.setTitleColor(UIColor.black, for: .normal)
        cancelLabel.font = UIFont(name: "FontAwesome", size: 15)
        cancelLabel.text = String(format: "%C", faicon["close"]!)
        cancelLabel.textColor = UIColor(colorLiteralRed: 35/255, green: 45/255, blue: 74/255, alpha: 1)
        showCountryButton.addSubview(cancelLabel)
        showCountryButton.sizeToFit()
        

        
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
    
    
        
               //showCountryButton.backgroundColor = UIColor.yellow
    
   }
