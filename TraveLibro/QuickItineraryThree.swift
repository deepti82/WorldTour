//
//  QuickItineraryThree.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 06/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItineraryThree: UIView, UITextFieldDelegate {

   
    @IBOutlet weak var addCountry: UIButton!
    @IBOutlet var quickThree: UIView!
    
    @IBOutlet weak var cityVisitedText: UITextField!
    @IBOutlet weak var countryVisitedText: UITextField!
    @IBOutlet weak var showCountryCityView: UIView!
    @IBOutlet weak var cityDropDown: UIButton!
    @IBOutlet weak var countryDropDown: UIButton!
    
    let verticalLayout = VerticalLayout(width: 360)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    
        addCountry.layer.cornerRadius = 5
//        addCountry.layer.cornerRadius = 5
//        addCity.layer.cornerRadius = 5
       
        cityVisitedText.delegate = self
        countryVisitedText.delegate = self
        countryDropDown.isHidden = true
        cityDropDown.isHidden = true
        showCountryCityView.addSubview(verticalLayout)

 addCountry.addTarget(self, action: #selector(addCountryFunction(_:)), for: .touchUpInside)
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        textField.resignFirstResponder()
//        one.durationTextField.resignFirstResponder()
//        one.monthPickerView.resignFirstResponder()
//        one.tripTitle.resignFirstResponder()
//        one.yearPickerView.resignFirstResponder()
        cityVisitedText.resignFirstResponder()
        countryVisitedText.resignFirstResponder()
        return true
        
    }
    func addCountryFunction(_ sender: UIButton) {
        
        let showCountryButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
        //showCountryButton.backgroundColor = UIColor.yellow
        showCountryButton.layoutIfNeeded()
        showCountryButton.titleLabel?.textAlignment = NSTextAlignment.left
        showCountryButton.setTitleColor(UIColor.black, for: .normal)
        verticalLayout.addSubview(showCountryButton)
        let cancelLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 10, height: 10))
        cancelLabel.font = UIFont(name: "FontAwesome", size: 15)
        cancelLabel.text = String(format: "%C", faicon["close"]!)
        cancelLabel.textColor = UIColor(colorLiteralRed: 35/255, green: 45/255, blue: 74/255, alpha: 1)
        showCountryButton.addSubview(cancelLabel)
        
        showCountryButton.addTarget(self, action: #selector(removeCountryCity(_:)), for: .touchUpInside)
        //increaseHeight(buttonHeight: 20)
        if countryVisitedText != nil && cityVisitedText != nil {
            styleHorizontalButton(showCountryButton, buttonTitle: "\(countryVisitedText.text!), \(cityVisitedText.text!)")
        }
    }
    
    
    func styleHorizontalButton(_ button: UIButton, buttonTitle: String) {
        
        //        print("inside the style horizontal button")
        //button.backgroundColor = UIColor.clear
        button.titleLabel!.font = avenirFont
       // button.titleLabel?.backgroundColor = UIColor.black
        button.setTitle(buttonTitle, for: UIControlState())
        button.setTitleColor(mainBlueColor, for: UIControlState())
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        
    }
    
    func removeCountryCity(_ sender: UIButton){
        sender.removeFromSuperview()
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "QuickItineraryThree", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view);
         }
    
   }
