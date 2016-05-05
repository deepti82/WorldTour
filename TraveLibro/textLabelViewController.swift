//
//  textLabelViewController.swift
//  TraveLibro
//
//  Created by Chintan Shah on 05/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class textLabelViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.font = avenirFont
        label.backgroundColor = UIColor.clearColor()
        label.text = "Exploring united Kingdom"
        
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
