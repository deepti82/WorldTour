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
        let prev = QuickItineraryPreview(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 837))
//        self.view.addSubview(prev)
        prev.userName.text = currentUser["firstName"].stringValue + " " + currentUser["lastName"].stringValue
        prev.quickTitle.text = quickItinery["title"].stringValue
        prev.duration.text = quickItinery["duration"].stringValue + " Days"
        prev.dateTime.text = quickItinery["month"].stringValue + " " + quickItinery["year"].stringValue
        prev.quickDescription.text = quickItinery["description"].stringValue
        
        
        
        self.createNavigation()
        previewLayout = VerticalLayout(width:self.view.frame.width)
        previewScroll.addSubview(previewLayout)
        previewLayout.addSubview(prev)
        scrollChange()
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
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rightButton = UIButton()
            rightButton.setTitle("Done", for: .normal)
//            rightButton.addTarget(self, action: #selector(self.donePage(_:)), for: .touchUpInside)
            rightButton.frame = CGRect(x: 0, y: 8, width: 80, height: 30)
        self.customNavigationBar(left: leftButton, right: rightButton)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
