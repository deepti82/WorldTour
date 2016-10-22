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
        rightButton.setImage(UIImage(named: "arrow_next_fa"), for: UIControlState())
        rightButton.addTarget(self, action: #selector(TripSummaryPhotosViewController.changeView(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        self.customNavigationBar(left: leftButton, right: rightButton)
        
        gridContainer.alpha = 1
        listContainer.alpha = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func changeView(_ sender: UIButton) {
        
        if gridContainer.alpha == 1 {
            
            gridContainer.alpha = 0
            listContainer.alpha = 1
            
        }
        else {
            
            gridContainer.alpha = 1
            listContainer.alpha = 0
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "photoGridEmbed" {
            
            let photoGrid = segue.destination as! TripSummaryPhotoGridViewController
            photoGrid.journeyId = journey
            
        }
        else if segue.identifier == "photoListEmbed" {
            
            let photoList = segue.destination as! ListPhotosViewController
            photoList.journeyId = journey
            photoList.journeyCreationDate = creationDate
        }
        
    }

}
