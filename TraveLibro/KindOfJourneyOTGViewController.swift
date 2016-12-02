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
    var selectedCategories :JSON = []
    var journeyID = ""
    
    var isEdit = false
    
    var backVC: NewTLViewController!
    
    @IBOutlet var groupThreeCategoryButtons: [UIButton]!
    @IBOutlet var groupTwoCategoryButtons: [UIButton]!
    @IBOutlet var groupOneCategoryButtons: [UIButton]!
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBackGround(self)
        
        let allControllers = self.navigationController?.viewControllers
        backVC = allControllers![allControllers!.count - 2] as! NewTLViewController
        backVC.journeyCategories = []
        
        doneButton.addTarget(self, action: #selector(KindOfJourneyOTGViewController.categoriesSelected(_:)), for: .touchUpInside)
        doneButton.layer.cornerRadius = 5
        
        for button in groupOneCategoryButtons {
            for cat in selectedCategories {
                if cat.1.stringValue == (button.titleLabel?.text)! {
                    backVC.journeyCategories.append(button.titleLabel!.text!)
                    button.setBackgroundImage(UIImage(named: "halfgreenbox"), for: UIControlState())
                    button.tag = 1
                }
            }
//            indexGroupOne += 1
            button.addTarget(self, action: #selector(KindOfJourneyOTGViewController.selectGroupOne(_:)), for: .touchUpInside)
            button.tintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
//            button.tag = indexGroupOne
            
        }
        
        
        
        for button in groupTwoCategoryButtons {
            
//            indexGroupTwo += 1
            for cat in selectedCategories {
                if cat.1.stringValue == (button.titleLabel?.text)! {
                    backVC.journeyCategories.append(button.titleLabel!.text!)
                    button.setBackgroundImage(UIImage(named: "halfgreenbox"), for: UIControlState())
                    button.tag = 1
                }
            }
            button.addTarget(self, action: #selector(KindOfJourneyOTGViewController.selectGroupTwo(_:)), for: .touchUpInside)
            button.tintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
//            button.tag = indexGroupTwo
            
        }
        
        for button in groupThreeCategoryButtons {
            
//            indexGroupThree += 1
            for cat in selectedCategories {
                if cat.1.stringValue == (button.titleLabel?.text)! {
                    backVC.journeyCategories.append(button.titleLabel!.text!)
                    button.setBackgroundImage(UIImage(named: "halfgreenbox"), for: UIControlState())
                    button.tag = 1
                }
            }
            button.addTarget(self, action: #selector(KindOfJourneyOTGViewController.selectGroupThree(_:)), for: .touchUpInside)
            button.tintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
//            button.tag = indexGroupThree
            
        }
        
        
    }
    
    func categoriesSelected(_ sender: UIButton) {
        
        if backVC.journeyCategories.count == 0 {
            
            let alert = UIAlertController(title: "Invalid input", message: "You need to select atleast one category", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else if isEdit {
            print("categories before save")
            print(backVC.journeyCategories)
            request.kindOfJourney(journeyID, kindOfJourney: backVC.journeyCategories, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    print("error: \(response.error?.localizedDescription)")
                }
                else if response["value"].bool! {
                    
                    print("is editing? \(self.isEdit)")
                    self.goBack()
                    
                }
                else {
                    
                    print("response error!")
                    
                }
                
                })
            })
            
            
        }
        else {
            
            self.goBack()
        }
        
        
//        self.navigationController?.pushViewController(backVC, animated: true)
        
    }
    
    func goBack() {
        
        self.backVC.showDetailsFn(isEdit: self.isEdit)
        self.navigationController!.popViewController(animated: true)
    }
    
    func selectGroupOne(_ sender: UIButton) {
        
//        for button in groupOneCategoryButtons {
//            
//            if selectedIndexG1 == button.tag {
//                
//                button.setBackgroundImage(UIImage(named: "graybox"), forState: .Normal)
//                
//            }
//            
//        }
//        
//        selectedIndexG1 = sender.tag
        if sender.tag == 0 {
            backVC.journeyCategories.append(sender.titleLabel!.text!)
            print("element added: \(backVC.journeyCategories)")
            sender.setBackgroundImage(UIImage(named: "halfgreenbox"), for: UIControlState())
            sender.tag = 1
        }
        
        else {
            
//            for buttonTitle in backVC.journeyCategories {
//                
//                if buttonTitle == sender.titleLabel?.text {
//                    
//                    
//                }
//                
//            }
            
            backVC.journeyCategories = backVC.journeyCategories.filter { $0 != sender.titleLabel?.text }
            print("element removed: \(backVC.journeyCategories)")
            sender.setBackgroundImage(UIImage(named: "graybox"), for: UIControlState())
            sender.tag = 0
        }
        
        
    }
    
    func selectGroupTwo(_ sender: UIButton) {
        
        if sender.tag == 0 {
            backVC.journeyCategories.append(sender.titleLabel!.text!)
            sender.setBackgroundImage(UIImage(named: "halfgreenbox"), for: UIControlState())
            sender.tag = 1
        }
            
        else {
            backVC.journeyCategories = backVC.journeyCategories.filter { $0 != sender.titleLabel?.text }
            sender.setBackgroundImage(UIImage(named: "graybox"), for: UIControlState())
            sender.tag = 0
            
        }
        
//        for button in groupTwoCategoryButtons {
//            
//            if selectedIndexG2 == button.tag {
//                
//                button.setBackgroundImage(UIImage(named: "graybox"), forState: .Normal)
//                
//            }
//            
//        }
//        
//        selectedIndexG2 = sender.tag
//        sender.setBackgroundImage(UIImage(named: "green_bg_new_small"), forState: .Normal)
        
    }
    
    func selectGroupThree(_ sender: UIButton) {
        
        if sender.tag == 0 {
            backVC.journeyCategories.append(sender.titleLabel!.text!)
            sender.setBackgroundImage(UIImage(named: "halfgreenbox"), for: UIControlState())
            sender.tag = 1
        }
            
        else {
            backVC.journeyCategories = backVC.journeyCategories.filter { $0 != sender.titleLabel?.text }
            sender.setBackgroundImage(UIImage(named: "graybox"), for: UIControlState())
            sender.tag = 0
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
