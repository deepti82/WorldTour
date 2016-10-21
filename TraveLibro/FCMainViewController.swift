//
//  FCMainViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import PageMenu

var nvcTwo: UINavigationController!


class FCMainViewController: UIViewController, CAPSPageMenuDelegate {
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extendedLayoutIncludesOpaqueBars = false
//        self.edgesForExtendedLayout = UIRectEdge(rawValue: 0)
        
//        self.setNavigationBarItem()
        let orangeColor = UIColor(red: 252/255, green: 80/255, blue: 71/255, alpha: 1)
        let blueColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
        print("inside the main, nvc: \(self.navigationController)")
        
        nvcTwo = self.navigationController
        
        // Array to keep track of controllers in page menu
        var controllerArray : [UIViewController] = []
        
        // Create variables for all view controllers you want to put in the
        // page menu, initialize them, and add each to the controller array.
        // (Can be any UIViewController subclass)
        // Make sure the title property of all view controllers is set
        // Example:
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "featuredTwo") as! FeaturedCitiesNewTwoViewController
        controller.whichView = "FC"
        controller.title = "Featured Cities"
        controllerArray.append(controller)
        
        let controllerTwo = storyboard!.instantiateViewController(withIdentifier: "featuredTwo") as! FeaturedCitiesNewTwoViewController
        controllerTwo.whichView = "MD"
        controllerTwo.title = "Must Do's"
        controllerArray.append(controllerTwo)
        
        let controllerThree = storyboard!.instantiateViewController(withIdentifier: "featuredRest") as! FeaturedCitiesRestViewController
        controllerThree.whichView = "IT"
        controllerThree.title = "Itineraries"
        controllerArray.append(controllerThree)
        
        
        let controllerFour = storyboard!.instantiateViewController(withIdentifier: "featuredRest") as! FeaturedCitiesRestViewController
        controllerFour.whichView = "JO"
        controllerFour.title = "Journeys"
        controllerArray.append(controllerFour)
        
        let controllerFive = storyboard!.instantiateViewController(withIdentifier: "featuredRest") as! FeaturedCitiesRestViewController
        controllerFive.whichView = "AG"
        controllerFive.title = "Popular Agents"
        controllerArray.append(controllerFive)
        
        
        // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
        // Example:
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(false),
            .menuItemSeparatorPercentageHeight(0.1),
            .menuItemFont(UIFont(name: "Avenir-Roman", size: 14)!),
            .scrollMenuBackgroundColor(UIColor.white),
            .selectionIndicatorColor(orangeColor),
            .unselectedMenuItemLabelColor(blueColor),
            .selectedMenuItemLabelColor(blueColor),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .menuHeight(45.0)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60), pageMenuOptions: parameters)
        pageMenu!.viewBackgroundColor = blueColor
        pageMenu?.delegate = self
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
