//
//  EditSettingsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EditSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.lightGrayColor()
        
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        titleView.center = CGPointMake(self.view.frame.width/2 , 100)
        titleView.text = "Click here to change your travel preferences"
        titleView.font = avenirFont
        titleView.textColor = mainBlueColor
        self.view.addSubview(titleView)
        
        let textView = MoreAboutMe(frame: CGRect(x: 0, y: 140, width: self.view.frame.width, height: 140))
        textView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(textView)

//        let resetpswd = ResetPassword(frame: CGRect(x: 0, y: 75, width: self.view.frame.width, height: 250))
//        self.view.addSubview(resetpswd)
        
//        let report = ReportProblem(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 300))
//        self.view.addSubview(report)
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
