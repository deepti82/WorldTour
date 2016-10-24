//
//  ExploreDestinationsViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 09/06/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit
import DKChainableAnimationKit

class ExploreDestinationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var flag: [Int] = []
    let countries = ["India", "USA", "UK"]
    let cities = [["Mumbai", "Pune", "Delhi"], ["Illinois", "Denver", "California"], ["London", "Birmigham", "Southampton"]]
    let cityImages = [["bandra_worli_sea_link", "pune_landmark", "agra_fort"], ["bandra_worli_sea_link", "pune_landmark", "agra_fort"], ["bandra_worli_sea_link", "pune_landmark", "agra_fort"]]
    let countryImages = ["india_gate", "usa", "usa"]
    var currentTableRow = 0
    var cityFlag: [[Int]] = [[]]
    var toggle = false
    var addSubview = false
    
    @IBOutlet weak var searchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightButton = UIButton()
        let options = String(format: "%C", faicon["options"]!)
        rightButton.titleLabel?.font = UIFont(name: "FontAwesome", size: 22)
        rightButton.setTitle(options, for: UIControlState())
        rightButton.addTarget(self, action: #selector(ExploreDestinationsViewController.showFilter(_:)), for: .touchUpInside)
        rightButton.frame = CGRect(x: 30, y: 15, width: 30, height: 30)
        
        self.setOnlyRightNavigationButton(rightButton)
        
        let searchHeader = SearchFieldView(frame: CGRect(x: 5, y: 30, width: self.view.frame.width - 10, height: 30))
//        searchHeader.center = CGPointMake(self.view.frame.width/2, 20)
        searchView.addSubview(searchHeader)
        
        for i in 0 ..< countries.count {
            
            flag.append(0)
            cityFlag.insert([], at: i)
            print("Cities count \(cities[i].count)")
            for j in 0 ..< cities[i].count {
                
                cityFlag[i].insert(0, at: j)
                print("cityflag: \(cityFlag[i][j])")
            }
            
            print("country flag \(flag[i])")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showFilter(_ sender: UIButton) {
        
        print("Show filter tapped")
        
        if !addSubview {
            
            let filter = FilterIntinerariesType(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            filter.tag = 1
            filter.layer.zPosition = 100
            filter.layer.opacity = 0
            self.view.addSubview(filter)
            addSubview = true
            
        }
        
        var filterSubview: UIView!
        
        for subview in self.view.subviews {
            
            if subview.tag == 1 {
                filterSubview = subview
            }
            
        }
        
        if !toggle {
            
            filterSubview.animation.makeOpacity(1.0).animate(0.5)
//            print("filter opacity: \()")
            toggle = true
            
        }
        
        else {
            
            print("else toggle")
            filterSubview.animation.makeOpacity(0.0).easeIn.animate(0.5)
            toggle = false
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("table cell index: \((indexPath as NSIndexPath).row)")
        currentTableRow = (indexPath as NSIndexPath).row
        
        let coverImageGradient = CAGradientLayer()
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell") as! ExploreDestinationsTableViewCell
        
        if flag[(indexPath as NSIndexPath).row] == 0 {
            
            let blackColour = UIColor.black.withAlphaComponent(0.9).cgColor as CGColor
            let transparent = UIColor.clear.cgColor as CGColor
            
            coverImageGradient.frame = cell.contentMainView.frame
            coverImageGradient.frame.size.width = cell.contentMainView.frame.width + 100
            coverImageGradient.colors = [blackColour, transparent]
            coverImageGradient.locations = [0.0, 0.25]
            
            cell.contentMainView.layer.addSublayer(coverImageGradient)
            cell.countryLabel.layer.zPosition = 10
            cell.flagImage.layer.zPosition = 10
            
            flag[(indexPath as NSIndexPath).row] = 1
        }
        
        cell.countryLabel.text = countries[(indexPath as NSIndexPath).row]
        cell.countryImage.image = UIImage(named: countryImages[(indexPath as NSIndexPath).row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cities[collectionView.tag].count
        
    }
    
    func tableView(tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let tableViewCell = cell as! ExploreDestinationsTableViewCell
//        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: (indexPath as NSIndexPath).row)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("collection cell index: \((indexPath as NSIndexPath).item)")
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! ExploreDestinationsCollectionViewCell
        
        if cityFlag[collectionView.tag][(indexPath as NSIndexPath).item] == 0 {
            
            let cityImageGradient = CAGradientLayer()
            
            let blackColour = UIColor.black.withAlphaComponent(0.9).cgColor as CGColor
            let transparent = UIColor.clear.cgColor as CGColor
            
            cityImageGradient.frame = cell.cityLabel.bounds
            cityImageGradient.colors = [blackColour, transparent]
            cityImageGradient.locations = [0.0, 0.75]
            
            cell.cityLabel.layer.addSublayer(cityImageGradient)
            cell.cityText.layer.zPosition = 10
            
            cityFlag[collectionView.tag][(indexPath as NSIndexPath).item] = 1
            
        }
        
        cell.cityText.text = cities[collectionView.tag][(indexPath as NSIndexPath).item]
        cell.cityImage.image = UIImage(named: cityImages[collectionView.tag][(indexPath as NSIndexPath).item])
        cell.cityImage.layer.zPosition = -1
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let childVC = storyboard?.instantiateViewControllerWithIdentifier("pagerTab") as! PagerTabViewController
//        self.navigationController?.pushViewController(childVC, animated: true)

        let childVC = storyboard?.instantiateViewController(withIdentifier: "featuredMain") as! FCMainViewController
        self.navigationController?.pushViewController(childVC, animated: true)
        
    }

}


class ExploreDestinationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var contentMainView: UIView!
    
    
//    func setCollectionViewDataSourceDelegate
//        <D: UICollectionViewDataSource & UICollectionViewDelegate
//        (_ dataSourceDelegate: D, forRow row: Int) {
//        
//        theCollectionView.delegate = dataSourceDelegate
//        theCollectionView.dataSource = dataSourceDelegate
//        theCollectionView.tag = row
//        theCollectionView.reloadData()
//        
//    }
    
}

class ExploreDestinationsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cityLabel: UIView!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var cityText: UILabel!
    
}
