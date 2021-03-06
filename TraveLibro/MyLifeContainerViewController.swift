//
//  MyLifeContainerViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 07/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class MyLifeContainerViewController: UIViewController {
    
    @IBOutlet weak var TheScrollView: UIScrollView!
    
    var verticalLayout: VerticalLayout!
    var whichView = "All"
    var whichEmptyView = "Journeys-All"
    var isInitalLoad = true
    var empty: EmptyScreenView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEmptyProfile = true
        
//        print("profile empty status: \(isEmptyProfile)")
        
//        print("which view simple container: \(whichView)")
        
        verticalLayout = VerticalLayout(width: self.view.frame.width+4);
        
        if isEmptyProfile {
            
//            print("here")
            
            if isInitalLoad {
                
                empty = EmptyScreenView(frame: CGRect(x: 0, y: 0, width: verticalLayout.frame.width, height: 250))
                //            print("here")
                self.addHeightToLayout(empty.frame.height)
                verticalLayout.addSubview(empty)
                isInitalLoad = false
                //            print("here")
            }
            
            print("which view in empty profile: \(whichEmptyView)")
            print("is loaded \(whichEmptyView)")
            print("is loaded \(whichEmptyView)")
            switch whichEmptyView {
            case "Journeys-All":
                print("in journeys all")
                empty.frame.size.height = 275.0
                empty.viewHeading.text = "Travel in a Time Machine"
                empty.viewBody.text = "Capture your journeys and activities whether local or global, creating a beautiful timeline and relive these treasured experiences of your past."
                break
            case "Journeys-TravelLife":
                print("in journeys tl")
                empty.frame.size.height = 350.0
                empty.viewHeading.text = "My Tales & Trails"
                let head = NSMutableAttributedString(string: "On-the-Go Journeys ", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 16)!])
                let body: NSMutableAttributedString = NSMutableAttributedString(attributedString: head)
                let bodyOne = NSMutableAttributedString(string: "\n Capture each moment of your journey via check-ins, pictures, videos, and thoughts live On-the-Go to create a stunning timeline with friends and family. \n \n ", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!])
                let headTwo = NSMutableAttributedString(string: "Chronicling Past Travels ", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Heavy", size: 16)!])
                let bodyTwo = NSMutableAttributedString(string: "\n Revisit the treasured moments of your past travels by creating a beautiful memoir of your trip.", attributes: [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 16)!])
                body.appendAttributedString(bodyOne)
                body.appendAttributedString(headTwo)
                body.appendAttributedString(bodyTwo)
                empty.viewBody.attributedText = body
                break
            case "Journeys-LocalLife":
                print("in journeys ll")
                empty.frame.size.height = 325.0
                empty.viewHeading.text = "Life In The City"
                empty.viewBody.text = "Candid, fun moments with friends, happy family get-togethers, some precious ‘me-time’…share your love for your city and inspire others to do the same. Cherish your local life memories eternally."
                break
            case "Moments–All":
                print("in moments all")
                empty.frame.size.height = 250.0
                empty.viewHeading.text = "Unwind​ B​y Rewinding"
                empty.viewBody.text = "Revisit and reminisce the days gone by through brilliant pictures and videos of your travel and local life."
                break
            case "Moments-TravelLife":
                print("in moments tl")
                empty.frame.size.height = 350.0
                empty.viewHeading.text = "Travel Becomes A Reason To Take Pictures And Store Them"
                empty.viewBody.text = "Some memories are worth sharing, travel surely tops the list. Your travels will not only inspire you to explore more of the world, you may just move another soul or two!"
                break
            case "Moments-LocalLife":
                print("in moments ll")
                empty.frame.size.height = 275.0
                empty.viewHeading.text = "Suspended In Time"
                empty.viewBody.text = "Beautiful memories created through fabulous pictures and videos of those precious moments shared with family, friends and yourself."
                break
            case "Reviews-All":
                print("in reviews all")
                empty.frame.size.height = 275.0
                empty.viewHeading.text = "Relive Y​our Storyline"
                empty.viewBody.text = "Rate the places, restaurants, cuisines, theatres, parks, museums, and more, when you check-in. Jot down your thoughts and feelings about them."
                break
            case "Reviews-TravelLife":
                print("in reviews tl")
                empty.frame.size.height = 285.0
                empty.viewHeading.text = "The World I​s Your Oyster"
                empty.viewBody.text = "A five star or a four star? What does that historical monument qualify for? Rate it and write a review. Help others with your rating and review."
                break
            case "Reviews-LocalLife":
                print("in reviews ll")
                empty.frame.size.height = 285.0
                empty.viewHeading.text = "A Touch Of Your Daily Dose"
                empty.viewBody.text = "Now how about rating and writing a super review for that newly-opened restaurant in your town? Wherever you go, click on a star and pen down your experiences."
                break
            default:
                print("in default")
                empty.frame.size.height = 250.0
                empty.viewHeading.text = "Unwind​ B​y Rewinding"
                empty.viewBody.text = "Revisit and reminisce the days gone by through brilliant pictures and videos of your travel and local life."
                break
            }
        }
        
        else {
            
            let tag = TimestampTagViewOnScroll(frame: CGRect(x: self.view.frame.width - 130, y: 20, width: 135, height: 75))
            //        tag.clipsToBounds = true
            tag.layer.zPosition = 1000
            self.view.addSubview(tag)
         
            let postOne = InProfileOTGPost(frame: CGRect(x: 0, y: 0, width: verticalLayout.frame.width, height: 450))
            postOne.clipsToBounds = true
            postOne.statusLabel.text = "Manan Vora ended his London Journey"
            postOne.iconButtonView.removeFromSuperview()
            
            
            let postTwo = NewProfilePosts(frame: CGRect(x: 0, y: -4, width: verticalLayout.frame.width, height: 700))
            postTwo.profileImageView.removeFromSuperview()
            postTwo.profileName.removeFromSuperview()
            postTwo.timestamp.removeFromSuperview()
            postTwo.followButton.removeFromSuperview()
            postTwo.iconButton.removeFromSuperview()
            postTwo.seperatorViewUp.removeFromSuperview()
            postTwo.OTGLabelView.removeFromSuperview()
            postTwo.titleConstraint.constant = 8.0
            postTwo.iconButtonUpConstraint.constant = 8.0
            postTwo.clipsToBounds = true
            
            let postThree = NewThoughtsView(frame: CGRect(x: 0, y: -16, width: verticalLayout.frame.width, height: 280))
            postThree.profileImage.removeFromSuperview()
            postThree.profileName.removeFromSuperview()
            postThree.timestamp.removeFromSuperview()
            postThree.followButton.removeFromSuperview()
            postThree.iconButton.removeFromSuperview()
            postThree.seperatorOne.removeFromSuperview()
            postThree.OTGLabelView.hidden = true
            postThree.titleDistanceConstraint.constant = 8.0
            postThree.buttonDistanceConstraint.constant = 8.0
            postThree.clipsToBounds = true
            
            switch whichView {
            case "All":
                print("All journeys")
                self.addHeightToLayout(postOne.frame.height)
                verticalLayout.addSubview(postOne)
                self.addHeightToLayout(postTwo.frame.height)
                verticalLayout.addSubview(postTwo)
                self.addHeightToLayout(postThree.frame.height)
                verticalLayout.addSubview(postThree)
                break
                
            case "TL":
                print("TL journeys")
                self.addHeightToLayout(postOne.frame.height)
                verticalLayout.addSubview(postOne)
                break
                
            case "LL":
                print("LL journeys")
                self.addHeightToLayout(postTwo.frame.height)
                verticalLayout.addSubview(postTwo)
                self.addHeightToLayout(postThree.frame.height)
                verticalLayout.addSubview(postThree)
                break
                
            default:
                break
            }
            
        }
        
        print("here")
        TheScrollView.contentSize.height = verticalLayout.frame.height + 100
        TheScrollView.addSubview(verticalLayout)
        print("here")
        
//        verticalLayout.userInteractionEnabled = false
        
    }
    
    func addHeightToLayout(height: CGFloat) {
        
        verticalLayout.frame.size.height += height
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
