//
//  DisplayPagesTwoViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 01/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class DisplayPagesTwoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(DisplayPagesTwoViewController.nextPage(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
    }
    
    func nextPage(sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("displayThree") as! DisplayPagesThreeViewController
        self.navigationController?.pushViewController(next, animated: true)
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
