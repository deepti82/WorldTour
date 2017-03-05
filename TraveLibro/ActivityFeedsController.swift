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
    
    @IBOutlet weak var scrollTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityScroll: UIScrollView!
    var layout: VerticalLayout!
    var feeds: JSON! = []
    var pageno = 1
    var loadStatus: Bool = true
    var mainFooter: FooterViewNew!
    var displayData: String = ""
    var loader = LoadingOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigation()
        globalActivityFeedsController = self
        activityScroll.delegate = self
        getDarkBackGround(self)
        layout = VerticalLayout(width: screenWidth)
        activityScroll.addSubview(layout)
        getActivity(pageNumber: pageno)
        loader.showOverlay(self.view)
        
        if displayData != "popular" && displayData != "popitinerary" {
            self.mainFooter = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 65, width: self.view.frame.width, height: 65))
            self.mainFooter.layer.zPosition = 5
            self.view.addSubview(self.mainFooter)
        }
        
        
        let i = PostImage()
        i.uploadPhotos()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalNavigationController = self.navigationController
    }
    
    func openSideMenu(_ sender: AnyObject) {
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.toggleLeft()
    }
    func searchTop(_ sender: AnyObject) {
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        globalNavigationController.pushViewController(searchVC, animated: true)
    }
    func createNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if displayData == "activity" {
            self.title = "Activity Feed"
        }else if displayData == "popular"{
            self.title = "Popular Journeys"
        }else if displayData == "popitinerary" {
            self.title = "Popular Itinerary"
        }else{
            self.title = selectedHash

        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "menu_left_icon"), for: UIControlState())
        leftButton.imageView?.image = leftButton.imageView?.image!.withRenderingMode(.alwaysTemplate)
        leftButton.imageView?.tintColor = UIColor.white
        leftButton.addTarget(self, action: #selector(self.openSideMenu(_:)), for: .touchUpInside)
        
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "search_toolbar"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(self.searchTop(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if displayData != "popular" && displayData != "popitinerary" {
            self.customNavigationBar(left: leftButton, right: rightButton)

        }else{
            self.customNavigationBar(left: leftButton, right: nil)

        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    func getActivity(pageNumber: Int) {

        if displayData == "activity" {
            print("in activity")
            request.getActivityFeeds(currentUser["_id"].stringValue, pageNumber: pageNumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    if request["data"] != "" {
                        self.loadStatus = true
                        
                        for post in request["quickItinerary"].array! {
                            
                            self.loader.hideOverlayView()
                            self.feeds.arrayObject?.append(post)
                            let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                            checkIn.feeds = post
                            checkIn.scrollView = self.activityScroll
                            checkIn.createProfileHeader(feed: post)
                            checkIn.activityFeed = self
                            self.layout.addSubview(checkIn)
                            self.addHeightToLayout()
                            
                        }
                        
                        for post in request["localLife"].array! {
                            self.loader.hideOverlayView()
                            self.feeds.arrayObject?.append(post)
                            let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                            checkIn.feeds = post
                            checkIn.scrollView = self.activityScroll
                            checkIn.createProfileHeader(feed: post)
                            checkIn.activityFeed = self
                            self.layout.addSubview(checkIn)
                            self.addHeightToLayout()
                            
                        }
                        
                        for post in request["data"].array! {
                             self.loader.hideOverlayView()
                            self.feeds.arrayObject?.append(post)
                            let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                            checkIn.feeds = post
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
        else if displayData == "popular" {
            let userr = User()

            request.getPopularJourney(userId: userr.getExistingUser(), pagenumber: pageNumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
                    if request["data"] != "" {
                        self.loadStatus = true
                        for post in request["data"].array! {
                            self.feeds.arrayObject?.append(post)
                            let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                            checkIn.feeds = post
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
        else if displayData == "popitinerary" {
            let userr = User()
            
            request.getPopularItinerary(userId: userr.getExistingUser(), pagenumber: pageNumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
                    if request["data"] != "" {
                        self.loadStatus = true
                        for post in request["data"].array! {
                            self.feeds.arrayObject?.append(post)
                            let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                            checkIn.feeds = post
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
        else{
            print("in hash clicked")
            let userr = User()
            request.getHashData(userr.getExistingUser(), pageNumber: pageNumber, search: selectedHash, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
                    if request["data"] != "" {
                        self.loadStatus = true
                        for post in request["data"].array! {
                            self.feeds.arrayObject?.append(post)
                            let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                            checkIn.feeds = post
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
        
        
    }
    
    func addHeightToLayout() {
        self.layout.layoutSubviews()
        self.activityScroll.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height + 60)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            if loadStatus {
                print("in load more of data.")
                pageno = pageno + 1
                getActivity(pageNumber: pageno)
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
        
        if displayData != "popular" && displayData != "popitinerary" {
            if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
                hideHeaderAndFooter(true);
            }
            else{
                hideHeaderAndFooter(false);
            }

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideHeaderAndFooter(_ isShow:Bool) {
        if(isShow) {
            scrollTopConstraint.constant = 0
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)

            self.mainFooter.frame.origin.y = self.view.frame.height + 95
        } else {
            scrollTopConstraint.constant = (self.navigationController?.navigationBar.frame.size.height)!
            
            self.navigationController?.setNavigationBarHidden(false, animated: true)

            self.mainFooter.frame.origin.y = self.view.frame.height - 65

        }
    }
    
    
}
