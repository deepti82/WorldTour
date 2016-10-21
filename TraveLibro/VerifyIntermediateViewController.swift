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
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(VerifyIntermediateViewController.nextOne(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        continueButton.layer.cornerRadius = 5
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func continueButtonTapped(_ sender: AnyObject) {
        
        let next = storyboard?.instantiateViewController(withIdentifier: "verifyOne") as! VerifyEmailViewController
        self.navigationController?.pushViewController(next, animated: true)
        
//        navigation.verifyUser(email, completion: {(json:JSON) -> () in
//            
//            print("response: \(json)")
//            
//        })
        
    }
    
    func nextOne(_ sender: UIButton) {
        
        let next = storyboard?.instantiateViewController(withIdentifier: "verifyOne") as! VerifyEmailViewController
        self.navigationController?.pushViewController(next, animated: true)
        
    }

}
