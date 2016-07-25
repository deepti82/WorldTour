//
//  FilterRestaurants.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FilterRestaurants: UIView {

    @IBOutlet weak var veganButton: UIButton!
    @IBOutlet weak var nonVegButton: UIButton!
    @IBOutlet weak var vegButton: UIButton!
    @IBOutlet weak var AllButton: UIButton!
    @IBOutlet weak var ForSearch: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        let searchBox = SearchFieldView(frame: CGRect(x: 0, y: 0, width: ForSearch.frame.width, height: 60))
        searchBox.center = CGPointMake(ForSearch.frame.width/2, ForSearch.frame.height/2)
        searchBox.leftLine.backgroundColor = UIColor.whiteColor()
        searchBox.rightLine.backgroundColor = UIColor.whiteColor()
        searchBox.bottomLine.backgroundColor = UIColor.whiteColor()
        searchBox.searchButton.tintColor = UIColor.whiteColor()
        searchBox.searchField.attributedPlaceholder  = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        ForSearch.addSubview(searchBox)
        
        makeCurvedCorners(veganButton)
        makeCurvedCorners(vegButton)
        makeCurvedCorners(nonVegButton)
        makeCurvedCorners(AllButton)
//        makeCurvedCorners(doneButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FilterRestaurants", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }

    func makeCurvedCorners(button: UIButton) -> Void {
        
        button.layer.cornerRadius = 5
        
    }
    
}
