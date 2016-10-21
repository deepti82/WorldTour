//
//  MomentsTab.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 21/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

@IBDesignable class MomentsTab: UIView {

    @IBOutlet weak var TagView: UIView!
    @IBOutlet weak var clockInTag: UILabel!
    @IBOutlet weak var daysInImage: UILabel!
    @IBOutlet weak var likesFALabel: UILabel!
    @IBOutlet weak var flag3: UIImageView!
    @IBOutlet weak var flag2: UIImageView!
    @IBOutlet weak var flag1: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        clockInTag.text = String(format: "%C", faicon["clock"]!)
        TagView.backgroundColor = mainBlueColor
        likesFALabel.text = String(format: "%C", faicon["likes"]!)
        
        flag3.layer.cornerRadius = self.flag3.frame.size.height/2
        flag3.clipsToBounds = true
        flag3.layer.borderColor = UIColor.white.cgColor
        flag3.layer.borderWidth = CGFloat(1.5)
        
        flag2.layer.cornerRadius = self.flag2.frame.size.height/2
        flag2.clipsToBounds = true
        flag2.layer.borderColor = UIColor.white.cgColor
        flag2.layer.borderWidth = CGFloat(1.5)
        
        flag1.layer.cornerRadius = self.flag1.frame.size.height/2
        flag1.clipsToBounds = true
        flag1.layer.borderColor = UIColor.white.cgColor
        flag1.layer.borderWidth = CGFloat(1.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MomentsTab", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
