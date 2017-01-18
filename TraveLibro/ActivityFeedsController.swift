//
//  ActivityFeedsController.swift
//  TraveLibro
//
//  Created by Jagruti  on 17/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityFeedsController: UIViewController {

    @IBOutlet weak var activityScroll: UIScrollView!
    var layout: VerticalLayout!
    var feeds: JSON!

    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        layout = VerticalLayout(width: screenWidth )
        activityScroll.addSubview(layout)
        getActivity(pageNumber: 1)
    }
    
    func getActivity(pageNumber: Int) {
        request.getActivityFeeds(currentUser["_id"].stringValue, pageNumber: pageNumber, completion: {(request) in
            DispatchQueue.main.async(execute: {

            self.feeds = request["data"]
            for post in self.feeds.array! {
                let checkIn = feedsLayout(width: self.view.frame.width)
                checkIn.createProfileHeader(feed: post)
                checkIn.activityFeed = self
                self.layout.addSubview(checkIn)
                
            }
            self.addHeightToLayout()
            })
        })
    }
    
    func addHeightToLayout() {
        self.layout.layoutSubviews()
        self.activityScroll.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
