
//  QuickItineraryPreview.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 08/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItineraryPreview: UIView {

    @IBOutlet weak var qiView: UIView!
    @IBOutlet weak var countryScroll: UIScrollView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var displayPiture: UIImageView!
    @IBOutlet weak var quickTitle: UILabel!
    @IBOutlet weak var cityScroll: UITextView!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var quickDescription: UITextView!
    @IBOutlet weak var typeGroup: UIStackView!
    @IBOutlet var quickType: [UIImageView]!
    var horizontal: HorizontalLayout!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        
        self.qiView.layer.cornerRadius = 5
        self.qiView.clipsToBounds = true
        
        self.userPhoto.layer.cornerRadius = 20
        self.userPhoto.clipsToBounds = true
        
        
        horizontal = HorizontalLayout(height: self.countryScroll.frame.height)
        
        if quickItinery["countryVisited"].count != 0 {
            for n in quickItinery["countryVisited"].array! {
                let oneButton = UIButton(frame: CGRect(x: 10, y: 0, width: 200, height: self.countryScroll.frame.height))
                self.horizontal.addSubview(oneButton)
                //                self.styleHorizontalButton(oneButton, buttonTitle: "\(n["name"].string!)")
                
                
                oneButton.backgroundColor = UIColor.clear
                oneButton.titleLabel!.font = avenirFont
                oneButton.setTitle("\(n["name"].string!)", for: UIControlState())
                oneButton.setTitleColor(mainBlueColor, for: UIControlState())
                oneButton.layer.cornerRadius = 5
                oneButton.layer.borderColor = UIColor.darkGray.cgColor
                oneButton.layer.borderWidth = 1.0
                
                
                countryScroll.addSubview(horizontal)
                horizontal.layoutSubviews()
                self.countryScroll.contentSize = CGSize(width: self.horizontal.frame.width, height: self.horizontal.frame.height)                
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QuickItineraryPreview", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }

}
