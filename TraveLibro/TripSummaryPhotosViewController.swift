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
    var fromView = ""
    
    var whichView : String!
    var journey = ""
    var creationDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showNavigationIn(img:"grid")
        
        gridContainer.alpha = 1
        listContainer.alpha = 0
        
    }
    
    func showNavigationIn(img: String) {
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: img), for: UIControlState())
        rightButton.addTarget(self, action: #selector(TripSummaryPhotosViewController.changeView(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 30, height: 30)
        
        let leftButton = UIButton()
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.popVC(_:)), for: .touchUpInside)
        leftButton.frame = CGRect(x: -10, y: 0, width: 30, height: 30)
        if fromView == "endJourney" {
            self.customNavigationBar(left: leftButton, right: nil)
        }else{
            self.customNavigationBar(left: leftButton, right: rightButton)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func changeView(_ sender: UIButton) {
        
        if gridContainer.alpha == 1 {
            showNavigationIn(img:"list")
            gridContainer.alpha = 0
            listContainer.alpha = 1
            
        }
        else {
            showNavigationIn(img:"grid")
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
