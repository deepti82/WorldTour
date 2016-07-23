//
//  FilterItineraries.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 10/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FilterItineraries: UIView {

    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet var stackButtons: [UIButton]!
    
    @IBOutlet var categoryButtons: [UIButton]!
    
    @IBOutlet var placeButtons: [UIButton]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let search = SearchFieldView(frame: CGRect(x: 0, y: 0, width: searchView.frame.width, height: searchView.frame.height))
        search.searchField.placeholder = "Search a city"
        search.leftLine.backgroundColor = UIColor.whiteColor()
        search.rightLine.backgroundColor = UIColor.whiteColor()
        search.bottomLine.backgroundColor = UIColor.whiteColor()
        search.searchButton.tintColor = UIColor.whiteColor()
        searchView.addSubview(search)
        
        search.backgroundColor = UIColor.clearColor()
        
//        let blurBackground = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
//        blurBackground.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.bounds
        blurView.layer.zPosition = -1
        blurView.userInteractionEnabled = false
        self.addSubview(blurView)
        
        doneButton.layer.cornerRadius = 5
        
        for button in stackButtons {
            
            button.tintColor = UIColor.whiteColor()
            
        }
        
        for button in categoryButtons {
            
            button.layer.cornerRadius = 5
            
        }
        
        for button in placeButtons {
            
            let check = UIImageView(frame: CGRect(x: -25, y: 0, width: 20, height: 20))
            check.image = UIImage(named: "checkbox_empty")
            button.titleLabel?.addSubview(check)
            check.tag = 1
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FilterItineraries", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

}
