//
//  ActivityFeedsController.swift
//  TraveLibro
//
//  Created by Jagruti  on 17/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class ActivityFeedsController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var activityScroll: UIScrollView!
    var layout: VerticalLayout!
    var feeds: JSON! = []
    var pageno = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        activityScroll.delegate = self
        getDarkBackGround(self)
        layout = VerticalLayout(width: screenWidth )
        activityScroll.addSubview(layout)
        getActivity(pageNumber: pageno)
    }
    
    func getActivity(pageNumber: Int) {
        request.getActivityFeeds(currentUser["_id"].stringValue, pageNumber: pageNumber, completion: {(request) in
            DispatchQueue.main.async(execute: {

            for post in request["data"].array! {
                self.feeds.arrayObject?.append(post)
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == (scrollView.contentSize.height - scrollView.frame.size.height) {
            print("in load more of data.")
            getActivity(pageNumber: pageno + 1)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
