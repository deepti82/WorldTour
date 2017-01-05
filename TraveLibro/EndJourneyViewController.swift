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
        
        endJourney = EndJourneyView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 425))
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
        
        scrollChange();
        
        //  END VERTICAL LAYOUT
        
        
        
    }
    
    
    func scrollChange() {
        self.rateCountriesLayout.layoutSubviews()
        self.rateCountriesScroll.contentSize = CGSize(width: self.rateCountriesLayout.frame.width, height: self.rateCountriesLayout.frame.height)
    }
    
    func createReview() {
        var rate = ShowRating(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150))
        rateCountriesLayout.addSubview(rate)
        scrollChange();
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
                    
                } else {
                    
                    print("no images")
                    self.endJourney.changePhotoText.isHidden = true
                   self.endJourney.changePhotoButton.isHidden = true
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
            request.endJourney(journey["_id"].string!, uniqueId: journey["uniqueId"].string!, user: currentUser["_id"].string!, userName: currentUser["name"].string!, buddies: journey["buddies"].array!, photo: coverImage, journeyName: journey["name"].stringValue, completion: {(response) in
                
                request.getUser(user.getExistingUser(), completion: {(response) in
                    
                    DispatchQueue.main.async(execute: {
                        currentUser = response["data"]
                        globalNewTLViewController.removeFromParentViewController()
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
    
    
}
