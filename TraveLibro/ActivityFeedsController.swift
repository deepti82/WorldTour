//
//  ActivityFeedsController.swift
//  TraveLibro
//
//  Created by Jagruti  on 17/01/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import Foundation

var globalActivityFeedsController:ActivityFeedsController!


class ActivityFeedsController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityScroll: UIScrollView!
    var layout: VerticalLayout!
    var feeds: JSON! = []
    var pageno = 1
    var loadStatus: Bool = true
    var mainFooter: FooterViewNew!
    var displayData: String = "activity"
    var loader = LoadingOverlay()
    var uploadingView:UploadingToCloud!
    var noInternet: UploadingToCloud!
    var checkpoint = true
    var refreshControl = UIRefreshControl()
    var isRefreshing = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in did load")
        
        refreshControl.addTarget(self, action: #selector(ActivityFeedsController.refresh(_:)), for: .valueChanged)
        let attributes = [NSForegroundColorAttributeName: UIColor.white]
        let attributedTitle = NSAttributedString(string: "Pull To Refresh", attributes: attributes)
        refreshControl.attributedTitle = attributedTitle
        refreshControl.tintColor = lightOrangeColor
        activityScroll.addSubview(refreshControl)

        
        createNavigation()
        globalActivityFeedsController = self
        activityScroll.delegate = self
        getDarkBackGround(self)
        layout = VerticalLayout(width: screenWidth)
        activityScroll.addSubview(layout)
        getActivity(pageNumber: pageno)
        loader.showOverlay(self.view)
        
        print("Chintan");
        
        self.mainFooter = FooterViewNew(frame: CGRect.zero)
        self.mainFooter.layer.zPosition = 5
        self.view.addSubview(self.mainFooter)
        mainFooter.activityImage.tintColor = mainOrangeColor
        mainFooter.activityOrange.textColor = mainOrangeColor
        
        let i = PostImage()
        i.uploadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainFooter.frame = CGRect(x: 0, y: self.view.frame.height - 65, width: self.view.frame.width, height: 65)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(globalActivityFeedsController.NCnote(_:)), name: NSNotification.Name(rawValue: "UPLOAD_ITINERARY"), object: nil)
        globalNavigationController = self.navigationController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayData = "activity"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func refresh(_ sender: AnyObject) {
        isRefreshing = true
        getActivity(pageNumber: pageno)
    }

    
    func NCnote(_ notification: Notification) {
        print("notification called")
        if currentUser != nil{
            displayData = "activity"
            getActivity(pageNumber: 1)
        }
    }
    
    func openSideMenu(_ sender: AnyObject) {
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.toggleLeft()
    }
    
    func createNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        if displayData == "activity" {
            self.title = "Activity Feed"
        }else if displayData == "popular"{
            self.title = "Popular Journeys"
        }else if displayData == "popitinerary" {
            self.title = "Popular Itineraries"
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
        rightButton.addTarget(self, action: #selector(self.searchTapped(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if displayData != "popular" && displayData != "popitinerary" {
            self.customNavigationBar(left: leftButton, right: rightButton)
            
        }else{
            self.customNavigationBar(left: leftButton, right: nil)
            
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getActivity(pageNumber: Int) {
        print("notification called \(displayData)")
        print("Page Number : \(pageNumber)")
        if checkpoint {
            checkpoint = false
        }
        if displayData == "activity" {
            print("in activity")            
            self.loadStatus = false
            
//            if pageNumber == 13 {
            showBottomLoader(onView: self.view)
                request.getActivityFeeds(currentUser["_id"].stringValue, pageNumber: pageNumber, completion: {(request, localLifeJsons,quickJsons) in
                    DispatchQueue.main.async(execute: {
                        hideBottomLoader()
                        NSLog(" check Response received \(request)")
                        

                        if self.isRefreshing {
                            self.refreshControl.endRefreshing()
                            self.isRefreshing = false

                        if pageNumber == 1 {
                            self.layout.removeAll()

                        }
                        }
                        for var post in quickJsons {
                            
                            self.loader.hideOverlayView()
                            self.feeds.arrayObject?.append(post)
                            post["user"] = ["name":currentUser["name"].stringValue, "profilePicture":currentUser["profilePicture"].stringValue]
                            post["offline"] = true
                            let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                            checkIn.feeds = post
                            checkIn.scrollView = self.activityScroll
                            checkIn.createProfileHeader(feed: post)
                            checkIn.activityFeed = self
                            self.uploadingView = UploadingToCloud(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 23))
                            self.uploadingView.uploadText.text = "Uploading to My Life."
                            self.uploadingView.backgroundColor = endJourneyColor
                            
                            self.layout.addSubview(checkIn)
                            self.layout.addSubview(self.uploadingView)
                            self.addHeightToLayout()
                            
                        }
                        
                        for var post in localLifeJsons {
                            self.loader.hideOverlayView()
                            self.feeds.arrayObject?.append(post)
                            
                            print("ininininin  \(currentUser)")
                            post["user"] = ["name":currentUser["name"].stringValue, "profilePicture":currentUser["profilePicture"].stringValue]
                            post["offline"] = true
                            let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                            checkIn.feeds = post
                            print("post post : \(post)")
                            checkIn.scrollView = self.activityScroll
                            checkIn.createProfileHeader(feed: post)
                            checkIn.activityFeed = self
                            
                            self.uploadingView = UploadingToCloud(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 23))
                            self.uploadingView.backView.backgroundColor = endJourneyColor
                            self.uploadingView.uploadText.textColor = mainBlueColor
                            self.layout.addSubview(checkIn)
                            self.layout.addSubview(self.uploadingView)
                            
                            self.addHeightToLayout()
                            
                        }

                        
                        
                        if !(request["data"].isEmpty) {
                           
                            self.loadStatus = true
                            print("responseActivity\(request["data"])")
                            
                            
                            for post in request["data"].array! {
                                NSLog(" check 1 \n")
                                self.loader.hideOverlayView()
                                self.feeds.arrayObject?.append(post)
                                let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                                checkIn.feeds = post
                                checkIn.scrollView = self.activityScroll
                                //                                print("\n\n\n POST ::: \n \(post) \n\n\n")
                                checkIn.createProfileHeader(feed: post)
                                checkIn.activityFeed = self
                                self.layout.addSubview(checkIn)
                                self.addHeightToLayout()
                                NSLog(" check 2 \n")
                            }

                            
                            if isConnectedToNetwork() {
                                NSLog(" check started building actual layout \n")
                                NSLog(" check done building actual layout \n")
                            }else{
                                print("no in internet")
                                self.loader.hideOverlayView()
                                self.noInternet = UploadingToCloud(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 23))
                                self.noInternet.uploadText.text = "No Internet Connection"
                                self.view.addSubview(self.noInternet)
                            }
                            
                            self.addHeightToLayout()
                        }
                        else{
                            //                        self.loadStatus = false
                            self.loader.hideOverlayView()
                        }                       
                        
                    })
                })
//            }
            
        }
        else if displayData == "popular" {
            let userr = User()
            
            request.getPopularJourney(userId: userr.getExistingUser(), pagenumber: pageNumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
                    if !(request["data"].isEmpty) {
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
//                        self.loadStatus = false
                    }
                })
            })
            
        }
        else if displayData == "popitinerary" {
            let userr = User()
            
            request.getPopularItinerary(userId: userr.getExistingUser(), pagenumber: pageNumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
                    if !(request["data"].isEmpty) {
                        self.loadStatus = true
                        for post in request["data"].array! {
                            self.feeds.arrayObject?.append(post)
                            let checkIn = ActivityFeedsLayout(width: self.view.frame.width)
                            checkIn.displayData = self.displayData
                            checkIn.feeds = post
                            checkIn.scrollView = self.activityScroll
                            checkIn.createProfileHeader(feed: post)
                            checkIn.activityFeed = self
                            self.layout.addSubview(checkIn)
                            self.addHeightToLayout()
                            
                        }
                        
                        self.addHeightToLayout()
                    }else{
//                        self.loadStatus = false
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
                    if !(request["data"].isEmpty) {
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
//                        self.loadStatus = false
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
        if isConnectedToNetwork() {
            if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
                if loadStatus {
                    print("in load more of data.")
                    pageno = pageno + 1
                    getActivity(pageNumber: pageno)
                }
            }
        }else{
            print("no in internet")
            if noInternet == nil {
                self.noInternet = UploadingToCloud(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 23))
                self.view.addSubview(self.noInternet)

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
        
        
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            hideHeaderAndFooter(true);
        }
        else{
            hideHeaderAndFooter(false);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideHeaderAndFooter(_ isShow:Bool) {
        if(isShow) {
            //            scrollTopConstraint.constant = 0
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            if self.noInternet != nil {
                noInternet.isHidden = true
            }
            
            self.mainFooter.frame.origin.y = self.view.frame.height + 95
        } else {
            //            scrollTopConstraint.constant = (self.navigationController?.navigationBar.frame.size.height)!
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            if self.noInternet != nil {
                noInternet.isHidden = false
            }
            
            self.mainFooter.frame.origin.y = self.view.frame.height - 65
            
        }
    }
    
    
}
