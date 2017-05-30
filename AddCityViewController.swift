import UIKit

import SwiftHTTP
import CoreLocation

class AddCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate {
    var loader = LoadingOverlay()
    var places: [JSON] = []
    var locationManager : CLLocationManager?
    var locValue:CLLocationCoordinate2D!
    var locationData: String!
    internal var isFromSettings: Bool!
    internal var isFromLocalLife = false
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var mainTableView: UITableView!
    
    //MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        self.title = "Where Do You Live?"
        
        cityTextField.attributedPlaceholder = NSAttributedString(string:  "Detect Location", attributes: [NSForegroundColorAttributeName: UIColor.white])
        cityTextField.returnKeyType = .done
        cityTextField.delegate = self
        cityTextField.addTarget(self, action: #selector(AddCityViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())        
        leftButton.frame = CGRect(x: -8, y: 0, width: 30, height: 30)
        
        if isFromSettings != nil && isFromSettings == true {
            leftButton.addTarget(self, action: #selector(self.saveCity), for: .touchUpInside)
            self.customNavigationBar(left: leftButton, right: nil)           
        }
        else {
            leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
            
            let rightButton = UIButton()
            rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
            rightButton.addTarget(self, action: #selector(AddCityViewController.saveCity), for: .touchUpInside)
            rightButton.frame = CGRect(x: 8, y: 8, width: 30, height: 30)
            self.customNavigationBar(left: leftButton, right: rightButton)
        }
        
        
        mainTableView.tableFooterView = UIView()
        
        self.detectLocation()
        
        if currentUser["homeCity"] != nil {
            cityTextField.text = currentUser["homeCity"].string!            
        }        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\n\n viewWillDisappear called ")
        if isFromSettings != nil && isFromSettings == true {
            self.saveCity()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveCity() {
        print("\n\n Save city called")
        var cityName = ""
        
        print("city name: \(cityTextField.text), \(currentUser["_id"]), \(currentUser["homeCity"].string)")        
        if self.cityTextField.text != "" {
            
            cityName = self.cityTextField.text!
            
            if currentUser["homeCity"].string == nil || self.cityTextField.text != currentUser["homeCity"].string!{
                request.editUser(currentUser["_id"].string!, editField: "homeCity", editFieldValue: cityName, completion: {(response) in
                    
                    DispatchQueue.main.sync(execute: {
                        print(response["value"])
                        
                        if response.error != nil {
                            
                            print("error: \(response.error?.localizedDescription)")
                            
                        } else if response["value"] == true {
                            currentUser = response["data"]
                            if self.isFromSettings != true {
                                if (Thread.isMainThread) {
                                    self.selectGender()
                                }
                                else {
                                    DispatchQueue.main.sync(execute: {
                                        self.selectGender()                                            
                                    })
                                }
                            }
                            else {
                                if (self.navigationController?.topViewController as? AddCityViewController) != nil {
                                    self.popVC(UIButton())
                                }
                            }
                        } else {
                            print("response error: \(response["data"])")
                        }
                    })
                    
                })
            }
            else{
                if self.isFromSettings != nil && self.isFromSettings == true {
                        if (self.navigationController?.topViewController as? AddCityViewController) != nil {
                            self.popVC(UIButton())
                        }
                }
                else {
                    self.selectGender()                        
                }
            }
            
        } else {
            self.alert(message: "Please Select City.", title: "Select City")
        }            
                
    }
    
    func selectGender() {
        print("\n\n selectGender called ")
        print("\n\n IsMainThread : \(Thread.isMainThread) \n\n")
        print("\n\n Top VC : \(self.navigationController?.topViewController)")
        
        if (self.navigationController?.topViewController?.isKind(of: AddCityViewController.self))! {
            let selectGenderVC = self.storyboard!.instantiateViewController(withIdentifier: "selectGender") as! SelectGenderViewController
            self.navigationController?.pushViewController(selectGenderVC, animated: true)            
        }
    }
    
    
    //MARK: - Text Field Delegate
    
    func textFieldDidChange(_ textfield: UITextField) {
        
        print("inside target function: \(cityTextField.text)")
        
        request.searchCity(cityTextField.text!, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                }
                    
                else {
                    
                    if response["value"].bool! {
                        
                        print("response arrived!")
                        print(response["data"]["predictions"].array!)
                        self.places = response["data"]["predictions"].array!
                        self.mainTableView.reloadData()
                        
                    }
                    else {
                        
                        print("response error: \(response["data"])")
                    }
                    
                }
                
            })
        })
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        mainTableView.isHidden = false
        
//        print("inside target function: \(cityTextField.text)")
//        
//        request.searchCity(cityTextField.text!, completion: {(response) in
//            
//            if response.error != nil {
//                
//                print("error: \(response.error?.localizedDescription)")
//            }
//                
//            else {
//                
//                if let abc = response["value"].string {
//                    
//                    print("response arrived!")
//                }
//                else {
//                    
//                    print("response error: \(response["data"])")
//                }
//                
//            }
//            
//        })
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        cityTextField.resignFirstResponder()
        mainTableView.isHidden = true
        
    }    
    
    
    //MARK: - Table view DataSource and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("in the count fn: \(places.count)")
        return places.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! addCityTableviewCell
        cell.placeName.text = places[(indexPath as NSIndexPath).row]["description"].string!
//        print(places)
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected \(places[(indexPath as NSIndexPath).row]["description"].string!)")
        cityTextField.text = places[(indexPath as NSIndexPath).row]["description"].string!
        cityTextField.resignFirstResponder()
        mainTableView.isHidden = true
        //saveCity()
        
    }
    
    
    //MARK: - -- Location --
    
    func detectLocation() {
        
        self.stopDetectingLocation()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startMonitoringSignificantLocationChanges()
        self.updateStatus(status: CLLocationManager.authorizationStatus())
    }
    
    func stopDetectingLocation() {
        locationManager?.stopUpdatingLocation()
        locationManager = nil
    }
    
    func updateStatus(status: CLAuthorizationStatus) {
        switch status {
            
        case CLAuthorizationStatus.notDetermined:
            self.requestAuthorization()
            break
            
        case CLAuthorizationStatus.authorizedAlways:
            fallthrough
        case CLAuthorizationStatus.authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            break
            
        case CLAuthorizationStatus.denied:
            fallthrough
        case CLAuthorizationStatus.restricted:            
            handleRestrictedMode(onVC: self)
            break
        }
    }
    
    func requestAuthorization() {
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
    }
    
    //MARK:-  Location Delegates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D!
       
        if(manager.location != nil) {
            locValue = manager.location!.coordinate
            
            self.stopDetectingLocation()
            
            request.getLocation(locValue.latitude, long: locValue.longitude, completion: { (response) in
                
                DispatchQueue.main.async(execute: {
                    print(response);
                    if (response.error != nil) {
                        print("error: \(response.error?.localizedDescription)")
                    }
                        
                    else {                        
                        if response["value"].boolValue {
                            
                            print("response: \(response)")
                            self.locationData = response["data"]["name"].string
                            print("location: \(self.locationData)")
                            
                            if self.locationData != nil {                                
                                self.cityTextField.text = self.locationData!
                                if (self.isFromSettings != nil && self.isFromSettings == true && self.isFromLocalLife == false) {
                                    //TODO:Check this if autoSave should be supported
                                }
                                else {
                                    //self.saveCity()
                                }
                            }
                        }
                        else {
                            
                            print("response error: \(response["data"])")
                            
                        }
                    }
                })
            })
        } else {
            print("Not able to detect the location");
        }        
    }    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Error while updating location " + error.localizedDescription)
        
    }    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("\n didChangeAuthorization : \(status.rawValue)")
        self.updateStatus(status: status)
    }    
    
}

class addCityTableviewCell: UITableViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    
}
