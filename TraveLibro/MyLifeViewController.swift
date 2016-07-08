//
//  MyLifeViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MyLifeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewZero: UIView!
    @IBOutlet weak var reviewsButton: UIButton!
    @IBOutlet weak var momentsButton: UIButton!
    @IBOutlet weak var journeysButton: UIButton!
    
    @IBOutlet weak var journeysWC: NSLayoutConstraint!
    @IBOutlet weak var momentsWC: NSLayoutConstraint!
    @IBOutlet weak var reviewsWC: NSLayoutConstraint!
    
    @IBOutlet weak var allRadio: UIButton!
    @IBOutlet weak var TLRadio: UIButton!
    @IBOutlet weak var LLRadio: UIButton!
    
    @IBOutlet weak var journeysContainerView: UIView!
    @IBOutlet weak var collectionContainer: UIView!
    @IBOutlet weak var tableContainer: UIView!
    
    
    var radioValue: String!
    var firstTime = true
    var verticalLayout: VerticalLayout!
    let titleLabels = ["November 2015 (25)", "October 2015 (25)", "September 2015 (25)", "August 2015 (25)"]
    
    
//    @IBOutlet weak var TheScrollView: UIScrollView!
    
//    @IBOutlet weak var TheCollectionViewDefault: UIView!
//    @IBOutlet weak var theCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frameWidth = self.view.frame.width - 25
        
        journeysWC.constant = frameWidth/3
        momentsWC.constant = frameWidth/3
        reviewsWC.constant = frameWidth/3
        
        reviewsButton.layer.zPosition = -1
        momentsButton.layer.zPosition = 1
        journeysButton.layer.zPosition = 3
        
        viewZero.layer.zPosition = 0
        viewOne.layer.zPosition = 2
        viewTwo.layer.zPosition = 4
        
        journeysButton.addTarget(self, action: #selector(MyLifeViewController.showJourneys(_:)), forControlEvents: .TouchUpInside)
        momentsButton.addTarget(self, action: #selector(MyLifeViewController.showMoments(_:)), forControlEvents: .TouchUpInside)
        reviewsButton.addTarget(self, action: #selector(MyLifeViewController.showReviews(_:)), forControlEvents: .TouchUpInside)
        
        viewBorder(viewZero)
        viewBorder(viewOne)
        viewBorder(viewTwo)
        
        buttonsView.clipsToBounds = true
        
        buttonShadow(journeysButton)
        buttonShadow(momentsButton)
        buttonShadow(reviewsButton)
        
        let radio = UIImageView(frame: CGRect(x: -18, y: 2, width: 15, height: 15))
        radio.image = UIImage(named: "radio_for_button")
        radio.contentMode = .ScaleAspectFit
        
        let radioTwo = UIImageView(frame: CGRect(x: -18, y: 2, width: 15, height: 15))
        radioTwo.image = UIImage(named: "radio_for_button")
        radioTwo.contentMode = .ScaleAspectFit
        
        let radioThree = UIImageView(frame: CGRect(x: -18, y: 2, width: 15, height: 15))
        radioThree.image = UIImage(named: "radio_for_button")
        radioThree.contentMode = .ScaleAspectFit
        
        allRadio.titleLabel?.addSubview(radio)
        TLRadio.titleLabel?.addSubview(radioTwo)
        LLRadio.titleLabel?.addSubview(radioThree)
        
        allRadio.addTarget(self, action: #selector(MyLifeViewController.allRadioChecked(_:)), forControlEvents: .TouchUpInside)
        TLRadio.addTarget(self, action: #selector(MyLifeViewController.travelLifeRadioChecked(_:)), forControlEvents: .TouchUpInside)
        LLRadio.addTarget(self, action: #selector(MyLifeViewController.localLifeRadioChecked(_:)), forControlEvents: .TouchUpInside)
        
        
        self.allRadioChecked(nil)
        
    }
    
    func newCollection(sender: UIPinchGestureRecognizer? = nil) {
        
        if sender?.scale > 0 {
            
            
            
        }
        
    }
    
    func swipeDown(sender: UIPanGestureRecognizer) {
        
        if sender.velocityInView(self.view).y > 0 {
            
            print("down direction")
            dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        
//        print("down direction: \(sender)")
        
    }
    
    func showJourneys(sender: UIButton) {
        
        print("Journeys")
        
//        journeysHC.constant = 65.0
//        momentsHC.constant = 60.0
//        reviewsHC.constant = 18.0
        
        reviewsButton.layer.zPosition = -1
        momentsButton.layer.zPosition = 1
        journeysButton.layer.zPosition = 3
        
        journeysContainerView.alpha = 1
        collectionContainer.alpha = 0
        tableContainer.alpha = 0
        
//        journeysButton.contentEdgeInsets.top = -15
//        momentsButton.contentEdgeInsets.top = -15
//        reviewsButton.contentEdgeInsets.top = -20
        
    }
    
    func showMoments(sender: UIButton) {
        
        print("Moments")
        
//        journeysHC.constant = 18.0
//        momentsHC.constant = 65.0
//        reviewsHC.constant = 60.0
        
        journeysButton.layer.zPosition = -1
        reviewsButton.layer.zPosition = 1
        momentsButton.layer.zPosition = 3
        
        journeysContainerView.alpha = 0
        collectionContainer.alpha = 0
        tableContainer.alpha = 1
        
//        momentsButton.contentEdgeInsets.top = -15
//        reviewsButton.contentEdgeInsets.top = -15
//        journeysButton.contentEdgeInsets.top = -20
        
    }
    
    func showReviews(sender: UIButton) {
        
        print("Reviews")
        
//        journeysHC.constant = 60.0
//        momentsHC.constant = 18.0
//        reviewsHC.constant = 65.0
        
        momentsButton.layer.zPosition = -1
        journeysButton.layer.zPosition = 1
        reviewsButton.layer.zPosition = 3
        
        journeysContainerView.alpha = 0
        collectionContainer.alpha = 1
        tableContainer.alpha = 0
        
//        reviewsButton.contentEdgeInsets.top = -15
//        journeysButton.contentEdgeInsets.top = -15
//        momentsButton.contentEdgeInsets.top = -20
        
    }
    
    func allRadioChecked(sender: AnyObject?) {
        
        let mySubviews = allRadio.titleLabel!.subviews
        radioValue = "All"
        let radio = UIImageView(frame: CGRect(x: -18, y: 2, width: 15, height: 15))
        radio.contentMode = .ScaleAspectFit
        
        print("all radio selected: \(allRadio.selected)")
        
        
        for subview in mySubviews {
            
            subview.removeFromSuperview()
            
        }
        
        if firstTime {
            
            radio.image = UIImage(named: "radio_checked_all")
            allRadio.selected = true
            firstTime = false
            
        }
        
        else if !allRadio.selected {
            
            radio.image = UIImage(named: "radio_checked_all")
            allRadio.selected = true
            TLRadio.selected = false
            LLRadio.selected = false
            self.unSelectRadio(TLRadio)
            self.unSelectRadio(LLRadio)
            
        }
        
        else if allRadio.selected {
            
            radio.image = UIImage(named: "radio_checked_all")
            allRadio.selected = true
            TLRadio.selected = false
            LLRadio.selected = false
            self.unSelectRadio(TLRadio)
            self.unSelectRadio(LLRadio)
            
        }
        
        
        allRadio.titleLabel?.addSubview(radio)
        
    }
    
    func travelLifeRadioChecked(sender: AnyObject?) {
        
        print("TL radio selected: \(TLRadio.selected)")
        
        let mySubviews = TLRadio.titleLabel!.subviews
        radioValue = "TL"
        let radioTwo = UIImageView(frame: CGRect(x: -18, y: 2, width: 15, height: 15))
        radioTwo.contentMode = .ScaleAspectFit
        
        for subview in mySubviews {
            
            subview.removeFromSuperview()
            
        }
        
        if  firstTime {
            
            radioTwo.image = UIImage(named: "radio_checked_travel_life")
            TLRadio.selected = true
            firstTime = false
            
        }
        
        else if !TLRadio.selected {
            
            print("inside travel life radio")
            radioTwo.image = UIImage(named: "radio_checked_travel_life")
            TLRadio.selected = true
            allRadio.selected = false
            LLRadio.selected = false
            self.unSelectRadio(LLRadio)
            self.unSelectRadio(allRadio)
            
        }
        
        else if TLRadio.selected {
            
            radioTwo.image = UIImage(named: "radio_checked_travel_life")
            TLRadio.selected = true
            allRadio.selected = false
            LLRadio.selected = false
            self.unSelectRadio(LLRadio)
            self.unSelectRadio(allRadio)
            
        }
        
        TLRadio.titleLabel?.addSubview(radioTwo)
        
        
    }
    
    func localLifeRadioChecked(sender: AnyObject?) {
        
        print("LL radio selected: \(LLRadio.selected)")
        
        let mySubviews = LLRadio.titleLabel!.subviews
        radioValue = "LL"
        let radioThree = UIImageView(frame: CGRect(x: -18, y: 2, width: 15, height: 15))
        radioThree.contentMode = .ScaleAspectFit
        
        for subview in mySubviews {
            
            subview.removeFromSuperview()
            
        }
        
        if  firstTime {
            
            radioThree.image = UIImage(named: "radio_checked_travel_life")
            LLRadio.selected = true
            firstTime = false
            
        }
        
        else if !LLRadio.selected && LLRadio != nil && !firstTime {
            
            print("inside local life radio")
            radioThree.image = UIImage(named: "radio_checked_local_life")
            LLRadio.selected = true
            TLRadio.selected = false
            allRadio.selected = false
            self.unSelectRadio(TLRadio)
            self.unSelectRadio(allRadio)
            
        }
        
        else if LLRadio.selected {
            
            radioThree.image = UIImage(named: "radio_for_button")
            radioThree.image = UIImage(named: "radio_checked_local_life")
            LLRadio.selected = true
            TLRadio.selected = false
            allRadio.selected = false
            self.unSelectRadio(TLRadio)
            self.unSelectRadio(allRadio)
            
        }
        
        LLRadio.titleLabel?.addSubview(radioThree)
        
        
    }
    
    func unSelectRadio(sender: UIButton) {
        
        let mySubviews = sender.titleLabel!.subviews
        
        let radioUnselect = UIImageView(frame: CGRect(x: -18, y: 2, width: 15, height: 15))
        radioUnselect.contentMode = .ScaleAspectFit
        
        for subview in mySubviews {
            
            subview.removeFromSuperview()
            
        }
        
        if !sender.selected {
            
            radioUnselect.image = UIImage(named: "radio_for_button")
            sender.selected = false
            
        }
        
        sender.titleLabel?.addSubview(radioUnselect)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewBorder(sender: UIView) {
        
        sender.layer.shadowColor = UIColor.darkGrayColor().CGColor
        sender.layer.shadowOpacity = 0.4
        sender.layer.shadowOffset = CGSizeMake(0, -1)
        sender.layer.shadowRadius = 1.0
//        sender.clipsToBounds = true
        
    }
    
    func buttonShadow(sender: UIButton) {
        
        sender.layer.shadowColor = UIColor.darkGrayColor().CGColor
        sender.layer.shadowOpacity = 0.4
        sender.layer.shadowOffset = CGSizeMake(1, 0)
        sender.layer.shadowRadius = 3.0
        
        sender.layer.cornerRadius = 5.0
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch segue.identifier! {
        case "journeySegue":
            let journeysVC = segue.destinationViewController as! MyLifeContainerViewController
            journeysVC.whichView = radioValue
            break
        
        case "tableSegue":
            break
        
        case "collectionSegue":
            break
            
        default:
            break
            
        }
        
        
    }
    
    
}
