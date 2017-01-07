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
    @IBOutlet weak var rateCountriesScroll: UIScrollView!
    var rateCountriesLayout: VerticalLayout!
    var coverImage = ""
    var coverImageImg = UIImage()
    var currentTime: String!
    var endJourney:EndJourneyView!
    var countriesVisited: [JSON] = []
    

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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
        
        setRating()

        
        //  START OF NAVIGATION BAR
        
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
        
        //  END OF NAVIGATION BER
        
        print("...........JOURNEY DATA................")
        print(journey)
        let buddies = journey["buddies"].array!
        let categories = journey["kindOfJourney"].array!
        
        //  START ADD VERTICAL LAYOUT
        
        self.rateCountriesLayout = VerticalLayout(width:self.view.frame.width)
        self.rateCountriesScroll.addSubview(self.rateCountriesLayout)
        
        
        
        endJourney = EndJourneyView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 366))
        endJourney.tag = 100
        endJourney.changeConstraint(height: 90)
        
//        endJourney.accesoriesVew.isHidden = true
        endJourney.categoryOne.tintColor = UIColor(colorLiteralRed: 255/255, green: 103/255, blue: 89/255, alpha: 1)
        endJourney.categoryTwo.tintColor = UIColor(colorLiteralRed: 255/255, green: 103/255, blue: 89/255, alpha: 1)
        endJourney.categoryThree.tintColor = UIColor(colorLiteralRed: 255/255, green: 103/255, blue: 89/255, alpha: 1)
        endJourney.changePhotoButton.addTarget(self, action: #selector(changePicture(_:)), for: .touchUpInside)
        endJourney.journeyCoverPic.backgroundColor = UIColor.white
        endJourney.journeyCoverPic.image = UIImage(named: "")
        endJourney.calendarIcon.text = String(format: "%C", faicon["calendar"]!)
        endJourney.clockIcon.text = String(format: "%C", faicon["clock"]!)
        
        getAllImages()
        
        endJourney.userDp.image = nil
        endJourney.buddiesImages[0].image = nil
        endJourney.buddiesImages[1].image = nil
        
        if currentUser["profilePicture"] != "" {
            DispatchQueue.main.async(execute: {
                self.endJourney.userDp.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])")!)
            })
            
        } else {
            endJourney.userDp.image = UIImage(named: "darkBg")
        }
        
        makeTLProfilePicture(endJourney.userDp)
        endJourney.endJourneyTitle.text = "\(currentUser["name"]) has ended the \(journey["name"]) Journey"
        
        //  add buddies
        if buddies.count >= 3 {
            
            endJourney.buddiesImages[0].hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!)
            makeTLProfilePicture(buddiesImages[0])
            endJourney.buddiesImages[1].hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(buddies[1]["profilePicture"])")!)
            makeTLProfilePicture(buddiesImages[1])
            endJourney.buddyCount.text = "+\(buddies.count - 2)"
            
        }
        else if buddies.count == 2 {
            
            //            endJourney.buddiesImages[0].hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!)
            //            makeTLProfilePicture(buddiesImages[0])
            //           endJourney.buddiesImages[1].hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(buddies[1]["profilePicture"])")!)
            //            makeTLProfilePicture(buddiesImages[1])
            //            endJourney.buddyCount.isHidden = true
            
        }
        else if buddies.count == 1 {
            
            endJourney.buddiesImages[0].hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!)
            makeTLProfilePicture(buddiesImages[0])
            endJourney.buddiesImages[1].isHidden = true
            endJourney.buddyCount.isHidden = true
            
        }
        else {
            
            endJourney.buddyStack.isHidden = true
            
        }
        
        //  add categories
        if categories.count >= 3 {
            endJourney.categoryImages[0].image = UIImage(named: "\(categories[0])")
            endJourney.categoryImages[1].image = UIImage(named: "\(categories[1])")
            endJourney.categoryImages[2].image = UIImage(named: "\(categories[2])")
            
        }
        else if journey["kindOfJourney"].array!.count == 2 {
            
            endJourney.categoryImages[0].image = UIImage(named: "\(categories[0])")
            endJourney.categoryImages[1].image = UIImage(named: "\(categories[1])")
            endJourney.categoryImages[2].isHidden = true
            
        }
        else if journey["kindOfJourney"].array!.count == 1 {
            
            endJourney.categoryImages[0].image = UIImage(named: "\(categories[0])")
            endJourney.categoryImages[1].isHidden = true
            endJourney.categoryImages[2].isHidden = true
            
        }
        else {
            
            endJourney.categoryStack.isHidden = true
            
        }
        rateCountriesLayout.addSubview(endJourney)
        createReview()
        scrollChange()
        
        //  END VERTICAL LAYOUT
        
        
        
    }
    
    var newJson: JSON = []
    
    func setRating() {
        
        print("sota baby")
        
        for n in journey["countryVisited"].array! {
            if journey["review"].contains(where: {$0.1["country"]["_id"] == n["country"]["_id"]}) {
                let a = journey["review"].index(where: {$0.1["country"]["_id"] == n["country"]["_id"]})
                let c = journey["review"][a!].0
                
                newJson.arrayObject?.append(journey["review"][Int(c)!].object)
            }else{
                newJson.arrayObject?.append(n.object)

            }
        }
        
        print(newJson)
    }
    
    
    func scrollChange() {
        self.rateCountriesLayout.layoutSubviews()
        self.rateCountriesScroll.contentSize = CGSize(width: self.rateCountriesLayout.frame.width, height: self.rateCountriesLayout.frame.height)
    }
    
    func createReview() {
        
        for subvw in rateCountriesLayout.subviews {
            if subvw.tag != 100 {
                subvw.removeFromSuperview()
            }
        }
        
        for (n,i) in newJson {
            var rateState = self.getRatingImage(rate: i["rating"].stringValue)
            let rate = ShowRating(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150))
            rate.rating.setImage(UIImage(named:rateState["image"].stringValue), for: .normal)
            rate.rating.setBackgroundImage(UIImage(named:rateState["back"].stringValue), for: .normal)
            rate.ratingLabel.text = i["country"]["name"].stringValue
            rate.rating.tag = Int(n)!
            rate.rating.addTarget(self, action: #selector(EndJourneyViewController.postReview(_:)), for: .touchUpInside)

            rateCountriesLayout.addSubview(rate)
            
            scrollChange()
        }
        
    }
    
    var backgroundReview = UIView()
    
    func postReview(_ sender: UIButton) {
        
        print("journey id: \(sender)")
        
        let tapout = UITapGestureRecognizer(target: self, action: #selector(EndJourneyViewController.reviewTapOut(_:)))
        backgroundReview = UIView(frame: self.view.frame)
        backgroundReview.addGestureRecognizer(tapout)
        backgroundReview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.view.addSubview(backgroundReview)
        self.view.bringSubview(toFront: backgroundReview)
        
        let rating = AddRatingCountries(frame: CGRect(x: 0, y: 0, width: width - 40, height: 423))
        rating.endJourney = self;
        rating.center = backgroundReview.center
        rating.layer.cornerRadius = 5
//        rating.postReview.setTitle(sender.titleLabel!.text!, for: .application)
        rating.tag = sender.tag
        
        if newJson[sender.tag]["rating"] != nil {
            var rateState = self.getRatingImage(rate: newJson[sender.tag]["rating"].stringValue)
            rating.updateSmiley(point: newJson[sender.tag]["rating"].intValue)
            rating.smiley.setImage(UIImage(named:rateState["image"].stringValue), for: .normal)
            rating.smiley.setBackgroundImage(UIImage(named:rateState["back"].stringValue), for: .normal)
        }
        
        
        rating.postReview.setTitle(newJson[sender.tag]["country"]["_id"].string!, for: .disabled)
        rating.countryName.text = newJson[sender.tag]["country"]["name"].string!
        rating.countryImage.hnk_setImageFromURL(URL(string: "\(adminUrl)upload/readFile?file=\(newJson[sender.tag]["country"]["flag"])")!)
        rating.clipsToBounds = true
        rating.addGestureRecognizer(UITapGestureRecognizer(target: self, action: nil))
        rating.countryVisitedData = newJson[sender.tag]
        rating.journeyData = journey
        rating.backgroundSuperview = backgroundReview
        backgroundReview.addSubview(rating)
        
    }
    
    func reviewTapOut(_ sender: UITapGestureRecognizer) {
        
        backgroundReview.removeFromSuperview()
        
    }
    
    func checkView(newcountry:JSON) {
        print("check view clicked")
        print(newcountry)
        self.journey = newcountry
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
//                    self.endJourney.accesoriesVew.isHidden = false
                    
                } else {
                    
                    print("no images")
//                    self.endJourney.accesoriesVew.isHidden = true
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
            print(imageString);
            if imageString.contains("http") {
                self.endJourney.journeyCoverPic.hnk_setImageFromURL(URL(string:imageString)!)
            }
            else {
                self.endJourney.journeyCoverPic.hnk_setImageFromURL(URL(string:"\(adminUrl)upload/readFile?file=\(imageString)&width=250")!)
            }
        })
    }
    
    func makeCoverPictureImage(image: String) {
        DispatchQueue.main.async(execute: {
            
            self.endJourney.journeyCoverPic.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(image)")!))
        })
    }
    
    func makeCoverPictureImageEdited(image: UIImage) {
        coverImageImg = image
        DispatchQueue.main.async(execute: {
            self.endJourney.journeyCoverPic.image = image
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
            var tstr = Toast(text: "Wait a while.....")
            tstr.show()
            self.goBack()
            request.endJourney(journey["_id"].string!, uniqueId: journey["uniqueId"].string!, user: currentUser["_id"].string!, userName: currentUser["name"].string!, buddies: journey["buddies"].array!, photo: coverImage, journeyName: journey["name"].stringValue, completion: {(response) in
                
                request.getUser(user.getExistingUser(), completion: {(response) in
                    
                    DispatchQueue.main.async(execute: {
                        currentUser = response["data"]
                        globalNewTLViewController.removeFromParentViewController()
                        tstr = Toast(text: "Journey ended successfully. Have a good life.")
                        tstr.show()
//                        self.goBack()
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
    
    
}
