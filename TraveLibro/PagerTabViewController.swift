//
//  PagerTabViewController.swift
//  
//
//  Created by Midhet Sulemani on 13/07/16.
//
//

import UIKit
//import TabPageViewController
//import XLPagerTabStrip

class PagerTabViewController: UIViewController {
    
//    @IBOutlet weak var containerView: UIScrollView!
    
    let orangeColor = UIColor(red: 252/255, green: 80/255, blue: 71/255, alpha: 1)
    let blueColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
    
    let graySpotifyColor = UIColor(red: 21/255.0, green: 21/255.0, blue: 24/255.0, alpha: 1.0)
    let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
    
    override func viewDidLoad() {
        

//        settings.style.buttonBarBackgroundColor:
        // buttonBar minimumInteritemSpacing value, note that button bar extends from UICollectionView
//        settings.style.buttonBarMinimumInteritemSpacing = 3.0
        // buttonBar minimumLineSpacing value
//        settings.style.buttonBarMinimumLineSpacing = 0
//        // buttonBar flow layout left content inset value
//        settings.style.buttonBarLeftContentInset = 10
//        // buttonBar flow layout right content inset value
//        settings.style.buttonBarRightContentInset = 10
//        
//        // selected bar view is created programmatically so it's important to set up the following 2 properties properly
//        settings.style.selectedBarBackgroundColor = orangeColor
//        settings.style.selectedBarHeight = 3.0
//        
//        // each buttonBar item is a UICollectionView cell of type ButtonBarViewCell
//        settings.style.buttonBarItemBackgroundColor =  UIColor.whiteColor()
//        settings.style.buttonBarItemFont = UIFont(name: "Avenir-Roman", size: 14)!
//        // helps to determine the cell width, it represent the space before and after the title label
//        settings.style.buttonBarItemLeftRightMargin = 8
//        settings.style.buttonBarItemTitleColor = blueColor
//        // in case the barView items do not fill the screen width this property stretch the cells to fill the screen
//        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
//        // only used if button bar is created programmatically and not using storyboards or nib files as recommended.
////        public var buttonBarHeight: CGFloat?
//        
//        settings.style.buttonBarBackgroundColor = UIColor.whiteColor()
//        settings.style.buttonBarItemBackgroundColor = UIColor.whiteColor()
//        settings.style.selectedBarBackgroundColor = orangeColor
//        settings.style.buttonBarItemFont = UIFont(name: "Avenir-Roman", size:14)!
//        settings.style.selectedBarHeight = 3.0
//        settings.style.buttonBarMinimumLineSpacing = 0
//        settings.style.buttonBarItemTitleColor = blueColor
//        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
//        
//        settings.style.buttonBarLeftContentInset = 20
//        settings.style.buttonBarRightContentInset = 20
        
        super.viewDidLoad()
        
//        self.removeNavigationBarItem()
//        
        
        
        
//        let tabPageViewController = TabPageViewController.create()
        
//        let featuredCities = storyboard?.instantiateViewControllerWithIdentifier("featuredCities") as! FeaturedCitiesViewController
//         featuredCities.whichView = "Featured Cities"
//        let featuredCities = FeaturedCitiesViewController()
//        featuredCities.whichView = "Featured Cities"
//        //         featuredCities.itemInfo = "Featured Cities"
////        mustDo.whichView = "Must Do View"
//        let itineraries = FeaturedCitiesViewController()
//        itineraries.whichView = "Itinerary View"
//        let journeys = storyboard?.instantiateViewControllerWithIdentifier("featuredCities") as! FeaturedCitiesViewController
//        journeys.whichView = "Journey View"
//        let popularAgents = storyboard?.instantiateViewControllerWithIdentifier("featuredCities") as! FeaturedCitiesViewController
//        popularAgents.whichView = "Popular Agents View"
//        
////        let vc1 = UIViewController()
////        let vc2 = UIViewController()
//        
//        tabPageViewController.tabItems = [(featuredCities, "Featured Cities"), (itineraries, "Itinerary View")]
//        
//        var option = TabPageOption.init()
//        option.currentColor = UIColor.redColor()
        
    }
    
//    override internal func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
//        
//        let featuredCities = storyboard?.instantiateViewControllerWithIdentifier("featuredCities") as! FeaturedCitiesViewController
//        featuredCities.whichView = "FC"
//        featuredCities.itemInfo = "Featured Cities"
//        let mustDo = storyboard?.instantiateViewControllerWithIdentifier("featuredCities") as! FeaturedCitiesViewController
//        mustDo.whichView = "MD"
//        mustDo.itemInfo = "Must Do's"
//        //        mustDo.whichView = "Must Do View"
//        let itineraries = storyboard?.instantiateViewControllerWithIdentifier("featuredCities") as! FeaturedCitiesViewController
//        itineraries.whichView = "It"
//        itineraries.itemInfo = "Itineraries"
//////        mustDo.whichView = "Must Do View"
////        let itineraries = storyboard?.instantiateViewControllerWithIdentifier("featuredCities") as! FeaturedCitiesViewController
////        itineraries.whichView = "Itinerary View"
//        let journeys = storyboard?.instantiateViewControllerWithIdentifier("featuredCities") as! FeaturedCitiesViewController
//        journeys.whichView = "Jo"
//        journeys.itemInfo = "Journeys"
//        let popularAgents = storyboard?.instantiateViewControllerWithIdentifier("featuredCities") as! FeaturedCitiesViewController
//        popularAgents.whichView = "Pop"
//        popularAgents.itemInfo = "Popular Agents"
//        
////        let child_1 = FeaturedCitiesViewController(style: .Plain, itemInfo: IndicatorInfo(title: "FRIENDS"))
////        child_1.blackTheme = true
////        let child_2 = FeaturedCitiesViewController(style: .Plain, itemInfo: IndicatorInfo(title: "FEATURED"))
////        child_2.blackTheme = true
////        return [child_1, child_2]
//        
//        return [featuredCities, mustDo, itineraries, journeys, popularAgents]
//    }
    
    
    
    
}




//class PagerTabViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
