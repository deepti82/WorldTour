//
//  AddNationalityNewViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddNationalityNewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(AddNationalityNewViewController.chooseCity(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseCity(sender: UIButton) {
        
        let signUpCityVC = self.storyboard?.instantiateViewControllerWithIdentifier("chooseCity") as! ChooseCityViewController
        self.navigationController?.pushViewController(signUpCityVC, animated: true)
        
    }

}
