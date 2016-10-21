//
//  FeaturedCitiesRestViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 19/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class FeaturedCitiesRestViewController: UIViewController {
    
    @IBOutlet weak var mainScroll: UIScrollView!
    
    var whichView: String!
    var layout: VerticalLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("which view in rest: \(whichView)")
        
//        let allSubviews = self.view.subviews
        
//        for eachSubview in allSubviews {
//            
//            if !(eachSubview is UICollectionView) {
//                
//                print("Each subview: \(eachSubview)")
//                eachSubview.removeFromSuperview()
//                
//            }
//            
//        }
        
        layout = VerticalLayout(width: self.view.frame.width);
//        self.verticalLayout.frame = self.view.frame
//        self.verticalLayout.backgroundColor = UIColor.whiteColor()
        
        switch whichView {
        case "IT":
            let toSelectItinerary = UITapGestureRecognizer(target: self, action: #selector(self.itineraryTap(_:)))
            
            let filter = UIButton(frame: CGRect(x: 315, y: 455, width: 50, height: 50))
            filter.setImage(UIImage(named: "filter_icon"), for: UIControlState())
            filter.layer.zPosition = 1000
            filter.addTarget(self, action: #selector(FeaturedCitiesRestViewController.showItineraryFilters(_:)), for: .touchUpInside)
            self.view.addSubview(filter)
            
            let itineraryView = Itineraries(frame: CGRect(x: 0, y: 10, width: layout.frame.width, height: 500))
//            toSelectItinerary.delegate = itineraryView.toTapView
            addHeightToScrollView(itineraryView.frame.height)
            layout.addSubview(itineraryView)
            itineraryView.toTapView.addGestureRecognizer(toSelectItinerary)
            
            let itineraryViewTwo = Itineraries(frame: CGRect(x: 0, y: 10, width: layout.frame.width, height: 500))
            addHeightToScrollView(itineraryViewTwo.frame.height)
            layout.addSubview(itineraryViewTwo)
            itineraryView.toTapView.addGestureRecognizer(toSelectItinerary)
            break
            
        case "JO":
            let popJourneyView = PopularJourneyView(frame: CGRect(x: 0, y: 10, width: layout.frame.width, height: 550))
            addHeightToScrollView(popJourneyView.frame.height)
            layout.addSubview(popJourneyView)
            let popJourneyViewTwo = PopularJourneyView(frame: CGRect(x: 0, y: 10, width: layout.frame.width, height: 550))
            addHeightToScrollView(popJourneyViewTwo.frame.height)
            layout.addSubview(popJourneyViewTwo)
//            self.view.addSubview(popJourneyView)
            break
            
        case "AG":
            let popAgentsView = PopularAgents(frame: CGRect(x: 0, y: 5, width: layout.frame.width, height: 250))
            addHeightToScrollView(popAgentsView.frame.height)
            layout.addSubview(popAgentsView)
            let popAgentsViewTwo = PopularAgents(frame: CGRect(x: 0, y: 5, width: layout.frame.width, height: 250))
            addHeightToScrollView(popAgentsViewTwo.frame.height)
            layout.addSubview(popAgentsViewTwo)
            let popAgentsViewThree = PopularAgents(frame: CGRect(x: 0, y: 5, width: layout.frame.width, height: 250))
            addHeightToScrollView(popAgentsViewThree.frame.height)
            layout.addSubview(popAgentsViewThree)
            let popAgentsViewFour = PopularAgents(frame: CGRect(x: 0, y: 5, width: layout.frame.width, height: 250))
            addHeightToScrollView(popAgentsViewFour.frame.height)
            layout.addSubview(popAgentsViewFour)
//            self.view.addSubview(popAgentsView)
            break
            
        default:
            break
        }
        
        mainScroll.contentSize.height = layout.frame.size.height + 50
        mainScroll.addSubview(layout)
        print("scroll view height: \(mainScroll.contentSize.height)")
        print("scroll view subviews: \(mainScroll.subviews)")
//        mainScroll.removeFromSuperview()
//        self.view.addSubview(verticalLayout)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itineraryTap (_ sender: UITapGestureRecognizer? = nil) {
        
        let eachItineraryController = storyboard!.instantiateViewController(withIdentifier: "EachItineraryViewController") as! EachItineraryViewController
        segueFromPagerStrip(nvcTwo, nextVC: eachItineraryController)
        
    }
    
    var filterView: FilterItineraries!
    var scroll: UIScrollView!
    
    func showItineraryFilters(_ sender: UIButton) {
        
        scroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        scroll.layer.zPosition = 1001
        self.view.addSubview(scroll)
        
        filterView = FilterItineraries(frame: CGRect(x: 0, y: 0, width: scroll.frame.width, height: 835))
        filterView.layer.opacity = 0.0
        scroll.addSubview(filterView)
        
        scroll.contentSize.height = filterView.frame.height
        
        filterView.doneButton.addTarget(self, action: #selector(FeaturedCitiesRestViewController.filtersApply(_:)), for: .touchUpInside)
        
        filterView.animation.makeOpacity(1.0).animate(0.5)
        
        for button in filterView.placeButtons {
            
            button.addTarget(self, action: #selector(FeaturedCitiesRestViewController.checkPlace(_:)), for: .touchUpInside)
            
        }
        
        for button in filterView.stackButtons {
            
            button.addTarget(self, action: #selector(FeaturedCitiesRestViewController.checkTypes(_:)), for: .touchUpInside)
            
        }
        
        for button in filterView.categoryButtons {
            
            button.addTarget(self, action: #selector(FeaturedCitiesRestViewController.checkCategories(_:)), for: .touchUpInside)
            
        }
    }
    
    func filtersApply(_ sender: UIButton) {
        
        //        let subview = self.view.subviews.last
        //
        //        let subsubview = subview?.subviews.last
        print("In done button target")
        filterView.animation.makeOpacity(0.0).animate(0.5)
        scroll.animation.makeOpacity(0.0).animate(0.5)
        
    }
    
    func checkPlace(_ sender: UIButton) {
        
        let subviews = sender.titleLabel?.subviews
        
        if sender.tag == 0 {
            
            let checked = UIImageView(frame: CGRect(x: -25, y: 0, width: 20, height: 20))
            checked.image = UIImage(named: "checkbox_fill")
            sender.titleLabel?.addSubview(checked)
            checked.tag = 2
            sender.tag = 1
            
        }
        
        for subview in subviews! {
            
            if subview.tag == 1 && !sender.isSelected {
                
                subview.isHidden = true
                sender.isSelected = true
                
            }
                
            else if subview.tag == 1 && sender.isSelected {
                
                sender.isSelected = false
                subview.isHidden = false
                
            }
            
            if subview.tag == 2 && sender.isSelected {
                
                subview.isHidden = false
                
            }
                
            else if subview.tag == 2 && !sender.isSelected {
                
                subview.isHidden = true
                
            }
            
        }
        
        
    }
    
    func checkTypes(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            sender.setBackgroundImage(UIImage(named: "orangebox"), for: UIControlState())
            sender.tag = 1
            
        }
            
        else {
            
            sender.setBackgroundImage(UIImage(named: "bluebox"), for: UIControlState())
            sender.tag = 0
            
        }
        
    }
    
    
    func checkCategories (_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            sender.backgroundColor = UIColor(red: 252/255, green: 80/255, blue: 71/255, alpha: 1)
            sender.tag = 1
            
        }
            
        else {
            
            sender.backgroundColor = UIColor(red: 35/255, green: 45/255, blue: 74/255, alpha: 1)
            sender.tag = 0
            
        }
        
    }
    
    func addHeightToScrollView(_ height: CGFloat) {
        
        print("height: \(height)")
        layout.frame.size.height += height
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
