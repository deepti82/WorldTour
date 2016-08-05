//
//  QuickItinerariesViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 05/08/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class QuickItinerariesViewController: UIViewController {
    
    var whichView: String!
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view: \(whichView)")
        
        switch whichView {
        case "One":
            let one = QuickItineraryOne(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 300))
            one.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
            self.view.addSubview(one)
        case "Two":
            let two = QuickItineraryTwo(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 450))
            two.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
            self.view.addSubview(two)
        case "Three":
            let three = QuickItineraryOne(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 300))
            three.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
            self.view.addSubview(three)
        case "Four":
            let four = QuickItineraryFour(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 400))
            four.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
            self.view.addSubview(four)
        case "Five":
            let five = QuickItineraryFive(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: 200))
            five.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
            self.view.addSubview(five)
        default:
            break
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
