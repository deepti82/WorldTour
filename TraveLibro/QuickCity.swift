//
//  QuickCity.swift
//  TraveLibro
//
//  Created by Jagruti  on 07/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

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
        deleteOut.setTitle(String(format: "%C", faicon["trash"]!), for: UIControlState())
        
        deleteOut.addTarget(self, action: #selector(self.deleteCity(_:)), for: .touchUpInside)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func deleteCity(_ sender:AnyObject) {
    print("delette city")
        if quickItinery["countryVisited"][self.countryTag]["cityVisited"].count <= 1 {
            let alt = Toast(text: "Atlest one city is compulsory.")
            alt.show()
        }else{
        quickItinery["countryVisited"][self.countryTag]["cityVisited"].arrayObject?.remove(at: self.tag)
//        selectedCity.arrayObject?.remove(at: self.cityTag)
        parentView.createLayout()
        }
        
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
