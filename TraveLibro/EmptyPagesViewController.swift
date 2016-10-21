//
//  EmptyPagesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EmptyPagesViewController: UIViewController {
    
    var whichView: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.setNavigationBarItem()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popToProfile(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
//        let rightButton = UIButton()
//        rightButton.setImage(UIImage(named: "add_fa_icon"), forState: .Normal)
//        rightButton.addTarget(self, action: #selector(BucketListTableViewController.addCountriesVisited(_:)), forControlEvents: .TouchUpInside)
//        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: nil)
        
        let nocountries = NoCountriesVisited(frame: CGRect(x: 0, y: 210, width: self.view.frame.width, height: 200))
        self.view.addSubview(nocountries)
        
        nocountries.addCountriesButton.addTarget(self, action: #selector(EmptyPagesViewController.addCountries(_:)), for: .touchUpInside)
        
        if whichView == "BucketList" {
            
            self.title = "Bucket List"
            nocountries.countriesVisitedLabel.text = "Add Countries To Your Bucket List Here"
            
        }
        
        else if whichView == "CountriesVisited" {
            
            self.title = "Countries Visited"
            nocountries.countriesVisitedLabel.text = "Add Countries To Your Countries Visited Here"
            
        }
        
    }
    
    func popToProfile(_ sender: UIButton) {
        
//        self.navigationController?.popToRootViewControllerAnimated(true)
        let prevVC = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
//        nextVC.whichView = whichView
        //            nextVC.isComingFromEmptyPages = true
        self.navigationController?.pushViewController(prevVC, animated: false)
        
        
    }
    
    func addCountries(_ sender: UIButton) {
        
//        if whichView == "BucketList" {
        
            let nextVC = storyboard?.instantiateViewController(withIdentifier: "SelectCountryVC") as! SelectCountryViewController
            nextVC.whichView = whichView
//            nextVC.isComingFromEmptyPages = true
            self.navigationController?.pushViewController(nextVC, animated: true)
//        }
        
//        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
//        nextVC.whichView = "addCountries"
//        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
