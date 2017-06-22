import UIKit

var checkInMainVC: UIViewController!
var previousVC: UIViewController!
var nextVC: UIViewController!

var flag = 0

extension UIViewController {
    
    //MARK: - Nationality
    
    func gotoNationalityPage() {
            
        if currentUser["alreadyLoggedIn"].bool! {
            globalNavigationController?.pushViewController(profileVC, animated: true)
        } else {
            globalNavigationController?.pushViewController(nationalityPage, animated: true)
        }
    }
    
    func gotoActivityController(lat:String?, lng:String?, category:String?) {
        if currentUser != nil {
            request.getUserFromCache(user.getExistingUser(), completion: { (response) in
                DispatchQueue.main.async {
                    popularView = "activity"
                    currentUser = response["data"]
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "TLMainFeedsView") as! TLMainFeedsViewController
                    vc.pageType = viewType.VIEW_TYPE_ACTIVITY
                    if lat != nil {
                        vc.currentLocation = ["lat":lat!, "long":lng!]                        
                    }
                    if category != nil {
                        vc.currentCategory = category!
                        vc.pageType = viewType.VIEW_TYPE_LOCAL_LIFE
                    }
                    
                    let nvc = UINavigationController(rootViewController: vc)
                    leftViewController.mainViewController = nvc
                    leftViewController.slideMenuController()?.changeMainViewController(leftViewController.mainViewController, close: true)
                    
                    UIViewController().customiseNavigation()
                    nvc.delegate = UIApplication.shared.delegate as! UINavigationControllerDelegate?
                }
            })
        }
    }
    
    
    //MARK: - Set Navigation bar
    
    func setNavigationBarItem() {
        
        self.customiseNavigation()
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.removegestures()
    }
    
    func setNavigationBarItemText(_ text:String) {
        
        customiseNavigation()
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.removegestures()
        self.navigationController?.navigationBar.topItem!.title = text
        
    }
    
    func customNavigationBar(left: UIButton?, right: AnyObject?) {
        
        customiseNavigation()
        
        if let ryt = right as? UIButton {
            ryt.contentHorizontalAlignment = .right
        }
        
        if left != nil {
            let leftBarButton = UIBarButtonItem()
            leftBarButton.customView = left
            self.navigationItem.leftBarButtonItem = leftBarButton
        }
        else {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        if (right != nil) {
            let rightBarButton = UIBarButtonItem()
            rightBarButton.customView = right as? UIView
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        else{
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func customNavigationTextBar(left: UIButton?, right: AnyObject?, text: String) {
        
        customNavigationBar(left: left, right: right)
        
        self.title = text
    }
    
    func setOnlyRightNavigationButton(_ button: UIButton) {
        
        self.setNavigationBarItem()
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = button
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        //        self.slideMenuController()?.addRightGestures()
        
    }
    
    func setTransperentNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.toolbar.barTintColor = UIColor.clear
    }
    
    func nextController(_ sender: UIBarButtonItem) -> () {
        self.navigationController?.pushViewController(checkInMainVC, animated: true)
    }
    
    func setForwardController(_ sender: AnyObject?) {
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func setBackwardController(_ sender: AnyObject?) {
        self.navigationController?.pushViewController(previousVC, animated: true)
    }
    
    func popVC(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func callBackViewC() {
        self.navigationController!.popViewController(animated: true)
    }
    
    
    //MARK: - Remove NavigationItems
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    
    //MARK: - Customize navigationbar
    
    func customiseNavigation() {
        
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: NAVIGATION_FONT!, NSForegroundColorAttributeName: UIColor.white]        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        self.navigationController?.toolbar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        self.navigationController?.navigationBar.isTranslucent = false
        
        if shouldShowTransperentNavBar {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.3, blue: 0.5, alpha: 0)
            self.navigationController?.navigationBar.barTintColor = UIColor.clear
            self.navigationController?.toolbar.barTintColor = UIColor.clear
        }
    }
    
    func removegestures() {
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
    
    
    //MARK: - BarButton Actions
    
    func searchTapped(_ sender: UIButton){
        if currentUser != nil {
            let searchVC = storyboard?.instantiateViewController(withIdentifier: "Search") as! MainSearchViewController
            globalNavigationController.pushViewController(searchVC, animated: true)
        }
        else {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        }
    }
}
