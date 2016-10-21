//
//  traveLifeVideoPost.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TraveLifeVideoPost: UIView {

    @IBOutlet weak var mainPost: UIImageView!
    @IBOutlet weak var imageScroll: UIScrollView!
    @IBOutlet weak var likeText: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var iconButtonView: UIView!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var cycleIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        likeLabel.text = String(format: "%C", faicon["likes"]!)
        
        let icon = IconButton(frame: CGRect(x: 0, y: 0, width: iconButtonView.frame.width, height: iconButtonView.frame.height))
        iconButtonView.addSubview(icon)
        
        imageScroll.contentSize.height = mainPost.frame.height
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TraveLifeVideoPost", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
