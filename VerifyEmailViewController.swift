//
//  VerifyEmailViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 06/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class VerifyEmailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(VerifyEmailViewController.selectNationality(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        let verified = AccountVerified(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        verified.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2 - 50)
        self.view.addSubview(verified)
        
        
        
    }
    
    func selectNationality(_ sender: UIButton) {
        
        let nationality = storyboard?.instantiateViewController(withIdentifier: "SelectCountryVC") as! SelectCountryViewController
        nationality.whichView = "selectNationality"
        self.navigationController?.pushViewController(nationality, animated: true)
        
        
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
