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

        let nofollow = NoFollowers(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 120))
        self.view.addSubview(nofollow)
        
        let nocountries = NoCountriesVisited(frame: CGRect(x: 0, y: 210, width: self.view.frame.width, height: 200))
        self.view.addSubview(nocountries)
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
