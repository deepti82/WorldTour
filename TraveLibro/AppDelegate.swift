
import UIKit
import Contacts
import Simplicity

import TwitterKit
import SQLite
import EventKitUI

import OneSignal
import SystemConfiguration

import Haneke
let cache = Shared.dataCache


let contactsObject = CNContactStore()
let mainBlueColor = UIColor(hex: "#2c3757") // #232D4A
let mainGreyColor = UIColor(red: 42/255, green: 42/255, blue:42/255,alpha:1)
let lightGreyColor = UIColor(hex:"#868686")
let navBlueColor = UIColor(red: 21/255, green: 25/255, blue: 54/255, alpha: 1) // #151936
let mainOrangeColor = UIColor(red: 252/255, green: 103/255, blue: 89/255, alpha: 1) // #336759
let mainOrangeTransparentColor = UIColor(red: 252/255, green: 103/255, blue: 89/255, alpha: 0.9)
let lightOrangeColor = UIColor(red: 252/255, green: 103/255, blue: 89/255, alpha: 1) // #FC5047
let darkOrangeColor = UIColor(hex: "FF6759").cgColor
let mainGreenColor = UIColor(red: 75/255, green: 203/255, blue: 187/255, alpha: 1) // #4BCBBB
let endJourneyColor = UIColor(red: 87/255, green: 211/255, blue: 199/255, alpha: 1) // #57D3C7
let navGreen = UIColor(red: 17/255, green: 211/255, blue: 203/255, alpha: 1) // #11d3cb
let navBlue = UIColor(red: 44/255, green: 55/255, blue: 87/255, alpha: 1) // #2c3757
let navOrange = UIColor(red: 255/255, green: 103/255, blue: 89/255, alpha: 1) // #ff6759
let avenirFont = UIFont(name: "Avenir-Roman", size: 14)
let avenirBold = UIFont(name: "Avenir-Medium", size: 14)
let FontAwesomeFont = UIFont(name: "FontAwesome", size: 14)
let NAVIGATION_FONT = UIFont(name: "Avenir-Roman", size: 18)

var faicon = [String: UInt32]()
var profileViewY:CGFloat = 45
var whichView: String!
var emailIcon: String!
var whatsAppIcon: String!
var facebookIcon: String!
var loader = LoadingOverlay()
var feedViewController: UIViewController!
var notificationsViewController: UIViewController!
var travelLifeViewController: UIViewController!
var hasLoggedInOnce = false
var onlyOnce = true

let request = Navigation()
let shared = LoadingOverlay()
var coverImageGrid = ""

let user = User()

let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height

var kindOfJourney: [String] = []
var youUsuallyGo: String = ""
var preferToTravel: [String] = []
var yourIdeal: [String] = []
var travelConfig: [String: [String]] = [:]
var quickItinery: JSON = []
var selectedCountry: JSON = []
var selectedCity: JSON = []
var selectedStatus: String = ""
var destinationVisited: JSON = []
var journeyImages: [String] = []
var endJourneyState: Bool = true
var storyboard: UIStoryboard!
var addedBuddies: JSON = []
var globalPostImage:[PostImage] = []
var currentJourney:JSON = []
var selectedHash:String = ""
var selectedPeople:String = ""
var selectedQuickI:String = ""
var selectedDetail:String = ""
var whichJourney:String = ""
var jouurneyToShow:JSON = []


var leftViewController: SideNavigationMenuViewController!


let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

let HEADER_HEIGHT = CGFloat(55)
let FOOTER_HEIGHT = CGFloat(20)
let IMAGE_HEIGHT = (screenWidth * 0.20)
let TITLE_HEIGHT = 80
let BUTTON_HEIGHT = CGFloat(28)
let DETAILS_HEIGHT = CGFloat(50)
let TIME_HEIGHT = CGFloat(27)

let categoryImages = ["restaurant_checkin", "nature_checkin", "landmarks_checkin", "museums_landmarks", "adventure_icon", "aqua_checkin", "shopping", "beach_checkin", "cinema_checkin", "hotels-1", "planetrans", "reg", "othersdottrans", "city_icon", "health_beauty", "emergency", "essential", "entertainment"]

var globalNavigationController:UINavigationController!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UINavigationControllerDelegate {
    
    var window: UIWindow?
    
    static func getDatabase () -> Connection {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        let db = try! Connection("\(path)/db.sqlite3")
        if(onlyOnce)
        {
            onlyOnce = false
            print("database path: \(path)")
        }
        return db;
        
    }
    
    internal func createMenuView() {
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var nvc: UINavigationController!
        
        leftViewController = storyboard.instantiateViewController(withIdentifier: "sideMenu") as! SideNavigationMenuViewController
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        
//        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignUpOne") as! SignInViewController
        
        let nationality = storyboard.instantiateViewController(withIdentifier: "nationalityNew") as!AddNationalityNewViewController
        
        let PJController = storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
        PJController.displayData = "popular"
        
        leftViewController.mainViewController = nvc
        
        if user.getExistingUser() == "" {
            
            nvc = UINavigationController(rootViewController: PJController)
            
            let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
            
            self.window?.rootViewController = slideMenuController
            nvc.navigationBar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
            nvc.navigationBar.barStyle = .blackTranslucent
            nvc.navigationBar.isTranslucent = true
            nvc.delegate = self
            
//            globalNavigationController = nvc
            
        } 
        else {
            request.getUser(user.getExistingUser(), completion: {(request) in
                DispatchQueue.main.async {
                    currentUser = request["data"]
                    if request["data"]["alreadyLoggedIn"] == false {
                        nvc = UINavigationController(rootViewController: nationality)
                        
                        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
                        
                        self.window?.rootViewController = slideMenuController
                    } else{
                        
                        nvc = UINavigationController(rootViewController: mainViewController)
                        
                        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
                        
                        self.window?.rootViewController = slideMenuController
                    }
                    nvc.navigationBar.barTintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 0.1)
                    nvc.navigationBar.barStyle = .blackTranslucent
                    nvc.navigationBar.isTranslucent = true
                    nvc.delegate = self
                    
//                    globalNavigationController = nvc
                }
            })
        }
    }
    
    
    //MARK:- Application Delegates
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        createMenuView()
        _ = AppDelegate.getDatabase()
        
        
        
        UINavigationBar.appearance().backgroundColor = mainBlueColor
        UIBarButtonItem.appearance().tintColor = UIColor.white
        
