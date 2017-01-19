//
//  LocalLifeRecommendationViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 01/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

var globalLocalLife:LocalLifeRecommendationViewController!

import UIKit
import CoreLocation

class LocalLifeRecommendationViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate {

    var addView:AddActivityNew!
    var backView:UIView!
    var newScroll:UIScrollView!
    var titleLabel:UILabel!
    var locationData = ""
    let locationManager = CLLocationManager()
    var isSameCity = false
    
    @IBOutlet weak var thisScroll: UIScrollView!
    var layout:VerticalLayout!
    
    @IBOutlet weak var plusButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        globalLocalLife = self
        getDarkBackGround(self)
        self.layout = VerticalLayout(width:screenWidth)
        self.setNavigationBarItemText("Local Life")
   
        self.thisScroll.addSubview(layout)
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 20)
        titleLabel.text = "Experience ... Like A Local"
        titleLabel.font = UIFont(name: "Avenir-Roman", size: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        layout.addSubview(titleLabel)
        

        let myView = LocalLifeRecommends(frame: CGRect(x: 0, y: -8, width: self.view.frame.width, height: 400))
        myView.photoTop.image = UIImage(named: "restaurantsLocalLife")
        myView.topLabel.text = "Restaurants and Bars"
        myView.photoBottom1.image = UIImage(named: "naturesLocalLife")
        myView.bottomLabel1.text = "Nature and Parks"
        myView.photoBottom2.image = UIImage(named: "sightsLocalLife")
        myView.bottomLabel2.text = "Sights and Landmarks"
        layout.addSubview(myView)
        
        let myView2 = LocalLifeRecommends(frame: CGRect(x: 0, y: -8, width: self.view.frame.width, height: 400))
        myView2.photoTop.image = UIImage(named: "museumsLocalLife")
        myView2.topLabel.text = "Museums and Galleries"
        myView2.photoBottom1.image = UIImage(named: "adventureLocalLife")
        myView2.bottomLabel1.text = "Adventure and Excursions"
        myView2.photoBottom2.image = UIImage(named: "bgzoosandaqua")
        myView2.bottomLabel2.text = "Zoos and Aquariums"
        layout.addSubview(myView2)
        
        let myView3 = LocalLifeRecommends(frame: CGRect(x: 0, y: -8, width: self.view.frame.width, height: 400))
        myView3.photoTop.image = UIImage(named: "bgeventsandfestival")
        myView3.topLabel.text = "Events and Festival"
        myView3.photoBottom1.image = UIImage(named: "bgshopping")
        myView3.bottomLabel1.text = "Shopping"
        myView3.photoBottom2.image = UIImage(named: "image1")
        myView3.bottomLabel2.text = "Beaches"
        layout.addSubview(myView3)
        
        let myView4 = LocalLifeRecommends(frame: CGRect(x: 0, y: -8, width: self.view.frame.width, height: 400))
        myView4.photoTop.image = UIImage(named: "bgreligious")
        myView4.topLabel.text = "Religious"
        myView4.photoBottom1.image = UIImage(named: "bgcinemasandtheatre")
        myView4.bottomLabel1.text = "Cinemas and Theatres"
        myView4.photoBottom2.image = UIImage(named: "bghotelsandaccom")
        myView4.bottomLabel2.text = "Hotels and accommodations"
        layout.addSubview(myView4)
        
        let myView5 = LocalLifeRecommends(frame: CGRect(x: 0, y: -16, width: self.view.frame.width, height: 188))
        myView5.photoTop.isHidden = true
        myView5.clipsToBounds = true
        myView5.photoBottom1.image = UIImage(named: "bgairport")
        myView5.bottomLabel1.text = "Airport"
        myView5.photoBottom2.image = UIImage(named: "bgother")
        myView5.bottomLabel2.text = "Others"

        layout.addSubview(myView5)

        let footer = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 60, width: self.view.frame.width, height: 60))
        self.view.addSubview(footer)
        
        self.detectLocation(UIButton())
        
       
        
        self.changeAddButton(false)
        

        self.addHeightToLayout();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        globalNavigationController = self.navigationController
    }
    
    func addHeightToLayout() {
        self.layout.layoutSubviews()
        self.thisScroll.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height + 60)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkInTap(_ sender: UIButton) {
        
        print("checkInButtonWasTapped")
        let checkInOneVC = storyboard?.instantiateViewController(withIdentifier: "checkInSearch") as! CheckInSearchViewController
        self.navigationController?.pushViewController(checkInOneVC, animated: true)
        
    }
    
    func categoryTap(_ sender: Any) {
        
    }
    
    @IBAction func addAction(_ sender: Any) {
        if(!self.isSameCity) {
            let alertController = UIAlertController(title: "", message:
                "You can create your Local Life activity only in the city you live in. If you wish to change the city you live in, go to Settings.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.cancel,handler: nil))
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            //Add Dard Blur Background
            var darkBlur: UIBlurEffect!
            var blurView: UIVisualEffectView!
            self.backView = UIView();
            self.backView.frame = self.view.frame
            self.view.addSubview(self.backView)
            self.backView.frame = self.view.frame
            darkBlur = UIBlurEffect(style: .dark)
            blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame.size.height = self.backView.frame.height
            blurView.frame.size.width = self.backView.frame.width
            blurView.layer.zPosition = -1
            blurView.isUserInteractionEnabled = false
            self.backView.addSubview(blurView)
            let vibrancyEffect = UIVibrancyEffect(blurEffect: darkBlur)
            let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
            blurView.contentView.addSubview(vibrancyEffectView)
            self.newScroll = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height - 60))
            self.backView.addSubview(self.newScroll)
            self.addView = AddActivityNew()
            //        self.addView.buddyAdded(myJourney["buddies"].arrayValue)
            self.addView.typeOfAddActivtiy = "CreateLocalLife"
            self.addView.frame = self.view.frame
            self.addView.newScroll = self.newScroll;
            self.newScroll.addSubview(self.addView)
            self.newScroll.contentSize.height = self.view.frame.height
            backView.addSubview(newScroll)
            
            let leftButton = UIButton()
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
            leftButton.addTarget(self, action: #selector(self.closeAdd(_:)), for: .touchUpInside)
            
            let rightButton = UIButton()
            rightButton.frame = CGRect(x: 0, y: 5, width: 50, height: 35)
            
            rightButton.setTitle("Post", for: UIControlState())
            rightButton.titleLabel?.font = avenirBold
            rightButton.titleLabel!.font = UIFont (name: "avenirBold", size: 20)
            rightButton.addTarget(self, action: #selector(self.newPost(_:) ), for: .touchUpInside)
            globalNavigationController.topViewController?.title = "Add Activity"
            globalNavigationController.topViewController?.customNavigationBar(left: leftButton, right: rightButton)
            addView.layer.zPosition = 10
            backView.layer.zPosition = 10
            newScroll.contentSize.height = self.view.frame.height
        }

    }
    
    
    func closeAdd(_ sender: UIButton) {
        hideAddActivity()
    }
    
    func newPost(_ sender: UIButton) {
        hideAddActivity()
    }
    
    func hideAddActivity() {
        addView.removeFromSuperview()
        backView.removeFromSuperview()

        self.setNavigationBarItemText("Local Life")
        let rightBarButton = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: {})
        self.addView.addVideoToBlock(video: info["UIImagePickerControllerMediaURL"] as! URL)
    }
    
    func changeAddButton(_ bol:Bool) {
        self.isSameCity = bol
//        self.plusButton.isUserInteractionEnabled = bol
        if(bol) {
            self.plusButton.imageView?.image = UIImage(named:"add_circleGreen")
        } else {
            self.plusButton.imageView?.image = UIImage(named:"add_circleGrey")
        }
    }
    
    func detectLocation(_ sender: AnyObject?) {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if manager.location?.coordinate != nil {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            print(locValue);
            userLocation = locValue
            request.checkLocalLife(lat: String(locValue.latitude), lng: String(locValue.longitude), completion: { (response) in
                DispatchQueue.main.async(execute: {
                    if (response.error != nil) {
                        print("error: \(response.error?.localizedDescription)")
                        self.titleLabel.text = "Location Not Found"
                    }
                    else if response["value"].bool! {
                        let city = response["data"]["city"].stringValue
                        self.titleLabel.text = "Experience \(city) Like A Local"
                        self.changeAddButton(response["data"]["status"].boolValue)
                    }
                })
            })
            
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
