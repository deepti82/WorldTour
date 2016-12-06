//
//  QuickItineraryTwo.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItineraryTwo: UIView {

    @IBOutlet var TypeButton: [UIButton]!
    @IBOutlet weak var nextButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        nextButton.layer.cornerRadius = 5
        
        let array = ["adventure", "business", "family", "romance", "backpacking", "budget", "luxury", "religious", "friends"]
        
        for button in TypeButton {
            
            let index = TypeButton.index(of: button)
            button.setTitle(array[index!], for: .application)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QuickItineraryTwo", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
