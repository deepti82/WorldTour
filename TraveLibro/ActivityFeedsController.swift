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
        globalActivityFeedsController = self
        activityScroll.delegate = self
        getDarkBackGround(self)
        layout = VerticalLayout(width: screenWidth)
        activityScroll.addSubview(layout)
        getActivity(pageNumber: pageno)
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
    var blackBg: UIView!
    func feedLayoutRate(feed:JSON) {
        print("review clickedd")
        
        blackBg = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        blackBg.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ActivityFeedsController.closeDialog(_:)))
        blackBg.addGestureRecognizer(tapGestureRecognizer)
        self.view.addSubview(blackBg)
        
        let closeButton = UIButton(frame: CGRect(x: 8, y: 20, width: 20, height: 20))
        let close = String(format: "%C", faicon["close"]!)
        
        closeButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
        closeButton.setTitle(close, for: UIControlState())
        closeButton.addTarget(self, action: #selector(ActivityFeedsController.exitDialog(_:)), for: .touchUpInside)
        blackBg.addSubview(closeButton)
        
        let ratingDialog = AddRating(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 400))
        ratingDialog.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
        
        ratingDialog.postReview.addTarget(self, action: #selector(ActivityFeedsController.closeDialog(_:)), for: .touchUpInside)
        blackBg.addSubview(ratingDialog)
    }
    
    func closeDialog(_ sender: AnyObject) {
        
        blackBg.isHidden = true
        //        checkInPost.rateButton.isHidden = true
        //        checkInPost.ratingLabel.isHidden = false
        //        checkInPost.ratingStack.isHidden = false
        
    }
    
    func exitDialog(_ sender: AnyObject) {
        
        blackBg.isHidden = true
        //        checkInPost.rateButton.isHidden = true
        //        checkInPost.ratingLabel.isHidden = false
        //        checkInPost.ratingStack.isHidden = false
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
