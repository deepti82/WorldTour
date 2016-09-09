//
//  AddActivityOTG.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 9/9/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddActivityOTG: UIView {

    @IBOutlet weak var checkInCategoryEdit: UIButton!
    @IBOutlet weak var checkInCategory: UILabel!
    @IBOutlet weak var checkInPlace: UILabel!
    @IBOutlet weak var checkInMainView: UIView!
    
    @IBOutlet weak var photosCount: UILabel!
    @IBOutlet weak var photoOne: UIImageView!
    @IBOutlet weak var photoTwo: UIImageView!
    @IBOutlet weak var photoThree: UIImageView!
    @IBOutlet weak var photoFour: UIImageView!
    @IBOutlet weak var photosMainView: UIView!
    
    @IBOutlet weak var videosCount: UILabel!
    @IBOutlet weak var videoOne: UIImageView!
    @IBOutlet weak var videoTwo: UIImageView!
    @IBOutlet weak var videoThree: UIImageView!
    @IBOutlet weak var videoFour: UIImageView!
    @IBOutlet weak var videosMainView: UIView!
    
    @IBOutlet weak var thoughtsText: UITextView!
    @IBOutlet weak var thoughtsCharacterCount: UILabel!
    @IBOutlet weak var thoughtsMainView: UIView!
    
    @IBOutlet weak var tagFriends: UILabel!
    @IBOutlet weak var friendsCount: UIButton!
    @IBOutlet weak var friendsMainView: UIView!
    
    @IBOutlet weak var fbShare: UIButton!
    @IBOutlet weak var whatsappShare: UIButton!
    @IBOutlet weak var googleShare: UIButton!
    @IBOutlet weak var twitterShare: UIButton!
    @IBOutlet weak var moreShare: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddActivityOTG", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}
