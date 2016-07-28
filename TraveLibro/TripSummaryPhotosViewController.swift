//
//  TripSummaryPhotosViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 28/07/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class TripSummaryPhotosViewController: UIViewController {

    @IBOutlet weak var listContainer: UIView!
    @IBOutlet weak var gridContainer: UIView!
    
    internal var whichView : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridContainer.alpha = 1
        listContainer.alpha = 0
        
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
