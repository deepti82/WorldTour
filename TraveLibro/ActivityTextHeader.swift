//
//  ActivityTextHeader.swift
//  TraveLibro
//
//  Created by Jagruti  on 19/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityTextHeader: UIView {
    
    @IBOutlet var textView: UIView!
    @IBOutlet weak var headerText: UITextView!
    
    
    var displayText = getRegularString(string: "", size: TL_REGULAR_FONT_SIZE)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ActivityTextHeader", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func setText(text: NSMutableAttributedString) {
        self.headerText.attributedText = text
    }
    
}
