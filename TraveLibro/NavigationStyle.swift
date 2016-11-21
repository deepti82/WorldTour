import UIKit

var checkInMainVC: UIViewController!
var previousVC: UIViewController!
var nextVC: UIViewController!

var flag = 0

extension UIViewController {
    
    func gotoNationalityPage() {
        
        print("inside nationality function")
        
        //        let tempStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let nationalityPage = self.storyboard!.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
        //        print("nationality: \(nationalityPage)")
        //        nationalityPage.whichView = "selectNationality"
        //        self.navigationController?.pushViewController(nationalityPage, animated: true)
                print("navigation: \(self.storyboard)")
        //        print("navigation: \(self.navigationController)")
        
        if currentUser["alreadyLoggedIn"].bool! {
            
            print("storyboard: \(navigation)")
            
            //            profileVC.initialEntrance = true
            //            self.slideMenuController()?.changeMainViewController(profileVC, close: true)
            navigation.pushViewController(profileVC, animated: true)
            
        }
        else {
            
            //            print("nationality: \(nationalityPage)")
            //            nationalityPage.whichView = "selectNationality"
            navigation.pushViewController(nationalityPage, animated: true)
            
        }
        
    }
    
    func setNavigationBarItem() {
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : avenirFont!]
        
//        self.navigationController?.navigationBar.translucent = false
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.navigationController?.toolbar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
//        self.navigationController?.navigationBar.translucent = false
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
        
        
//        let logo = UIImage(named: "ic_action_panther.png")
//        let imageView = UIImageView(image:logo)
        
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        imageView.frame = CGRectMake(0,14,50,50);
//        
//        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
//        imageView.center.x  = screenSize.width/2
//        self.navigationController?.view.addSubview(imageView)
    }
    
    func setNavigationBarItemText(_ text:String) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : avenirFont!]
        self.navigationController?.navigationBar.isTranslucent = true
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.navigationController?.toolbar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.5)
        self.navigationController?.navigationBar.barStyle = .black
//        self.navigationController?.navigationBar.translucent = false
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.addRightGestures()
        
        self.navigationController?.navigationBar.topItem!.title = text;
        
    }
    
    func removeNavigationBarItem() {
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        
    }
    
    func setCheckInNavigationBarItem (_ viewController: UIViewController) {
        
        removeNavigationBarItem()
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : avenirFont!]
        
        checkInMainVC = viewController
        
        print("storyboard: \(self.navigationController)")
        
        let closeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        closeImage.image = UIImage(named: "close_fa")
        
        let nextImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        nextImage.image = UIImage(named: "arrow_next_fa")
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.toolbar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let leftButton = UIBarButtonItem(image: closeImage.image, style: .plain, target: self, action: #selector(UIViewController.closeController(_:)))
        leftButton.imageInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let rightButton = UIBarButtonItem(image: nextImage.image, style: .plain, target: self, action: #selector(UIViewController.nextController(_:)))
        rightButton.imageInsets = UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10)
        
        self.navigationItem.setLeftBarButton(leftButton, animated: true)
        self.navigationItem.setRightBarButton(rightButton, animated: true)
        
    }
    
    func setCheckInMainNavigationBarItem (_ viewController: UIViewController) {
        
        removeNavigationBarItem()
        
        let nextImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        nextImage.image = UIImage(named: "arrow_next_fa")
        
        checkInMainVC = viewController
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.toolbar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
//        self.navigationController?.navigationBar.translucent = false
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "arrow_next_fa"), style: .plain, target: self, action: #selector(UIViewController.nextController(_:)))
        rightButton.imageInsets = UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10)
        self.navigationItem.setRightBarButton(rightButton, animated: true)
        
    }
    
    func addBlurEffect() {
        
        if flag == 0 {
            
            print("inside blur view")
            // Add blur view
            let bounds = self.navigationController?.navigationBar.bounds as CGRect!
            let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light)) as UIVisualEffectView
            visualEffectView.frame = bounds!
            visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.navigationController?.navigationBar.addSubview(visualEffectView)
            flag = 1
            
            // Here you can add visual effects to any UIView control.
            // Replace custom view with navigation bar in above code to add effects to custom view.
        }
    }
    
    func customNavigationBar(left: UIButton?, right: UIButton?) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.toolbar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.5)
//        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor().colorWithAlphaComponent(0.1)
//        self.navigationController?.view.backgroundColor = UIColor.clearColor()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        addBlurEffect()
//            UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
        
//        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.barStyle = .black
//        self.navigationController?.navigationBar.translucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 18)!]
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = left
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = right
        
//        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: UIImage(named: "add_fa_icon"), style: .Plain, target: self, action: #selector(UIViewController.setForwardController(_:))), animated: true)
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
//        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(image: UIImage(named: "arrow_next_fa"), style: .Plain, target: self, action: #selector(UIViewController.setBackwardController(_:))), animated: true)
//        self.navigationController?.toolbar.barTintColor = mainBlueColor
//        self.navigationController?.navigationBar.barTintColor = mainBlueColor
//        self.navigationController?.navigationBar.barStyle = .Black
//        
//        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: UIImage(named: "arrow_next_fa"), style: .Plain, target: self, action: #selector(UIViewController.setBackwardController(_:))), animated: true)
//        self.navigationController?.toolbar.barTintColor = mainBlueColor
//        self.navigationController?.navigationBar.barTintColor = mainBlueColor
//        self.navigationController?.navigationBar.barStyle = .Black
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        
    }
    
    func setOnlyRightNavigationButton(_ button: UIButton) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 18)!]
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.navigationController?.toolbar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.5)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.5)
        self.navigationController?.navigationBar.barStyle = .black
//        self.navigationController?.navigationBar.translucent = false
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = button
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
        self.slideMenuController()?.addLeftGestures()
//        self.slideMenuController()?.addRightGestures()
        
    }
    
    func setOnlyLeftNavigationButton(_ button: UIButton) {
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName : UIFont(name: "Avenir-Medium", size: 18)!]
        
//        self.addLeftBarButtonWithImage(UIImage(named: "menu_left_icon")!)
        self.navigationController?.toolbar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.5)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.5)
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.translucent = false
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = button
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        //self.addRightBarButtonWithImage(UIImage(named: "ic_notifications_black_24dp")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
//        self.slideMenuController()?.addLeftGestures()
        //        self.slideMenuController()?.addRightGestures()
        
    }
    
    func closeController(_ sender: UIBarButtonItem) -> () {
        
        print("close controller called")
        
        let allVCs = self.navigationController?.viewControllers
        print("all VCS: \(allVCs)")
        let checkInVC = allVCs![(allVCs?.count)! - 2]
        print("checkin vc: \(checkInVC)")
        
        self.navigationController!.popToViewController(checkInVC, animated: true)
        
    }
    
    func nextController(_ sender: UIBarButtonItem) -> () {
        
        print("next view controller called")
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
    
    func setFooterTabBar(_ vc: UIViewController) {
        
        let footer = getFooter(frame: CGRect(x: 0, y: vc.view.frame.height - 45, width: vc.view.frame.width, height: 45))
        vc.view.addSubview(footer)
        footer.layer.zPosition = 100
        
        self.tabBarItem.title = "Feed"
        
    }
}
