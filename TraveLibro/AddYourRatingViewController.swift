//
//  AddYourRatingViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 14/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AddYourRatingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getBackGround(self)
        
        let addIcon = IconButton(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        addIcon.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 - 125)
        addIcon.button.setImage(UIImage(named: "star_rate_icon"), forState: .Normal)
        addIcon.view.backgroundColor = UIColor(red: 255/255, green: 104/255, blue: 88/255, alpha: 255/255)
        self.view.addSubview(addIcon)
        
        let addReviewView = AddRating(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 250))
        addReviewView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 100)
        self.view.addSubview(addReviewView)
        
        let postButton = UIButton(frame: CGRect(x: 0, y: 0, width: 75, height: 25))
        postButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 225)
        postButton.setTitle("POST", forState: .Normal)
        postButton.titleLabel?.font = avenirFont
        postButton.backgroundColor = mainBlueColor
        postButton.layer.cornerRadius = 5
        self.view.addSubview(postButton)
        
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
