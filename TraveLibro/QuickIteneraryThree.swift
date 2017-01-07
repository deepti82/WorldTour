//
//  QuickIteneraryThree.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 07/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickIteneraryThree: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var countries: JSON = []
    @IBOutlet weak var countryListTable: UITableView!
    @IBOutlet weak var cityVisitedButton: UIButton!
    @IBOutlet weak var countryVisitedButton: UIButton!
    @IBOutlet weak var addCountry: UIButton!
    @IBOutlet weak var cityVisited: UITextField!
    @IBOutlet weak var countryVisited: UITextField!
    let verticalLayout = VerticalLayout(width: 300)
    var viewAdded = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: cityVisited)
        
        //        self.scrView.insertSubview(self.verticalLayout, at: 0)
        if quickItinery["countryVisited"] == nil {
            quickItinery["countryVisited"] = []
        }
        
        if selectedCountry.count != 0 {
            countryVisited.text = selectedCountry[0]["name"].string
        }
        
        //        getCountry()
        addCountry.layer.cornerRadius = 5
        addCountry.addTarget(self, action: #selector(addCountryFunction(_:)), for: .touchUpInside)
//        showCountryCityVisited.addSubview(verticalLayout)
        cityVisited.delegate = self
        countryVisited.delegate = self
        
        countryListTable.delegate = self
        countryListTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewAdded = false
        
        if selectedCountry.count != 0 {
            countryVisited.text = selectedCountry["name"].string
        }
        
        if selectedCity.count != 0 {
            
            cityVisited.text = createCity(cities: selectedCity)
            
        } else {
            cityVisited.text = ""
        }
        
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return quickItinery["countryVisited"].count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quickItinery["countryVisited"][section]["cityVisited"].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.countryListTable.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
                
        cell.textLabel?.text = quickItinery["countryVisited"][indexPath.section]["cityVisited"][indexPath.row]["name"].stringValue
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        img.image = UIImage(named:"cross_icon")
        vw.addSubview(img)
        cell.accessoryView = vw
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    
//        let v = UITableViewHeaderFooterView()
//        v.textLabel?.text = "Header Text"
//        v.tag = section
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(QuickIteneraryThree.headerTapped(_:)))
////        tapRecognizer.delegate = self
//        v.textLabel?.textColor = UIColor.white
//        v.tintColor = endJourneyColor
//                v.addGestureRecognizer(tapRecognizer)
//        return v
//        
//    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){

        view.tintColor = endJourneyColor
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        let tap = UITapGestureRecognizer(target: self, action: #selector(QuickIteneraryThree.headerTapped(_:)))
        header.tag = section

        header.addGestureRecognizer(tap)
        
    }
    
    
    
    func headerTapped(_ sender: UITableViewHeaderFooterView) {
        print("header clicked")
        print(sender.tag)
        quickItinery["countryVisited"].arrayObject?.remove(at: sender.tag)
        countryListTable.reloadData()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return quickItinery["countryVisited"][section]["name"].string
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        quickItinery["countryVisited"][indexPath.section]["cityVisited"].arrayObject?.remove(at: indexPath.row)
        countryListTable.reloadData()
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("on text field")
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
//            self.cityTableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func addCountryFunction(_ sender: UIButton) {
        if !viewAdded {
            viewAdded = true
            var a: JSON = ["country":selectedCountry["_id"], "name":selectedCountry["name"], "cityVisited":selectedCity]
            if quickItinery["countryVisited"].contains(where: {$0.1["country"] == selectedCountry["_id"]}) {
                let b = quickItinery["countryVisited"].index(where: {$0.1["country"] == selectedCountry["_id"]})
                let c = quickItinery["countryVisited"][b!].0
                
                quickItinery["countryVisited"][Int(c)!] = a
                countryListTable.reloadData()
            }else{
                quickItinery["countryVisited"].arrayObject?.append(a.object)
                countryListTable.reloadData()
                
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

class labpad: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
        
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
}
