//
//  AppDelegate.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 23/04/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Contacts

let contactsObject = CNContactStore()
let mainBlueColor = UIColor(red: 0.1725, green: 0.2175, blue: 0.3412, alpha: 1) // #2C3757
let mainOrangeColor = UIColor(red: 1, green: 0.408, blue: 0.345, alpha: 1) // #FF6858
let avenirFont = UIFont(name: "Avenir-Roman", size: 14)
let FontAwesomeFont = UIFont(name: "FontAwesome", size: 14)

var faicon = [String: UInt32]()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        faicon["clock"] = 0xf017
        faicon["calendar"] = 0xf073
        faicon["rocket"] = 0xf135
        faicon["videoPlay"] = 0xf16a
        faicon["likes"] = 0xf004
        faicon["reviews"] = 0xf234
        faicon["angle_up"] = 0xf106
        faicon["facebook"] = 0xf09a
        faicon["email"] = 0xf0e0
        faicon["whatsapp"] = 0xf232
        faicon["check"] = 0xf00c
        faicon["trash"] = 0xf014
        
        let pageController = UIPageControl.appearance()
        pageController.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageController.currentPageIndicatorTintColor = UIColor.blackColor()
        pageController.backgroundColor = UIColor.clearColor()
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

