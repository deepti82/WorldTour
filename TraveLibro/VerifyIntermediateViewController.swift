//
//  VerifyIntermediateViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 06/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class VerifyIntermediateViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(VerifyIntermediateViewController.nextOne(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        continueButton.layer.cornerRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButtonTapped(sender: AnyObject) {
        
        let next = storyboard?.instantiateViewControllerWithIdentifier("verifyOne") as! VerifyEmailViewController
        self.navigationController?.pushViewController(next, animated: true)
        
//        navigation.verifyUser(email, completion: {(json:JSON) -> () in
//            
//            print("response: \(json)")
//            
//        })
        
    }
    
    func nextOne(sender: UIButton) {
        
        let next = storyboard?.instantiateViewControllerWithIdentifier("verifyOne") as! VerifyEmailViewController
        self.navigationController?.pushViewController(next, animated: true)
        
    }

}
