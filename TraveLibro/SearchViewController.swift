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
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        print("in search view controller")
        getDarkBackGround(self)
        
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: 0, height: 750)
        search = SearchFieldView(frame: CGRect(x: 10, y: 8, width: self.view.frame.width - 20 , height: 30))
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

        
        let searchView = Search(frame: CGRect(x: 0, y: 105, width: self.view.frame.width, height: 614))
    
        searchView.setData()
        self.scrollView.addSubview(searchView)
        
        setTopNavigation("Search")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchTable(_ sender: UITapGestureRecognizer) {
        let searchTable = storyboard?.instantiateViewController(withIdentifier: "searchTable") as! SearchTableViewController
        print(search.searchField)
        searchTable.newSearch = search.searchField.text!
//        searchTable.searchController.searchBar.text = search.searchField.text
        globalNavigationController.pushViewController(searchTable, animated: true)
        print("hello")
//        search.searchField.placeholder = ""
    }

    func setTopNavigation(_ text: String) {
        let leftButton = UIButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.setImage(UIImage(named: "arrow_prev"), for: UIControlState())
        leftButton.addTarget(self, action: #selector(self.goBack(_:)), for: .touchUpInside)
        let rightButton = UIView()
        self.title = text
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir-Medium", size: 18)!]
        
        self.customNavigationBar(left: leftButton, right: rightButton)
    }
    
    
    
    func goBack(_ sender:AnyObject) {
        self.navigationController!.popViewController(animated: true)
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
