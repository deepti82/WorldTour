//
//  PopularBloggersViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 13/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster
import Foundation

class PopularBloggersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableTopConstraint: NSLayoutConstraint!
    var allUsers: [JSON] = []
    var pagenum = 1
    var loader = LoadingOverlay()
    var hasNext = true
    let refreshControl = UIRefreshControl()
    var mainFooter: FooterViewNew!
    var back: Bool = false
    
    @IBOutlet weak var userTableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if back {
            createNavigation()
        }else{
            self.setTopNavigation("Popular Bloggers")
        }
        
        getDarkBackGround(self)
        
        loader.showOverlay(self.view)
        
        self.mainFooter = FooterViewNew(frame: CGRect.zero)
        self.mainFooter.layer.zPosition = 5
        self.view.addSubview(self.mainFooter)
        
        refreshControl.addTarget(self, action: #selector(PopularBloggersViewController.pullToRefreshCalled), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = lightOrangeColor
        userTableView.addSubview(refreshControl)
        
        getPopulerUser(pageNum : pagenum )
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Helpers
    
    func pullToRefreshCalled() {        
        pagenum = 1
        getPopulerUser(pageNum: pagenum)
    }
    
    
    //MARK: - GetUsers
    func getPopulerUser(pageNum : Int) {
        
        print("\n Fetching popular users from page : \(pageNum)")
        
        request.getPopularUsers(pagenumber: pageNum) { (response) in
            
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                
                if response.error != nil {                    
                    print("error: \(response.error!.localizedDescription)")
                    self.refreshControl.endRefreshing()
                }
                    
                else if response["value"].bool! {
                    
                    if self.refreshControl.isRefreshing {
                        self.allUsers = []
                        self.refreshControl.endRefreshing()
                    }
                    
                    let newResponse = response["data"].array!
                    
                    if newResponse.isEmpty {
                        self.hasNext = false
                    }
                    
                    if self.allUsers.isEmpty {
                        self.allUsers = newResponse
                        if newResponse.isEmpty {
                            Toast(text: "No bloggers....").show()
                        }
                    }
                    else {                        
                        self.allUsers.append(contentsOf: newResponse)
                    }
                    
                    if !(newResponse.isEmpty) {
                        self.userTableView.reloadData()                            
                    }                        
                }
                    
                else {                    
                    print("response error!")
                    self.refreshControl.endRefreshing()                    
                }
                
            })
            
        }
        
    }
    
    
    //MARK: - Tableview Delegates and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allUsers.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(screenHeight)
        let tableh = screenHeight
        let h = (tableh / 2) - 50
        return h
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell") as! PopularBloggerTableViewCell
        cell.followButton.layer.cornerRadius = 5
        cell.followButton.layer.borderColor = UIColor.white.cgColor
        cell.followButton.layer.borderWidth = 1.5
        cell.followButton.clipsToBounds = true
        
        let cellData = allUsers[indexPath.row]        
        cell.userIcon.image = UIImage(named:"logo-default")
        cell.userIcon.hnk_setImageFromURL(getImageURL("\(adminUrl)upload/readFile?file=\(cellData["profilePicture"].stringValue)", width: SMALL_PHOTO_WIDTH))

        cell.userName.text = cellData["name"].stringValue

        cell.photoCountLabel.text = cellData["photos_count"].stringValue
        cell.videoCountLabel.text = cellData["videos_count"].stringValue

        cell.countryVisitedCountLabel.text = cellData["countriesVisited_count"].stringValue
        cell.journeyCountLabel.text = cellData["journeysCreated_count"].stringValue
        cell.followerCountLabel.text = cellData["followers_count"].stringValue

        cell.userBadgeImage.image = UIImage(named:"\(cellData["userBadgeName"].stringValue.lowercased())blogger")
        print("iiiiiiii \(cellData["userBadgeName"].stringValue.lowercased())")
        
        switch cellData["userBadgeName"].stringValue.lowercased() {
        case "justgotWings":
            cell.starWidth.constant = cell.starWidth.constant + 50
        case "globetrotter":
            cell.starWidth.constant = cell.starWidth.constant + 40
        default:
            cell.starWidth.constant = cell.starWidth.constant
        }

        if(currentUser != nil) {
            cell.followButton.tag = indexPath.row
            setFollowButtonTitle(button: cell.followButton, followType: cellData["following"].intValue, otherUserID: cellData["_id"].stringValue)
        }
        else {
            cell.followButton.setTitle("Follow", for: .normal)
        }
        cell.followButton.sizeToFit()

        return cell
        
    }

    func setTopNavigation(_ text: String) {
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
        self.title = text
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        
    }

    
    func openSideMenu(_ sender: UIButton){
        
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.toggleLeft()
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
                
        if allUsers.count > 0 && indexPath.row == (allUsers.count - 1) {            
            if hasNext {
                getPopulerUser(pageNum: (pagenum + 1))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentUser != nil {
            selectedPeople = allUsers[indexPath.row]["_id"].stringValue
            selectedUser = allUsers[indexPath.row]
            let profile = self.storyboard!.instantiateViewController(withIdentifier: "TLProfileView") as! TLProfileViewController
            profile.displayData = "search"
            profile.currentSelectedUser = selectedUser
            self.navigationController!.pushViewController(profile, animated: true)            
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
    
    
    //MARK: - Follow Action
    
    @IBAction func followButtonClicked(_ sender: UIButton) {
        
        if currentUser != nil {
            if sender.titleLabel?.text == "Follow" {
                request.followUser(currentUser["_id"].string!, followUserId: allUsers[sender.tag]["_id"].stringValue, completion: {(response) in                
                    DispatchQueue.main.async(execute: {
                        
                        
                        if response.error != nil {
                            print("error: \(response.error!.localizedDescription)")
                        }
                        else if response["value"].bool! {
                            setFollowButtonTitle(button: sender, followType: response["data"]["responseValue"].intValue, otherUserID: "")
                        }
                        else {
                            print("error: \(response["error"])")
                        }
                    })
                })
            }
            else{
                request.unfollow(currentUser["_id"].string!, unFollowId: allUsers[sender.tag]["_id"].stringValue, completion: {(response) in
                    DispatchQueue.main.async(execute: {
                        if response.error != nil {
                            print("error: \(response.error!.localizedDescription)")
                        }
                        else if response["value"].bool! {
                            setFollowButtonTitle(button: sender, followType: response["data"]["responseValue"].intValue, otherUserID: "")
                        }
                        else {                            
                            print("error: \(response["error"])")
                        }
                    })
                })
            }            
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)            
        }        
    }    
    
    //MARK: - Scroll Delagtes
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            hideHeaderAndFooter(true);
        }
        else{
            hideHeaderAndFooter(false);
        }
        
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
    
    func createNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}


class PopularBloggerTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var cellBackgroundView: UIView!
//    @IBOutlet weak var titleTag: UIView!
//    @IBOutlet weak var cameraIcon: UIImageView!
//    @IBOutlet weak var videoIcon: UIImageView!
//    @IBOutlet weak var locationIcon: UIImageView!
//    
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var videoCountLabel: UILabel!
    @IBOutlet weak var starWidth: NSLayoutConstraint!
//    @IBOutlet weak var bucketListCount: UILabel!
//    
    @IBOutlet weak var countryVisitedCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var journeyCountLabel: UILabel!
//
    @IBOutlet weak var userBadgeImage: UIImageView!
//
    @IBOutlet weak var followButton: UIButton!
}
