//
//  QuickItineraryPreviewViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 08/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import Toaster



class QuickItineraryPreviewViewController: UIViewController {
    
    @IBOutlet weak var previewScroll: UIScrollView!
    var previewLayout: VerticalLayout!
    var selectedQuick: JSON = []
    var footer: FooterViewNew!
    var footerAbove: previewBase!
    
    func loadPreview() {
        let prev = QuickItineraryPreview(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 837))
        //        self.view.addSubview(prev)        
        
        
        let getImageUrl = adminUrl + "upload/readFile?file=" + ((quickItinery["status"].boolValue) ? 
            quickItinery["creator"]["profilePicture"].stringValue + "&width=100" :
            currentUser["profilePicture"].stringValue) + "&width=100"
        prev.getGradiant()
        prev.gradiantLayer = CAGradientLayer()
        prev.gradiantLayer.frame.size = prev.displayPiture.frame.size
        prev.gradiantLayer.colors = [UIColor.black, UIColor.white]
        prev.displayPiture.layer.addSublayer(prev.gradiantLayer)

        prev.userPhoto.hnk_setImageFromURL(URL(string: getImageUrl)!)
        if selectedQuickI != "" {
            if quickItinery["coverPhoto"] != nil {
                prev.displayPiture.hnk_setImageFromURL(getImageURL(quickItinery["coverPhoto"].stringValue, width: 200))
            }
        }else{
            if globalPostImage.count != 0 {
                prev.displayPiture.image = globalPostImage[0].image

            }
        }
        
        prev.userName.text? = (quickItinery["status"].boolValue) ? quickItinery["creator"]["name"].stringValue : currentUser["name"].stringValue
        if quickItinery["title"] != nil {
            prev.quickTitle.text? = quickItinery["title"].stringValue
        }else{
            prev.quickTitle.text? = quickItinery["name"].stringValue
        }
        prev.duration.text? = quickItinery["duration"].stringValue
        prev.dateTime.text? = quickItinery["month"].stringValue + " " + quickItinery["year"].stringValue
        prev.quickDescription.text? = quickItinery["description"].stringValue
        prev.json = quickItinery;
        prev.generateCity()
        
        if quickItinery["itineraryType"].count >= 3 {
            
            prev.quickType[0].image = UIImage(named: categoryImage(quickItinery["itineraryType"][0].stringValue))
            prev.quickType[1].image = UIImage(named: categoryImage(quickItinery["itineraryType"][1].stringValue))
            prev.quickType[2].image = UIImage(named: categoryImage(quickItinery["itineraryType"][2].stringValue))
            
        }
        else if quickItinery["itineraryType"].count == 2 {
            
            prev.quickType[0].image = UIImage(named: categoryImage(quickItinery["itineraryType"][0].stringValue))
            prev.quickType[1].image = UIImage(named: categoryImage(quickItinery["itineraryType"][1].stringValue))
            prev.quickType[2].isHidden = true
            
        }
        else if quickItinery["itineraryType"].count == 1 {
            
            prev.quickType[0].image = UIImage(named: categoryImage(quickItinery["itineraryType"][0].stringValue))
            prev.quickType[1].isHidden = true
            prev.quickType[2].isHidden = true
            
        }
        else {
            
            prev.typeGroup.isHidden = true
            
        }
        
        for i in 0 ... (prev.quickType.count - 1) {
            prev.quickType[i].tintColor = UIColor.white
        }
        
        self.createNavigation()
        previewLayout = VerticalLayout(width:self.view.frame.width)
        previewScroll.addSubview(previewLayout)
        previewLayout.addSubview(prev)
        scrollChange()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.title = "Itinerary Preview"       
        
        footer = FooterViewNew(frame: CGRect.zero)
        footer.layer.zPosition = 1000
        
        footer.backgroundColor = UIColor.white
        self.view.addSubview(footer)        
        
