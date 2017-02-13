//
//  QuickItinerariesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import iCarousel

class QuickItinerariesViewController: UIViewController, UITextFieldDelegate , iCarouselDelegate, iCarouselDataSource{
    var whichView: String!
    var pageIndex = 0
    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?
    let quickOne = QuickIteneraryOne()
    let quickTwo = QuickIteneraryTwo()
    var one = QuickItineraryOne()
    var two = QuickItineraryTwo()
    var three = QuickIteneraryThree()
     var viewControllers1 = [UIViewController]()
    @IBOutlet var carouselView: iCarousel!
    func searchCountry(search:String) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewControllers1.append(quickOne)
        viewControllers1.append(quickTwo)
//        viewControllers1.append(quickThree)
//        viewControllers1.append(quickFour)
//        viewControllers1.append(quickFive)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView.type = .coverFlow
        let quickOne: QuickIteneraryOne = (storyboard?.instantiateViewController(withIdentifier: "quickOne")) as! QuickIteneraryOne
        let quickTwo: QuickIteneraryTwo = (storyboard?.instantiateViewController(withIdentifier: "quickTwo")) as! QuickIteneraryTwo
        let quickThree: QuickIteneraryThree = (storyboard?.instantiateViewController(withIdentifier: "quickThree")) as! QuickIteneraryThree
        let quickFour: QuickIteneraryFour = (storyboard?.instantiateViewController(withIdentifier: "quickFour")) as! QuickIteneraryFour
        let quickFive: QuickIteneraryFive = (storyboard?.instantiateViewController(withIdentifier: "quickFive")) as! QuickIteneraryFive

        viewControllers1.append(quickOne)
        viewControllers1.append(quickTwo)
        viewControllers1.append(quickThree)
        viewControllers1.append(quickFour)
        viewControllers1.append(quickFive)
        
        print("view: \(whichView)")
        
        
        
//        switch whichView {
//        case "One":
//            one = QuickItineraryOne(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 300))
//            one.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
//                      // one.nextButton.addTarget(self, action:#selector(QuickItinerariesViewController.nextButtonPressed(_:)), for: .touchUpInside)
//            
//            
//           //            textField(textField: one.durationTextField, shouldChangeCharactersInRange: one.durationTextField.text?.startIndex ..< 3, replacementString: "999")
//            //currentMonth = (dateFormatter.string(from: date as Date))
//            
//            //var strDate = dateFormatter.string(from: datePickerView.date)
//           //let str = "\(components.month)"
//            //one.monthPickerView.text = str
//            //datePickerView.datePickerMode = UIDatePickerMode.date
//            //one.monthPickerView.inputView = datePickerView
//           // datePickerView.addTarget(self, action: #selector(QuickItinerariesViewController.monthChanged(_:)), for: UIControlEvents.valueChanged)
//                   case "Two":
//            let two = QuickItineraryTwo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 450))
//            two.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
//            self.view.addSubview(two)
//           
//            
//        case "Three":
//            let three = ItineraryThree(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 350))
//            three.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
//            self.view.addSubview(three)
//            
//            
//        case "Four":
//            let four = QuickItineraryFour(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 400))
//            four.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
//            self.view.addSubview(four)
//        case "Five":
//            let five = QuickItineraryFive(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 200))
//            five.center = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2)
//            self.view.addSubview(five)
////            five.saveButton.addTarget(self, action: #selector(QuickItinerariesViewController.saveButtonPressed(_:)), for: .touchUpInside)
////
//        default:
//            break
//            
//        }
//        
       
   
   
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

    func numberOfItems(in carousel: iCarousel) -> Int {
       return viewControllers1.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let one = QuickItineraryOne(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 300))
      let   two = QuickItineraryTwo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 450))

        return one
        
    }
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return 1.1
        }
            return value
        
    }
}
