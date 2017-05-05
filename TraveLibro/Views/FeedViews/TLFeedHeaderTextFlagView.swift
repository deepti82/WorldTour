//
//  TLFeedHeaderTextFlagView.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 03/05/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TLFeedHeaderTextFlagView: UIView {
    
    
    @IBOutlet weak var headerTextView: UITextView!
    @IBOutlet weak var flagStackView: UIStackView!    
    @IBOutlet var flagImageArray: [UIImageView]!    
    
    var displayText = getRegularString(string: "", size: TL_REGULAR_FONT_SIZE)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        for flagImageView in flagImageArray {
            makeFlagBorderWhiteCorner(flagImageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FeedHeaderTextFlagView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func setText(text: NSMutableAttributedString) {
        self.headerTextView.attributedText = text
    }
    
    func setFlag(feed: JSON) {
        
        for imgView in self.flagImageArray {
            imgView.image = nil
            imgView.layer.borderColor = UIColor.clear.cgColor
        }
        
        if !((feed["countryVisited"].arrayValue).isEmpty) {
            for i in 0..<feed["countryVisited"].arrayValue.count {
                if flagImageArray[i].frame.size.height > 0 {
                    flagImageArray[i].hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(feed["countryVisited"][i]["country"]["flag"])", width: SMALL_PHOTO_WIDTH))
                    flagImageArray[i].layer.borderColor = UIColor.white.cgColor
                }
                else {
                    print("In else")
                }
            }
        }
    }

}
