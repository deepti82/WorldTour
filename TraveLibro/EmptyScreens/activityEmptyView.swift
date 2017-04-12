//
//  activityEmptyView.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 12/04/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class activityEmptyView: UIView {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var exploreView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        exploreView.layer.cornerRadius = 5.0       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "activityEmptyView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);        
    }

}
