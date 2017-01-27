//
//  AddRatingCountries.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 16/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster

class AddRatingCountries: UIView, UITextViewDelegate {
    
    var ratingIndex = 0
    var starCount = 0
    
    @IBOutlet weak var starsStack: UIStackView!
    @IBOutlet weak var postReview: UIButton!
    @IBOutlet weak var reviewConclusion: UILabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet var stars: [UIButton]!
    @IBOutlet weak var smiley: UIButton!
    
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryCount: UILabel!
    
    let moodArr = ["Disappointed", "Sad", "Good", "Super", "In Love"]
    let imageArr = ["disapointed", "sad", "good", "superface", "love"]
    let parent = EndJourneyViewController()
    var countryVisitedData: JSON!
    var journeyData: JSON!
    var i = 3
    var backgroundSuperview: UIView!
    
    
    var endJourney:EndJourneyViewController!
    
    @IBAction func postReviewTapped(_ sender: AnyObject) {
        
        let journeyId = sender.title(for: .application)!
        let countryId = sender.title(for: .disabled)!
        
        var reviewText = ""
        
        if reviewTextView.text != nil && reviewTextView.text != "Fill Me In..." {
            reviewText = reviewTextView.text
        }
        
        reviewTextView.resignFirstResponder()
        self.countryVisitedData["rating"] = JSON(self.starCount)
        self.countryVisitedData["rating"] = JSON(self.starCount)
        self.journeyData["review"].arrayObject?.append(self.countryVisitedData.object)
        self.parent.checkView(newcountry: journeyData)
        
        endJourney.newJson[self.tag]["rating"] = JSON(starCount)
        endJourney.newJson[self.tag]["review"] = JSON(reviewTextView.text)
        endJourney.createReview()
        self.removeFromSuperview()
        
        
        request.rateCountry(currentUser["_id"].string!, journeyId: journeyData["_id"].stringValue, countryId: countryId, rating: "\(starCount)", review: reviewText, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    let tstr = Toast(text: "You rated \(self.countryName.text!) as \(self.reviewConclusion.text!)")
                    tstr.show()
                    
                }
                else {
                    let tstr = Toast(text: "Enable to rate \(self.countryName.text!). try again later!!!")
                    tstr.show()
                    print("response error!")
                    
                }
                
            })
            
        })
        
    }
    
    func updateSmiley(point:Int) {

        ratingIndex = point
        reviewConclusion.text = moodArr[point - 1]
        smiley.setImage(UIImage(named: imageArr[point - 1]), for: UIControlState())
        updateButtonSelectionStates()
        
    }
    
    func getRatingData(data: JSON) {
        
        if data.count > 0 {
            self.reviewTextView.text = ""
            self.smiley.setImage(UIImage(named: imageArr[0]), for: .normal)
            reviewConclusion.text = moodArr[0]
            for star in stars {
                star.isSelected = false
                star.isHighlighted = false
            }
            stars[0].isSelected = true
            self.countryCount.text = "\(i)/\(data.count) Countries Reviewed"
            self.countryName.text = data[i - 1]["country"]["name"].string!
            self.postReview.setTitle(journeyData["_id"].string!, for: .application)
            self.postReview.setTitle(data[i - 1]["country"]["_id"].string!, for: .disabled)
            let imageURL = "\(adminUrl)upload/readFile?file=\(data[i - 1]["country"]["flag"].string!)"
            DispatchQueue.main.async(execute: {
                do {
                    let data = try? Data(contentsOf: URL(string: imageURL)!)
                    self.countryImage.image = UIImage(data: data!)
                }
            })
//            view.postReviewTapped(view.postReview)
//            if data.count > num {
            
//            } else {
//                view.postReview.superview?.superview?.removeFromSuperview()
//            }
        } else {
            // do nothing
        }
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
            star.addTarget(self, action: #selector(AddRatingCountries.ratingButtonTapped), for: .touchDown)
        }
        stars[0].isSelected = true
        
        //        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
        let nib = UINib(nibName: "AddRatingCountries", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func ratingButtonTapped(_ button: UIButton) {
        print("rating button tapped")
        ratingIndex = stars.index(of: button)! + 1
        reviewConclusion.text = moodArr[ratingIndex - 1]
        smiley.setImage(UIImage(named: imageArr[ratingIndex - 1]), for: UIControlState())
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates() {
        print("in update states")
        starCount = 0
        for (index, button) in stars.enumerated() {
            button.isSelected = index < ratingIndex
            if button.isSelected {
                
                starCount += 1
                
            }
        }
    }
    
}

