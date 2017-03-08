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
    
    func loadPreview() {
        let prev = QuickItineraryPreview(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 837))
        //        self.view.addSubview(prev)
        
        let getImageUrl = adminUrl + "upload/readFile?file=" + currentUser["profilePicture"].stringValue + "&width=100"
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
        
        prev.userName.text? = currentUser["firstName"].stringValue + " " + currentUser["lastName"].stringValue
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
        
        
        
        
        self.createNavigation()
        previewLayout = VerticalLayout(width:self.view.frame.width)
        previewScroll.addSubview(previewLayout)
        previewLayout.addSubview(prev)
        scrollChange()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(quickItinery)
        print(currentUser)
        self.title = "Itinerary Preview"
        
        
        let footer = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 65, width: self.view.frame.width, height: 65))
        footer.layer.zPosition = 1000
        
        footer.layer.shadowColor = UIColor.black.cgColor
        footer.layer.shadowOpacity = 0.5
        footer.layer.shadowOffset = CGSize.zero
        footer.layer.shadowRadius = 10
        
        footer.feedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.goToFeed(_:))))
        footer.notifyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.gotoNotifications(_:))))
        footer.LLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.gotoLocalLife(_:))))
        footer.TLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.gotoTravelLife(_:))))
        footer.backgroundColor = UIColor.white
        self.view.addSubview(footer)
        
        
        let footerAbove = previewBase(frame: CGRect(x: 0, y: self.view.frame.height - 105, width: self.view.frame.width, height: 40))
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
    
    func showQuickPhotos() {
    let modalContent = self.storyboard?.instantiateViewController(withIdentifier: "itineraryPhotos") as! EachItineraryPhotosViewController
    modalContent.selectedItinerary = quickItinery
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
        rightButton.setTitle("Done", for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.titleLabel?.font = avenirBold
        rightButton.addTarget(self, action: #selector(QuickItineraryPreviewViewController.donePage(_:)), for: .touchUpInside)
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 20)!]
        rightButton.frame = CGRect(x: 20, y: 8, width: 45, height: 30)
        print("selected status \(selectedQuickI)")
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
    
    func alertControllerBackgroundTapped()
    {
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
            qi.save(quickItinery, imageArr: globalPostImage, statusVal: false)
            
            self.goToActivity()
        }
//        if selectedQuickI != "" && !quickItinery["status"].boolValue {
            actionSheet.addAction(saveActionButton)
//        }
        
        let publishActionButton: UIAlertAction = UIAlertAction(title: "Publish", style: .destructive) { action -> Void in
            var qi = QuickItinerary()
            qi.save(quickItinery, imageArr: globalPostImage, statusVal: true)
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
