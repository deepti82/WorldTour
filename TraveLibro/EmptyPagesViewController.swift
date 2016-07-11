//
//  EmptyPagesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EmptyPagesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBarItem()
        
        let nocountries = NoCountriesVisited(frame: CGRect(x: 0, y: 210, width: self.view.frame.width, height: 200))
        self.view.addSubview(nocountries)
        
        nocountries.addCountriesButton.addTarget(self, action: #selector(EmptyPagesViewController.addCountries(_:)), forControlEvents: .TouchUpInside)
        
    }
    
    func addCountries(sender: UIButton) {
        
        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("SelectCountryVC") as! SelectCountryViewController
        nextVC.whichView = "addCountries"
        self.navigationController?.pushViewController(nextVC, animated: true)
        
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
