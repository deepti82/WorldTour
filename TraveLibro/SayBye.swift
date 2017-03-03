//
//  SayBye.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 17/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SayBye: UIView {

    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var line: drawLine!
    @IBOutlet weak var byeImage: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var clockTime: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
//        textView.backgroundColor = mainBlueColor
        textView.layer.cornerRadius = 23.5
        
    
        textView.clipsToBounds = true
        line.backgroundColor = UIColor.clear
        calendarIcon.text = String(format: "%C", faicon["calendar"]!)
       clockIcon.text = String(format: "%C", faicon["clock"]!)
//
        clockTime.shadowColor = UIColor.black
        clockTime.shadowOffset = CGSize(width: 1, height: 1)
        //        journeyName.layer.shadowOpacity = 0.
        clockTime.layer.masksToBounds = true

        
        clockTime.layer.shadowRadius = 1.0
        
        timestamp.shadowColor = UIColor.black
        timestamp.shadowOffset = CGSize(width: 1, height: 1)
        //        journeyName.layer.shadowOpacity = 0.
        timestamp.layer.masksToBounds = true

       
        timestamp.layer.shadowRadius = 1.0

//        timestamp.textColor = UIColor(red: 105/255, green: 147/255, blue: 171/255, alpha: 1)
//       profileImageView.layer.cornerRadius = 35
//        profileImageView.layer.zPosition = 2
//        byeImage.layer.zPosition = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SayBye", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
