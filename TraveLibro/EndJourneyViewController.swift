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
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "darkBg")!)
        self.journeyCoverPic.backgroundColor = UIColor.white
        self.journeyCoverPic.image = UIImage(named: "")
        
        //calendarIcon.text = String(format: "%C", args: faicon["calendar"])
        //clockIcon.text = String(format: "%C", arguments: faicon["clock"])
        
        calendarIcon.text = String(format: "%C", faicon["calendar"]!)
        clockIcon.text = String(format: "%C", faicon["clock"]!)
        
        getAllImages()
        
        if currentUser["profilePicture"] != "" {
            userDp.image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(currentUser["profilePicture"])")!))
        } else {
            userDp.image = UIImage(named: "darkBg")
        }
        
        makeTLProfilePicture(userDp)
        endJourneyTitle.text = "\(currentUser["name"]) has ended the \(journey["name"]) Journey"
        
        let buddies = journey["buddies"].array!
        let categories = journey["kindOfJourney"].array!
        
        if buddies.count >= 3 {
            
            buddiesImages[0].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!))
            makeTLProfilePicture(buddiesImages[0])
            buddiesImages[1].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(buddies[1]["profilePicture"])")!))
            makeTLProfilePicture(buddiesImages[1])
            buddyCount.text = "+\(buddies.count - 2)"
            
        }
        else if buddies.count == 2 {
            
            buddiesImages[0].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!))
            makeTLProfilePicture(buddiesImages[0])
            buddiesImages[1].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(buddies[1]["profilePicture"])")!))
            makeTLProfilePicture(buddiesImages[1])
            buddyCount.isHidden = true
            
        }
        else if buddies.count == 1 {
            
            buddiesImages[0].image = UIImage(data: try! Data(contentsOf: URL(string: "\(adminUrl)upload/readFile?file=\(buddies[0]["profilePicture"])")!))
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
        request.getJourneyPhotos(journeyId: journey["_id"].string!, completion: {(response) in
            
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
                    
                }
                if response["data"]["photos"].array!.count > 0 {
                    
                    self.randomImage()
                }
                else {
                    
                    let image = self.journey["startLocationPic"].string!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    self.makeCoverPicture(image: image!)
                    
                    // installed will remove spacing and constraints
                    //self.changePhotoText.isHidden = true
                    //self.changePhotoButton.isHidden = true
                    
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
            let mapurl = URL(string: imageString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            do {
                let data = try! Data(contentsOf: mapurl!)
                self.journeyCoverPic.image = UIImage(data: data)
            }
            
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
                    
                    print("response arrived!")
                    self.goBack()
                    
                }
                else {
                    
                    print("response error")
                }
                
            })
            
        })
        
        
    }
    
    func goBack() {
            
        print("\(self.navigationController!.viewControllers)")
        let allvcs = self.navigationController!.viewControllers
        for vc in allvcs {
            
            if vc.isKind(of: ProfileViewController.self) {
                
                self.navigationController!.popToViewController(vc, animated: true)
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
