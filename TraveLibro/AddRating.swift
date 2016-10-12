//
//  AddRating.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddRating: UIView, UITextViewDelegate {
    
    var ratingIndex = 0
    var starCount = 0
    
    @IBOutlet weak var postReview: UIButton!
    @IBOutlet weak var reviewConclusion: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var stars: [UIButton]!
    @IBOutlet weak var smiley: UIButton!
    
    let moodArr = ["Disappointed", "Sad", "Good", "Super", "In Love"]
    let imageArr = ["disapointed", "sad", "good", "superface", "love"]
    let parent = NewTLViewController()
    
    @IBAction func postReviewTapped(sender: UIButton) {
        
            print("post id in review: \(sender.titleForState(.Application)!)")
            let post = sender.titleForState(.Application)!
            reviewTextView.resignFirstResponder()
            
            request.rateCheckIn(currentUser["_id"].string!, postId: post, rating: "\(starCount)", review: reviewTextView.text, completion: {(response) in
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    if response.error != nil {
                        
                        print("error: \(response.error!.localizedDescription)")
                        
                    }
                    else if response["value"] {
                        
                        print("response arrived")
                        sender.superview!.superview!.superview!.removeFromSuperview()
                        self.parent.removeRatingButton(sender.titleForState(.Application)!)
                        
                    }
                    else {
                        
                        print("response error!")
                        
                    }
                    
                })
                
            })
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        postReview.layer.cornerRadius = 5
        postReview.clipsToBounds = true
        reviewTextView.delegate = self
        reviewTextView.returnKeyType = .Done
        
        for star in stars {
            star.setImage(UIImage(named: "star_uncheck"), forState: .Normal)
            star.setImage(UIImage(named: "star_check"), forState: .Selected)
            star.setImage(UIImage(named: "star_check"), forState: [.Highlighted, .Selected])
            star.adjustsImageWhenHighlighted = false
            star.addTarget(self, action: #selector(AddRating.ratingButtonTapped), forControlEvents: .TouchDown)
        }
        
//        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if reviewTextView.text == "Fill Me In..." {
            
            reviewTextView.text = ""
            
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        
        if reviewTextView.text == "" {
            
            reviewTextView.text = "Fill Me In..."
            
        }
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            reviewTextView.resignFirstResponder()
            
            if reviewTextView.text == "" {
                
                reviewTextView.text = "Fill Me In..."
                
            }
            return true
            
        }
        
        return true
        
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "AddRating", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view)
    }
    
    func ratingButtonTapped(button: UIButton) {
        ratingIndex = stars.indexOf(button)! + 1
        reviewConclusion.text = moodArr[ratingIndex - 1]
        smiley.setImage(UIImage(named: imageArr[ratingIndex - 1]), forState: .Normal)
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        starCount = 0
        for (index, button) in stars.enumerate() {
            button.selected = index < ratingIndex
            if button.selected {
                
                starCount += 1
                
            }
        }
    }

}
