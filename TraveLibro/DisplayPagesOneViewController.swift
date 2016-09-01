//
//  DisplayPagesOneViewController.swift
//  TraveLibro
//
//  Created by Harsh Thakkar on 01/09/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class DisplayPagesOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(0, 0, 30, 30)
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(DisplayPagesTwoViewController.nextPage(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        self.customNavigationBar(leftButton, right: rightButton)
        
//        let theScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        theScrollView.delaysContentTouches = false
//        self.view.addSubview(theScrollView)
        
//        checkBoxNumber = 6
//        
//        let cardView = TutorialCards(frame: CGRect(x: 25, y: 125, width: self.view.frame.width - 50, height: 6 * 125 - 75))
//        cardView.cardTitle.text = "Your kind of journey"
////        cardView.cardDescription.text = cardDescription
//        self.view.addSubview(cardView)
        
    }
    
    func nextPage(sender: UIButton) {
        
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("displayTwo") as! DisplayPagesTwoViewController
        self.navigationController?.pushViewController(next, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
