//
//  TripPhotoHeader.swift
//  TraveLibro
//
//  Created by Jagruti  on 28/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class TripPhotoHeader: UIView {

    @IBOutlet weak var noOfDay: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeNow: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()


    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillProfileHeader(feed:JSON) {

        timeNow.text = changeDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ", getFormat: "dd-MM-yyyy", date: feed["createdAt"].stringValue, isDate: true)

    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TripPhotoHeader", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    
    func getDays(_ startDate: String, postDate: String) -> Int {
        
        let DFOne = DateFormatter()
        DFOne.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        let DFTwo = DateFormatter()
        
        DFTwo.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        
        let start = DFOne.date(from: startDate)
        let post = DFTwo.date(from: postDate)
        
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: start!)
        let date2 = calendar.startOfDay(for: post!)
        
        let flags = NSCalendar.Unit.day
        let components = (calendar as NSCalendar).components(flags, from: date1, to: date2, options: [])
        return components.day!
        
    }
    
    func changeDateFormat(_ givenFormat: String, getFormat: String, date: String, isDate: Bool) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = givenFormat
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = getFormat
        
        if isDate {
            
            dateFormatter.dateStyle = .medium
            
        }
        
        let goodDate = dateFormatter.string(from: date!)
        return goodDate
        
    }

}
