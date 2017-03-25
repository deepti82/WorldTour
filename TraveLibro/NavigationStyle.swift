import UIKit

var checkInMainVC: UIViewController!
var previousVC: UIViewController!
var nextVC: UIViewController!

var flag = 0

extension UIViewController {
    
    //MARK: - Nationality
    
    func gotoNationalityPage() {
        
        if currentUser["alreadyLoggedIn"].bool! {
            profileVC.initialEntrance = true
            self.slideMenuController()?.changeMainViewController(profileVC, close: true)
            navigation.pushViewController(profileVC, animated: true)
        } else {
            navigation.pushViewController(nationalityPage, animated: true)
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
        
        if (right != nil) {
            let rightBarButton = UIBarButtonItem()
            rightBarButton.customView = right as? UIView
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
    
    func customNavigationTextBar(left: UIButton?, right: AnyObject?, text: String) {
        
        customNavigationBar(left: left, right: right)
        
        self.title = text
        
//        let leftBarButton = UIBarButtonItem()
//        leftBarButton.customView = left
//        self.navigationItem.leftBarButtonItem = leftBarButton
//        
//        if (right != nil) {
//            let rightBarButton = UIBarButtonItem()
//            rightBarButton.customView = right as? UIView
//            self.navigationItem.rightBarButtonItem = rightBarButton
//        }        
//        
//        self.slideMenuController()?.removeLeftGestures()
//        self.slideMenuController()?.removeRightGestures()
        
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
    
//    func toProfile(id:String) {
//        selectedPeople = id
//        let profile = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
//        profile.displayData = "search"
//        globalNavigationController.pushViewController(profile, animated: true)
//    }
    
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
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : NAVIGATION_FONT!]
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        self.navigationController?.toolbar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    
    
    func removegestures() {
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
    }
}
