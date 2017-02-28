//
//  PopularJourneysViewController.swift
//  TraveLibro
//
//  Created by Midhet Sulemani on 24/05/16.
//  Copyright © 2016 Wohlig Technology. All rights reserved.
//

import UIKit

class PopularJourneysViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var journeyTableView: UITableView!
    var allJourneys: [JSON] = []
    var currentPageNum = 1
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getDarkBackGround(self)
        journeyTableView.backgroundColor = UIColor.clear
        journeyTableView.tableFooterView = UIView()
        
        self.setNavigationBarItem()
        
        getPopularJourneys()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Fetch Data
    
    func getPopularJourneys() {
        
        print("\n fetching data for : \(currentPageNum)")
        
        request.getPopularJourney(pagenumber: currentPageNum) { (response) in
            
            print("\n Popular journey response : \(response)")
            
            DispatchQueue.main.async(execute: {
                
                if response.error != nil {
                    
                    print("error: \(response.error!.localizedDescription)")
                    
                }
                else if response["value"].bool! {
                    
                    self.allJourneys = response["data"].array!
                    self.journeyTableView.reloadData()
                }
                else {
                    
                    print("response error!")
                    
                }
                
            })
            
        }
    }
    
    
    //MARK: - TableView Datasource and Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allJourneys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = allJourneys[indexPath.row]
        
        print("\n\n CellData : \(cellData) \n\n")
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "emptyCell", for: indexPath) as? EmptyTableViewCell
        if cell == nil {
             cell = EmptyTableViewCell.init(style: .default, reuseIdentifier: "emptyCell", data: cellData, helper: self)
        }
        else {
            cell?.setData(data: cellData, helper: self)
        }
        
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    

}


