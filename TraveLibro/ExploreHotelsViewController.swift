//
//  ExploreHotelsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import SwiftyJSON

class ExploreHotelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var whichView: String!
    var scrollView: UIScrollView!
    var hotels: HotelTypeSelect!
    var city = ""
    var data: [JSON] = []
    
    
    let hotelNames = ["The Taj Mahal Palace", "Trident, Nariman Point", "The Taj Mahal Palace", "Trident, Nariman Point", "The Taj Mahal Palace", "Trident, Nariman Point"]
    let labelName = ["Must Do's", "Hotels", "Restaurants", "Popular Agents"]
//    var animationHasBeenShown = false
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(_ transitionContext: UIViewControllerContextTransitioning) -> TimeInterval {
        return 0.5
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func filterTap(_ sender: UIButton) {
        
//        let circleMaskPathInitial = UIBezierPath(ovalInRect: sender.frame)
//        let extremePoint = CGPoint(x: sender.center.x - 0, y: sender.center.y - CGRectGetHeight(self.view.frame))
//        print("extreme point \(extremePoint)")
//        let radius = sqrt((extremePoint.x*extremePoint.x) + (extremePoint.y*extremePoint.y))
//        let circleMaskPathFinal = UIBezierPath(ovalInRect: CGRectInset(sender.frame, -radius, -radius))
//        
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = circleMaskPathFinal.CGPath
//        self.view.layer.mask = maskLayer
//        
//        let finalLayer = CAShapeLayer()
//        finalLayer.path = self.view.accessibilityPath?.CGPath
//        self.view.layer.mask = finalLayer
//        
//        let maskLayerAnimation = CABasicAnimation(keyPath: "path")
//        maskLayerAnimation.fromValue = circleMaskPathInitial.CGPath
//        maskLayerAnimation.toValue = circleMaskPathFinal.CGPath
//        maskLayerAnimation.duration = 0.5
//        maskLayerAnimation.delegate = self
//        maskLayer.addAnimation(maskLayerAnimation, forKey: "path")
//        
//        let PanAnimation = CABasicAnimation(keyPath: "transform.scale")
//        PanAnimation.fromValue = NSNumber(double: 1.0)
//        PanAnimation.toValue = NSNumber(double: 100)
//        PanAnimation.duration = 10.0
//        PanAnimation.delegate = self
//        finalLayer.addAnimation(PanAnimation, forKey: "transform.scale")
        
        if whichView == "Hotels" {
            
            hotels = HotelTypeSelect(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            hotels.layer.opacity = 0.0
            hotels.doneButton.layer.cornerRadius = 5
            hotels.doneButton.addTarget(self, action: #selector(ExploreHotelsViewController.doneHotelFilter(_:)), for: .touchUpInside)
            self.view.addSubview(hotels)
            
            for button in hotels.hotelFiltersButton {
                
                button.layer.cornerRadius = 5
                button.addTarget(self, action: #selector(ExploreHotelsViewController.hotelType(_:)), for: .touchUpInside)
                
            }
            
            for button in hotels.starButtons {
                
                button.addTarget(self, action: #selector(ExploreHotelsViewController.starRating(_:)), for: .touchUpInside)
                
            }
            
            hotels.animation.makeOpacity(1.0).animate(0.3)
            
        }
        
        else {
            
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            scrollView.contentSize.height = 1650
            scrollView.layer.zPosition = 100
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.layer.opacity = 0.0
            self.view.addSubview(scrollView)
            
            let filterVC = storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterCheckboxesViewController
            self.addChildViewController(filterVC)
            filterVC.view.frame.size.height = scrollView.contentSize.height
            filterVC.doneButton.addTarget(self, action: #selector(ExploreHotelsViewController.filterDone(_:)), for: .touchUpInside)
            filterVC.whichView = "Restaurants"
            scrollView.addSubview(filterVC.view)
//            let filter = FilterCheckboxesViewController()
//            filterVC.delegate = self
//            filterVC.didMoveToParentViewController(self)
//            self.registerForPreviewingWithDelegate(self, sourceView: scrollView)
            scrollView.animation.makeOpacity(1.0).animate(0.3)
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        getHotels()
        
    }
    
    func doneHotelFilter(_ sender: UIButton) {
        
        print("inside done hotel filter button")
        hotels.animation.makeOpacity(0.0).animate(0.3)
        
    }
    
    func hotelType(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            sender.backgroundColor = mainOrangeColor
            sender.tag = 1
        }
        
        else {
            
            sender.backgroundColor = mainBlueColor
            sender.tag = 0
            
        }
    }
    
    func filterDone(_ sender: UIButton) {
        
        scrollView.animation.makeOpacity(0.0).animate(0.3)
        
    }
    
    func starRating(_ sender: UIButton) {
        
        print("inside rating button")
        
        if sender.tag == 0 {
            
            sender.setImage(UIImage(named: "star_check"), for: UIControlState())
            sender.tag = 1
        }
            
        else {
            
            sender.setImage(UIImage(named: "star_uncheck"), for: UIControlState())
            sender.tag = 0
        }
    }
    
//    override func viewDidAppear(animated: Bool) {
//        
//        UIView.animateWithDuration(0.8, delay: 0.0, options: [.CurveEaseOut], animations: {
//            self.animationHasBeenShown = true
//            }, completion: nil)
//        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotelCell") as! HotelsTableViewCell
        cell.hotelNames.text = data[(indexPath as NSIndexPath).row]["name"].string!
        cell.hotelExpense.text = data[(indexPath as NSIndexPath).row]["budget"].string!
//        cell.hotelNames.text = hotelNames[indexPath.row]
        
        if (indexPath as NSIndexPath).row % 2 == 0 {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        }
        
        else {
            
            cell.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        }
        
        if whichView == "Hotels" {
            
            cell.restaurantCuisines.isHidden = true
            
        }
        else if whichView == "Rest" {
            
            cell.ratingStack.isHidden = true
            
        }
        
        for image in cell.ratingStars {
            
            image.tintColor = mainBlueColor
            
        }
        
        return cell
    }
    
    func makeStars(_ view: UIView, starCount: Int) {
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let headerView = HotelsCustomHeader(frame: CGRect(x: 0, y: -20, width: tableView.frame.width, height: 85))
        headerView.backgroundColor = mainBlueColor
        self.view.addSubview(headerView)
        
        return headerView
    }
    
    func getHotels() {
        
        var view = "Hotels"
        
        if whichView == "Hotels" {
            
            view = "hotels"
            
        }
        else if whichView == "Rest" {
            
            view = "restaurants"
            
        }
        
        
        request.cityTypeData("hotels", city: city, completion: {(response) in
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"] {
                    
                    self.data = response["data"].array!
                    self.myTableView.reloadData()
                    
                }
                else {
                    
                    print("response error")
                    
                }
                
            })
            
        })
    }
    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return 4
//        
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        
//        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("navCell", forIndexPath: indexPath) as! NavigationCollectionViewCell
//        cell.navLabel.text = labelName[indexPath.item]
//        return cell
//        
//    }
//    
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! NavigationCollectionViewCell
//        cell.selectionUnderline.backgroundColor = mainOrangeColor
//        
//    }
//    
//    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        
//        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! NavigationCollectionViewCell
//        cell.selectionUnderline.backgroundColor = UIColor.whiteColor()
//        
//    }

}

class HotelsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hotelNames: UILabel!
    @IBOutlet weak var hotelExpense: UILabel!
    @IBOutlet weak var ratingStack: UIStackView!
    @IBOutlet weak var restaurantCuisines: UILabel!
    @IBOutlet var ratingStars: [UIImageView]!
    
}

//class NavigationCollectionViewCell: UICollectionViewCell {
//    
//    @IBOutlet weak var navLabel: UILabel!
//    @IBOutlet weak var selectionUnderline: UIView!
//    
//}

//class CircleTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
//    
//    weak var transitionContext: UIViewControllerContextTransitioning?
//    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
//        return 0.5
//    }
