//
//  Search.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 14/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class Search: UIView {

    @IBOutlet var popularBloggersScroll: UIScrollView!
    @IBOutlet var PopularItinerariesScroll: UIScrollView!
    @IBOutlet weak var popularJourneyScroll: UIScrollView!
    
    var horizontalScrollItinerary:HorizontalLayout!
    var horizontalScrollBlogger:HorizontalLayout!
    var horizontalScrollJourney:HorizontalLayout!
    var element: SearchElement!
    var data: JSON = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
           }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "Search", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        self.horizontalScrollItinerary = HorizontalLayout(height: PopularItinerariesScroll.frame.height)
        self.PopularItinerariesScroll.addSubview(horizontalScrollItinerary)
        
        self.horizontalScrollBlogger = HorizontalLayout(height: popularBloggersScroll.frame.height)
        self.popularBloggersScroll.addSubview(horizontalScrollBlogger)

        self.horizontalScrollJourney = HorizontalLayout(height: popularJourneyScroll.frame.height)
        self.popularJourneyScroll.addSubview(horizontalScrollJourney)

    }
    
    func setData() {
        request.getHomePage(completion: {(request) in
            DispatchQueue.main.async(execute: {

            self.data = request["data"]
            self.setItinerary(data: self.data["itinerary"])
                self.setJourney(data: self.data["journey"])
                self.setBloggers(data: self.data["user"])
            })
        })
    }
    
    func setItinerary(data: JSON) {
        for iti in data {
            
            element = SearchElement(frame: CGRect(x: 5, y: 0, width: 171, height: 150))
            element.imageLable.text = iti.1["name"].stringValue
            element.image.hnk_setImageFromURL(getImageURL(iti.1["coverPhoto"].stringValue, width: 200))
            horizontalScrollItinerary.addSubview(element)
        }
        
        self.horizontalScrollItinerary.layoutSubviews()
        self.PopularItinerariesScroll.contentSize = CGSize(width: self.horizontalScrollItinerary.frame.width, height: self.horizontalScrollItinerary.frame.height)
        
    }
    
    func setJourney(data: JSON) {
         for iti in data {
        element = SearchElement(frame: CGRect(x: 5, y: 0, width: 171, height: 150))
            element.imageLable.text = iti.1["name"].stringValue
            element.image.hnk_setImageFromURL(getImageURL(iti.1["startLocationPic"].stringValue, width: 200))
            
        horizontalScrollJourney.addSubview(element)
        }
        
        self.horizontalScrollJourney.layoutSubviews()
        self.popularJourneyScroll.contentSize = CGSize(width: self.horizontalScrollJourney.frame.width, height: self.horizontalScrollJourney.frame.height)
        
    }
    
    func setBloggers(data: JSON) {
        for iti in data {
        element = SearchElement(frame: CGRect(x: 5, y: 0, width: 171, height: 150))
            element.imageLable.text = iti.1["name"].stringValue
            element.image.hnk_setImageFromURL(getImageURL(iti.1["profilePicture"].stringValue, width: 200))

        horizontalScrollBlogger.addSubview(element)
        }
        
        self.horizontalScrollBlogger.layoutSubviews()
        self.PopularItinerariesScroll.contentSize = CGSize(width: self.popularBloggersScroll.frame.width, height: self.horizontalScrollBlogger.frame.height)
        
    }


}
