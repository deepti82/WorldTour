//
//  QuickIteneraryThree.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 07/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickIteneraryThree: UIViewController, UITextFieldDelegate,  UITableViewDelegate {
    
    @IBOutlet weak var cityTableTitle: UILabel!
    @IBOutlet weak var countryTableTitle: UILabel!
    var countries: JSON = []
    @IBOutlet weak var cityTableView: UITableView!
    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var countryTableView: UITableView!
    @IBOutlet weak var showCountryCityVisited: UIView!
    @IBOutlet weak var cityVisitedButton: UIButton!
    @IBOutlet weak var countryVisitedButton: UIButton!
    @IBOutlet weak var addCountry: UIButton!
    @IBOutlet weak var cityVisited: UITextField!
    @IBOutlet weak var countryVisited: UITextField!
    let verticalLayout = VerticalLayout(width: 300)
    var viewAdded = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrView.insertSubview(self.verticalLayout, at: 0)
        if quickItinery["countryVisited"] == nil {
            quickItinery["countryVisited"] = []
        }
        
        if selectedCountry.count != 0 {
            countryVisited.text = selectedCountry[0]["name"].string
        }
        
        //        getCountry()
        addCountry.layer.cornerRadius = 5
        addCountry.addTarget(self, action: #selector(addCountryFunction(_:)), for: .touchUpInside)
        showCountryCityVisited.addSubview(verticalLayout)
        cityVisited.delegate = self
        countryVisited.delegate = self
        
        countryVisitedButton.isHidden = true
        cityVisitedButton.isHidden = true
        //        cityTableView.delegate = self
        //        cityTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewAdded = false
        
        if selectedCountry.count != 0 {
            countryVisited.text = selectedCountry["name"].string
        }
        
        if selectedCity.count != 0 {
            
            cityVisited.text = createCity(cities: selectedCity)
            
        }
        createCityCountry()
        
        
    }
    
    func createCity(cities:JSON) -> String {
        var a = ""
        if cities.count != 0 {
            for i in 0...cities.count - 1 {
                if i == 0 {
                    a = a + cities[i]["name"].stringValue
                }else{
                    a = a + ", " + cities[i]["name"].stringValue
                }
                
            }
        }
        
        return a
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            selectedStatus = "country"
            let next = self.storyboard?.instantiateViewController(withIdentifier: "QITableView") as! QuickIteneraryTableViewController
            self.present(next, animated: true, completion: nil)
        }else{
            selectedStatus = "city"
            let next = self.storyboard?.instantiateViewController(withIdentifier: "QITableView") as! QuickIteneraryTableViewController
            self.present(next, animated: true, completion: nil)
        }
    }
       
    func getCountry() {
        request.getAllCountries({(request) in
            self.countries = request["data"]
            self.cityTableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //  START CREATE COUNTRY-CITY VIEW
    
    func createCityCountry() {
        self.verticalLayout.removeAll()
        if quickItinery["countryVisited"].count != 0{
            for i in 0...quickItinery["countryVisited"].count - 1 {
                let three = ItineraryThree()
                three.frame = CGRect(x: 0, y: 5, width: 300, height: 30)
                three.index = i
                three.cityCountry.text = "\(quickItinery["countryVisited"][i]["name"]):  \(createCity(cities: quickItinery["countryVisited"][i]["cityVisited"]))"
                
                styleHorizontalButton(three)
                self.verticalLayout.addSubview(three)
                self.verticalLayout.layoutSubviews()
                self.scrView.contentSize = CGSize(width: self.verticalLayout.frame.width, height: self.verticalLayout.frame.height)
                
            }
        }
        
    }
    
    func addCountryFunction(_ sender: UIButton) {
        if !viewAdded {
            viewAdded = true
            var a: JSON = ["country":selectedCountry["_id"], "name":selectedCountry["name"], "cityVisited":selectedCity]
            if quickItinery["countryVisited"].contains(where: {$0.1["country"] == selectedCountry["_id"]}) {
                let b = quickItinery["countryVisited"].index(where: {$0.1["country"] == selectedCountry["_id"]})
                let c = quickItinery["countryVisited"][b!].0
                
                quickItinery["countryVisited"][Int(c)!] = a
                createCityCountry()
            }else{
                quickItinery["countryVisited"].arrayObject?.append(a.object)
                createCityCountry()
                
            }
            
        }
        
    }
    
    func styleHorizontalButton(_ button: UIView) {
        
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        
    }
    
    //  END CREATE COUNTRY-CITY VIEW
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityVisited.resignFirstResponder()
        countryVisited.resignFirstResponder()
        return true
    }
}
