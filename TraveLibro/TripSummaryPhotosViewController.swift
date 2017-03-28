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
    var noPhoto = 0
    
    var whichView : String!
    var journey = ""
    var creationDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("on photo view controller")
        if whichView == "videos" {
            showNavigationIn(img:"list",text: "Videos")

        }else{
            showNavigationIn(img:"list",text: "Photos")

        }
        
        gridContainer.alpha = 1
        listContainer.alpha = 0
        
    }
    
    func showNavigationIn(img: String, text: String) {
        let rightButton = UIButton()
        rightButton.setImage(UIImage(named: img), for: UIControlState())
        rightButton.addTarget(self, action: #selector(TripSummaryPhotosViewController.changeView(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 0, y: 8, width: 20, height: 20)
        self.title = text
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        
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
    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
    }

    
    
    func changeView(_ sender: UIButton) {
        
        if gridContainer.alpha == 1 {
            if whichView == "videos" {
                showNavigationIn(img:"list",text: "Videos (\(noPhoto))")
                
            }else{
                showNavigationIn(img:"list",text: "Photos (\(noPhoto))")
                
            }
            gridContainer.alpha = 0
            listContainer.alpha = 1
            
        }
        else {
            if whichView == "videos" {
                showNavigationIn(img:"list",text: "Videos (\(noPhoto))")
                
            }else{
                showNavigationIn(img:"list",text: "Photos (\(noPhoto))")
                
            }
            //            setTopNavigation("Photos")
            gridContainer.alpha = 1
            listContainer.alpha = 0
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "photoGridEmbed" {
            
            let photoGrid = segue.destination as! TripSummaryPhotoGridViewController
            photoGrid.journeyId = journey
            photoGrid.fromView = fromView
            photoGrid.type = whichView
            
            
        }
        else if segue.identifier == "photoListEmbed" {
            
            let photoList = segue.destination as! ListPhotosViewController
            photoList.journeyId = journey
            photoList.type = whichView
            photoList.journeyCreationDate = creationDate
        }
        
    }

}
