//
//  AddNationalityNewViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftHTTP

class AddNationalityNewViewController: UIViewController, UIPickerViewDelegate {
    
    var allCountries: [JSON] = [["name":"India"],["name":"USA"]]
    var nationalityID = ""
    internal var isFromSettings: Bool!
    
    @IBAction func AddNationality(_ sender: AnyObject) {
        
        pickNationalityMainView.isHidden = false
        
    }
    
    @IBAction func donePickerView(_ sender: AnyObject) {
        
        pickNationalityMainView.isHidden = true
        saveCountry(sender as! UIButton)
        
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
        getDarkBackGround(self)
        navigationController?.isNavigationBarHidden = false
        
        getDarkBackGroundBlur(self)
        
        if isFromSettings != nil && isFromSettings == true {
            let leftButton = UIButton()
            leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            self.customNavigationBar(left: leftButton, right: nil)
        }
        else {
            let rightButton = UIButton()
            rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
            rightButton.addTarget(self, action: #selector(AddNationalityNewViewController.saveCountry(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
            self.customNavigationBar(left: nil, right: rightButton)
        }
        
        nationalityPickerView.delegate = self
        
        self.title = "Country of Origin"        
        
        if currentUser["homeCountry"] != nil {
            
            addNationality.isHidden = true
            addNationalityButton.isHidden = true
            userNationatilty.isHidden = false
            userNationatilty.setTitle(currentUser["homeCountry"]["name"].stringValue, for: .normal)
            nationalityID = currentUser["homeCountry"]["_id"].stringValue
            
        }
        
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.default
//        toolBar.isTranslucent = true
//        //        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//        toolBar.sizeToFit()
//        
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddNationalityNewViewController.donePickerView(_:)))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddNationalityNewViewController.cancelPickerView(_:)))
//        
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.isUserInteractionEnabled = true
//        
//        toolBar.frame = CGRect(x: 0, y: 0,width: pickNationalityMainView.frame.width,height: 30)
//        pickNationalityMainView.addSubview(toolBar)
        
        
        
        
        request.getAllCountries({(response) in
            
            DispatchQueue.main.async(execute: {
                print("countries")
                print(response)
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }else {
                    print("in else")
                    if response["value"] == true {
                        print("in else of if part")
                        
                        self.allCountries = response["data"].array!
//                        print("countries data: \(self.allCountries)")
                        self.nationalityPickerView.reloadAllComponents()
                        
                    }
                
                }
                
                
            })
            
        })
        
    }
    
    
    //MARK: - Picker Delegates
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
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
        nationalityID = allCountries[row]["_id"].string!        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveCountry(_ sender: UIButton) {
        
        var countrySelected: String = ""
        
        if userNationatilty.titleLabel!.text == "Button" {
            
            countrySelected = ""
            alert(message: "Select Country", title: "Please Select Origin Country")
            
        } else if userNationatilty.titleLabel!.text != nil {
            
            countrySelected = nationalityID
            request.editUser(currentUser["_id"].string!, editField: "homeCountry", editFieldValue: countrySelected, completion: {(response) in
                
                DispatchQueue.main.async(execute: {
                    
                    if response.error != nil {
                        
                        self.alert(message: "Select Country", title: "Please try agin later...")
                        print("error: \(response.error?.localizedDescription)")
                        
                    } else {
                        if response["value"] == true {
                            currentUser = response["data"]
                            if self.isFromSettings != true {
                                self.chooseCity(sender)
                            }                            
                        } else {
                            
                            print("response error: \(response["data"])")
                            
                        }
                        
                    }
                    
                })
                
            })
            
        }
        
    }
    
    
    func chooseCity(_ sender: UIButton) {
        let cityVC = self.storyboard!.instantiateViewController(withIdentifier: "addCity") as! AddCityViewController
        self.navigationController?.pushViewController(cityVC, animated: true)
    }

}