//        UIButton.appearance().
        
//        OneSignal.initWithLaunchOptions(launchOptions, appId: "bf8baf0a-dcfb-4a30-a0c1-ee67cae2feb1")
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: "bf8baf0a-dcfb-4a30-a0c1-ee67cae2feb1", handleNotificationReceived:             { (notification) in
            let payload: OSNotificationPayload? = notification?.payload
            
            
            let fullMessage: String? = payload?.body
            
            print("Recived no" + fullMessage!)
            
            print("Received Notification - \(notification?.payload.notificationID) - \(notification?.payload.title)")
            
        }, handleNotificationAction: nil, settings: [kOSSettingsKeyAutoPrompt : false, kOSSettingsKeyInAppAlerts : false])
        faicon["magic"] = 0xf0d0
        faicon["clock"] = 0xf017
        faicon["calendar"] = 0xf073
        faicon["rocket"] = 0xf135
        faicon["videoPlay"] = 0xf16a
        faicon["likes"] = 0xf004
        faicon["reviews"] = 0xf234
        faicon["angle_up"] = 0xf106
        faicon["facebook"] = 0xf09a
        faicon["email"] = 0xf0e0
        faicon["envelop"] = 0xf003
        faicon["whatsapp"] = 0xf232
        faicon["check"] = 0xf00c
        faicon["trash"] = 0xf014
        faicon["close"] = 0xf00d
        faicon["next"] = 0xf105
        faicon["arrow-down"] = 0xf078
        faicon["options"] = 0xf142
        faicon["location"] = 0xf041
        faicon["bold"] = 0xf032
        faicon["italics"] = 0xf033
        faicon["emptyCircle"] = 0xf10c
        faicon["fullCircle"] = 0xf111
        faicon["edit"] = 0xf040
        faicon["twitterSquare"] = 0xf081
        faicon["fbSquare"] = 0xf082
        faicon["googleSquare"] = 0xf0d4
        faicon["comments"] = 0xf075
        faicon["upload"] = 0xf093
        faicon["bars"] = 0xf0c9
        faicon["travelibroVideo"] = 0xf144
        
        emailIcon = String(format: "%C", faicon["email"]!)
        facebookIcon = String(format: "%C", faicon["facebook"]!)
        whatsAppIcon = String(format: "%C", faicon["whatsapp"]!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showLoginView(notification:)), name: NSNotification.Name(rawValue: "NO_LOGGEDIN_USER_FOUND"), object: nil)
        
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.white
        pageController.currentPageIndicatorTintColor = mainBlueColor
        pageController.backgroundColor = UIColor.clear
        
        //        self.addObserver(self, forKeyPath: "profileViewY", options: .New, context: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = UITabBarController()
        let homeVC = storyboard.instantiateViewController(withIdentifier: "Home") as! HomeViewController
        let feedVC = storyboard.instantiateViewController(withIdentifier: "Activity") as! ProfilePostsViewController
        tabBarController.viewControllers = [homeVC, feedVC]
        //        window?.rootViewController = tabBarController
        
        let image = UIImage(named: "adventure_icon")
        
        feedVC.tabBarItem = UITabBarItem(title: "Feed", image: image, tag: 1)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        return Simplicity.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        var prevVC = UIViewController()
        if (navigationController.viewControllers.count > 1 ) {
            prevVC = navigationController.viewControllers[navigationController.viewControllers.count - 1]
            prevVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    
    //MARK: - Notification Observer
    
    func showLoginView(notification: Notification)  {
       
        var showpage = 2 
        
        if let info = notification.object as? Dictionary<String,Int> {
            if let s = info["type"] {
                showpage = s
            }
        }
        
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignUpOne") as! SignInViewController
        signInVC.showPage = showpage
        signInVC.shouldShowNavBar = true
        globalNavigationController.delegate = self
        globalNavigationController.pushViewController(signInVC, animated: true)
    }
    
}

func isConnectedToNetwork() -> Bool {
    
    var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
    if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
        return false
    }
    
    /* Only Working for WIFI
     let isReachable = flags == .reachable
     let needsConnection = flags == .connectionRequired
     
     return isReachable && !needsConnection
     */
    
    // Working for Cellular and WIFI
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    let ret = (isReachable && !needsConnection)
    
    return ret
}


func categoryImage(_ str: String) -> String {
    var retStr = ""
    switch str {
        
    case "adventure":
        retStr =  "adventure"
    case "backpacking":
        retStr =  "backpacking"
    case "business":
        retStr = "business_new"
    case "religious":
        retStr = "religious"
    case "romance":
        retStr = "romance_new"
    case "budget":
        retStr = "luxury"
    case "luxury":
        retStr = "luxury_new"
    case "family":
        retStr = "family"
    case "friends":
        retStr = "friends"
    case "solo":
        retStr = "solo"
    case "partner":
        retStr = "partner"
    case "colleague":
        retStr = "colleague"
    default:
        retStr = ""
    }
    return retStr
}



func addTopBorder(_ color: UIColor, view: UIView, borderWidth: CGFloat) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: borderWidth)
    view.layer.addSublayer(border)
}

