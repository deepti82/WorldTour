//
//  ChooseCityViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ChooseCityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    let pickOption = ["one", "two", "three", "seven", "fifteen"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationButton.tintColor = UIColor.white
        
//        let cityPicker = UIPickerView()
//        cityPicker.delegate = self
//        cityPicker.dataSource = self
        
        cityTextField.attributedPlaceholder = NSAttributedString(string: "Mumbai", attributes: [NSForegroundColorAttributeName: UIColor.white])
//        cityTextField.inputView = cityPicker
        
        cityTextField.delegate = self
        
        getDarkBackGroundBlur(self)
        
        locationView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(ChooseCityViewController.selectGender(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
//        let toolBar = UIToolbar()
//        toolBar.barStyle = UIBarStyle.Default
//        toolBar.translucent = true
////        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
//        toolBar.sizeToFit()
//        
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChooseCityViewController.donePicker(_:)))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChooseCityViewController.cancelPicker(_:)))
//        
//        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//        toolBar.userInteractionEnabled = true
//        
//        cityTextField.inputAccessoryView = toolBar
        
    }
    
    func donePicker(_ sender: AnyObject) {
        
        cityTextField.resignFirstResponder()
    }
    
    func cancelPicker(_ sender: AnyObject) {
        
        cityTextField.resignFirstResponder()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickOption[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickOption.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        cityTextField.text = pickOption[row]
    }
    
    func selectGender(_ sender: UIButton) {
        
        let selectGenderVC = storyboard?.instantiateViewController(withIdentifier: "selectGender") as! SelectGenderViewController
        self.navigationController?.pushViewController(selectGenderVC, animated: true)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        print("has begun editing")
        locationView.animation.makeFrame(8, 10, locationView.frame.width, locationView.frame.height).animate(0.2)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
