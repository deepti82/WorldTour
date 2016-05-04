//
//  OnTheGoViewController.swift
//  TraveLibro
//
//  Created by Chintan Shah on 02/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class OnTheGoViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let drawView = drawLine(frame: CGRect(x: 0, y: 0, width: 400, height: 700))
        self.view.addSubview(drawView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
