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
    
    @IBAction func AddNationality(_ sender: AnyObject) {
        
        pickNationalityMainView.isHidden = false
        
    }
    
    @IBAction func donePickerView(_ sender: AnyObject) {
        
        pickNationalityMainView.isHidden = true
        chooseCity(sender as! UIButton)
        
    }
    
    @IBAction func cancelPickerView(_ sender: AnyObject) {
        
        pickNationalityMainView.isHidden = true
        
        
    }
    
    @IBOutlet weak var addNationality: UILabel!
    @IBOutlet weak var addNationalityButton: UIButton!
    @IBOutlet weak var pickNationalityMainView: UIView!
    @IBOutlet weak var nationalityPickerView: UIPickerView!
    @IBOutlet weak var userNationatilty: UIButton!
    
    @IBAction func userNationatiltyButtonTap(_ sender: AnyObject) {
        
        pickNationalityMainView.isHidden = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        
        getDarkBackGroundBlur(self)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(AddNationalityNewViewController.chooseCity(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
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
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                
                else {
                    
                    if let abc = response["value"].string {
                        
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
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
//        print("countries count: \(allCountries.count)")
        
        if allCountries.count != 0 {
            
            return allCountries[row]["name"].string
            
        }
        
        return ""
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        if allCountries.count != 0 {
            
            return allCountries.count
            
        }
        
        return 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        userNationatilty.isHidden = false
        addNationality.isHidden = true
        addNationalityButton.isHidden = true
        userNationatilty.setTitle(allCountries[row]["name"].string, for: UIControlState())
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseCity(_ sender: UIButton) {
        
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
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                }
                else {
                    
                    if let abc = response["value"].string {
                        
                        let cityVC = self.storyboard!.instantiateViewController(withIdentifier: "addCity") as! AddCityViewController
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
