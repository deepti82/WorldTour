//
//  EachCityPagerViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 22/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import PageMenu

class EachCityPagerViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let orangeColor = UIColor(red: 252/255, green: 80/255, blue: 71/255, alpha: 1)
        let blueColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
        
        nvcTwo = self.navigationController
        
        var controllerArray : [UIViewController] = []
        
        let controllerOne = storyboard!.instantiateViewControllerWithIdentifier("featuredTwo") as! FeaturedCitiesNewTwoViewController
        controllerOne.whichView = "MD"
        controllerOne.title = "Must Do's"
        controllerArray.append(controllerOne)
        
        let controllerThree = storyboard!.instantiateViewControllerWithIdentifier("ExploreHotelsVC") as! ExploreHotelsViewController
        controllerThree.whichView = "Hotels"
        controllerThree.title = "Hotels"
        controllerArray.append(controllerThree)
        
        let controllerFour = storyboard!.instantiateViewControllerWithIdentifier("ExploreHotelsVC") as! ExploreHotelsViewController
        controllerFour.whichView = "Rest"
        controllerFour.title = "Restaurants"
        controllerArray.append(controllerFour)
        
        let controllerFive = storyboard!.instantiateViewControllerWithIdentifier("featuredRest") as! FeaturedCitiesRestViewController
        controllerFive.whichView = "AG"
        controllerFive.title = "Popular Agents"
        controllerArray.append(controllerFive)
        
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(4.3),
            .UseMenuLikeSegmentedControl(false),
            .MenuItemSeparatorPercentageHeight(0.1),
            .MenuItemFont(UIFont(name: "Avenir-Roman", size: 14)!),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(orangeColor),
            .UnselectedMenuItemLabelColor(blueColor),
            .SelectedMenuItemLabelColor(blueColor),
            .MenuItemWidthBasedOnTitleTextWidth(false),
            .MenuHeight(45.0)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0, 60, self.view.frame.width, self.view.frame.height - 60), pageMenuOptions: parameters)
        pageMenu!.viewBackgroundColor = blueColor
        
        self.view.addSubview(pageMenu!.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
