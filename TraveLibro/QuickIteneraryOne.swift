//
//  QuickIteneraryOne.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 07/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import CoreGraphics
class QuickIteneraryOne: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tripTitle: UITextField!
    
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var yearPickerView: UITextField!
    @IBOutlet weak var monthPickerView: UITextField!
    var months: [String]!
    var years: [Int] = []
    var yearsPicker: [Int] = []
    var monthsPicker: [String] = []
    var eachButton: [String] = []
    var pickerView = UIPickerView()
    var datePickerView: UIDatePicker = UIDatePicker()
    var date = NSDate()
    var currentYear: Int = 0
   
    var currentMonth: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        quickItinery = ["title": "", "year": "", "month": "", "duration": ""]
        
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.frame = CGRect(x: 0, y: 240, width: view.frame.width, height: 200)
        yearPickerView.inputView = pickerView
        monthPickerView.inputView = pickerView
        let calendar = NSCalendar.current
        let dateFormatterMonth = DateFormatter()
        let dateFormatter = DateFormatter()
        let components = calendar.dateComponents([.month , .year], from: date as Date)
        dateFormatter.dateFormat = "yyyy"
        quickItinery["title"] = JSON(tripTitle.text!)
        quickItinery["month"] = JSON(monthPickerView.text!)
        quickItinery["year"] = JSON(yearPickerView.text!)
        quickItinery["duration"] = JSON(durationTextField.text!)
        currentYear = Int(dateFormatter.string(from: date as Date))!
        self.durationTextField.delegate = self
        self.tripTitle.delegate = self
        self.commonSetup()
        for i in 0..<35{
            yearsPicker.append(currentYear)
            currentYear -= 1
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commonSetup() {
        // population years
        var years: [Int] = []
        if years.count == 0 {
            var year = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.year, from: NSDate() as Date)
            for _ in 1...15 {
                years.append(year)
                year += 1
            }
        }
        self.years = years
        
        var months: [String] = []
        var month = 0
        for _ in 1...12 {
            months.append(DateFormatter().shortMonthSymbols[month].capitalized)
            month += 1
        }
        yearPickerView.delegate = self
        self.months = months
        pickerView.delegate = self
        pickerView.dataSource = self
        
        monthPickerView.delegate = self
        
        let currentMonth = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!.component(.month, from: NSDate() as Date)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(yearsPicker[row])"
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return yearsPicker.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch  component {
        case 0:
            monthPickerView.text = months[row]
        case 1:
            yearPickerView.text = "\(yearsPicker[row])"
        default:
            break
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool
    {
        if range.length + range.location > (durationTextField.text?.characters.count)! {
            return false
        }
        let newLength = (durationTextField.text?.characters.count)! + string.characters.count - range.length
        return newLength <= 3
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        durationTextField.resignFirstResponder()
        tripTitle.resignFirstResponder()
        return true
    }
    override func viewWillDisappear(_ animated: Bool) {
        quickItinery["title"] = JSON(tripTitle.text!)
        quickItinery["month"] = JSON(monthPickerView.text!)
        if yearPickerView.text != "" {
            quickItinery["year"] = JSON(Int(yearPickerView.text!)!)
        }
        if durationTextField.text != "" {
            quickItinery["duration"] = JSON(Int(durationTextField.text!)!)

        }
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
