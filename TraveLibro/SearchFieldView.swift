//
//  SearchFieldView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SearchFieldView: UIView {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var SearchView: UIView!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "SearchFieldView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}
