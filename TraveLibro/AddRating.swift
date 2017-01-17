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
    
    @IBOutlet weak var starsStack: UIStackView!
    @IBOutlet weak var postReview: UIButton!
    @IBOutlet weak var reviewConclusion: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var stars: [UIButton]!
    @IBOutlet weak var smiley: UIButton!
    
    var post:Post!
    var checkIn:RatingCheckIn!
    var json:JSON!
    
    let moodArr = ["Disappointed", "Sad", "Good", "Super", "In Love"]
    let imageArr = ["disapointed", "sad", "good", "superface", "love"]
    var navController = UINavigationController()
    
    @IBAction func postReviewTapped(_ sender: UIButton) {
        
        print("post id in review: \(sender.title(for: .application)!)")
        reviewTextView.resignFirstResponder()
        var reviewBody = ""
        
        if reviewTextView.text != nil && reviewTextView.text != "Fill Me In..." {
            reviewBody = reviewTextView.text
        }
        self.checkIn.modifyAsReview(num: (self.starCount - 1))
        self.checkIn.reviewTapOut(UITapGestureRecognizer())
        self.removeFromSuperview()
        request.rateCheckIn(currentUser["_id"].string!, postId: post.post_ids, rating: "\(starCount)", review: reviewBody, completion: {(response) in
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                }
                else if response["value"].bool! {
                    print("Review Sent Successfully");
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
        reviewTextView.returnKeyType = .done
        
        for star in stars {
            star.setImage(UIImage(named: "star_uncheck"), for: UIControlState())
            star.setImage(UIImage(named: "star_check"), for: .selected)
            star.setImage(UIImage(named: "star_check"), for: [.highlighted, .selected])
            star.adjustsImageWhenHighlighted = false
            star.addTarget(self, action: #selector(AddRating.ratingButtonTapped), for: .touchDown)
        }
        
        
//        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateSmiley(point:Int) {
        
        ratingIndex = point
        reviewConclusion.text = moodArr[point - 1]
        smiley.setImage(UIImage(named: imageArr[point - 1]), for: UIControlState())
        updateButtonSelectionStates()
        
    }
    
    func ratingDisplay(_ review: JSON) {
        
        reviewTextView.text = review["review"].string!
        for i in 0 ..< Int(review["rating"].string!)! {
            
            stars[i].setImage(UIImage(named: "star_check"), for: UIControlState())
            
        }
        smiley.setImage(UIImage(named: imageArr[Int(review["rating"].string!)! - 1]), for: UIControlState())
        reviewConclusion.text = moodArr[Int(review["rating"].string!)! - 1]
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if reviewTextView.text == "Fill Me In..." {
            
            reviewTextView.text = ""
            
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
        if reviewTextView.text == "" {
            
            reviewTextView.text = "Fill Me In..."
            
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
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
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AddRating", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        if(json != nil) {
            ratingDisplay(json)
        }
    }
    
    func ratingButtonTapped(_ button: UIButton) {
        print("button taped")
        
        ratingIndex = stars.index(of: button)! + 1
        print(ratingIndex)
        reviewConclusion.text = moodArr[ratingIndex - 1]
        smiley.setImage(UIImage(named: imageArr[ratingIndex - 1]), for: UIControlState())
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        starCount = 0
        for (index, button) in stars.enumerated() {
            button.isSelected = index < ratingIndex
            if button.isSelected {
                
                starCount += 1
                
            }
        }
    }

}
