//
//  EditSettingsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EditSettingsViewController: UIViewController {
    
    internal var whichView = "noView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view: \(whichView)")
        
        switch whichView {
        case "MAMView":
            self.title = "Edit More About Me"
            let titleView = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
            titleView.center = CGPointMake(self.view.frame.width/2 , 100)
            titleView.setTitle("Click here to change your travel preferences", forState: .Normal)
            titleView.titleLabel?.font = avenirFont!
            titleView.setTitleColor(UIColor(red: 88/255, green: 88/255, blue: 88/255, alpha: 1), forState: .Normal)
            titleView.backgroundColor = UIColor.clearColor()
            titleView.addTarget(self, action: #selector(EditSettingsViewController.editPreferences(_:)), forControlEvents: .TouchUpInside)
            self.view.addSubview(titleView)
            
            let textView = MoreAboutMe(frame: CGRect(x: 0, y: 140, width: self.view.frame.width, height: 150))
            textView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(textView)
            break
            
        case "NewPswdView":
            self.title = "Reset Password"
            print("in new pswd view")
            let resetpswd = ResetPassword(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: 250))
            self.view.addSubview(resetpswd)
            break
        
        case "ReportView":
            self.title = "Report a problem"
            let report = ReportProblem(frame: CGRect(x: 0, y: 80, width: self.view.frame.width, height: 300))
            report.submitButton.addTarget(self, action: #selector(EditSettingsViewController.submitComplaint(_:)), forControlEvents: .TouchUpInside)
            self.view.addSubview(report)
            break
            
        default:
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editPreferences(sender: UIButton) {
        
        let displayCardsVC = storyboard?.instantiateViewControllerWithIdentifier("DisplayCards") as! DisplayCardsViewController
        self.navigationController?.pushViewController(displayCardsVC, animated: true)
        
        
    }
    
    func submitComplaint(sender: UIButton) {
        
        let alert = UIAlertController(title: nil, message:
            "Successfully Reported!", preferredStyle: .Alert)
        
        self.presentViewController(alert, animated: false, completion: nil)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler:
            {action in      
                alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
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
