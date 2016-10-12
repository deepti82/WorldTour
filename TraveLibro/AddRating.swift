//
//  AddRating.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddRating: UIView {
    
    var ratingIndex = 0
    
    @IBOutlet weak var postReview: UIButton!
    @IBOutlet weak var reviewConclusion: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var stars: [UIButton]!
    @IBOutlet weak var smiley: UIButton!
    
    let moodArr = ["Disappointed", "Sad", "Good", "Super", "In Love"]
    let imageArr = ["disapointed", "sad", "good", "superface", "love"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        postReview.layer.cornerRadius = 5
        postReview.clipsToBounds = true
        
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
        for (index, button) in stars.enumerate() {
            // If the index of a button is less than the rating, that button should be selected.
            button.selected = index < ratingIndex
        }
    }

}
