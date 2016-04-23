//
//  ViewController.swift
//  TraveLibro
//
//  Created by Wohlig Technology on 23/04/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let mainBlueColor = UIColor(red: 0.1725, green: 0.2175, blue: 0.3412, alpha: 1) // #2C3757
    let mainOrangeColor = UIColor(red: 1, green: 0.408, blue: 0.345, alpha: 1) // #FF6858
    let avenirFont = UIFont(name: "AvenirRoman", size: 14)
    let FoneAwesomeFont = UIFont(name: "FontAwesome", size: 14)
    
    let button: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // adding status bar view
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: 20.0))
        view.backgroundColor = mainBlueColor
        self.view.addSubview(view)
        
        // appling avenir font to label and button
        UILabel.appearance().font = avenirFont
        button.titleLabel!.font = avenirFont        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}