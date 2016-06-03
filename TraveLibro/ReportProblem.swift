//
//  ReportProblem.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ReportProblem: UIView {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var theTextView: UITextView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        theTextView.text = "Placeholder"
        theTextView.textColor = UIColor.lightGrayColor()
        theTextView.layer.borderWidth = 1.0
        theTextView.layer.borderColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1).CGColor
        submitButton.layer.cornerRadius = 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ReportProblem", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
        
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGrayColor()
        }
    }

}