//
//  SignupCardsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 20/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

var checkBoxNumber: Int!

class SignupCardsViewController: UIViewController {
    
    
    var pageIndex = 0
    var cardTitle: String = ""
    var cardDescription: String = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
    var checkBoxes: CGFloat =  6
    var cardViewHeight: CGFloat!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkBoxNumber = Int(checkBoxes)
        
        let theScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        theScrollView.delaysContentTouches = false
        self.view.addSubview(theScrollView)
        
//        let view = TutorialCards()
//        view.cardDescription.text = "Lorem Ipsum is simply dummy"
        
        if checkBoxes < 6 {
            
            cardViewHeight = checkBoxes * 125 + 75
            
        }
        
        else if checkBoxes == 8 {
            
            cardViewHeight = checkBoxes * 100 - 50
            
        }
            
        else if checkBoxes == 11 {
            
            cardViewHeight = checkBoxes * 100 - 80
            
        }
        
        else {
            
            cardViewHeight = checkBoxes * 125 - 75
            
        }
        
        
        let cardView = TutorialCards(frame: CGRect(x: 25, y: 125, width: self.view.frame.width - 50, height: cardViewHeight))
        cardView.cardTitle.text = cardTitle
        cardView.cardDescription.text = cardDescription
        theScrollView.addSubview(cardView)
        
        if checkBoxes > 6 {
            
            theScrollView.contentSize.height = cardView.frame.height + 50
        }
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
