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
    var mainFooter: FooterViewNew!
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainFooter = FooterViewNew(frame: CGRect(x: 0, y: self.view.frame.height - 65, width: self.view.frame.width, height: 65))
        self.mainFooter.layer.zPosition = 5
        self.view.addSubview(self.mainFooter)
        getDarkBackGround(self)
        journeyTableView.backgroundColor = UIColor.clear
        journeyTableView.tableFooterView = UIView()
        
        self.setNavigationBarItem()
        
        getPopularJourneys()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideHeaderAndFooter(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Fetch Data
    
    func getPopularJourneys() {
        
        print("\n fetching data for : \(currentPageNum)")
        
        request.getPopularJourney(userId: currentUser["_id"].stringValue, pagenumber: currentPageNum) { (response) in
            
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
            hideHeaderAndFooter(true);
        }
        else{
            hideHeaderAndFooter(false);
        }
        
    }
    
    func hideHeaderAndFooter(_ isShow:Bool) {
        if(isShow) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)            
            self.mainFooter.frame.origin.y = self.view.frame.height + 95
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: true)            
            self.mainFooter.frame.origin.y = self.view.frame.height - 65            
        }
    }

}


