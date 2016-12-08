//
//  QuickIteneraryFour.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 07/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickIteneraryFour: UIViewController, UITextViewDelegate {

    @IBOutlet weak var nextUitextView: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
       @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var italicButton: UIButton!
    @IBOutlet weak var boldButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        nextUitextView.isHidden = true
        boldButton.setTitle(String(format: "%C", faicon["bold"]!), for: UIControlState())
        italicButton.setTitle(String(format: "%C", faicon["italics"]!), for: UIControlState())
         nextButton.isHidden = true
         descriptionTextView.font = UIFont(name: "Arial-Italic", size: 14)
        boldButton.addTarget(self, action: #selector(boldText(_:)), for: .touchUpInside)
        italicButton.addTarget(self, action: #selector(italicText(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func boldText(_ sender: UIButton) {
        let range = descriptionTextView.selectedRange
        let string = NSMutableAttributedString(attributedString: descriptionTextView.attributedText)
//        let attributes = [NSForegroundColorAttributeName: UIColor.red]
        let attributes = [NSFontAttributeName: UIFont(name: "Avenir-Heavy",size: 14)!]
        string.addAttributes(attributes, range: descriptionTextView.selectedRange)
        descriptionTextView.attributedText = string
        descriptionTextView.selectedRange = range
    }
    
    func italicText(_ sender: UIButton){
        let range = descriptionTextView.selectedRange
        let string = NSMutableAttributedString(attributedString: descriptionTextView.attributedText)
        //        let attributes = [NSForegroundColorAttributeName: UIColor.red]
        let attributes1 = [NSFontAttributeName: UIFont(name: "Avenir-MediumOblique",size: 14)!]
        string.addAttributes(attributes1, range: descriptionTextView.selectedRange)
        descriptionTextView.attributedText = string
        descriptionTextView.selectedRange = range

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
         if(text == "\n")
        {
            descriptionTextView.resignFirstResponder()
            return false
        }
     return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
