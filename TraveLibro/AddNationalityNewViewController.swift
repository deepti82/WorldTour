//
//  AddNationalityNewViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftHTTP
import Toaster

class AddNationalityNewViewController: UIViewController, UIPickerViewDelegate {
    
    var allCountries: [JSON] = []
    var nationalityID = ""
    var hintLabel: UILabel!
    var loader = LoadingOverlay()
    
    internal var isFromSettings: Bool!
    
    @IBOutlet weak var addNationality: UILabel!
    @IBOutlet weak var addNationalityButton: UIButton!
    @IBOutlet weak var pickNationalityMainView: UIView!
    @IBOutlet weak var nationalityPickerView: UIPickerView!
    @IBOutlet weak var userNationatilty: UIButton!
    
    
    //MARK: - Actions
    
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
    
    @IBAction func userNationatiltyButtonTap(_ sender: AnyObject) {
        
        pickNationalityMainView.isHidden = false
        
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = false
        getDarkBackGroundBlur(self)
        
        if isFromSettings != nil && isFromSettings == true {
            let leftButton = UIButton()
            leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
            leftButton.addTarget(self, action: #selector(self.saveCountry(_:)), for: .touchUpInside)
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
        
        hintLabel = UILabel(frame: CGRect(x: 20, y: 0, width: screenWidth - 40, height: 30))
        hintLabel.center = CGPoint(x: hintLabel.center.x, y: self.view.center.y - 100)
        hintLabel.font = avenirFont
        hintLabel.text = "Click on country name to edit"
        hintLabel.textColor = UIColor.white
        hintLabel.textAlignment = .center
        hintLabel.isHidden = true
        self.view.addSubview(hintLabel)
        
        nationalityPickerView.delegate = self
        
        self.title = "Country of Origin"        
        
        if currentUser["homeCountry"] != nil {
            
            addNationality.isHidden = true
            addNationalityButton.isHidden = true
            userNationatilty.isHidden = false
            userNationatilty.setTitle(currentUser["homeCountry"]["name"].stringValue, for: .normal)
            nationalityID = currentUser["homeCountry"]["_id"].stringValue
            hintLabel.isHidden = false
        }
        
        loader.showOverlay(self.view)
        
        fetchCountries()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchCountries() {
        
        request.getAllCountries({(response) in
            
            DispatchQueue.main.async(execute: {
                self.loader.hideOverlayView()
                
                if response.error != nil {
                    print("error: \(response.error?.localizedDescription)")
                }
                else {
                    if response["value"] == true {
                        self.allCountries = response["data"].array!
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
        hintLabel.isHidden = false
    }
    
    
    //MARK: - Save
    
    func saveCountry(_ sender: UIButton) {
        
        var countrySelected: String = ""
        
        if userNationatilty.titleLabel!.text == "Button" {
            
            countrySelected = ""
            alert(message: "Select Country", title: "Please Select Origin Country")
            
        } else if userNationatilty.titleLabel!.text != nil {
            
            countrySelected = nationalityID
            if userNationatilty.titleLabel?.text != currentUser["homeCountry"]["name"].stringValue {
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
                                else {
                                    Toast(text: "User's nation updated").show()
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentUserUpdated"), object: nil)
                                    self.popVC(UIButton())
                                }
                            } else {
                                
                                print("response error: \(response["data"])")
                                
                            }
                            
                        }
                        
                    })
                    
                })
            }
            else {
                if isFromSettings != nil && isFromSettings == true {
                    self.popVC(UIButton())
                }
                else {
                    self.chooseCity(sender)
                }
            }
            
        }
        
    }
    
    
    func chooseCity(_ sender: UIButton) {
        let cityVC = self.storyboard!.instantiateViewController(withIdentifier: "addCity") as! AddCityViewController
        self.navigationController?.pushViewController(cityVC, animated: true)
    }

}
