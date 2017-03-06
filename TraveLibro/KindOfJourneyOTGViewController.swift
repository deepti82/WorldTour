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
    var selectedCategories: JSON = []
    var journeyID = ""
    var loader = LoadingOverlay()
    var isEdit = false
    
    var backVC: NewTLViewController!
    
    @IBOutlet var groupThreeCategoryButtons: [UIButton]!
    @IBOutlet var groupTwoCategoryButtons: [UIButton]!
    @IBOutlet var groupOneCategoryButtons: [UIButton]!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        loader.showOverlay(self.view)
        self.setTopNavigation(text: "Kind of Journey");
        getDarkBackGroundBlue(self)
        
        let allControllers = self.navigationController?.viewControllers
        backVC = allControllers![allControllers!.count - 2] as! NewTLViewController
        backVC.journeyCategories = []
        
        doneButton.addTarget(self, action: #selector(KindOfJourneyOTGViewController.categoriesSelected(_:)), for: .touchUpInside)
        doneButton.layer.cornerRadius = 5
        
        for button in groupOneCategoryButtons {
            for cat in selectedCategories {
                if cat.1.stringValue == (button.titleLabel?.text)! {
                    backVC.journeyCategories.append(button.titleLabel!.text!)
                    button.setBackgroundImage(UIImage(named: "halfgreenbox"), for: .normal)
                    button.tag = 1
                }
            }
            button.addTarget(self, action: #selector(KindOfJourneyOTGViewController.selectGroupOne(_:)), for: .touchUpInside)
           button.imageView?.tintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
            
        }
        
        
        
        for button in groupTwoCategoryButtons {
            
            for cat in selectedCategories {
                if cat.1.stringValue == (button.titleLabel?.text)! {
                    backVC.journeyCategories.append(button.titleLabel!.text!)
                    button.setBackgroundImage(UIImage(named: "halfgreenbox"), for: .normal)
                    button.tag = 1
                }
            }
            button.addTarget(self, action: #selector(KindOfJourneyOTGViewController.selectGroupTwo(_:)), for: .touchUpInside)
            button.imageView?.tintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
            
        }
        
        for button in groupThreeCategoryButtons {
            
            for cat in selectedCategories {
                if cat.1.stringValue == (button.titleLabel?.text)! {
                    backVC.journeyCategories.append(button.titleLabel!.text!)
                    button.setBackgroundImage(UIImage(named: "halfgreenbox"), for: .normal)
                    button.tag = 1
                }
            }
            button.addTarget(self, action: #selector(KindOfJourneyOTGViewController.selectGroupThree(_:)), for: .touchUpInside)
            button.imageView?.tintColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
            
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
//            print(backVC.journeyCategories)
            request.kindOfJourney(journeyID, kindOfJourney: backVC.journeyCategories, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                if response.error != nil {
                    print("error: \(response.error?.localizedDescription)")
                }
                else if response["value"].bool! {
                    
                    print("is editing? \(self.isEdit)")
                    self.goBack(UIView())
                    if(globalNewTLViewController != nil) {
                        globalNewTLViewController.getJourney()
                    }
                    
                }
                else {
                    
                    print("response error!")
                    
                }
                
                })
            })
            
            
        }
        else {
            
            self.goBack(UIView())
        }
        
    }
    
    func goBack(_ sender:AnyObject) {
        
        self.backVC.showDetailsFn(isEdit: self.isEdit)
        self.navigationController!.popViewController(animated: true)
    }
    
    
    
    
    func selectGroupOne(_ sender: UIButton) {
        
        if sender.tag == 0 {
            backVC.journeyCategories.append(sender.titleLabel!.text!)
            print("element added: \(backVC.journeyCategories)")
            sender.setBackgroundImage(UIImage(named: "halfgreenbox"), for: .normal)
            sender.tag = 1
        }
        
        else {
            
            backVC.journeyCategories = backVC.journeyCategories.filter { $0 != sender.titleLabel?.text }
            print("element removed: \(backVC.journeyCategories)")
            sender.setBackgroundImage(UIImage(named: "grey1"), for: .normal)
            sender.tag = 0
        }
        
        
    }
    
    
    
    func setTopNavigation(text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    func selectGroupTwo(_ sender: UIButton) {
        
        if sender.tag == 0 {
            backVC.journeyCategories.append(sender.titleLabel!.text!)
            sender.setBackgroundImage(UIImage(named: "orange"), for: .normal)
            sender.tag = 1
        }
            
        else {
            backVC.journeyCategories = backVC.journeyCategories.filter { $0 != sender.titleLabel?.text }
            sender.setBackgroundImage(UIImage(named: "grey1"), for: .normal)
            sender.tag = 0
            
        }
    }
    
    func selectGroupThree(_ sender: UIButton) {
        
        if sender.tag == 0 {
            backVC.journeyCategories.append(sender.titleLabel!.text!)
            sender.setBackgroundImage(UIImage(named: "halfgreenbox"), for: .normal)
            sender.tag = 1
        }
            
        else {
            backVC.journeyCategories = backVC.journeyCategories.filter { $0 != sender.titleLabel?.text }
            sender.setBackgroundImage(UIImage(named: "grey1"), for: .normal)
            sender.tag = 0
            
        }
    }
}
