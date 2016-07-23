//
//  ExploreHotelsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 11/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ExploreHotelsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var whichView: String!
    
    let hotelNames = ["The Taj Mahal Palace", "Trident, Nariman Point", "The Taj Mahal Palace", "Trident, Nariman Point", "The Taj Mahal Palace", "Trident, Nariman Point"]
    let labelName = ["Must Do's", "Hotels", "Restaurants", "Popular Agents"]
//    var animationHasBeenShown = false
    weak var transitionContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func filterTap(sender: UIButton) {
        
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
            
            
            
            
        }
        
        else {
            
            let scrollView = UIScrollView(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: self.view.frame.height))
            scrollView.contentSize.height = 2500
            scrollView.layer.zPosition = 100
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.layer.opacity = 0.0
            self.view.addSubview(scrollView)
            
            let filterVC = storyboard?.instantiateViewControllerWithIdentifier("FilterViewController") as! FilterCheckboxesViewController
            addChildViewController(filterVC)
            filterVC.view.frame.size.height = scrollView.contentSize.height
            //        filterVC.view.layer.addSublayer(finalLayer)
            //        filterVC.view.layer.addAnimation(PanAnimation, forKey: "transform.scale")
            scrollView.addSubview(filterVC.view)
            filterVC.didMoveToParentViewController(self)
            
            scrollView.animation.makeOpacity(1.0).animate(0.5)
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return hotelNames.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("hotelCell") as! HotelsTableViewCell
        cell.hotelNames.text = hotelNames[indexPath.row]
        
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
        }
        
        else {
            
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        }
        
        if whichView == "Hotels" {
            
            cell.restaurantCuisines.hidden = true
            
        }
        else if whichView == "Rest" {
            
            cell.ratingStack.hidden = true
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        // Dequeue with the reuse identifier
        let headerView = HotelsCustomHeader(frame: CGRect(x: 0, y: -20, width: tableView.frame.width, height: 85))
        headerView.backgroundColor = mainBlueColor
        self.view.addSubview(headerView)
        
        return headerView
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