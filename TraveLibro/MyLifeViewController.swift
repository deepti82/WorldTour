//
//  MyLifeViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 23/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var isEmptyProfile = false

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
    var whatTab = "Journeys"
    var child: MyLifeContainerViewController!
    var whatEmptyTab = "Journeys"
    
//    @IBOutlet weak var TheScrollView: UIScrollView!
    
//    @IBOutlet weak var TheCollectionViewDefault: UIView!
//    @IBOutlet weak var theCollectionView: UICollectionView!
    
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var arrowDownButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        let leftButton = UIButton()
        leftButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 14)
        let arrow = String(format: "%C", faicon["arrow-down"]!)
        leftButton.setTitle(arrow, forState: .Normal)
        leftButton.addTarget(self, action: #selector(MyLifeViewController.exitMyLife(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        leftButton.titleLabel?.font = UIFont(name: "Avenir-Roman", size: 12)
        rightButton.setTitle("Follow", forState: .Normal)
        rightButton.addTarget(self, action: #selector(MyLifeViewController.follow(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 100, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
        isEmptyProfile = true
        
        arrowDownButton.setTitle(arrow, forState: .Normal)
        arrowDownButton.addTarget(self, action: #selector(MyLifeViewController.exitMyLife(_:)), forControlEvents: .TouchUpInside)
        
        followButton.addTarget(self, action: #selector(MyLifeViewController.follow(_:)), forControlEvents: .TouchUpInside)
        
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 20))
        statusBar.layer.zPosition = -1
        statusBar.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
        self.view.addSubview(statusBar)
        
        
        let frameWidth = self.view.frame.width - 25
        
        print("in main my life")
        
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
        
        self.setDefaults()
        self.allRadioChecked(nil)
        
        child = self.childViewControllers[0] as! MyLifeContainerViewController
        
    }
    
    func exitMyLife(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func follow(sender: UIButton) {
        
        sender.setTitle("Following", forState: .Normal)
        
    }
    
    func setDefaults() {
        
        let journeys = storyboard?.instantiateViewControllerWithIdentifier("myLifeSimple") as! MyLifeContainerViewController
        journeys.whichView = "All"
        
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
        
        whatEmptyTab = "Journeys"
        reviewsButton.layer.zPosition = -1
        momentsButton.layer.zPosition = 1
        journeysButton.layer.zPosition = 3
        
        if !isEmptyProfile {
            
            print("Journeys")
            whatTab = "Journeys"
            
            //        journeysHC.constant = 65.0
            //        momentsHC.constant = 60.0
            //        reviewsHC.constant = 18.0
            
            journeysContainerView.alpha = 1
            collectionContainer.alpha = 0
            tableContainer.alpha = 0
            
        }
        
        flag = true
        self.allRadioChecked(nil)
        
//        journeysButton.contentEdgeInsets.top = -15
//        momentsButton.contentEdgeInsets.top = -15
//        reviewsButton.contentEdgeInsets.top = -20
        
    }
    
    func showMoments(sender: UIButton) {
        
        whatEmptyTab = "Moments"
        journeysButton.layer.zPosition = -1
        reviewsButton.layer.zPosition = 1
        momentsButton.layer.zPosition = 3
        
        if !isEmptyProfile {
            
            print("Moments")
            whatTab = "Moments"
            //        journeysHC.constant = 18.0
            //        momentsHC.constant = 65.0
            //        reviewsHC.constant = 60.0
            
            journeysContainerView.alpha = 0
            collectionContainer.alpha = 1
            tableContainer.alpha = 0
            
        }
        
        flag = true
        self.allRadioChecked(nil)
//        momentsButton.contentEdgeInsets.top = -15
//        reviewsButton.contentEdgeInsets.top = -15
//        journeysButton.contentEdgeInsets.top = -20
        
    }
    
    func showReviews(sender: UIButton) {
        
        whatEmptyTab = "Reviews"
        momentsButton.layer.zPosition = -1
        journeysButton.layer.zPosition = 1
        reviewsButton.layer.zPosition = 3
        
        if !isEmptyProfile {
            
            print("Reviews")
            whatTab = "Reviews"
            //        journeysHC.constant = 60.0
            //        momentsHC.constant = 18.0
            //        reviewsHC.constant = 65.0
            
            journeysContainerView.alpha = 0
            collectionContainer.alpha = 0
            tableContainer.alpha = 1
            
        }
        
        flag = true
        self.allRadioChecked(nil)
//        reviewsButton.contentEdgeInsets.top = -15
//        journeysButton.contentEdgeInsets.top = -15
//        momentsButton.contentEdgeInsets.top = -20
        
    }
    
    var flag = false
    
    func allRadioChecked(sender: AnyObject?) {
        
        if flag && isEmptyProfile {
            
            child.whichEmptyView = "\(whatEmptyTab)-All"
            child.viewDidLoad()
            flag = false
        }
        
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
        
        if whatTab == "Journeys" {
            
             print("inside all life radio 2")
            let simpleVC = self.childViewControllers[0] as! MyLifeContainerViewController
            simpleVC.whichView = "All"
            
            journeysContainerView.alpha = 0
            journeysContainerView.alpha = 1
            
            simpleVC.view.setNeedsDisplay()
            
        }
        
        else if whatTab == "Moments" {
            
//            let simpleVC = storyboard?.instantiateViewControllerWithIdentifier("multipleCollectionVC") as! MyLifeMomentsViewController
            
            
            let simpleVC = self.childViewControllers[1] as! MyLifeMomentsViewController
            simpleVC.whichView = "All"
            simpleVC.mainView.reloadData()
            
        }
        
        else if whatTab == "Reviews" {
            
            tableContainer.alpha = 1
            let simpleVC = self.childViewControllers[2] as! AccordionViewController
            simpleVC.whichView = "All"
            simpleVC.tableMainView.reloadData()
            
        }
        
        
    }
    
    func travelLifeRadioChecked(sender: AnyObject?) {
        
        if isEmptyProfile {
            
            child.whichEmptyView = "\(whatEmptyTab)-TravelLife"
            child.viewDidLoad()
            
        }
        
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
        
        if whatTab == "Journeys" {
            
            print("inside travel life radio 2")
            let simpleVC = self.childViewControllers.first as! MyLifeContainerViewController
            simpleVC.whichView = "TL"
            
            journeysContainerView.alpha = 0
            journeysContainerView.alpha = 1
            
            simpleVC.view.setNeedsDisplay()
            
        }
            
        else if whatTab == "Moments" {
            
            let simpleVC = self.childViewControllers[1] as! MyLifeMomentsViewController
            simpleVC.whichView = "Travel Life"
            simpleVC.mainView.reloadData()
            
        }
            
        else if whatTab == "Reviews" {
            
            tableContainer.alpha = 0
            collectionContainer.alpha = 1
            let simpleVC = self.childViewControllers[1] as! MyLifeMomentsViewController
            simpleVC.whichView = "Reviews TL"
            simpleVC.mainView.reloadData()
            
        }
        
    }
    
    func localLifeRadioChecked(sender: AnyObject?) {
        
        if isEmptyProfile {
            
            child.whichEmptyView = "\(whatEmptyTab)-LocalLife"
            child.viewDidLoad()
            
        }
        
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
        
        if whatTab == "Journeys" {
            
            print("inside all life radio 2")
            
            journeysContainerView.alpha = 0
            journeysContainerView.alpha = 1
            
            let simpleVC = self.childViewControllers.first as! MyLifeContainerViewController
            simpleVC.whichView = "LL"
            simpleVC.view.setNeedsDisplay()
            
        }
            
        else if whatTab == "Moments" {
            
            let simpleVC = self.childViewControllers[1] as! MyLifeMomentsViewController
            simpleVC.whichView = "Local Life"
            simpleVC.mainView.reloadData()
            
        }
            
        else if whatTab == "Reviews" {
            
            tableContainer.alpha = 0
            collectionContainer.alpha = 1
            let simpleVC = self.childViewControllers[1] as! MyLifeMomentsViewController
            simpleVC.whichView = "Reviews LL"
            simpleVC.mainView.reloadData()
            
        }
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
        sender.layer.shadowOpacity = 0.6
        sender.layer.shadowOffset = CGSizeMake(0, -1)
        sender.layer.shadowRadius = 5.0
//        sender.clipsToBounds = true
        
    }
    
    func buttonShadow(sender: UIButton) {
        
        sender.layer.shadowColor = UIColor.darkGrayColor().CGColor
        sender.layer.shadowOpacity = 0.4
        sender.layer.shadowOffset = CGSizeMake(1, 0)
        sender.layer.shadowRadius = 3.0
        
        sender.layer.cornerRadius = 5.0
        
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        switch segue.identifier! {
//        case "journeySegue":
//            let journeysVC = segue.destinationViewController as! MyLifeContainerViewController
//            journeysVC.whichView = radioValue
//            break
//        
//        case "tableSegue":
//            break
//        
//        case "collectionSegue":
//            break
//            
//        default:
//            break
//            
//        }
//        
//        
//    }
    
    
}
