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
    
    var whichView : String!
    var journey = ""
    var creationDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: "arrow_next_fa"), forState: .Normal)
        rightButton.addTarget(self, action: #selector(TripSummaryPhotosViewController.changeView(_:)), forControlEvents: .TouchUpInside)
        rightButton.frame = CGRectMake(0, 8, 30, 30)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), forState: .Normal)
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), forControlEvents: .TouchUpInside)
        leftButton.frame = CGRectMake(-10, 0, 30, 30)
        self.customNavigationBar(leftButton, right: rightButton)
        
        gridContainer.alpha = 1
        listContainer.alpha = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func changeView(sender: UIButton) {
        
        if gridContainer.alpha == 1 {
            
            gridContainer.alpha = 0
            listContainer.alpha = 1
            
        }
        else {
            
            gridContainer.alpha = 1
            listContainer.alpha = 0
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "photoGridEmbed" {
            
            let photoGrid = segue.destinationViewController as! TripSummaryPhotoGridViewController
            photoGrid.journeyId = journey
            
        }
        else if segue.identifier == "photoListEmbed" {
            
            let photoList = segue.destinationViewController as! ListPhotosViewController
            photoList.journeyId = journey
            photoList.journeyCreationDate = creationDate
        }
        
    }

}
