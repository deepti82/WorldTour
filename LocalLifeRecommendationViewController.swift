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
import Toaster

class LocalLifeRecommendationViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, CLLocationManagerDelegate, UITextViewDelegate, UIScrollViewDelegate {
    var currentTime =  ""
    var addView:AddActivityNew!
    var backView:UIView!
    var newScroll:UIScrollView!
    var titleLabel:UILabel!
    var locationData = ""
    let locationManager = CLLocationManager()
    var isSameCity = false
    var whichView = "noView"
    var locValue:CLLocationCoordinate2D!
    var json:JSON!
    var loader = LoadingOverlay()
    var layout:VerticalLayout!
    var mainFooter: FooterViewNew!
    var textFieldYPos = CGFloat(0)
    var difference = CGFloat(0)
  
    @IBOutlet weak var thisScroll: UIScrollView!
    @IBOutlet weak var plusButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.hideOverlayView()
        let i = PostImage()
        i.uploadPhotos()
        
        globalLocalLife = self
        getDarkBackGround(self)
        self.layout = VerticalLayout(width:screenWidth)
//        self.setNavigationBarItemText("Local Life")
        createNavigation("Local Life")
        
        self.thisScroll.addSubview(layout)
        self.thisScroll.delegate = self
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 20)
        titleLabel.text = "Experience ... Like A Local"
        titleLabel.font = UIFont(name: "Avenir-Roman", size: 16)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        layout.addSubview(titleLabel)
        
        
        let myView = LocalLifeRecommends(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 400))
        myView.photoTop.image = UIImage(named: "restaurantsLocalLife")
        myView.photoTopView.tag = 1
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife))
        myView.photoTopView.isUserInteractionEnabled = true
        myView.photoTopView.addGestureRecognizer(tapGestureRecognizer)
        
        
        myView.topLabel.text = "Restaurants and Bars"
        myView.photoBottom1.image = UIImage(named: "naturesLocalLife")
        myView.bottomLabel1.text = "Nature and Parks"
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView.photoBottomView1.isUserInteractionEnabled = true
        myView.photoBottomView1.addGestureRecognizer(tapGestureRecognizer1)
        myView.photoBottomView1.tag = 2
//myView.photoBottomView1.ta
        
        myView.photoBottom2.image = UIImage(named: "sightsLocalLife")
        myView.bottomLabel2.text = "Sights and Landmarks"
        let tapGestureRecognizer2 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView.photoBottomView2.isUserInteractionEnabled = true
        myView.photoBottomView2.addGestureRecognizer(tapGestureRecognizer2)
        myView.photoBottomView2.tag = 3
        layout.addSubview(myView)
        
        
        let myView2 = LocalLifeRecommends(frame: CGRect(x: 0, y: -10, width: self.view.frame.width, height: 400))
        myView2.photoTop.image = UIImage(named: "museumsLocalLife")
        myView2.topLabel.text = "Museums and Galleries"
        myView2.photoBottom1.image = UIImage(named: "adventureLocalLife")
        myView2.bottomLabel1.text = "Adventure and Excursions"
        myView2.photoBottom2.image = UIImage(named: "bgzoosandaqua")
        myView2.bottomLabel2.text = "Zoos and Aquariums"
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView2.photoTopView.isUserInteractionEnabled = true
        myView2.photoTopView.addGestureRecognizer(tapGestureRecognizer3)
        myView2.photoTopView.tag = 4
        let tapGestureRecognizer4 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView2.photoBottomView1.isUserInteractionEnabled = true
        myView2.photoBottomView1.addGestureRecognizer(tapGestureRecognizer4)
        myView2.photoBottomView1.tag = 5
        let tapGestureRecognizer5 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView2.photoBottomView2.isUserInteractionEnabled = true
        myView2.photoBottomView2.addGestureRecognizer(tapGestureRecognizer5)
        myView2.photoBottomView2.tag = 6

        

//        tapGesture(myView2.photoBottomView1)
//        tapGesture(myView2.photoBottom2)
        layout.addSubview(myView2)
        
        let myView3 = LocalLifeRecommends(frame: CGRect(x: 0, y: -10, width: self.view.frame.width, height: 400))
        myView3.photoTop.image = UIImage(named: "bgeventsandfestival")
        myView3.topLabel.text = "Events and Festival"
        myView3.photoBottom1.image = UIImage(named: "bgshopping")
        myView3.bottomLabel1.text = "Shopping"
        myView3.photoBottom2.image = UIImage(named: "image1")
        myView3.bottomLabel2.text = "Beaches"
