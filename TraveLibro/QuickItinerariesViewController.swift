//
//  QuickItinerariesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItinerariesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var whichView: String!
    var pageIndex = 0
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    var one = QuickItineraryOne()
    var two = QuickItineraryTwo()
    var months: [String]!
    var years: [Int] = []
    var yearsPicker: [Int] = []
    var pickerView = UIPickerView()
    var datePickerView: UIDatePicker = UIDatePicker()
    var date = NSDate()
    var currentYear: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonSetup()
        print("view: \(whichView)")
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        switch whichView {
        case "One":
            one = QuickItineraryOne(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 300))
            one.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            pickerView.frame = CGRect(x: 0, y: 240, width: view.frame.width, height: 200)
            self.view.addSubview(one)
            one.yearPickerView.inputView = pickerView
            var calendar = NSCalendar.current
            let dateFormatter = DateFormatter()
            let components = calendar.dateComponents([.month , .year], from: date as Date)
            dateFormatter.dateFormat = "yyyy"
           currentYear = Int(dateFormatter.string(from: date as Date))!
            //var strDate = dateFormatter.string(from: datePickerView.date)
           //let str = "\(components.month)"
            //one.monthPickerView.text = str
            //datePickerView.datePickerMode = UIDatePickerMode.date
            //one.monthPickerView.inputView = datePickerView
           // datePickerView.addTarget(self, action: #selector(QuickItinerariesViewController.monthChanged(_:)), for: UIControlEvents.valueChanged)
                   case "Two":
            let two = QuickItineraryTwo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 450))
            two.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            self.view.addSubview(two)
        case "Three":
            let three = QuickItineraryThree(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 350))
            three.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            self.view.addSubview(three)
        case "Four":
            let four = QuickItineraryFour(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 400))
            four.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            self.view.addSubview(four)
        case "Five":
            let five = QuickItineraryFive(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 200))
            five.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
            self.view.addSubview(five)
        default:
            break
            
        }

        for i in 0..<35{
            yearsPicker.append(currentYear)
            currentYear -= 1
            print("\(yearsPicker[i])")
        }
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
            months.append(DateFormatter().monthSymbols[month].capitalized)
            month += 1
        }
//        if one.yearPickerView.inputView == pickerView {
//         self.pickerView.selectRow(0, inComponent: 0, animated: true)
//        }
        one.yearPickerView.delegate = self
        self.months = months
        pickerView.delegate = self
        pickerView.dataSource = self
        
        one.monthPickerView.delegate = self
        
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
            one.monthPickerView.text = months[row]
        case 1:
            one.yearPickerView.text = "\(yearsPicker[row])"
        default:
            break
        }
    }
        /*func monthChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
            //var components = Calendar.current.shortMonthSymbols
        //components = "\(Calendar.current.shortMonthSymbols)
       dateFormatter.dateFormat = "MMM"
//        dateFormatter.dateStyle = .medium
        
        var strDate = dateFormatter.string(from: datePickerView.date)
        //strDate = "\(components)"
        one.monthPickerView.text = strDate
        
    }*/
    



}
