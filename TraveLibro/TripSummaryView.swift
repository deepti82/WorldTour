//
//  TripSummaryView.swift
//  TraveLibro
//
//  Created by Jagruti  on 13/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import Haneke

class TripSummaryView: UIView {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var tripDate: UILabel!
    @IBOutlet weak var tripDays: UILabel!
    @IBOutlet weak var likes: UILabel!
    var allData: JSON = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        setAll()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TripSummaryView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    
    func setAll() {
        self.profilePic.layer.cornerRadius = 10
        self.profilePic.clipsToBounds = true

        self.profilePic.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(allData["user"]["profilePicture"])")!)
        self.profileName.text! = allData["user"]["name"].stringValue
    }
}
