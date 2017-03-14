//
//  ReportProblem.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ReportProblem: UIView, UITextViewDelegate {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var theTextView: UITextView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        theTextView.text = "Write Report"
        theTextView.textColor = UIColor.lightGray
        theTextView.layer.borderWidth = 1.0
        theTextView.layer.borderColor = UIColor(red: 225/255, green: 225/255, blue: 225/255, alpha: 1).cgColor
        theTextView.delegate = self
        submitButton.layer.cornerRadius = 5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ReportProblem", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if theTextView.textColor == UIColor.lightGray {
            theTextView.text = nil
            theTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if theTextView.text.isEmpty {
            theTextView.text = "Write Report"
            theTextView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
