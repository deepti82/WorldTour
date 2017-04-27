//
//  MyLifeJourneyTravel.swift
//  TraveLibro
//
//  Created by Jagruti  on 12/04/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class MyLifeJourneyTravel: UIView {

    
    @IBOutlet weak var startJourney: UIButton!
    @IBOutlet weak var startDocument: UIButton!
    @IBOutlet weak var startJourneyText: UILabel!
    @IBOutlet weak var startDocumentText: UILabel!
    @IBOutlet weak var nextParaTop: NSLayoutConstraint!
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        loadViewFromNib ()
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loadViewFromNib() {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MyLifeJourneyTravel", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
    }
    
    func setView(){
        if isSelfUser(otherUserID: currentUser["_id"].stringValue) {
            startJourney.isHidden = false
            startDocument.isHidden = false
            startDocumentText.isHidden = false
            startJourneyText.isHidden = false
            
        }else{
//            nextParaTop.constant = 8
            self.startJourney.isHidden = true
            self.startDocument.isHidden = true
            self.startDocumentText.isHidden = true
            self.startJourneyText.isHidden = true
        }

    }
    
    @IBAction func createJourney(_ sender: UIButton) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "newTL") as! NewTLViewController
        vc.isJourney = false
        vc.insideView = "journey"
        globalNavigationController?.setNavigationBarHidden(false, animated: true)
        globalNavigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func createItinerary(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "qiPVC") as! QIViewController
        globalNavigationController?.setNavigationBarHidden(false, animated: true)
        globalNavigationController?.pushViewController(vc, animated: true)
        //        self.setVC(newViewController: vc)
    }
    
    func setVC(newViewController : UIViewController) {
        
        let nvc = UINavigationController(rootViewController: newViewController)
        leftViewController.mainViewController = nvc
        leftViewController.slideMenuController()?.changeMainViewController(leftViewController.mainViewController, close: true)
        
        UIViewController().customiseNavigation()
        nvc.delegate = UIApplication.shared.delegate as! UINavigationControllerDelegate?
    }
}
