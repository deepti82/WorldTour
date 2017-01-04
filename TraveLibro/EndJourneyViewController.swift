import UIKit
import Toaster

var globalEndJourneyViewController: UIViewController!


class EndJourneyViewController: UIViewController {
    
    @IBOutlet weak var endJourneyTitle: UILabel!
    @IBOutlet weak var calendarIcon: UILabel!
    @IBOutlet weak var clockIcon: UILabel!
    @IBOutlet weak var userDp: UIImageView!
    @IBOutlet weak var journeyCoverPic: UIImageView!
    @IBOutlet weak var buddyStack: UIStackView!
    @IBOutlet weak var categoryStack: UIStackView!
    
    @IBOutlet weak var scrollEndJourneyView: UIScrollView!
    @IBOutlet weak var categoryOne: UIImageView!
    @IBOutlet weak var categoryTwo: UIImageView!
    @IBOutlet weak var categoryThree: UIImageView!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var buddyCount: UILabel!
    @IBOutlet var categoryImages: [UIImageView]!
    @IBOutlet var buddiesImages: [UIImageView]!
    
    @IBOutlet weak var changePhotoText: UILabel!
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var changePhotoViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var rateCountriesView: UIView!
    @IBOutlet weak var rateCountriesScroll: UIScrollView!
    @IBOutlet weak var rateCountriesLayout: VerticalLayout!
    var coverImage = ""
    var coverImageImg = UIImage()
    var currentTime: String!
    var endJourney = EndJourneyView()
    
    var journey: JSON!
    
