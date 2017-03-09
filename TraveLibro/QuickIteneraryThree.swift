//
//  QuickIteneraryThree.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 07/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickIteneraryThree: UIViewController, UITextFieldDelegate {
    
    var countries: JSON = []
    @IBOutlet weak var cityVisitedButton: UIButton!
    @IBOutlet weak var countryVisitedButton: UIButton!
    @IBOutlet weak var addCountry: UIButton!
    @IBOutlet weak var cityVisited: UILabel!
    @IBOutlet weak var countryVisited: UILabel!
    @IBOutlet weak var quickScroll: UIScrollView!
    @IBOutlet weak var blurBG: UIView!
    @IBOutlet weak var countryView: UIView!
    @IBOutlet weak var cityView: UIView!
    var uploadingView: UploadingToCloud!
//    let verticalLayout = VerticalLayout(width: 300)
    var verticalLayout: VerticalLayout!
    var viewAdded = false
    
    var loader = LoadingOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("internet connection")
        print(isConnectedToNetwork())
    
//        loader.showOverlay(self.view)
        cityPlaceholder()
        countryPlaceholder()
        cityView.underlined()
        countryView.underlined()
        cityVisited.layer.zPosition = 10
        countryVisited.layer.zPosition = 100000
//        countryView.layer.zPosition = -1
        self.view.bringSubview(toFront: cityVisited)
        self.verticalLayout = VerticalLayout(width:self.quickScroll.frame.width)
        
        //        self.scrView.insertSubview(self.verticalLayout, at: 0)
        if quickItinery["countryVisited"] == nil {
            quickItinery["countryVisited"] = []
        }
        
        if selectedCountry.count != 0 {
            countryVisited.text = selectedCountry[0]["name"].string
        }
        
        self.quickScroll.addSubview(self.verticalLayout)
        
        //        getCountry()
        
        let tapout1 = UITapGestureRecognizer(target: self, action: #selector(self.cityClicked(_:)))
        tapout1.numberOfTapsRequired = 1
        cityVisited.addGestureRecognizer(tapout1)
        
        let tapout2 = UITapGestureRecognizer(target: self, action: #selector(self.countryClicked(_:)))
        tapout2.numberOfTapsRequired = 1
        countryVisited.addGestureRecognizer(tapout2)
        
        addCountry.layer.cornerRadius = 5
        addCountry.addTarget(self, action: #selector(addCountryFunction(_:)), for: .touchUpInside)
//        showCountryCityVisited.addSubview(verticalLayout)
        transparentCardWhite(blurBG)
        
        print("heightscroll\(quickScroll)")
        print("blurblurblur\(blurBG)")
        
        createLayout();
        
    }
    
    func cityPlaceholder() {
        cityVisited.attributedText = NSAttributedString(string:  "Add City", attributes: [NSForegroundColorAttributeName: mainBlueColor])
    }

    func countryPlaceholder() {
        countryVisited.attributedText = NSAttributedString(string:  "Add Country", attributes: [NSForegroundColorAttributeName: mainBlueColor])
    }

    
    func cityClicked(_ sender: UITapGestureRecognizer) {
        selectedStatus = "city"
        let next = self.storyboard?.instantiateViewController(withIdentifier: "QITableView") as! QuickIteneraryTableViewController
        self.present(next, animated: true, completion: nil)
    }
    
    func countryClicked(_ sender: UITapGestureRecognizer) {
        selectedStatus = "country"
        let next = self.storyboard?.instantiateViewController(withIdentifier: "QITableView") as! QuickIteneraryTableViewController
        self.present(next, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAdded = false
        showInternetStrip()
        fillText()
        
    }
    
    func showInternetStrip() {
        
        print(isConnectedToNetwork())
        
        if uploadingView != nil {
            uploadingView.removeFromSuperview()
        }
        if !isConnectedToNetwork() {
          uploadingView = UploadingToCloud(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 23))
            uploadingView.uploadText.text = "No internet connection."
        self.view.addSubview(uploadingView)
        }
        
    }
    
    func fillText() {
        if selectedCountry.count != 0 {
            countryVisited.text = selectedCountry["name"].string
        }else{
            countryPlaceholder()
        }
        
        if selectedCity.count != 0 {
            cityVisited.text = createCity(cities: selectedCity)
        } else {
            cityPlaceholder()
        }
    }
    
    
    
    func createLayout() {
        cityPlaceholder()
        countryPlaceholder()
        fillText()
        verticalLayout.removeAll()
        
        for (n,i) in quickItinery["countryVisited"] {
            
            let quickCountry = QuickCountry(frame: CGRect(x: 0, y: 3, width: 327, height: 30))
            
            quickCountry.countryName.text = i["name"].stringValue
            quickCountry.tag = Int(n)!
            quickCountry.countryTag = Int(n)!
            quickCountry.parentView = self
            verticalLayout.addSubview(quickCountry)
            
            for (no,ob) in i["cityVisited"] {
                let quickCity = QuickCity(frame: CGRect(x: 0, y: 3, width: 327, height: 30))
                quickCity.parentView = self
                quickCity.cityName.text = ob["name"].stringValue
                quickCity.countryTag = Int(n)!
                quickCity.tag = Int(no)!
                verticalLayout.addSubview(quickCity)
            }
        }
        scrollChange()
    }
    
    func scrollChange() {
        self.verticalLayout.layoutSubviews()
        self.quickScroll.contentSize = CGSize(width: self.quickScroll.frame.width, height: self.verticalLayout.frame.height)
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
        print("in country function")
        if !viewAdded {
            viewAdded = true
            var a: JSON = ["country":selectedCountry["_id"], "_id":selectedCountry["_id"], "name":selectedCountry["name"], "cityVisited":selectedCity]
            if quickItinery["countryVisited"].contains(where: {$0.1["_id"] == selectedCountry["_id"]}) {
                let b = quickItinery["countryVisited"].index(where: {$0.1["_id"] == selectedCountry["_id"]})
                let c = quickItinery["countryVisited"][b!].0
                
                quickItinery["countryVisited"][Int(c)!] = a
                createLayout()
            }else{
                quickItinery["countryVisited"].arrayObject?.append(a.object)
                createLayout()
            }
            selectedCountry = []
            selectedCity = []
            fillText()
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
