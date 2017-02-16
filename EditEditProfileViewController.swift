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
    var genderView: GenderInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("which view: \(whichView)")
        
        
        if whichView == 5 {
         
            let locationView = SearchLocation(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
            locationView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            locationView.locationTextField.borderStyle = .none
            locationView.locationTextField.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            self.view.addSubview(locationView)
        }
        
        else if whichView == 1 {
            
            let DOBView = EditDOB(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 250))
            DOBView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            DOBView.saveButton.addTarget(self, action: #selector(EditEditProfileViewController.editDate(_:)), for: .touchUpInside)
            self.view.addSubview(DOBView)
        }
        
        else if whichView == 6 {
            
            getDarkBackGroundBlur(self)
            
            genderView = GenderInfo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 280))
            genderView.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            genderView.heButton.tintColor = UIColor.lightGray
            genderView.sheButton.tintColor = UIColor.lightGray
            if genderValue == "female" {
                genderView.sheButtonTap(nil)
            }
            else {
                genderView.heButtonTap(nil)               
            }
            self.view.addSubview(genderView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editDate(_ sender: UIButton) {
        
        self.navigationController!.popViewController(animated: true)        
        
    }

}
