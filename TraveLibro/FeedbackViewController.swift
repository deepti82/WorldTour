//
//  FeedbackViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 04/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var commentTextBox: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func submitFeedback(sender: AnyObject) {
        
        print("submit feedback")
        
        let alertController = UIAlertController(title: nil, message:
            "Successfully Submitted", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBarItem()
        
        commentTextBox.text = "Comment"
        commentTextBox.textColor = UIColor.lightGrayColor()
        submitButton.layer.cornerRadius = 5
        submitButton.clipsToBounds = true
        
        commentTextBox.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
       
        commentTextBox.text = ""
        commentTextBox.textColor = UIColor.blackColor()
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if commentTextBox.text == nil {
            
            commentTextBox.text = "Comment"
            
        }
        
    }

}
