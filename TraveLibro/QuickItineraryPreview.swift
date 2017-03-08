
//  QuickItineraryPreview.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 08/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItineraryPreview: UIView {

    @IBOutlet weak var quickTypeThree: UIImageView!
    @IBOutlet weak var quickTypeTwo: UIImageView!
    @IBOutlet weak var quickTypeOne: UIImageView!
    @IBOutlet weak var qiView: UIView!
    @IBOutlet weak var countryScroll: UIScrollView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var displayPiture: UIImageView!
    @IBOutlet weak var quickTitle: UILabel!
    @IBOutlet weak var dateTime: UILabel!
    @IBOutlet weak var quickDescription: UITextView!
    @IBOutlet weak var typeGroup: UIStackView!
    @IBOutlet var quickType: [UIImageView]!
    var horizontal: HorizontalLayout!
    var cityScroll:UILabel!
    @IBOutlet weak var cityScroller: UIScrollView!
    var json:JSON!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        
        self.qiView.layer.cornerRadius = 5
        self.qiView.clipsToBounds = true
        
        HiBye(userPhoto)
        self.userPhoto.clipsToBounds = true
        quickTypeOne.tintColor = UIColor.white
        quickTypeTwo.tintColor = UIColor.white
        quickTypeThree.tintColor = UIColor.white
        qiView.layer.zPosition = 100
        horizontal = HorizontalLayout(height: self.countryScroll.frame.height)
        countryScroll.addSubview(horizontal)
        if quickItinery["countryVisited"].count != 0 {
            for n in quickItinery["countryVisited"].array! {
                let oneButton = UIButton(frame: CGRect(x: 10, y: 0, width: 200, height: self.countryScroll.frame.height))
                oneButton.backgroundColor = UIColor.clear
                oneButton.titleLabel!.font = avenirFont
                if n["name"] != nil {
                    oneButton.setTitle("\(n["name"].string!)", for: UIControlState())
                }else{
                    oneButton.setTitle("\(n["country"]["name"].string!)", for: UIControlState())
                }
                oneButton.setTitleColor(mainBlueColor, for: UIControlState())
                oneButton.layer.cornerRadius = 5
                oneButton.layer.borderColor = UIColor.darkGray.cgColor
                oneButton.layer.borderWidth = 1.0
                oneButton.titleLabel?.sizeToFit()
                oneButton.frame.size.width = (oneButton.titleLabel?.frame.size.width)! + 20
                self.horizontal.addSubview(oneButton)
            }
            horizontal.layoutSubviews()
            self.countryScroll.contentSize = CGSize(width: self.horizontal.frame.width, height: self.horizontal.frame.height)
        }
    }
    
    func generateCity () {

        self.cityScroll = UILabel(frame: CGRect(x: 0, y: 10, width: 1000, height: cityScroller.frame.height))
        self.cityScroll.text = ""
        self.cityScroll.font = UIFont(name: "Avenir-Roman", size: 16)
        if self.json["countryVisited"].count != 0 {
            for n in json["countryVisited"].array! {
                for (i,m) in n["cityVisited"] {
                    if m["name"] != nil {
                        self.cityScroll.text = self.cityScroll.text! + m["name"].stringValue + " | "

                    }else{
                        self.cityScroll.text = self.cityScroll.text! + m["city"]["name"].stringValue + " | "

                    }
                }
            }
            var name = self.cityScroll.text
            name = name?.substring(to: (name?.index(before: (name?.endIndex)!))!)
            name = name?.substring(to: (name?.index(before: (name?.endIndex)!))!)
            name = name?.substring(to: (name?.index(before: (name?.endIndex)!))!)
            self.cityScroll.text = name
            self.cityScroll.sizeToFit()
            self.cityScroller.addSubview(self.cityScroll)
            //            self.cityScroll.frame.size.width = 1000
            self.cityScroller.contentSize = CGSize(width: self.cityScroll.frame.size.width, height: self.cityScroller.frame.height)
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