//        tapGesture(myView3.photoTopView)
        let tapGestureRecognizer6 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView3.photoTopView.isUserInteractionEnabled = true
        myView3.photoTopView.addGestureRecognizer(tapGestureRecognizer6)
        myView3.photoTopView.tag = 7
        let tapGestureRecognizer7 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView3.photoBottomView1.isUserInteractionEnabled = true
        myView3.photoBottomView1.addGestureRecognizer(tapGestureRecognizer7)
        myView3.photoBottomView1.tag = 8
        let tapGestureRecognizer8 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView3.photoBottomView2.isUserInteractionEnabled = true
        myView3.photoBottomView2.addGestureRecognizer(tapGestureRecognizer8)
        layout.addSubview(myView3)
        myView3.photoBottomView2.tag = 9
        let myView4 = LocalLifeRecommends(frame: CGRect(x: 0, y: -10, width: self.view.frame.width, height: 400))
        myView4.photoTop.image = UIImage(named: "bgreligious")
        myView4.topLabel.text = "Religious"
        myView4.photoBottom1.image = UIImage(named: "bgcinemasandtheatre")
        myView4.bottomLabel1.text = "Cinema and Theatres"
        myView4.photoBottom2.image = UIImage(named: "bghotelsandaccom")
        myView4.bottomLabel2.text = "Hotels and Accommodations"
        let tapGestureRecognizer9 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView4.photoTopView.isUserInteractionEnabled = true
        myView4.photoTopView.addGestureRecognizer(tapGestureRecognizer9)
        myView4.photoTopView.tag = 10
        let tapGestureRecognizer10 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView4.photoBottomView1.isUserInteractionEnabled = true
        myView4.photoBottomView1.addGestureRecognizer(tapGestureRecognizer10)
        myView4.photoBottomView1.tag = 11
        let tapGestureRecognizer11 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView4.photoBottomView2.isUserInteractionEnabled = true
        myView4.photoBottomView2.addGestureRecognizer(tapGestureRecognizer11)
        myView4.photoBottomView2.tag = 12
        layout.addSubview(myView4)
        
        let myView5 = LocalLifeRecommends(frame: CGRect(x: 0, y: -13, width: self.view.frame.width, height: 188))
        myView5.photoTop.isHidden = true
        myView5.clipsToBounds = true
        myView5.photoBottom1.image = UIImage(named: "bgairport")
        myView5.bottomLabel1.text = "Transportation"
        myView5.photoBottom2.image = UIImage(named: "bgother")
        myView5.bottomLabel2.text = "Others"
        
        let tapGestureRecognizer12 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView5.photoBottomView1.isUserInteractionEnabled = true
        myView5.photoBottomView1.addGestureRecognizer(tapGestureRecognizer12)
        myView5.photoBottomView1.tag = 13
        let tapGestureRecognizer13 = UITapGestureRecognizer(target:self, action: #selector(self.getCategoryLocalLife(_:)))
        myView5.photoBottomView2.isUserInteractionEnabled = true
        myView5.photoBottomView2.addGestureRecognizer(tapGestureRecognizer13)
        myView5.photoBottomView2.tag = 14
        layout.addSubview(myView5)
        
        self.mainFooter = FooterViewNew(frame: CGRect.zero)
        mainFooter.localLifeIcon.tintColor = mainGreenColor
        self.view.addSubview(mainFooter)
        
        self.detectLocation(UIButton())
        self.changeAddButton(false)
        self.addHeightToLayout();
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainFooter.frame = CGRect(x: 0, y: self.view.frame.height - 65, width: self.view.frame.width, height: 65)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        globalNavigationController = self.navigationController
    }
    
    func addHeightToLayout() {
        self.layout.layoutSubviews()
        self.thisScroll.contentSize = CGSize(width: self.layout.frame.width, height: self.layout.frame.height - 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkInTap(_ sender: UIButton) {
        
        print("checkInButtonWasTapped")
        let checkInOneVC = storyboard?.instantiateViewController(withIdentifier: "checkInSearch") as! MainSearchViewController
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
            self.backView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
            self.view.addSubview(self.backView)
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
            self.newScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            self.backView.addSubview(self.newScroll)
            self.addView = AddActivityNew()
            self.addView.thoughtsTextView.delegate = self
            //        self.addView.buddyAdded(myJourney["buddies"].arrayValue)
            self.addView.typeOfAddActivtiy = "CreateLocalLife"
            self.addView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: self.view.frame.size.height)
            self.addView.newScroll = self.newScroll;
            self.newScroll.addSubview(self.addView)
            self.newScroll.contentSize.height = self.view.frame.height
            backView.addSubview(newScroll)
            addView.finalImageTag.tintColor = UIColor(hex: "#11d3cb")
            addView.videoTagFinal.tintColor = UIColor(hex: "#11d3cb")
//            addView.finalThoughtTag.tintColor = UIColor(hex: "#11d3cb")
//            addView.locationGreen.isHidden = true
//            addView.locationTag.isHidden = true
//            addView.locationGreen.tintColor = UIColor(hex: "#11d3cb")
            
//            addView.penGreen.tintColor = UIColor(hex: "#11d3cb")
            let leftButton = UIButton()
            leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
            leftButton.addTarget(self, action: #selector(self.closeAdd(_:)), for: .touchUpInside)
            
            let rightButton = UIButton()
            rightButton.frame = CGRect(x: 0, y: 5, width: 50, height: 35)
            
            rightButton.setTitle("Post", for: UIControlState())
            rightButton.titleLabel?.font = avenirBold
            rightButton.titleLabel!.font = UIFont (name: "avenirBold", size: 20)
            rightButton.addTarget(self, action: #selector(self.newPost(_:)), for: .touchUpInside)
            globalNavigationController.topViewController?.title = "Add Activity"
            globalNavigationController.topViewController?.customNavigationBar(left: leftButton, right: rightButton)
            addView.layer.zPosition = 10
            backView.layer.zPosition = 10
            newScroll.contentSize.height = self.view.frame.height
//            addView.finalThoughtTag.isHidden = true
//           addView.penGreen.isHidden = true
        
        }
        
    }
    
    
//    func resignThoughtsTexViewKeyboard() {
//        addView.thoughtsTextView.resignFirstResponder()
//    }

    
    
    func closeAdd(_ sender: UIButton) {
        hideAddActivity()
    }
    
    func newPost(_ sender: UIButton) {
        hideAddActivity()
        
        
        
        let post  = LocalLifePostModel();
        
        let buddies = JSON(self.addView.addedBuddies).rawString()
        var lat = ""
        if self.addView.currentLat != nil && self.addView.currentLat != 0.0 {
            lat = String(self.addView.currentLat!)
            if(lat == "0.0") {
                lat = ""
               
            }
        }
        var lng = ""
        if self.addView.currentLong != nil && self.addView.currentLong != 0.0 {
            lng = String(self.addView.currentLong!)
            if(lng == "0.0") {
                lng = ""
                
            }
        }
        var category = ""
        if self.addView.categoryLabel.text! != nil {
            category = self.addView.categoryLabel.text!
            if(category == "") {
                category = ""
            }
        }
        
        var location = ""
        if self.addView.addLocationButton.titleLabel?.text! != nil {
            location = (self.addView.addLocationButton.titleLabel?.text)!
            addView.locationTag.tintColor = UIColor(hex: "#11d3cb")
            if(location == "Add Location") {
                location = ""
                
            }
        }
        
        var thoughts = ""
        if self.addView.thoughtsTextView.text! != nil {
            thoughts = self.addView.thoughtsTextView.text!
//             addView.finalThoughtTag.tintColor = UIColor(hex: "#11d3cb")
//            addView.finalThoughtTag.isHidden = true
            if(thoughts == "Fill Me In...") {
                thoughts = ""
            }
        }
        
        let dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSZ"
        self.currentTime = dateFormatterTwo.string(from: Date())
        
        if(self.addView.imageArr.count > 0 || self.addView.videoURL != nil || thoughts.characters.count > 0 || location.characters.count > 0) {
            _ = post.setPost(currentUser["_id"].string!, JourneyId: "", Type: "local-life", Date: self.currentTime, Location: location, Category: category, Latitude: lat, Longitude: lng, Country: self.addView.currentCountry, City: self.addView.currentCity, thoughts: thoughts, buddies: buddies!, imageArr: self.addView.imageArr,videoURL:self.addView.videoURL, videoCaption:self.addView.videoCaption)
            
            goToActivity();
        }
    }
    
    func goToActivity() {
        let tlVC = self.storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
        tlVC.displayData = "activity"
        
        self.navigationController?.pushViewController(tlVC, animated: false)
    }
    
    func hideAddActivity() {
        addView.removeFromSuperview()
        backView.removeFromSuperview()
        
        self.setNavigationBarItemText("Local Life")
        let rightBarButton = UIBarButtonItem()
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
//        print(info["UIImagePickerControllerMediaType"]);
        let mediaType = info["UIImagePickerControllerMediaType"] as? String
        if(mediaType == "public.image") {
            picker.dismiss(animated: true, completion: {})
            let tempImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            
            let imgA:[UIImage] = [tempImage!]
            self.addView.photosAdded(assets: imgA)
        } else {
            picker.dismiss(animated: true, completion: {})
            self.addView.addVideoToBlock(video: info["UIImagePickerControllerMediaURL"] as! URL)
        }

    }
    
    func createNavigation(_ text: String) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Activity Feed"
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "menu_left_icon"), for: UIControlState())
        leftButton.imageView?.image = leftButton.imageView?.image!.withRenderingMode(.alwaysTemplate)
        leftButton.imageView?.tintColor = UIColor.white
        leftButton.addTarget(self, action: #selector(self.openSideMenu(_:)), for: .touchUpInside)
        
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "search_toolbar"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(self.searchTop(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        self.customNavigationBar(left: leftButton, right: rightButton)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = text
    }

    
   
    
    func openSideMenu(_ sender: UIButton){
        
        self.slideMenuController()?.addLeftGestures()
        self.slideMenuController()?.toggleLeft()
    }
    
    
    func searchTop(_ sender: UIButton){
        
        let searchVC = storyboard?.instantiateViewController(withIdentifier: "Search") as! MainSearchViewController
        globalNavigationController.pushViewController(searchVC, animated: true)
        
    }
    
    
    
    func changeAddButton(_ bol:Bool) {
        self.isSameCity = bol
        //        self.plusButton.isUserInteractionEnabled = bol
        if(bol) {
            self.plusButton.setImage(UIImage(named:"add_circleGreen"), for: UIControlState())
        } else {
            self.plusButton.setImage(UIImage(named:"add_circleGrey"), for: UIControlState())
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
        loader.hideOverlayView()
        if manager.location?.coordinate != nil {
            locValue = manager.location!.coordinate
            print(locValue);
            userLocation = locValue
            request.checkLocalLife(lat: String(locValue.latitude), lng: String(locValue.longitude), completion: { (response) in
                DispatchQueue.main.async(execute: {
                    if (response.error != nil) {
                        print("error: \(response.error?.localizedDescription)")
                        self.titleLabel.text = "Location Not Found"
                    }
                    else if response["value"].bool! {
                        print(response);
                        print("showeJson")
                        self.json = response["data"]
                        let city = response["data"]["user"]["city"].stringValue
                        self.titleLabel.text = "Experience \(city) Like A Local"
                        self.changeAddButton(response["data"]["user"]["status"].boolValue)
                    }
                })
            })
            
            
        }
    }
    
    
    func getCategoryLocalLife(_ sender:AnyObject ) {
        if(self.json != nil) {
            var category = ""
            let tapG = sender as! UITapGestureRecognizer
            let num:Int = (tapG.view?.tag)!
            switch (num) {
            case  1:
                category =  "Restaurants & Bars"
                
            case 2:
                category =  "Nature & Parks"
                
            case 3:
                category =  "Sights & Landmarks"
                
            case 4:
                category =  "Museums & Galleries"
                
            case 5:
                category =  "Adventure & Excursions"
                
            case 6:
                category =  "Zoo & Aquariums"
                
            case 7:
                category =  "Events & Festival"
                
            case 8:
                category =  "Shopping"
                
            case 9:
                category =  "Beaches"
                
            case 10:
                category =  "Religious"
                
            case 11:
                category =  "Cinema & Theatres"
                
            case 12:
                category =  "Hotels & Accomodations"
                
            case 13:
                category =  "Transportation"
                
            case 14:
                category =  "Others"
            default:
                category = "Others"
            }
            
            let nearMeListController = storyboard?.instantiateViewController(withIdentifier: "nearMeListVC") as! NearMeListViewController
            nearMeListController.fromLocal = true
            nearMeListController.nearMeType = category
            
            let localLifeListController = storyboard?.instantiateViewController(withIdentifier: "localLifePosts") as! LocalLifePostsViewController
            localLifeListController.nearMeType = category
            let numCat = self.json[category].intValue
            switch(numCat) {
            case 1:
                self.navigationController?.pushViewController(localLifeListController, animated: true)
            case 2:
                self.navigationController?.pushViewController(nearMeListController, animated: true)
            case 3:
                let tstr = Toast(text: "No \(category) Available Near You")
                tstr.show()
                
                self.navigationController?.pushViewController(nearMeListController, animated: true)
            default:
                break;
            }
        } else {
            let tstr = Toast(text: "Finding Your Location")
            tstr.show()
        }
        
    }
    
    
    //MARK: - Scroll Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            hideHeaderAndFooter(true);
        }
        else{
            hideHeaderAndFooter(false);
        }
    }
    
    func hideHeaderAndFooter(_ isShow:Bool) {
        if(isShow) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.mainFooter.frame.origin.y = self.view.frame.height + 95
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.mainFooter.frame.origin.y = self.view.frame.height - 65
        }
    }

    //MARK: - Text Delegate
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            addView.thoughtsTextView.resignFirstResponder()
            
            if addView.thoughtsTextView.text == "" {
                
                addView.thoughtsTextView.text = "Fill Me In..."
                
            }
            return true
            
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let number = newText.characters.count
        addView.countCharacters(number)
        return number <= 180
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textFieldYPos = textView.frame.origin.y + textView.frame.size.height
        if addView.thoughtsTextView.text == "Fill Me In..." {
            addView.thoughtsTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textFieldYPos = 0
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldYPos = textField.frame.origin.y + textField.frame.size.height
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldYPos = 0
    }
    
    
}
