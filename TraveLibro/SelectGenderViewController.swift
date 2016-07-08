//
//  SelectGenderViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SelectGenderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        
        let dpVC = storyboard?.instantiateViewControllerWithIdentifier("setDp") as! SetProfilePictureViewController
        setCheckInNavigationBarItem(dpVC)
        
        let gender = GenderInfo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 350))
        gender.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        self.view.addSubview(gender)
        

        // Do any additional setup after loading the view.
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
