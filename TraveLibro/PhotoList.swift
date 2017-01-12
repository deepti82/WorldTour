//
//  PhotoList.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 03/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PhotoList: UIView {

    @IBOutlet weak var likesIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var videoIcon: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentIcon: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var mi: JSON = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        likesIcon.text = String(format: "%C", faicon["likes"]!)
        clockIcon.text = String(format: "%C", faicon["clock"]!)
        commentIcon.text = String(format: "%C", faicon["comments"]!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @IBAction func likeClicked(_ sender: UIButton) {
        print(mi)
    }
    @IBAction func commentClicked(_ sender: UIButton) {
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PhotoList", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }
}
