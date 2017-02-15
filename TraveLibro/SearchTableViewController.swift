//
//  SearchTableViewController.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 14/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
import DKChainableAnimationKit

class SearchTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate {

     var searchController: UISearchController!
    @IBOutlet weak var searchTable: UITableView!
    @IBOutlet weak var hashTagSlide: UIView!
    @IBOutlet weak var hashtagsSearch: UIButton!
    @IBOutlet weak var peopleSearch: UIButton!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet var noTravellersStrip: UILabel!
    @IBOutlet var selectStrip: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        transparentCardWhite(selectStrip)
        sliderView.isHidden = false
        hashTagSlide.isHidden = true
        getDarkBackGround(self)
        noTravellersStrip.isHidden = true
        configureSearchController()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "search", for: indexPath) as! searchHashtags
        cell.peopleHashtagsImage.image = UIImage(named: "logo-default")
        noColor(cell.peopleHashtagsImage)
        cell.nameHashtagsLabel.text = "Pranay"
        cell.slurgHashtimesLabel.text = "pranay@gmail.com"
        cell.hashLabel.isHidden = true
        return cell
    }
    
    @IBAction func people(_ sender: Any) {
        sliderView.isHidden = false
        hashTagSlide.isHidden = true
//        if peopleSearch.tag == 0 {
//        sliderView.animation.animate(1.0).moveX(-242).easeOut.animate(1.0)
//        }else {
//           sliderView.animation.animate(1.0).moveX(242).easeOut.animate(1.0)
//        }
    }
   
    @IBAction func hashtags(_ sender: UIButton) {
        
        hashTagSlide.isHidden = false
        sliderView.isHidden = true
//        if hashtagsSearch.tag == 0 {
//            sliderView.animation.animate(1.0).moveX(242).easeOut.animate(1.0)
//        }else {
//            sliderView.animation.animate(1.0).moveX(0).easeOut.animate(1.0)
//        }

        
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
//        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchTable.tableHeaderView = searchController.searchBar
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class searchHashtags: UITableViewCell{
    
    @IBOutlet weak var peopleHashtagsImage: UIImageView!
    @IBOutlet weak var nameHashtagsLabel: UILabel!
    @IBOutlet weak var slurgHashtimesLabel: UILabel!
    @IBOutlet weak var hashLabel: UILabel!
    
}
