//
//  StatusView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 18/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class StatusView: UIView {

    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var timestampView: UIView!
    @IBOutlet weak var likeViewLabel: UILabel!
    @IBOutlet weak var likeHeart: UILabel!
    @IBOutlet weak var line1: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
//        let timestamp = DateAndTime(frame: CGRect(x: 0, y: 0, width: 200, height: timestampView.frame.size.height))
//        timestampView.addSubview(timestamp)
        
        let sideIcon = IconButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        sideIcon.center = CGPoint(x: self.frame.size.width - 30, y: 10)
        self.addSubview(sideIcon)
        
        likeViewLabel.textColor = mainBlueColor
        
        likeHeart.font = UIFont(name: "FontAwesome", size: 12)
        likeHeart.text = String(format: "%C", faicon["likes"]!)
        
        let seperatorLine = drawSeperatorLineTwo(frame: CGRect(x: 0, y: line1.frame.size.height/2, width: self.frame.size.width - 25, height: 10))
        seperatorLine.backgroundColor = UIColor.clear
        line1.addSubview(seperatorLine)
        
        let seperatorLineTwo = drawSeperatorLineTwo(frame: CGRect(x: 0, y: line2.frame.size.height - 1, width: self.frame.size.width - 25, height: 10))
        seperatorLineTwo.backgroundColor = UIColor.clear
        line2.addSubview(seperatorLineTwo)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "StatusView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
