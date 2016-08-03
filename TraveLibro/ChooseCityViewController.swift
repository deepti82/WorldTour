//
//  ChooseCityViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 02/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ChooseCityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationButton: UIButton!
    
    let pickOption = ["one", "two", "three", "seven", "fifteen"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationButton.tintColor = UIColor.whiteColor()
        
        let cityPicker = UIPickerView()
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
        cityTextField.attributedPlaceholder = NSAttributedString(string: "Mumbai", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        cityTextField.inputView = cityPicker
        
        
        getDarkBackGroundBlur(self)
        
        locationView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(ChooseCityViewController.selectGender(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
//        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChooseCityViewController.donePicker(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ChooseCityViewController.cancelPicker(_:)))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        cityTextField.inputAccessoryView = toolBar
        
    }
    
    func donePicker(sender: AnyObject) {
        
        cityTextField.resignFirstResponder()
    }
    
    func cancelPicker(sender: AnyObject) {
        
        cityTextField.resignFirstResponder()
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickOption[row]
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickOption.count
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        cityTextField.text = pickOption[row]
    }
    
    func selectGender(sender: UIButton) {
        
        let selectGenderVC = storyboard?.instantiateViewControllerWithIdentifier("selectGender") as! SelectGenderViewController
        self.navigationController?.pushViewController(selectGenderVC, animated: true)
        
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