        footerAbove = previewBase(frame: CGRect.zero)
        footerAbove.layer.zPosition = 900
        footerAbove.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showPhoto(_:))))

        self.view.addSubview(footerAbove)
        
        if selectedQuickI == "" {
            loadPreview()
        }else{
            request.getItinerary(selectedQuickI, completion: {(request) in
                DispatchQueue.main.async(execute: {
                    quickItinery = request["data"]
                    self.selectedQuick = request["data"]["photos"]
                    self.createNavigation()
                    self.loadPreview()
                })
            })
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        footer.frame = CGRect(x: 0, y: self.view.frame.size.height - FOOTER_HEIGHT, width: screenWidth, height: FOOTER_HEIGHT)
        footerAbove.frame = CGRect(x: 0, y: self.view.frame.size.height - 105, width: screenWidth, height: 40)
    }
    
    func showQuickPhotos() {
        let qiPics = quickItinery["photos"].array
        
        let modalContent = self.storyboard?.instantiateViewController(withIdentifier: "itineraryPhotos") as! EachItineraryPhotosViewController
        modalContent.selectedItinerary = (qiPics != nil) ? quickItinery : ""
        modalContent.modalPresentationStyle = .fullScreen
        _ = modalContent.popoverPresentationController
        self.present(modalContent, animated: true, completion: nil)
    }
    
    func showPhoto(_ sender: UITapGestureRecognizer) {
        if selectedQuickI == "" {
            if globalPostImage.count == 0 {
                let tstr = Toast(text: "No Photos.")
                tstr.show()
            }else{
                showQuickPhotos()
            }
            
        }else{
            if self.selectedQuick.count == 0 {
                let tstr = Toast(text: "No Photos.")
                tstr.show()
            }else{
                showQuickPhotos()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func scrollChange() {
        self.previewLayout.layoutSubviews()
        self.previewScroll.contentSize = CGSize(width: self.previewLayout.frame.width, height: self.previewLayout.frame.height)
    }
    
    
    func createNavigation() {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
        rightButton.titleLabel?.font = UIFont(name: "avenirBold", size: 20)
        rightButton.setTitle("Done", for: .normal)
        rightButton.addTarget(self, action: #selector(QuickItineraryPreviewViewController.donePage(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 20, y: 8, width: 45, height: 30)
        
        if selectedQuickI == "" {
            self.customNavigationBar(left: leftButton, right: rightButton)

        }else{
            let userm = User()
            print(selectedQuick)
            if (!quickItinery["status"].boolValue) && (currentUser["_id"].stringValue == userm.getExistingUser()) {
                print(" in if")
                self.customNavigationBar(left: leftButton, right: rightButton)
            }else{
                print("in else")
                self.customNavigationBar(left: leftButton, right: nil)
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func alertControllerBackgroundTapped() {
        print("back clicked")
        self.dismiss(animated: true, completion: nil)
    }
    
    func donePage(_ sender: UIButton) {
        let actionSheet: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let MessageString = NSMutableAttributedString()
        
        MessageString.append(NSAttributedString(string: "Save - ", attributes: [NSFontAttributeName: avenirBold!,NSForegroundColorAttributeName : UIColor.black]))
        
        MessageString.append(NSAttributedString(string: "Unpublished Trips can be found in the My Life - Journeys section.", attributes: [NSFontAttributeName: avenirBold!, NSParagraphStyleAttributeName: NSParagraphStyle(), NSForegroundColorAttributeName: UIColor.gray]))
        
        MessageString.append(NSAttributedString(string: "\nPublish - ", attributes: [NSFontAttributeName: avenirBold!,NSForegroundColorAttributeName : UIColor.black]))
        
        MessageString.append(NSAttributedString(string: "Trips can be viewed by your Followers.", attributes: [NSFontAttributeName: avenirBold!, NSParagraphStyleAttributeName: NSParagraphStyle(), NSForegroundColorAttributeName: UIColor.gray]))
        
        actionSheet.setValue(MessageString, forKey: "attributedMessage")
        
       
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Save", style: .default) { action -> Void in
            
            //        request.postQuickitenary(title: quickItinery["title"].stringValue, year: quickItinery["year"].int!, month: quickItinery["month"].stringValue, duration:quickItinery["duration"].int!, description:quickItinery["description"].stringValue, itineraryType:quickItinery["itineraryType"], countryVisited:quickItinery["countryVisited"],status:false,  completion: {(response) in
            //            DispatchQueue.main.async(execute: {
            //                print(response)
            //                if response.error != nil {
            //
            //                    print("error: \(response.error!.localizedDescription)")
            //
            //                }
            //                else if response["value"].bool! {
            //                    quickItinery = []
            //                    let tstr = Toast(text: "Itenary saved successfully.")
            //                    tstr.show()
            //                    let next = self.storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
            //                    self.navigationController?.pushViewController(next, animated: true)
            //                    print("nothing")
            //                }
            //                else {
            //                    print("nothing")
            //                    
            //                }
            //            })
            //        })
            
            let qi = QuickItinerary()
            qi.save(quickItinery, imageArr: globalPostImage, statusVal: false,oldId:editValue)
            
            self.goToActivity()
        }
//        if selectedQuickI != "" && !quickItinery["status"].boolValue {
            actionSheet.addAction(saveActionButton)
//        }
        
        let publishActionButton: UIAlertAction = UIAlertAction(title: "Publish", style: .destructive) { action -> Void in
            let qi = QuickItinerary()
            qi.save(quickItinery, imageArr: globalPostImage, statusVal: true,oldId:editValue)
            self.goToActivity()
        }
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { action -> Void in
            actionSheet.dismiss(animated: true, completion: nil)

        }
        
        actionSheet.addAction(publishActionButton)
        actionSheet.addAction(cancelActionButton)
        self.present(actionSheet, animated: true, completion: {
            actionSheet.view.superview?.isUserInteractionEnabled = true
            actionSheet.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    func goToActivity() {
        let tlVC = self.storyboard!.instantiateViewController(withIdentifier: "activityFeeds") as! ActivityFeedsController
        tlVC.displayData = "activity"
        
        self.navigationController?.pushViewController(tlVC, animated: false)
    }
    
}
