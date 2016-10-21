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
        searchBox.center = CGPoint(x: ForSearch.frame.width/2, y: ForSearch.frame.height/2)
        searchBox.leftLine.backgroundColor = UIColor.white
        searchBox.rightLine.backgroundColor = UIColor.white
        searchBox.bottomLine.backgroundColor = UIColor.white
        searchBox.searchButton.tintColor = UIColor.white
        searchBox.searchField.attributedPlaceholder  = NSAttributedString(string: "Search", attributes: [NSForegroundColorAttributeName: UIColor.white])
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
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FilterRestaurants", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

    func makeCurvedCorners(_ button: UIButton) -> Void {
        
        button.layer.cornerRadius = 5
        
    }
    
}
