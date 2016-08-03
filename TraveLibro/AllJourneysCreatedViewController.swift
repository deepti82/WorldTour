//
//  AllJourneysCreatedViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 29/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class AllJourneysCreatedViewController: UIViewController {

    @IBOutlet weak var mainScroll: UIScrollView!
    var layout: VerticalLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDarkBackGround(self)
        
        layout = VerticalLayout(width: self.view.frame.width)
        mainScroll.addSubview(layout)
        
        let subOne = InProfileOTGPost(frame: CGRect(x: 0, y: 20, width: layout.frame.width, height: 500))
        layout.addSubview(subOne)
        
        
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
