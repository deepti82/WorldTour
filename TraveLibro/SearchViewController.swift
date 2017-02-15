//
//  SearchViewController.swift
//  TraveLibro
//
//  Created by Pranay Joshi on 14/02/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var search: SearchFieldView!
    @IBOutlet var SearchView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getDarkBackGround(self)
        search = SearchFieldView(frame: CGRect(x: 10, y: 8, width: SearchView.frame.width - 20 , height: 30))
        search.searchField.returnKeyType = .done
        SearchView.addSubview(search)
  
        transparentCardWhite(SearchView)
        search.searchField.attributedPlaceholder = NSAttributedString(string:  "Search", attributes: [NSForegroundColorAttributeName: mainBlueColor])
        search.leftLine.backgroundColor = mainOrangeColor
        search.rightLine.backgroundColor = mainOrangeColor
        search.bottomLine.backgroundColor = mainOrangeColor
        search.searchButton.tintColor = mainOrangeColor
        
        let tapout = UITapGestureRecognizer(target: self, action: #selector(self.searchTable(_:)))
        search.SearchView.addGestureRecognizer(tapout)

        
        let searchView = Search(frame: CGRect(x: 0, y: 105, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(searchView)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchTable(_ sender: UITapGestureRecognizer) {
        let searchTable = storyboard?.instantiateViewController(withIdentifier: "searchTable") as! SearchTableViewController
        globalNavigationController.pushViewController(searchTable, animated: true)
        print("hello")
        search.searchField.placeholder = ""
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