    @IBAction func changePicture(_ sender: AnyObject) {
        if journeyImages.count > 0 {
            
            let photoVC = storyboard?.instantiateViewController(withIdentifier: "photoGrid") as! TripSummaryPhotosViewController
            photoVC.fromView = "endJourney"
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.pushViewController(photoVC, animated: true)
            photoVC.whichView = "photo"
            photoVC.journey = journey["_id"].string!
            photoVC.creationDate = journey["startTime"].string!
            
            
            
        }
        else {
            
            print("No pictures found")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        globalEndJourneyViewController = self
        journeyImages = []
        
        endJourneyState = true
        
        ToastView.appearance().backgroundColor = endJourneyColor
        print("...........................")
        print(journey["createdAt"])
        
        categoryOne.tintColor = UIColor(colorLiteralRed: 255/255, green: 103/255, blue: 89/255, alpha: 1)
        categoryTwo.tintColor = UIColor(colorLiteralRed: 255/255, green: 103/255, blue: 89/255, alpha: 1)
        categoryThree.tintColor = UIColor(colorLiteralRed: 255/255, green: 103/255, blue: 89/255, alpha: 1)
        
        endJourney = EndJourneyView(frame: CGRect(x: 0, y: 30, width: self.view.frame.width, height: 300))
        let dateFormatterTwo = DateFormatter()
        dateFormatterTwo.dateFormat = "dd-MM-yyyy HH:mm"
//        self.currentTime = dateFormatterTwo.string(from: journey["createdAt"])
        
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        
        rightButton.setTitle("Done", for: .normal)
        rightButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 15)
        rightButton.addTarget(self, action: #selector(EndJourneyViewController.doneEndJourney(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 10, y: 0, width: 40, height: 30)
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
        
        //  ADD BUDDIES
        
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
        
        //  END BUDDIES
        
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
    func checkView(newcountry:JSON) {
        print("check view clicked")
        print(newcountry)
        self.journey = newcountry
        self.getAllCountryReviews()
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
                        
                        journeyImages.append(image["name"].string!)
                        
                    }
                    
                } else {
                    
                    print("no images")
                    self.changePhotoText.isHidden = true
                   self.changePhotoButton.isHidden = true
//                   self.changePhotoViewHeight.constant = 47.0
                    
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
    
    
    
    func randomImage() {
        
        let randomIndex = Int(arc4random_uniform(UInt32(journeyImages.count)))
        self.coverImage = journeyImages[randomIndex]
        makeCoverPicture(image: journeyImages[randomIndex])
        
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
    
    func makeCoverPictureImageEdited(image: UIImage) {
        coverImageImg = image
        DispatchQueue.main.async(execute: {
            self.journeyCoverPic.image = image
        })
    }
    
    func doneEndJourney(_ sender: UIButton) {
        if coverImage.contains("UIImage") {
            let exportFileUrl = "file://" + NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/coverimage.jpg"
            DispatchQueue.main.async(execute: {
                
                do {
                    
                    if let data = UIImageJPEGRepresentation(self.coverImageImg, 0.35) {
                        try data.write(to: URL(string: exportFileUrl)!, options: .atomic)
                        
                        request.uploadPhotos(URL(string: exportFileUrl)!, localDbId: 0, completion: {(responce) in
                            if responce["value"] == true {
                                
                            self.coverImage = responce["data"][0].stringValue
                                
                                request.endJourney(self.journey["_id"].string!, uniqueId: self.journey["uniqueId"].string!, user: currentUser["_id"].string!, userName: currentUser["name"].string!, buddies: self.journey["buddies"].array!, photo: self.coverImage, journeyName: self.journey["name"].stringValue, completion: {(response) in
                                    
                                    print("journey ended toaster")
                                    let tstr = Toast(text: "Journey ended successfully. Have a good life.")
                                    tstr.show()
                                    
                                    request.getUser(user.getExistingUser(), completion: {(response) in
                                        
                                        DispatchQueue.main.async(execute: {
                                            currentUser = response["data"]
                                            
//                                            self.goBack()
                                        })
                                    })
                                })
                            }
                        })
                    }
                } catch let error as NSError {
                    
                    print("error creating file: \(error.localizedDescription)")
                    
                }
                                
            })

            
        }else{
            request.endJourney(journey["_id"].string!, uniqueId: journey["uniqueId"].string!, user: currentUser["_id"].string!, userName: currentUser["name"].string!, buddies: journey["buddies"].array!, photo: coverImage, journeyName: journey["name"].stringValue, completion: {(response) in
                
                request.getUser(user.getExistingUser(), completion: {(response) in
                    
                    DispatchQueue.main.async(execute: {
                        currentUser = response["data"]
                        let tstr = Toast(text: "Journey ended successfully. Have a good life.")
                        tstr.show()
                        self.goBack()
                    })
                })
            })
        }
    }
    
    var loader = LoadingOverlay()
    
    func goBack() {
        
        let selectGenderVC = self.storyboard!.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
        self.navigationController?.pushViewController(selectGenderVC, animated: true)
    }
    
    //  START UPDATE RATING
    func removeRatingButton() {
        
        //        print("layout: \(layout.subviews)")
        backgroundReview.removeFromSuperview()
//        rateCountriesLayoutMod.removeAll()
        request.getJourney(currentUser["_id"].string!, completion: {(response) in

            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    self.journey = response["data"]
                  //  self.getAllCountryReviews()
                    self.reloadInputViews()
                    
                }
                else {
                    
                    print("response error")
                }
                
            })
            
        })
        
    }
    //  END UPDATE RATING
    
    
    
    
    
    
    var countriesVisited: [JSON] = []
    var rateCountriesLayoutMod: VerticalLayout!
    
    func getAllCountryReviews() {
        print("in all country review")
//        rateCountriesLayoutMod.removeAll()
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
                        rateCountriesLayoutMod.addSubview(rateButton)
                        addHeightToLayout(height: 150, layoutView: rateCountriesLayoutMod, scroll: rateCountriesScroll)
                    } else {
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
        
        let rateButton = RatingCheckIn(frame: CGRect(x: 0, y: -23, width: width, height: 150))
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
    
    var viewHeight = 0
    func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = CGFloat(viewHeight)
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= 258
            }
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
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
