//
//  KindOfJourneyOTGViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 26/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class KindOfJourneyOTGViewController: UIViewController {
    
    var indexGroupOne = 0
    var indexGroupTwo = 0
    var indexGroupThree = 0
    
    var selectedIndexG1 = 1
    var selectedIndexG2 = 1
    var selectedIndexG3 = 1
    
    @IBOutlet var groupThreeCategoryButtons: [UIButton]!
    @IBOutlet var groupTwoCategoryButtons: [UIButton]!
    @IBOutlet var groupOneCategoryButtons: [UIButton]!
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)
        
        doneButton.addTarget(self, action: #selector(KindOfJourneyOTGViewController.categoriesSelected(_:)), forControlEvents: .TouchUpInside)
        doneButton.layer.cornerRadius = 5
        
        for button in groupOneCategoryButtons {
            
            indexGroupOne += 1
            button.addTarget(self, action: #selector(KindOfJourneyOTGViewController.selectGroupOne(_:)), forControlEvents: .TouchUpInside)
            button.tintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
            button.tag = indexGroupOne
            
        }
        
        
        
        for button in groupTwoCategoryButtons {
            
            indexGroupTwo += 1
            button.addTarget(self, action: #selector(KindOfJourneyOTGViewController.selectGroupTwo(_:)), forControlEvents: .TouchUpInside)
            button.tintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
            button.tag = indexGroupTwo
            
        }
        
        for button in groupThreeCategoryButtons {
            
            indexGroupThree += 1
            button.addTarget(self, action: #selector(KindOfJourneyOTGViewController.selectGroupThree(_:)), forControlEvents: .TouchUpInside)
            button.tintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
            button.tag = indexGroupThree
            
        }
        
        
    }
    
    func categoriesSelected(sender: UIButton) {
        
//        let backVC = storyboard?.instantiateViewControllerWithIdentifier("newTL") as! NewTLViewController
//        backVC.view.setNeedsDisplay()
        self.navigationController?.popViewControllerAnimated(true)
//        self.navigationController?.pushViewController(backVC, animated: true)
        
    }
    
    func selectGroupOne(sender: UIButton) {
        
        for button in groupOneCategoryButtons {
            
            if selectedIndexG1 == button.tag {
                
                button.setBackgroundImage(UIImage(named: "graybox"), forState: .Normal)
                
            }
            
        }
        
        selectedIndexG1 = sender.tag
        sender.setBackgroundImage(UIImage(named: "green_bg_new_small"), forState: .Normal)
        
    }
    
    func selectGroupTwo(sender: UIButton) {
        
        for button in groupTwoCategoryButtons {
            
            if selectedIndexG2 == button.tag {
                
                button.setBackgroundImage(UIImage(named: "graybox"), forState: .Normal)
                
            }
            
        }
        
        selectedIndexG2 = sender.tag
        sender.setBackgroundImage(UIImage(named: "green_bg_new_small"), forState: .Normal)
        
    }
    
    func selectGroupThree(sender: UIButton) {
        
        for button in groupThreeCategoryButtons {
            
            if selectedIndexG3 == button.tag {
                
                button.setBackgroundImage(UIImage(named: "graybox"), forState: .Normal)
                
            }
            
        }
        
        selectedIndexG3 = sender.tag
        sender.setBackgroundImage(UIImage(named: "green_bg_new_small"), forState: .Normal)
        
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
