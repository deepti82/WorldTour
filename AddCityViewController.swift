import UIKit
import SwiftyJSON
import SwiftHTTP
import CoreLocation

class AddCityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate {
    
    var places: [JSON] = []
    let locationManager = CLLocationManager()
    var locValue:CLLocationCoordinate2D!
    var locationData: String!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var mainTableView: UITableView!
    
    @IBAction func detectLocationButton(sender: AnyObject) {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        request.getLocation(locValue.latitude, long: locValue.longitude, completion: { (response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if (response.error != nil) {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                    
                else {
                    
                    if response["value"] {
                     
                        print("response: \(response)")
                        self.locationData = response["data"]["name"].string
                        print("location: \(self.locationData)")
                        
                        if self.locationData != nil {
                         
                            self.cityTextField.text = self.locationData
                            
                        }
                        
                    }
                    else {
                        
                        print("response error: \(response["data"])")
                        
                    }
                }
            })
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGroundBlur(self)
        
        self.title = "Where Do You Live?"
        
        cityTextField.attributedPlaceholder = NSAttributedString(string:  "Detect Location", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        cityTextField.returnKeyType = .Done
        cityTextField.delegate = self
        cityTextField.addTarget(self, action: #selector(AddCityViewController.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(-8, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(AddCityViewController.selectGender(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(8, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        mainTableView.tableFooterView = UIView()
        
//        if currentUser["homeCity"] != nil {
//            
//            cityTextField.text = currentUser["homeCity"].string!
////            addNationalityButton.hidden = true
////            userNationatilty.setTitle(currentUser["homeCountry"].string!, forState: .Normal)
//            
//        }
        
    }
    
    func selectGender(sender: UIButton?) {
        
        var cityName = ""
        
        print("city name: \(cityTextField.text), \(currentUser["_id"])")
        
        if cityTextField.text != nil {
            
         cityName = cityTextField.text!
            
        }
        
        request.editUser(currentUser["_id"].string!, editField: "homeCity", editFieldValue: cityName, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                    
                }
                
                else if response["value"] {
                    
                    print("response arrived!")
                    let selectGenderVC = self.storyboard!.instantiateViewControllerWithIdentifier("selectGender") as! SelectGenderViewController
                    self.navigationController?.pushViewController(selectGenderVC, animated: true)
                    
                }
                else {
                    
                    print("response error: \(response["data"])")
                    
                }
            })
            
        })
        
    }
    
    func textFieldDidChange(textfield: UITextField) {
        
        print("inside target function: \(cityTextField.text)")
        
        request.searchCity(cityTextField.text!, completion: {(response) in
            
            dispatch_async(dispatch_get_main_queue(), {
                
                if response.error != nil {
                    
                    print("error: \(response.error?.localizedDescription)")
                }
                    
                else {
                    
                    if response["value"] {
                        
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
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        mainTableView.hidden = false
        
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
//                if response["value"] {
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
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        cityTextField.resignFirstResponder()
        mainTableView.hidden = true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("in the count fn: \(places.count)")
        return places.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! addCityTableviewCell
        cell.placeName.text = places[indexPath.row]["description"].string!
//        print(places)
        cell.selectionStyle = .None
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("selected \(places[indexPath.row]["description"].string!)")
        cityTextField.text = places[indexPath.row]["description"].string!
        cityTextField.resignFirstResponder()
        mainTableView.hidden = true
        selectGender(nil)
        
    }

}

class addCityTableviewCell: UITableViewCell {
    
    @IBOutlet weak var placeName: UILabel!
    
}
