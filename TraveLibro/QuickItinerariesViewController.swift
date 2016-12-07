//
//  QuickItinerariesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItinerariesViewController: UIViewController, UITextFieldDelegate {
    var whichView: String!
    var pageIndex = 0
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    var one = QuickItineraryOne()
    var two = QuickItineraryTwo()
    var three = QuickItineraryThree()
    
    func searchCountry(search:String) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view: \(whichView)")
        
        
        
        switch whichView {
        case "One":
            one = QuickItineraryOne(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 300))
            one.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
                      // one.nextButton.addTarget(self, action:#selector(QuickItinerariesViewController.nextButtonPressed(_:)), for: .touchUpInside)
            
            
           //            textField(textField: one.durationTextField, shouldChangeCharactersInRange: one.durationTextField.text?.startIndex ..< 3, replacementString: "999")
            //currentMonth = (dateFormatter.string(from: date as Date))
            
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
//            five.saveButton.addTarget(self, action: #selector(QuickItinerariesViewController.saveButtonPressed(_:)), for: .touchUpInside)
//
        default:
            break
            
        }
        
       
    
   
    //func nextButtonPressed(_ sender: UIButton){
       //let storyboard = UIStoryboard(name: "QuickItineraryTwo", bundle: Bundle(for: TabPageViewController.self))
        
   // }

   

    
    
    //One
    
           }

        
   //        if one.yearPickerView.inputView == pickerView {
//         self.pickerView.selectRow(0, inComponent: 0, animated: true)
//        }
    
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
    //Two
    
   
    
    
    //three
    //    func increaseHeight(buttonHeight: Int) {
//        if three.quickThree.frame.height <= view.frame.height - 100{
//            three.quickThree.animation.makeHeight(CGFloat(buttonHeight)).animate(0.5)
//        }
//    }

//five
//    func saveButtonPressed(_ sender: UIButton) {
//        request.postQuickitenary(json: quickItinery,  completion: {(response) in
//            DispatchQueue.main.async(execute: {
//                
//                if response.error != nil {
//                    
//                    print("error: \(response.error!.localizedDescription)")
//                    
//                }
//                else if response["value"].bool! {
//                    print("nothing")
//                }
//                else {
//                    print("nothing")
//                    
//                }
//            })
//        })
//    }
//

}
