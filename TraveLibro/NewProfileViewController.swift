//
//  NewProfileViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 17/04/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class NewProfileViewController: UIViewController {

    var footer:FooterViewNew!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "search_toolbar"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(self.searchTapped(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: -10, y: 8, width: 30, height: 30)
        self.setOnlyRightNavigationButton(rightButton)
        
        footer = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - MAIN_FOOTER_HEIGHT, width: self.view.frame.width, height: MAIN_FOOTER_HEIGHT))
        self.view.addSubview(footer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
