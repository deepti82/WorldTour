//
//  PopularController.swift
//  TraveLibro
//
//  Created by Jagruti  on 18/03/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
var globalPopularController: PopularController!
class PopularController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var popularScroll: UIScrollView!
    var layout: VerticalLayout!
    var feeds: JSON! = []
    var pageno = 1
    var loadStatus: Bool = true
    var mainFooter: FooterViewNew!
    var displayData: String = "activity"
    var loader = LoadingOverlay()
    var uploadingView:UploadingToCloud!
    var checkpoint = true
    var back:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("in did load")
        
        if displayData == "activity" {
            self.title = "Activity Feed"
        }else if displayData == "popular"{
            self.title = "Popular Journeys"
        }else if displayData == "popitinerary" {
            self.title = "Popular Itineraries"
        }else{
            self.title = selectedHash
        }
        
        if back {
            createNavigationBack()
        }else{
            createNavigation()
        }
        globalPopularController = self
        popularScroll.delegate = self
        getDarkBackGround(self)
        layout = VerticalLayout(width: screenWidth)
        popularScroll.addSubview(layout)
        getActivity(pageNumber: pageno)
        loader.showOverlay(self.view)
        
        self.mainFooter = FooterViewNew(frame: CGRect.zero)
        self.mainFooter.layer.zPosition = 5
        self.view.addSubview(self.mainFooter)
        
        let i = PostImage()
        i.uploadPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainFooter.frame = CGRect(x: 0, y: self.view.frame.height - MAIN_FOOTER_HEIGHT, width: self.view.frame.width, height: MAIN_FOOTER_HEIGHT)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalNavigationController = self.navigationController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideHeaderAndFooter(false)
        displayData = "activity"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }    
    
    func demonote(_ notification: Notification) {
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
        
    func createNavigationBack() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func createNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
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
            self.customNavigationBar(left: leftButton, right: rightButton)
            
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getActivity(pageNumber: Int) {
        print("notification called \(displayData)")
        if checkpoint {
            checkpoint = false
        }
        
        if displayData == "popular" {
            let userr = User()
            self.loadStatus = false
            request.getPopularJourney(userId: userr.getExistingUser(), pagenumber: pageNumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
                    if !(request["data"].isEmpty) {
                        self.loadStatus = true
                        for post in request["data"].array! {
                            print("\n CellData :: type : \(post["type"].stringValue)")
                            
                            self.feeds.arrayObject?.append(post)
                            let checkIn = PopularLayout(width: self.view.frame.width)
                            checkIn.feeds = post
                            checkIn.scrollView = self.popularScroll
                            checkIn.createProfileHeader(feed: post)
                            checkIn.popular = self
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
            self.loadStatus = false
            request.getPopularItinerary(userId: userr.getExistingUser(), pagenumber: pageNumber, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    self.loader.hideOverlayView()
                    if !(request["data"].isEmpty) {
                        self.loadStatus = true
                        for post in request["data"].array! {
                            self.feeds.arrayObject?.append(post)
                            let checkIn = PopularLayout(width: self.view.frame.width)
                            checkIn.displayData = self.displayData
                            checkIn.feeds = post
                            checkIn.scrollView = self.popularScroll
                            checkIn.createProfileHeader(feed: post)
                            checkIn.popular = self
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
        self.popularScroll.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height + 60)
        
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
            self.navigationController?.setNavigationBarHidden(true, animated: true)            
            self.mainFooter.frame.origin.y = self.view.frame.height + MAIN_FOOTER_HEIGHT
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)           
            self.mainFooter.frame.origin.y = self.view.frame.height - MAIN_FOOTER_HEIGHT
        }
    }


}
