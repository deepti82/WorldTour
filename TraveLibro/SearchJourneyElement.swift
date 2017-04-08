//
//  SearchJourneyElement.swift
//  TraveLibro
//
//  Created by Jagruti  on 15/03/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class SearchJourneyElement: UIView {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageLable: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var creatorPic: UIImageView!
    @IBOutlet weak var creatorName: UILabel!
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var dayText: UILabel!
    
    
    var index = ""
    var feeds:JSON = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
//        makeTLProfilePictureBorderWhite(creatorPic)
        makeTLProfilePictureFollowers(creatorPic)
        
//        let gradient = CAGradientLayer()
//        
//        let blackColour = UIColor.black.withAlphaComponent(0.8).cgColor as CGColor
//        let transparent = UIColor.clear.cgColor as CGColor
//        
//        gradient.frame = self.gradientView.bounds
//        gradient.frame.size.width = gradientView.frame.width + 40
//        gradient.colors = [transparent, blackColour]
//        gradient.locations = [0.0, 0.75]
//        
//        self.gradientView.layer.addSublayer(gradient)
        
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.addTarget(self, action: #selector(self.toggleFullscreen))
        self.image.addGestureRecognizer(tapRecognizer)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SearchJourneyElement", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func setData(data:JSON, tabs:String) {
        print("set data clicked")
        feeds = data
        index = tabs
        self.creatorName.text = data["journeyCreator"]["name"].stringValue
        self.creatorPic.hnk_setImageFromURL(getImageURL(data["journeyCreator"]["profilePicture"].stringValue, width: 300))
        self.days.text = data["duration"].stringValue
        if data["duration"].intValue > 1 {
            self.dayText.text = "Days"
        }else{
            self.dayText.text = "Day"
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.toggleFullscreen(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func toggleFullscreen(_ sender: AnyObject){
        print("clicked....")
        print(feeds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if index == "journey" {
            let controller = storyboard.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
            controller.fromOutSide = feeds["_id"].stringValue
            controller.fromType = feeds["type"].stringValue
            
            print(feeds["_id"])
            print(feeds["type"])
            
            globalNavigationController.pushViewController(controller, animated: true)
        }else if index == "user" {
            selectedPeople = feeds["_id"].stringValue
            selectedUser = feeds
            let profile = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
            profile.displayData = "search"
            profile.currentSelectedUser = selectedUser
            globalNavigationController.pushViewController(profile, animated: true)
        }else{
            if feeds["type"].stringValue == "quick-itinerary" {
                
                selectedQuickI = self.feeds["_id"].stringValue
                let profile = storyboard.instantiateViewController(withIdentifier: "previewQ") as! QuickItineraryPreviewViewController
                globalNavigationController.pushViewController(profile, animated: true)
                
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "EachItineraryViewController") as! EachItineraryViewController
                controller.fromOutSide = feeds["_id"].stringValue
                globalNavigationController?.setNavigationBarHidden(false, animated: false)
                globalNavigationController?.pushViewController(controller, animated: true)
            }
            
            
        }
        
        
    }

}
