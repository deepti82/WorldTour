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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEmptyProfile = true
        
        print("profile empty status: \(isEmptyProfile)")
        
        print("which view simple container: \(whichView)")
        
        verticalLayout = VerticalLayout(width: self.view.frame.width+4);
        
        if isEmptyProfile {
            
            print("here")
            
            let empty = EmptyScreenView(frame: CGRect(x: 0, y: 0, width: verticalLayout.frame.width, height: 250))
//            empty.clipsToBounds = true
//            empty.statusLabel.text = "Manan Vora ended his London Journey"
//            empty.iconButtonView.removeFromSuperview()
            print("here")
            self.addHeightToLayout(empty.frame.height)
            verticalLayout.addSubview(empty)
            print("here")
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
