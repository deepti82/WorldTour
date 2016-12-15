//
//  EndJourneyViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 10/8/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class EndJourneyViewController: UIViewController {

    @IBOutlet weak var endJourneyTitle: UILabel!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var userDp: UIImageView!
    @IBOutlet weak var journeyCoverPic: UIImageView!
    @IBOutlet weak var buddyStack: UIStackView!
    @IBOutlet weak var categoryStack: UIStackView!
    
    @IBOutlet weak var buddyCount: UILabel!
    @IBOutlet var categoryImages: [UIImageView]!
    @IBOutlet var buddiesImages: [UIImageView]!
    
    @IBOutlet weak var changePhotoText: UILabel!
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var changePhotoViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var rateCountriesView: UIView!
    @IBOutlet weak var rateCountriesScroll: UIScrollView!
    @IBOutlet weak var rateCountriesLayout: VerticalLayout!
    
    var journeyImages: [String] = []
    var journey: JSON!
    
    @IBAction func changePicture(_ sender: AnyObject) {
        
        if journeyImages.count > 0 {
            
            let selectImage = storyboard?.instantiateViewController(withIdentifier: "multipleCollectionVC") as! MyLifeMomentsViewController
            selectImage.whichView = "SelectCover"
            selectImage.images = journeyImages
            self.navigationController?.navigationItem.leftBarButtonItem?.title = ""
            self.navigationController?.pushViewController(selectImage, animated: true)
            
        }
        else {
            
            print("No pictures found")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        //rightButton.setTitle("Done", for: UIControlState())
        //rightButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        let image = UIImage(cgImage: (UIImage(named: "arrow_prev")?.cgImage!)!, scale: 1.0, orientation: .upMirrored)
        rightButton.setImage(image, for: UIControlState())
        rightButton.addTarget(self, action: #selector(EndJourneyViewController.doneEndJourney(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        getAllCountryReviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewTLViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewTLViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
        self.journeyCoverPic.backgroundColor = UIColor.white
        self.journeyCoverPic.image = UIImage(named: "")
        
        //calendarIcon.text = String(format: "%C", args: faicon["calendar"])
        //clockIcon.text = String(format: "%C", arguments: faicon["clock"])
        
        calendarIcon.text = String(format: "%C", faicon["calendar"]!)
        clockIcon.text = String(format: "%C", faicon["clock"]!)
        
        getAllImages()
        
        self.userDp.image = nil
        buddiesImages[0].image = nil
        buddiesImages[1].image = nil
        
        if currentUser["profilePicture"] != "" {
            DispatchQueue.main.async(execute: {
                self.userDp.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])")!)
            })
        
        } else {
            userDp.image = UIImage(named: "darkBg")
        }
        
        makeTLProfilePicture(userDp)
        endJourneyTitle.text = "\(currentUser["name"]) has ended the \(journey["name"]) Journey"
        
        let buddies = journey["buddies"].array!
        let categories = journey["kindOfJourney"].array!
        
        if buddies.count >= 3 {
            
            buddiesImages[0].hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!)
            makeTLProfilePicture(buddiesImages[0])
            buddiesImages[1].hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(buddies[1]["profilePicture"])")!)
            makeTLProfilePicture(buddiesImages[1])
            buddyCount.text = "+\(buddies.count - 2)"
            
        }
        else if buddies.count == 2 {
            
            buddiesImages[0].hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!)
            makeTLProfilePicture(buddiesImages[0])
            buddiesImages[1].hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(buddies[1]["profilePicture"])")!)
            makeTLProfilePicture(buddiesImages[1])
            buddyCount.isHidden = true
            
        }
        else if buddies.count == 1 {
            
            buddiesImages[0].hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!)
            makeTLProfilePicture(buddiesImages[0])
            buddiesImages[1].isHidden = true
            buddyCount.isHidden = true
            
        }
        else {
            
            buddyStack.isHidden = true
            
        }
        
        if categories.count >= 3 {
            
            categoryImages[0].image = UIImage(named: "\(categories[0])")
            categoryImages[1].image = UIImage(named: "\(categories[1])")
            categoryImages[2].image = UIImage(named: "\(categories[2])")
            
        }
        else if journey["kindOfJourney"].array!.count == 2 {
            
            categoryImages[0].image = UIImage(named: "\(categories[0])")
            categoryImages[1].image = UIImage(named: "\(categories[1])")
            categoryImages[2].isHidden = true
            
        }
        else if journey["kindOfJourney"].array!.count == 1 {
            
            categoryImages[0].image = UIImage(named: "\(categories[0])")
            categoryImages[1].isHidden = true
            categoryImages[2].isHidden = true
            
        }
        else {
            
            categoryStack.isHidden = true
            
        }
        
        
    }
    
    func getAllImages() {
        
        //print("in get all images: \(journey!)")
        request.getJourneyPhotos(journeyId: journey["_id"].string!, userId: currentUser["_id"].string!, completion: {(response) in
            
            if response.error != nil {
                
                print("error: \(response.error!.localizedDescription)")
            }
            else if response["value"].bool! {
                
                let photosArr = response["data"]["photos"].array!
                
                if photosArr != [] {
                
                    for image in response["data"]["photos"].array! {
                        
                        self.journeyImages.append(image["name"].string!)
                        
                    }
                    
                } else {
                    
                    print("no images")
                    self.changePhotoText.isHidden = true
                    self.changePhotoButton.isHidden = true
                    self.changePhotoViewHeight.constant = 47.0
                    
                }
                if response["data"]["photos"].array!.count > 0 {
                    
                    self.randomImage()
                }
                else {
                    
                    let image = self.journey["startLocationPic"].string!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    self.makeCoverPicture(image: image!)
                    
                }
                
            }
            else {
                
                print("response error!")
            }
            
        })
        
    }
    
    var coverImage = ""
    
    func randomImage() {
        
        let randomIndex = Int(arc4random_uniform(UInt32(journeyImages.count)))
        print(journeyImages[randomIndex])
        self.coverImage = self.journeyImages[randomIndex]
        makeCoverPicture(image: self.journeyImages[randomIndex])
        
    }
    
    func makeCoverPicture (image: String) {
        
        DispatchQueue.main.async(execute: {
            
            //self.journeyCoverPic.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(image)")!))
            
            let imageString = self.journey["startLocationPic"].string!
            
            if imageString.contains("maps.googleapis.com") {
                self.journeyCoverPic.hnk_setImageFromURL(URL(string:imageString)!)
            }
            else {
                self.journeyCoverPic.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(imageString)&width=250")!)
            }
            
        })
        
    }
    
    func makeCoverPictureImage(image: String) {
        
        DispatchQueue.main.async(execute: {
            
            self.journeyCoverPic.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(image)")!))
        })
    }
    
    func doneEndJourney(_ sender: UIButton) {
        
        print("clicked done journey")
        
        request.endJourney(journey["_id"].string!, uniqueId: journey["uniqueId"].string!, user: currentUser["_id"].string!, userName: currentUser["name"].string!, buddies: journey["buddies"].array!, photo: coverImage, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    request.getUser(user.getExistingUser(), completion: {(request) in
                        currentUser = request["data"]
                        self.goBack()
                    })
                    
                }
                else {
                    
                    print("response error")
                }
                
            })
            
        })
        
        
    }
    
    var loader = LoadingOverlay()
    
    func goBack() {
        
        loader.showOverlay(self.view)
        
        print("\(self.navigationController!.viewControllers)")
        let allvcs = self.navigationController!.viewControllers
        
        for vc in allvcs {
            
            if vc.isKind(of: ProfileViewController.self) {
                
                self.navigationController!.popToViewController(vc, animated: true)
                
            }
        }
        
        loader.hideOverlayView()
    }
    
    var countriesVisited: [JSON] = []
    var rateCountriesLayoutMod: VerticalLayout!
    
    func getAllCountryReviews() {
        
        var reviews = ["Disappointed", "Sad", "Good", "Super", "In Love"]
        var reviewSmileys = ["disapointed", "sad", "good", "superface", "love"]
        countriesVisited = journey["countryVisited"].array!
        rateCountriesLayoutMod = VerticalLayout(width: self.view.frame.width)
        rateCountriesScroll.addSubview(rateCountriesLayoutMod)
        
        if journey["review"].array!.count > 0 {
            
            for eachCountry in countriesVisited {
                
                var flag = 0
                var countryJSON: JSON!
                
                for eachReview in journey["review"].array! {
                    
                    if eachReview["country"]["_id"].string! == eachCountry["country"]["_id"].string! {
                        
                        flag = 1
                        let rateButton = ShowRating(frame: CGRect(x: 0, y: 0, width: width, height: 150))
                        print("rating: \(Int(eachReview["rating"].string!))")
                        rateButton.ratingLabel.text = "Reviewed \(reviews[Int(eachReview["rating"].string!)! - 1])"
                        rateButton.rating.setImage(UIImage(named: reviewSmileys[Int(eachReview["rating"].string!)! - 1]), for: .normal)
//                        rateButton.rateCheckInButton.tag = countriesVisited.index(of: eachRating)!
//                        rateButton.rateCheckInButton.addTarget(self, action: #selector(EndJourneyViewController.postReview(_:)), for: .touchUpInside)
//                        rateButton.rateCheckInButton.setTitle(journey["_id"].string!, for: .normal)
                        rateCountriesLayoutMod.addSubview(rateButton)
                        addHeightToLayout(height: 150, layoutView: rateCountriesLayoutMod, scroll: rateCountriesScroll)
                    }
                    
                    else {
                        
                        countryJSON = eachCountry
                    }
                }
                
                if flag == 0 {
                    
                    getRatingLayout(eachRating: countryJSON)
                }
            }
        }
        else {
            
            rateCountries()
        }
        
    }
    
    func rateCountries() {
//        rateCountriesView.addSubview(scrollView)
        
        for eachRating in countriesVisited {
            
            getRatingLayout(eachRating: eachRating)
        }
        
    }
    
    func getRatingLayout(eachRating: JSON) {
        
        let rateButton = RatingCheckIn(frame: CGRect(x: 0, y: 0, width: width, height: 150))
        rateButton.rateCheckInLabel.text = "Rate \(eachRating["country"]["name"])?"
        rateButton.rateCheckInButton.tag = countriesVisited.index(of: eachRating)!
        rateButton.rateCheckInButton.addTarget(self, action: #selector(EndJourneyViewController.postReview(_:)), for: .touchUpInside)
        rateButton.rateCheckInButton.setTitle(journey["_id"].string!, for: .normal)
        rateCountriesLayoutMod.addSubview(rateButton)
        addHeightToLayout(height: 150, layoutView: rateCountriesLayoutMod, scroll: rateCountriesScroll)
    }
    
    func addHeightToLayout(height: CGFloat, layoutView: VerticalLayout, scroll: UIScrollView) {
        
        layoutView.frame.size.height += height
        scroll.contentSize.height += height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    
    var backgroundReview = UIView()
    
    func postReview(_ sender: UIButton) {
        
        print("journey id: \(sender.titleLabel!.text!)")
        
        let tapout = UITapGestureRecognizer(target: self, action: #selector(EndJourneyViewController.reviewTapOut(_:)))
        backgroundReview = UIView(frame: self.view.frame)
        backgroundReview.addGestureRecognizer(tapout)
        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.view.addSubview(backgroundReview)
        self.view.bringSubview(toFront: backgroundReview)
        
        let rating = AddRatingCountries(frame: CGRect(x: 0, y: 0, width: width - 40, height: 423))
        rating.center = backgroundReview.center
        rating.layer.cornerRadius = 5
        rating.postReview.setTitle(sender.titleLabel!.text!, for: .application)
        rating.postReview.setTitle(countriesVisited[sender.tag]["country"]["_id"].string!, for: .disabled)
        rating.countryName.text = countriesVisited[sender.tag]["country"]["name"].string!
        rating.countryImage.hnk_setImageFromURL(URL(string: "\(adminUrl)upload/readFile?file=\(countriesVisited[sender.tag]["country"]["flag"])")!)
        rating.clipsToBounds = true
        rating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        rating.countryVisitedData = countriesVisited[sender.tag]
        rating.journeyData = journey
        rating.backgroundSuperview = backgroundReview
        backgroundReview.addSubview(rating)
    }
    
    func reviewTapOut(_ sender: UITapGestureRecognizer) {
        
        backgroundReview.removeFromSuperview()
        
    }
}
