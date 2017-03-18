//
//  NearMeDetailViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 21/11/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class NearMeDetailViewController: UIViewController {
    
    var nearMeDetailJSON: JSON!
    var nearMePlaceId: String!
    var nearMeRating: Int!
    
    var currentLat: Double!
    var currentLong: Double!
    
    var nearMeLat: Double!
    var nearMeLong: Double!
    let border = CALayer()
    let layer1 = CAShapeLayer()
    
    @IBOutlet weak var dropShadow: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var openingHours: UILabel!
    @IBOutlet weak var directions: UIButton!
    @IBOutlet var stars: [UIButton]!
    var nearMeType = ""
    var nearMeDistance = NSMutableAttributedString()
    var nearMeAddress = NSMutableAttributedString()
    var nearMePhone = NSMutableAttributedString()
    var nearMeOpeningHours = NSMutableAttributedString()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        detailView.layer.shadowColor = UIColor.black.cgColor
//        detailView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
//        detailView.layer.shadowOpacity = 1.0

        
//        let width = CGFloat(2)
//        border.frame = CGRect(x: 0, y: self.detailView.frame.height - width, width: self.view.frame.size.width, height: 2)
//        border.borderColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.5).cgColor
//        border.borderWidth = width
//        self.detailView.layer.addSublayer(border)
//        self.detailView.layer.masksToBounds = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        getDarkBackGround(self)
        navigationController?.hidesBarsOnSwipe = false
        detailView.layer.cornerRadius = 10
        detailView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        detailView.isHidden = true
        
//        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: self.dropShadow.frame.origin.y, width: screenWidth, height: 4))
//        self.layer1.masksToBounds = false
//        self.layer1.shadowColor = UIColor.black.cgColor
//        self.layer1.shadowOffset = CGSize(width: 0.0, height: 5.0)
//        self.layer1.shadowOpacity = 0.5
//        self.layer1.shadowPath = shadowPath.cgPath
//        self.dropShadow.layer.addSublayer(self.layer1)
        
//        directions.layer.borderWidth = 2.0
//        directions.layer.borderColor = mainOrangeColor.cgColor
//        directions.layer.cornerRadius = 5.0
//        directions.clipsToBounds = true
        
        getPlaceDetail()
        setTopNavigation(nearMeType)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
    }
    
    func getPlaceDetail() {
        request.getNearMeDetail(placeId: nearMePlaceId, completion: {(response) in
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    print("error: \(response.error!.localizedDescription)")
                } else if response["value"].bool! {
                    self.nearMeDetailJSON = response["data"]
                    
                    self.name.text = self.nearMeDetailJSON["name"].string!
                    
                    self.nearMeLat = self.nearMeDetailJSON["geometry"]["location"]["lat"].double!
                    self.nearMeLong = self.nearMeDetailJSON["geometry"]["location"]["lng"].double!
                    
                    let currentCoordinate = CLLocation(latitude: self.currentLat, longitude: self.currentLong)
                    let nearMeCoordinate = CLLocation(latitude: self.nearMeLat, longitude: self.nearMeLong)
                    let distanceInMeters = currentCoordinate.distance(from: nearMeCoordinate)
                    
                    self.nearMeDistance = NSMutableAttributedString(string: "Distance from You :", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!])
                    self.nearMeDistance.append(NSAttributedString(string: " \(Float(distanceInMeters))m", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!]))
                    self.distance.attributedText = self.nearMeDistance
                    
                    if self.nearMeDetailJSON["vicinity"].string != nil && self.nearMeDetailJSON["vicinity"].string != "" {
                    
                        self.nearMeAddress = NSMutableAttributedString(string: "Address :", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
                        self.nearMeAddress.append(NSAttributedString(string: " \(self.nearMeDetailJSON["vicinity"].string!)", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
                        self.address.attributedText = self.nearMeAddress
                        
//
                        
                    } else {
                        self.address.isHidden = true
                    }
                    
                    if self.nearMeDetailJSON["international_phone_number"].string != nil && self.nearMeDetailJSON["international_phone_number"].string != "" {
                    
                        self.nearMePhone = NSMutableAttributedString(string: "Phone :", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
                        self.nearMePhone.append(NSAttributedString(string: " \(self.nearMeDetailJSON["international_phone_number"])", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
                        self.phone.attributedText = self.nearMePhone
                        let tap = UITapGestureRecognizer(target: self, action: #selector(NearMeDetailViewController.callTap(_:)))
                        self.phone.addGestureRecognizer(tap)
                        //UIApplication.shared.open(URL(string: "tel://\(self.nearMeDetailJSON["international_phone_number"].string!)")!)
                        
                    } else {
                        self.phone.isHidden = true
                    }
                    
                    if self.nearMeDetailJSON["opening_hours"]["weekday_text"][self.getWeekDay()!].string != nil && self.nearMeDetailJSON["opening_hours"]["weekday_text"][self.getWeekDay()!].string != "" {
                    
                        self.nearMeOpeningHours = NSMutableAttributedString(string: "Opening Hours :", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 14)!])
                        self.nearMeOpeningHours.append(NSAttributedString(string: " \(self.nearMeDetailJSON["opening_hours"]["weekday_text"][self.getWeekDay()!])", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 14)!]))
                        self.openingHours.attributedText = self.nearMeOpeningHours
                        
                    } else {
                        self.openingHours.isHidden = true
                    }
                    
                    for star in self.stars {
                        star.setImage(UIImage(named: "star_uncheck")?.withRenderingMode(.alwaysTemplate), for: UIControlState())
                        star.setImage(UIImage(named: "star_check")?.withRenderingMode(.alwaysTemplate), for: .selected)
                        star.setImage(UIImage(named: "star_check")?.withRenderingMode(.alwaysTemplate), for: [.highlighted, .selected])
                        star.adjustsImageWhenHighlighted = false
                    }
                    
                    if self.nearMeRating != nil {
                        for (index, star) in self.stars.enumerated() {
                            star.isSelected = index < self.nearMeRating
                        }
                    }
                    
                    self.detailView.isHidden = false
                    
                } else {
                    print("response error")
                }
            })
        })
    }
    
    @IBAction func directionsClick(_ sender: AnyObject) {
        let latitude: CLLocationDegrees = nearMeLat
        let longitude: CLLocationDegrees = nearMeLong
        
        let regionDistance: CLLocationDistance = 1000000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.nearMeDetailJSON["name"].string!
        mapItem.openInMaps(launchOptions: options)
    }
    
    func callTap(_ sender: UITapGestureRecognizer) {
        let num = "telprompt://\(self.nearMeDetailJSON["international_phone_number"].string!)".replacingOccurrences(of: "-", with: "").replacingOccurrences(of: " ", with: "")
        let url: URL = URL(string: num)!
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    func getWeekDay() -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myCalendar = Calendar(identifier: .gregorian)
        var weekDay = myCalendar.component(.weekday, from: Date())
        print("weekDay: \(weekDay)")
        
        if weekDay == 1 {
            weekDay = 8
        }
        weekDay -= 2
        return weekDay
    }

    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
