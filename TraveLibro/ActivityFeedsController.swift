//
//  ActivityFeedsController.swift
//  TraveLibro
//
//  Created by Jagruti  on 17/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

var globalActivityFeedsController:ActivityFeedsController!


class ActivityFeedsController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var activityScroll: UIScrollView!
    var layout: VerticalLayout!
    var feeds: JSON! = []
    var pageno = 1
    var loadStatus: Bool = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigation()
        globalActivityFeedsController = self
        activityScroll.delegate = self
        getDarkBackGround(self)
        layout = VerticalLayout(width: screenWidth)
        activityScroll.addSubview(layout)
        getActivity(pageNumber: pageno)
    }
    
    func createNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Activity Feed"
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    func getActivity(pageNumber: Int) {
        print("yaaaho")
        print(pageNumber)
        request.getActivityFeeds(currentUser["_id"].stringValue, pageNumber: pageNumber, completion: {(request) in
            DispatchQueue.main.async(execute: {
                if request["data"] != "" {
                    self.loadStatus = true
                    for post in request["data"].array! {
                        self.feeds.arrayObject?.append(post)
                        let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                        checkIn.scrollView = self.activityScroll
                        checkIn.createProfileHeader(feed: post)
                        checkIn.activityFeed = self
                        self.layout.addSubview(checkIn)
                        self.addHeightToLayout()
                        
                    }
                    
                    self.addHeightToLayout()
                }else{
                    self.loadStatus = false
                }
            })
        })
    }
    
    func addHeightToLayout() {
        self.layout.layoutSubviews()
        self.activityScroll.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height + 60)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == (scrollView.contentSize.height - scrollView.frame.size.height) {
            if loadStatus {
                print("in load more of data.")
                getActivity(pageNumber: pageno + 1)
            }
            
        }
        
        for postView in layout.subviews {
            if(postView is ActivityFeedsLayout) {
                let feeds = postView as! ActivityFeedsLayout
                if(feeds.videoContainer != nil) {
                    feeds.videoToPlay()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
