//
//  QuickItineraryPreviewViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 08/12/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItineraryPreviewViewController: UIViewController {
    
    @IBOutlet weak var previewScroll: UIScrollView!
    var previewLayout: VerticalLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(quickItinery)
        print(currentUser)
        self.title = "Itinerary Preview"
        
        
        let footer = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 60, width: self.view.frame.width, height: 60))
        footer.layer.zPosition = 1000
        
        footer.layer.shadowColor = UIColor.black.cgColor
        footer.layer.shadowOpacity = 0.5
        footer.layer.shadowOffset = CGSize.zero
        footer.layer.shadowRadius = 10
        
        footer.feedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.goToFeed(_:))))
        footer.notifyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.gotoNotifications(_:))))
        footer.LLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.gotoLocalLife(_:))))
        footer.TLView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIViewController.gotoTravelLife(_:))))
        footer.backgroundColor = navGreen
        self.view.addSubview(footer)
        
        
        let footerAbove = previewBase(frame: CGRect(x: 0, y: self.view.frame.height - 95, width: self.view.frame.width, height: 40))
        footerAbove.layer.zPosition = 900
        footerAbove.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showPhoto(_:))))

        self.view.addSubview(footerAbove)
        
        
        let prev = QuickItineraryPreview(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 837))
        //        self.view.addSubview(prev)
        
        let getImageUrl = adminUrl + "upload/readFile?file=" + currentUser["profilePicture"].stringValue + "&width=100"
        prev.userPhoto.hnk_setImageFromURL(URL(string: getImageUrl)!)
        
        prev.userName.text? = currentUser["firstName"].stringValue + " " + currentUser["lastName"].stringValue
        prev.quickTitle.text? = quickItinery["title"].stringValue
        prev.duration.text? = quickItinery["duration"].stringValue
        prev.dateTime.text? = quickItinery["month"].stringValue + " " + quickItinery["year"].stringValue
        prev.quickDescription.text? = quickItinery["description"].stringValue
        
        if quickItinery["countryVisited"].count != 0 {
            for n in quickItinery["countryVisited"].array! {
                
                for (i,m) in n["cityVisited"] {
                    if i == "0" {
                        prev.cityScroll.text = prev.cityScroll.text! + "" + m["name"].stringValue
                    }else{
                        prev.cityScroll.text = prev.cityScroll.text! + " | " + m["name"].stringValue
                    }
                }
            }
            
        }
        
        
        
        
        if quickItinery["itineraryType"].count >= 3 {
            prev.quickType[0].image = UIImage(named: quickItinery["itineraryType"][0].stringValue)
            prev.quickType[1].image = UIImage(named: quickItinery["itineraryType"][1].stringValue)
            prev.quickType[2].image = UIImage(named: quickItinery["itineraryType"][2].stringValue)
            
        }
        else if quickItinery["itineraryType"].array!.count == 2 {
            
            prev.quickType[0].image = UIImage(named: quickItinery["itineraryType"][0].stringValue)
            prev.quickType[1].image = UIImage(named: quickItinery["itineraryType"][1].stringValue)
            prev.quickType[2].isHidden = true
            
        }
        else if quickItinery["itineraryType"].array!.count == 1 {
            
            prev.quickType[0].image = UIImage(named: quickItinery["itineraryType"][0].stringValue)
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
    
    func showPhoto(_ sender: UITapGestureRecognizer) {
        
        let TLVC = storyboard!.instantiateViewController(withIdentifier: "quickPhotos") as! QuickPhotosCollectionViewController
        navigationController?.present(TLVC, animated: true, completion: nil)
    
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
        rightButton.setTitleColor(navGreen, for: .normal)
        rightButton.titleLabel?.font = avenirBold
        rightButton.addTarget(self, action: #selector(QuickItineraryPreviewViewController.donePage(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 45, height: 30)
        self.customNavigationBar(left: leftButton, right: rightButton)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func donePage(_ sender: UIButton) {
        let actionSheet: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        let MessageString = NSMutableAttributedString()
        
        MessageString.append(NSAttributedString(string: "Save - ", attributes: [NSFontAttributeName: avenirBold!,NSForegroundColorAttributeName : UIColor.black]))
        
        MessageString.append(NSAttributedString(string: "Unpublished Trips can be found in the My Life - Journeys section.", attributes: [NSFontAttributeName: avenirBold!, NSParagraphStyleAttributeName: NSParagraphStyle(), NSForegroundColorAttributeName: UIColor.gray]))
        
        MessageString.append(NSAttributedString(string: "\nPublish - ", attributes: [NSFontAttributeName: avenirBold!,NSForegroundColorAttributeName : UIColor.black]))
        
        MessageString.append(NSAttributedString(string: "Trips can be viewed by your Followers.", attributes: [NSFontAttributeName: avenirBold!, NSParagraphStyleAttributeName: NSParagraphStyle(), NSForegroundColorAttributeName: UIColor.gray]))
        
        actionSheet.setValue(MessageString, forKey: "attributedMessage")
        
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Save", style: .default) { action -> Void in
            print("Cancel")
            
        }
        
        actionSheet.addAction(cancelActionButton)
        
        let spamActionButton: UIAlertAction = UIAlertAction(title: "Publish", style: .destructive) { action -> Void in
            print("Spam or Scam")
        }
        
        actionSheet.addAction(spamActionButton)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}
