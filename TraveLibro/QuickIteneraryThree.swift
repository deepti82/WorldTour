//
//  QuickIteneraryThree.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 07/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickIteneraryThree: UIViewController, UITextFieldDelegate,  UITableViewDelegate {
    let three = QuickItineraryThree()
    @IBOutlet weak var cityTableTitle: UILabel!
    @IBOutlet weak var countryTableTitle: UILabel!
    var countries: JSON = []
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var showCountryCityVisited: UIView!
    @IBOutlet weak var cityVisitedButton: UIButton!
    @IBOutlet weak var countryVisitedButton: UIButton!
    @IBOutlet weak var addCountry: UIButton!
    @IBOutlet weak var cityVisited: UITextField!
    @IBOutlet weak var countryVisited: UITextField!
    let verticalLayout = VerticalLayout(width: 300)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedCountry.count != 0 {
            countryVisited.text = selectedCountry[0]["name"].string
        }
        //        getCountry()
        addCountry.layer.cornerRadius = 5
        addCountry.addTarget(self, action: #selector(addCountryFunction(_:)), for: .touchUpInside)
        showCountryCityVisited.addSubview(verticalLayout)
        cityVisited.delegate = self
        //        countryVisited.delegate = self
        
        countryVisitedButton.isHidden = true
        cityVisitedButton.isHidden = true
        //        cityTableView.delegate = self
        //        cityTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if selectedCountry.count != 0 {
            countryVisited.text = selectedCountry["name"].string
        }
        
        
        if selectedCity.count != 0 {
            var a = ""
            for i in 0 ... selectedCity.count - 1 {
                if i == 0 {
                    a = a + selectedCity[i]["name"].stringValue
                }else{
                    a = a + ", " + selectedCity[i]["name"].stringValue
                }
                
            }
            cityVisited.text = a
        }
        
    }
    
    @IBAction func countryChange(_ sender: UITextField) {
        selectedStatus = "country"
        let next = self.storyboard?.instantiateViewController(withIdentifier: "QITableView") as! QuickIteneraryTableViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func cityChange(_ sender: UITextField) {
        selectedStatus = "city"
        let next = self.storyboard?.instantiateViewController(withIdentifier: "QITableView") as! QuickIteneraryTableViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func getCountry() {
        request.getAllCountries({(request) in
            self.countries = request["data"]
            self.cityTableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addCountryFunction(_ sender: UIButton) {

        
                //showCountryButton.backgroundColor = UIColor.yellow
        three.quickThree.frame = CGRect(x: 14 , y: 209, width: 300, height: 58)
        verticalLayout.addSubview(three.showCountryButton)
        three.showCountryButton.addSubview(three.cancelLabel)
        
        three.showCountryButton.addTarget(self, action: #selector(removeCountryCity(_:)), for: .touchUpInside)
        //increaseHeight(buttonHeight: 20)
        if countryVisited != nil && cityVisited != nil {
            var a:JSON = ["name":"\(countryVisited.text!):  \(cityVisited.text!)"]
            destinationVisited.arrayObject?.append(a.object)
            styleHorizontalButton(three.showCountryButton, buttonTitle: "\(countryVisited.text!):  \(cityVisited.text!)")
            three.showCountryButton.translatesAutoresizingMaskIntoConstraints = true
            
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityVisited.resignFirstResponder()
        countryVisited.resignFirstResponder()
        return true
        
    }
    
    //    func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1
    //    }
    
    //    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Countries
    //        print(self.countries[indexPath.row]["name"])
    //        cell.textLabel?.text = self.countries[indexPath.row]["name"].stringValue
    //        return cell
    //
    //    }
    
    
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //
    //        return countries.count
    //        
    //    }
    
}

class Countries: UITableViewCell {
    
}
