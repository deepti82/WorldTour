//
//  EditEditProfileViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 07/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EditEditProfileViewController: UIViewController {
    
    internal var whichView: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("which view: \(whichView)")
        
        if whichView == 6 {
         
            let locationView = SearchLocation(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
            locationView.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
            locationView.locationTextField.borderStyle = .None
            locationView.locationTextField.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
            self.view.addSubview(locationView)
        }
        
        else if whichView == 1 {
            
            let DOBView = EditDOB(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
            DOBView.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
            DOBView.saveButton.addTarget(self, action: #selector(EditEditProfileViewController.editDate(_:)), forControlEvents: .TouchUpInside)
            self.view.addSubview(DOBView)
        }
        
        else if whichView == 7 {
            
            let genderView = GenderInfo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 280))
            genderView.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
            genderView.heButton.tintColor = UIColor.lightGrayColor()
            genderView.sheButton.tintColor = UIColor.lightGrayColor()
            self.view.addSubview(genderView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editDate(sender: UIButton) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
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
