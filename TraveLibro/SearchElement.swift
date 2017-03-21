//
//  SearchElement.swift
//  TraveLibro
//
//  Created by Jagruti  on 24/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class SearchElement: UIView {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageLable: UILabel!
    @IBOutlet weak var gradientView: UIView!
    var index = ""
    var feeds:JSON = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        
        let gradient = CAGradientLayer()
        
        let blackColour = UIColor.black.withAlphaComponent(0.8).cgColor as CGColor
        let transparent = UIColor.clear.cgColor as CGColor
        
        gradient.frame = self.gradientView.bounds
        gradient.frame.size.width = gradientView.frame.width + 15
        gradient.colors = [transparent, blackColour]
        gradient.locations = [0.0, 0.90]
        
        self.gradientView.layer.addSublayer(gradient)
        
        
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
        let nib = UINib(nibName: "SearchElement", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func setData(data:JSON, tabs:String) {
        print("set data clicked")
        feeds = data
        index = tabs
        
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
                globalNavigationController?.setNavigationBarHidden(false, animated: true)
                globalNavigationController?.pushViewController(controller, animated: true)
            }
            
            
        }
        
        
    }
}
