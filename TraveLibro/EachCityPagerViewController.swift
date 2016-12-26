//
//  EachCityPagerViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 22/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EachCityPagerViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?
    var whichView : String!
    var city = ""
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let orangeColor = UIColor(red: 252/255, green: 80/255, blue: 71/255, alpha: 1)
        let blueColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
        
        nvcTwo = self.navigationController
        
        var controllerArray : [UIViewController] = []
        let controllerOne = storyboard!.instantiateViewController(withIdentifier: "featuredTwo") as! FeaturedCitiesNewTwoViewController
        controllerOne.whichView = "MD"
        controllerOne.title = "Must Do's"
        controllerOne.city = city
        controllerArray.append(controllerOne)
        
        let controllerThree = storyboard!.instantiateViewController(withIdentifier: "ExploreHotelsVC") as! ExploreHotelsViewController
        controllerThree.whichView = "Hotels"
        controllerThree.city = city
        controllerThree.title = "Hotels"
        controllerArray.append(controllerThree)
        
        let controllerFour = storyboard!.instantiateViewController(withIdentifier: "ExploreHotelsVC") as! ExploreHotelsViewController
        controllerFour.whichView = "Rest"
        controllerFour.city = city
        controllerFour.title = "Restaurants"
        controllerArray.append(controllerFour)
        
        let controllerFive = storyboard!.instantiateViewController(withIdentifier: "featuredRest") as! FeaturedCitiesRestViewController
        controllerFive.whichView = "AG"
        controllerFive.title = "Popular Agents"
        controllerArray.append(controllerFive)
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(4.3),
            .useMenuLikeSegmentedControl(false),
            .menuItemSeparatorPercentageHeight(0.1),
            .menuItemFont(UIFont(name: "Avenir-Roman", size: 14)!),
            .scrollMenuBackgroundColor(UIColor.white),
            .selectionIndicatorColor(orangeColor),
            .unselectedMenuItemLabelColor(blueColor),
            .selectedMenuItemLabelColor(blueColor),
            .menuItemWidthBasedOnTitleTextWidth(false),
            .menuHeight(45.0)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60), pageMenuOptions: parameters)
        pageMenu!.viewBackgroundColor = blueColor
        
        self.view.addSubview(pageMenu!.view)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
