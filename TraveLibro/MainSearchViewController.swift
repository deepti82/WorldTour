//
//  MainSearchViewController.swift
//  TraveLibro
//
//  Created by Jagruti  on 15/03/17.
//  Copyright © 2017 Wohlig Technology. All rights reserved.
//

import UIKit
var globalMainSearchViewController: MainSearchViewController!

class MainSearchViewController: UIViewController, UITextFieldDelegate {
    
    var search: SearchFieldView!
    @IBOutlet var SearchView: UIView!
    @IBOutlet weak var searchSlider: UIView!
    @IBOutlet weak var searchTable: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalMainSearchViewController = self
        changeView(switchView: "slider")
        search = SearchFieldView(frame: CGRect(x: 10, y: 8, width: self.view.frame.width - 20 , height: 30))
        search.searchField.returnKeyType = .done
        search.searchField.delegate = self
        
        SearchView.addSubview(search)
        
        transparentCardWhite(SearchView)
        search.searchField.attributedPlaceholder = NSAttributedString(string:  "Search", attributes: [NSForegroundColorAttributeName: mainBlueColor])
        search.leftLine.backgroundColor = mainOrangeColor
        search.rightLine.backgroundColor = mainOrangeColor
        search.bottomLine.backgroundColor = mainOrangeColor
        search.searchButton.tintColor = mainOrangeColor
        
        let tapout = UITapGestureRecognizer(target: self, action: #selector(self.searchTable(_:)))
        search.SearchView.addGestureRecognizer(tapout)
        
        
        setTopNavigation("Search")

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func searchTable(_ sender: UITapGestureRecognizer) {
        changeView(switchView: "table")
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
    
    func changeView(switchView: String) {
        if switchView == "slider" {
            self.searchSlider.isHidden = false
            self.searchTable.isHidden = true
        }else{
            self.searchSlider.isHidden = true
            self.searchTable.isHidden = false
            globalSearchTableViewController.page = 1
            globalSearchTableViewController.searchPeople(search: search.searchField.text!)
        }
    }
    
}
