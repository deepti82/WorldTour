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
        
        rateCheckInLabel.shadowColor = UIColor.black
        rateCheckInLabel.shadowOffset = CGSize(width: 10, height: 10)
        rateCheckInLabel.layer.masksToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RatingCheckIn", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
}

//class RatingAlert: UIView {
//    
//    var rating = 0
//    let spacing = 25
//    let starCount = 5
//    var ratingButtons = [UIButton]()
//    let moodArr = ["Disappointed", "Sad", "Good", "Super", "In Love"]
//    let imageArr = ["disapointed", "sad", "good", "superface", "love"]
//    
//    var imageView: UIImageView!
//    var backimageView: UIImageView!
//    var moodText: UILabel!
//    var ratingView: UIView!
//    var reviewLabel: UILabel!
//    var textView: UITextView!
//    var postButton: UIButton!
//    let filledStarImage = UIImage(named: "star_check")
//    let emptyStarImage = UIImage(named: "star_uncheck")
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        imageView.center.x = frame.size.width / 2
//        imageView.image = UIImage(named: "disapointed")
//        addSubview(imageView)
//        
//        backimageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//        backimageView.center.x = frame.size.width / 2
//        backimageView.image = UIImage(named: "green_bg_new_small")
//        addSubview(backimageView)
//        
//        moodText = UILabel(frame: CGRect(x: 0, y: 60, width: frame.size.width, height: 20))
//        moodText.textAlignment = .center
//        moodText.textColor = mainBlueColor
//        addSubview(moodText)
//        
//        ratingView = UIView(frame: CGRect(x: 0, y: 100, width: 225, height: 25))
//        ratingView.center.x = frame.size.width / 2
//        addSubview(ratingView)
//        
//        reviewLabel = UILabel(frame: CGRect(x: 0, y: 135, width: frame.size.width, height: 20))
//        reviewLabel.text = "Add your Review"
//        reviewLabel.textColor = UIColor.blue
//        reviewLabel.textAlignment = .center
//        reviewLabel.font = UIFont(name: "Avenir", size: 13)
//        addSubview(reviewLabel)
//        
//        textView = UITextView(frame: CGRect(x: 50, y: 160, width: frame.size.width - 50, height: 80))
//        textView.text = "Fill me in..."
//        textView.font = UIFont(name: "Avenir", size: 16)
//        textView.resignFirstResponder()
//        addSubview(textView)
//        
//        postButton = UIButton(frame: CGRect(x: 0, y: 240, width: 100, height: 40))
//        postButton.center.x = frame.size.width / 2
//        postButton.setTitle("POST", for: UIControlState())
//        postButton.backgroundColor = mainBlueColor
//        postButton.layer.cornerRadius = 5
//        addSubview(postButton)
//        
//        for _ in 0..<starCount {
//            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
//            button.setImage(emptyStarImage, for: UIControlState())
//            button.setImage(filledStarImage, for: .selected)
//            button.setImage(filledStarImage, for: [.highlighted, .selected])
//            button.adjustsImageWhenHighlighted = false
//            button.addTarget(self, action: #selector(RatingAlert.ratingButtonTapped), for: .touchDown)
//            ratingButtons += [button]
//            ratingView.addSubview(button)
//        }
//    }
//    
//    override func layoutSubviews() {
//        var buttonFrame = CGRect(x: 0, y: 0, width: 25, height: 25)
//        
//        for (index, button) in ratingButtons.enumerated() {
//            buttonFrame.origin.x = CGFloat(index * (25 + spacing))
//            button.frame = buttonFrame
//        }
//        
//        updateButtonSelectionStates()
//    }
//    
//    override var intrinsicContentSize : CGSize {
//        return CGSize(width: frame.size.width, height: 25)
//    }
//    
//    func ratingButtonTapped(_ button: UIButton) {
//        rating = ratingButtons.index(of: button)! + 1
//        print(rating)
//        moodText.text = moodArr[rating - 1]
//        imageView.image = UIImage(named: imageArr[rating - 1])
//        updateButtonSelectionStates()
//    }
//    
//    func updateButtonSelectionStates() {
//        for (index, button) in ratingButtons.enumerated() {
//            // If the index of a button is less than the rating, that button should be selected.
//            button.isSelected = index < rating
//        }
//    }
//    
//}
