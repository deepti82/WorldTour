//
//  RatingCheckIn.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 08/10/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class RatingCheckIn: UIView {
    
    @IBOutlet weak var rateCheckInLabel: UILabel!
    @IBOutlet weak var rateCheckInButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "RatingCheckIn", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view)
    }
    
}

class RatingAlert: UIView {
    
    var rating = 0
    let spacing = 25
    let starCount = 5
    var ratingButtons = [UIButton]()
    let moodArr = ["Disappointed", "Sad", "Good", "Super", "In Love"]
    let imageArr = ["disapointed", "sad", "good", "superface", "love"]
    
    var imageView: UIImageView!
    var backimageView: UIImageView!
    var moodText: UILabel!
    var ratingView: UIView!
    var reviewLabel: UILabel!
    var textView: UITextView!
    var postButton: UIButton!
    let filledStarImage = UIImage(named: "star_check")
    let emptyStarImage = UIImage(named: "star_uncheck")
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        imageView.center.x = frame.size.width / 2
        imageView.image = UIImage(named: "disapointed")
        addSubview(imageView)
        
        backimageView = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        backimageView.center.x = frame.size.width / 2
        backimageView.image = UIImage(named: "green_bg_new_small")
        addSubview(backimageView)
        
        moodText = UILabel(frame: CGRectMake(0, 60, frame.size.width, 20))
        moodText.textAlignment = .Center
        moodText.textColor = mainBlueColor
        addSubview(moodText)
        
        ratingView = UIView(frame: CGRect(x: 0, y: 100, width: 225, height: 25))
        ratingView.center.x = frame.size.width / 2
        addSubview(ratingView)
        
        reviewLabel = UILabel(frame: CGRectMake(0, 135, frame.size.width, 20))
        reviewLabel.text = "Add your Review"
        reviewLabel.textColor = UIColor.blueColor()
        reviewLabel.textAlignment = .Center
        reviewLabel.font = UIFont(name: "Avenir", size: 13)
        addSubview(reviewLabel)
        
        textView = UITextView(frame: CGRectMake(50, 160, frame.size.width - 50, 80))
        textView.text = "Fill me in..."
        textView.font = UIFont(name: "Avenir", size: 16)
        textView.resignFirstResponder()
        addSubview(textView)
        
        postButton = UIButton(frame: CGRectMake(0, 240, 100, 40))
        postButton.center.x = frame.size.width / 2
        postButton.setTitle("POST", forState: .Normal)
        postButton.backgroundColor = mainBlueColor
        postButton.layer.cornerRadius = 5
        addSubview(postButton)
        
        for _ in 0..<starCount {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.setImage(emptyStarImage, forState: .Normal)
            button.setImage(filledStarImage, forState: .Selected)
            button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
            button.adjustsImageWhenHighlighted = false
            button.addTarget(self, action: #selector(RatingAlert.ratingButtonTapped), forControlEvents: .TouchDown)
            ratingButtons += [button]
            ratingView.addSubview(button)
        }
    }
    
    override func layoutSubviews() {
        var buttonFrame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        for (index, button) in ratingButtons.enumerate() {
            buttonFrame.origin.x = CGFloat(index * (25 + spacing))
            button.frame = buttonFrame
        }
        
        updateButtonSelectionStates()
    }
    
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: frame.size.width, height: 25)
    }
    
    func ratingButtonTapped(button: UIButton) {
        rating = ratingButtons.indexOf(button)! + 1
        print(rating)
        moodText.text = moodArr[rating - 1]
        imageView.image = UIImage(named: imageArr[rating - 1])
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerate() {
            // If the index of a button is less than the rating, that button should be selected.
            button.selected = index < rating
        }
    }
    
}
