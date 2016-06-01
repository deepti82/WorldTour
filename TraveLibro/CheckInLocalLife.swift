//
//  CheckInLocalLife.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 01/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class CheckInLocalLife: UIView {

    @IBOutlet weak var timestampView: UIView!
    @IBOutlet weak var iconButtonView: UIView!
    @IBOutlet weak var likeIcon: UILabel!
    @IBOutlet weak var myScroll: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        likeIcon.text = String(format: "%C", faicon["likes"]!)
        
        let timestamp = DateAndTime(frame: CGRect(x: 0, y: 0, width: timestampView.frame.size.width, height: timestampView.frame.size.height))
        timestampView.addSubview(timestamp)
        
        let icon = IconButton(frame: CGRect(x: 0, y: 0, width: iconButtonView.frame.size.width, height: iconButtonView.frame.size.width))
        iconButtonView.addSubview(icon)
        
        
        myScroll.contentSize = CGSizeMake(500, 95)
        
        
        
        let photobar = PhotoBar(frame: CGRect(x: 0, y: 0, width: 450, height: myScroll.frame.height))
        myScroll.addSubview(photobar)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CheckInLocalLife", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }

}
