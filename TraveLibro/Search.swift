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
    var loader = LoadingOverlay()
    var horizontalScrollItinerary:HorizontalLayout!
    var horizontalScrollBlogger:HorizontalLayout!
    var horizontalScrollJourney:HorizontalLayout!
    var element: SearchElement!
    var elementJourney: SearchJourneyElement!
    var data: JSON = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
        popularJourneyScroll.contentSize.width = 1000
        popularJourneyScroll.isScrollEnabled = true
        PopularItinerariesScroll.isScrollEnabled = true
        popularBloggersScroll.isScrollEnabled = true
        PopularItinerariesScroll.contentSize = CGSize(width: 2000, height: 0)
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
                globalMainSearchViewController.closeLoader()
                self.setItinerary(data: self.data["itinerary"])
                self.setJourney(data: self.data["journey"])
                self.setBloggers(data: self.data["user"])
            })
        })
    }
    
    func setItinerary(data: JSON) {
        for (i, iti) in data {
            var xco = 4
            if i == "0" {
                xco = 0
            }
            
            element = SearchElement(frame: CGRect(x: xco, y: 0, width: 165, height: 220))
            element.imageLable.text = iti["name"].stringValue
            
            element.image.hnk_setImageFromURL(getImageURL(iti["coverPhoto"].stringValue, width: 300))
            element.setData(data: iti, tabs: "itinerary")
            
            horizontalScrollItinerary.addSubview(element)
        }
        
        self.horizontalScrollItinerary.layoutSubviews()
        self.PopularItinerariesScroll.contentSize = CGSize(width: self.horizontalScrollItinerary.frame.width, height: self.horizontalScrollItinerary.frame.height)
        
    }
    
    func setJourney(data: JSON) {
        print("journey journey \(data)")
        for (i, iti) in data {
            var xco = 4
            if i == "0" {
                xco = 0
            }
            elementJourney = SearchJourneyElement(frame: CGRect(x: 0, y: 0, width: Int(globalSearchViewController.view.frame.width), height: 220))
            elementJourney.imageLable.text = iti["name"].stringValue
            elementJourney.image.hnk_setImageFromURL(getImageURL(iti["coverPhoto"].stringValue, width: 300))
            elementJourney.setData(data: iti, tabs: "journey")
            horizontalScrollJourney.addSubview(elementJourney)
        }
        
        self.horizontalScrollJourney.layoutSubviews()
        self.popularJourneyScroll.contentSize = CGSize(width: self.horizontalScrollJourney.frame.width, height: self.horizontalScrollJourney.frame.height)
        
    }
    
    func setBloggers(data: JSON) {
        for (i, iti) in data {
            var xco = 4
            if i == "0" {
                xco = 0
            }
            element = SearchElement(frame: CGRect(x: xco, y: 0, width: 165, height: 220))
            element.imageLable.text = iti["name"].stringValue
            element.image.hnk_setImageFromURL(getImageURL(iti["profilePicture"].stringValue, width: 300))
            element.setData(data: iti, tabs: "user")
            horizontalScrollBlogger.addSubview(element)
        }
        
        self.horizontalScrollBlogger.layoutSubviews()
        self.popularBloggersScroll.contentSize = CGSize(width: self.horizontalScrollBlogger.frame.width, height: self.horizontalScrollBlogger.frame.height)
        
    }
    
    @IBAction func toJourney(_ sender: UIButton) {
        let profile = storyboard.instantiateViewController(withIdentifier: "popular") as! PopularController
        profile.displayData = "popular"
        profile.back = true
        globalNavigationController.pushViewController(profile, animated: true)
    }
    @IBAction func toItinerary(_ sender: UIButton) {
        let profile = storyboard.instantiateViewController(withIdentifier: "popular") as! PopularController
        profile.displayData = "popitinerary"
        profile.back = true
        globalNavigationController.pushViewController(profile, animated: true)
    }
    @IBAction func toBloggers(_ sender: UIButton) {
        let profile = storyboard.instantiateViewController(withIdentifier: "popularBloggers") as! PopularBloggersViewController
        profile.back = true
        globalNavigationController.pushViewController(profile, animated: true)
    }
    
}
