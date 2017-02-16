//
//  NotificationTitle.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 15/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class NotificationTitle: UIView {
    
    
    @IBOutlet weak var NFMessageLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "notificationTitleView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
    
    func setMessageLabel(data: JSON) {
        
        NFMessageLabel.text = ""
        var message = ""
        let firstName = data["userFrom"]["name"].stringValue        
        message = firstName + " wants to tag you in her On The Go Journey"
        
        
        NFMessageLabel.text = message
    }
    
    

}
