//
//  Rating.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class Rating: UIView {
    
    @IBOutlet weak var corneRadiusView: UIView!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var checkInTitle: UILabel!
    @IBOutlet weak var reviewDescription: UILabel!
    @IBOutlet var stars: [UIImageView]!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var upLine: drawLine!
   
    let border = CALayer()
    var lines = 0
    var textViewHeight: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        upLine.backgroundColor = UIColor.clear
        
        calendarIcon.text = String(format: "%C", faicon["calendar"]!)
        clockIcon.text = String(format: "%C", faicon["clock"]!)
        
    
        corneRadiusView.layer.cornerRadius = 10
        corneRadiusView.layer.masksToBounds = true
        
        let width = CGFloat(2)
        border.frame = CGRect(x: 0, y: corneRadiusView.frame.size.height - width, width:  corneRadiusView.frame.size.width, height: corneRadiusView.frame.size.height)
        border.borderColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
        border.borderWidth = width
        corneRadiusView.layer.addSublayer(border)
        

       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Rating", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
    }

}
