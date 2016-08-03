//
//  AllJourneysViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 29/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AllJourneysViewController: UIViewController {

    @IBOutlet weak var mainScroll: UIScrollView!
    var layout: VerticalLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        
        layout = VerticalLayout(width: self.view.frame.width - 8)
        
        let postOne = InProfileOTGPost(frame: CGRect(x: 4, y: 8, width: layout.frame.width, height: 450))
        postOne.clipsToBounds = true
        postOne.statusLabel.text = "Manan Vora ended his London Journey"
        postOne.iconButtonView.removeFromSuperview()
        addHeightToLayout(postOne.frame.height)
        layout.addSubview(postOne)
        
        let postTwo = NewProfilePosts(frame: CGRect(x: 4, y: 0, width: layout.frame.width, height: 700))
        postTwo.profileImageView.removeFromSuperview()
        postTwo.profileName.removeFromSuperview()
        postTwo.timestamp.removeFromSuperview()
        postTwo.followButton.removeFromSuperview()
        postTwo.iconButton.removeFromSuperview()
        postTwo.seperatorViewUp.removeFromSuperview()
//        postTwo.OTGLabelView.removeFromSuperview()
        postTwo.titleConstraint.constant = 8.0
        postTwo.iconButtonUpConstraint.constant = 8.0
        postTwo.clipsToBounds = true
        addHeightToLayout(postTwo.frame.height)
        layout.addSubview(postTwo)
        
        let postThree = NewThoughtsView(frame: CGRect(x: 4, y: 0, width: layout.frame.width, height: 280))
        postThree.profileImage.removeFromSuperview()
        postThree.profileName.removeFromSuperview()
        postThree.timestamp.removeFromSuperview()
        postThree.followButton.removeFromSuperview()
        postThree.iconButton.removeFromSuperview()
        postThree.seperatorOne.removeFromSuperview()
//        postThree.OTGLabelView.hidden = true
        postThree.titleDistanceConstraint.constant = 8.0
        postThree.buttonDistanceConstraint.constant = 8.0
        postThree.clipsToBounds = true
        addHeightToLayout(postThree.frame.height)
        layout.addSubview(postThree)
        
        mainScroll.addSubview(layout)
        
    }
    
    func addHeightToLayout(height: CGFloat) {
        
        mainScroll.contentSize.height += height + 100
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
