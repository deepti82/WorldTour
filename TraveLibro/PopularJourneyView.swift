//
//  PopularJourneysView.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PopularJourneyView: UIView {

    @IBOutlet weak var follow: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mainPhoto: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var flag3: UIImageView!
    @IBOutlet weak var flag2: UIImageView!
    @IBOutlet weak var flag1: UIImageView!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var TitleLabelView: UIView!
    
    @IBAction func followButton(_ sender: AnyObject) {
        
        follow.setTitle("Following", for: UIControlState())
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        
        flag3.layer.cornerRadius = self.flag3.frame.size.height/2
        flag3.clipsToBounds = true
        flag3.layer.borderColor = UIColor.white.cgColor
        flag3.layer.borderWidth = CGFloat(1.5)
        
        flag2.layer.cornerRadius = self.flag2.frame.size.height/2
        flag2.clipsToBounds = true
        flag2.layer.borderColor = UIColor.white.cgColor
        flag2.layer.borderWidth = CGFloat(1.5)
        
        flag1.layer.cornerRadius = self.flag1.frame.size.height/2
        flag1.clipsToBounds = true
        flag1.layer.borderColor = UIColor.white.cgColor
        flag1.layer.borderWidth = CGFloat(1.5)
        
        calendarLabel.text = String(format: "%C", faicon["calendar"]!)
        clockLabel.text = String(format: "%C", faicon["clock"]!)
        likeLabel.text = String(format: "%C", faicon["likes"]!)
        
        TitleLabelView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        mainPhoto.layer.zPosition = -10
        
        cardView.layer.cornerRadius = 5
        //cardView.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PopularJourneyView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
