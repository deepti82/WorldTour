//
//  SignupCardsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class SignupCardsViewController: UIViewController {
    
    
    var pageIndex = 0
    var cardTitle: String = ""
    var cardDescription: String = ""
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let theScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        theScrollView.contentSize.height = 1000
        theScrollView.delaysContentTouches = false
        self.view.addSubview(theScrollView)
        
        let cardView = TutorialCards(frame: CGRect(x: 37.5, y: 100, width: self.view.frame.width - 75, height: 800))
        cardView.cardTitle.text = cardTitle
        cardView.cardDescription.text = cardDescription
        theScrollView.addSubview(cardView)
        
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
