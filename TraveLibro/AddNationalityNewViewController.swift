//
//  AddNationalityNewViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON

class AddNationalityNewViewController: UIViewController, UIPickerViewDelegate {
    
    var allCountries: [JSON] = []
    
    @IBAction func AddNationality(sender: AnyObject) {
        
        pickNationalityMainView.hidden = false
        
    }
    
    @IBAction func donePickerView(sender: AnyObject) {
        
        pickNationalityMainView.hidden = true
        chooseCity(sender as! UIButton)
        
    }
    
    @IBAction func cancelPickerView(sender: AnyObject) {
        
        pickNationalityMainView.hidden = true
        
        
    }
    
    @IBOutlet weak var addNationality: UILabel!
    @IBOutlet weak var addNationalityButton: UIButton!
    @IBOutlet weak var pickNationalityMainView: UIView!
    @IBOutlet weak var nationalityPickerView: UIPickerView!
    @IBOutlet weak var userNationatilty: UIButton!
    
    @IBAction func userNationatiltyButtonTap(sender: AnyObject) {
        
        pickNationalityMainView.hidden = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = false
        
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
        
        nationalityPickerView.delegate = self
        
        self.title = "Country of Origin"
        
//        if currentUser["homeCountry"] != nil {
//            
//            addNationality.hidden = true
//            addNationalityButton.hidden = true
//            userNationatilty.hidden = false
//            userNationatilty.setTitle(currentUser["homeCountry"].string!, forState: .Normal)
//            
//        }
        
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.Default
//        toolBar.translucent = true
//        //        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//        toolBar.sizeToFit()
//        
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddNationalityNewViewController.donePicker(_:)))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddNationalityNewViewController.cancelPicker(_:)))
//        
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.userInteractionEnabled = true
//        
//        toolBar.frame = CGRectMake(0, 0, pickNationalityMainView.frame.width, 30)
//        pickNationalityMainView.addSubview(toolBar)
        
        request.getAllCountries({(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                
                else {
                    
                    if response["value"] {
                        
                        self.allCountries = response["data"].array!
//                        print("countries data: \(self.allCountries)")
                        self.nationalityPickerView.reloadAllComponents()
                        
                    }
                    
                }
                
                
            })
            
            
            
        })
        
    }
    
//    func donePicker(sender: AnyObject) {
//        
//        
//        
//    }
//    
//    func cancelPicker(sender: AnyObject) {
//        
//        pickNationalityMainView.hidden = true
//        
//    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
//        print("countries count: \(allCountries.count)")
        
        if allCountries.count != 0 {
            
            return allCountries[row]["name"].string
            
        }
        
        return ""
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if allCountries.count != 0 {
            
            return allCountries.count
            
        }
        
        return 0
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        userNationatilty.hidden = false
        addNationality.hidden = true
        addNationalityButton.hidden = true
        userNationatilty.setTitle(allCountries[row]["name"].string, forState: .Normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseCity(sender: UIButton) {
        
        var countrySelected: String = ""

        if userNationatilty.titleLabel!.text == "Button" {
            
            countrySelected = ""
            
        }
        
        else if userNationatilty.titleLabel!.text != nil {
            
            countrySelected = userNationatilty.titleLabel!.text!
            
        }
        
//        print("current user: \(currentUser)")
        
        
//        let signUpCityVC = self.storyboard?.instantiateViewControllerWithIdentifier("chooseCity") as! ChooseCityViewController
//        self.navigationController?.pushViewController(signUpCityVC, animated: true)
        
        request.editUser(currentUser["_id"].string!, editField: "homeCountry", editFieldValue: countrySelected, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                }
                else {
                    
                    if response["value"] {
                        
                        let cityVC = self.storyboard!.instantiateViewControllerWithIdentifier("addCity") as! AddCityViewController
                        self.navigationController?.pushViewController(cityVC, animated: true)
                        
                    }
                        
                    else {
                        
                        print("response error: \(response["data"])")
                    }
                    
                }
                
            })
        })
        
    }

}
